#!/usr/bin/env bash
# Validação do estúdio de conteúdo (agnóstico de marca). Itens de MCP (Metricool,
# Kairogen) validam-se dentro da sessão do Claude, não aqui.
set -uo pipefail

TOOLS_DIR="${TOOLS_DIR:-/workspace}"
VIDEO_USE="$TOOLS_DIR/browser-use/video-use"
[ -d "$VIDEO_USE" ] || VIDEO_USE="$HOME/video-editor/video-use"
FF_PATH="/opt/homebrew/opt/ffmpeg-full/bin"
[ -d "$FF_PATH" ] && export PATH="$FF_PATH:$PATH"

# npx precisa do registry: registry.npmjs.org vem em no_proxy e bate direto no
# firewall (403); pelo agent proxy responde. Mesmo contorno do setup.sh.
if [ -n "${HTTPS_PROXY:-}" ]; then
  export no_proxy="" NO_PROXY="" HTTP_PROXY="$HTTPS_PROXY"
  export npm_config_proxy="$HTTPS_PROXY" npm_config_https_proxy="$HTTPS_PROXY"
  export npm_config_noproxy="" npm_config_cafile="${SSL_CERT_FILE:-/root/.ccr/ca-bundle.crt}"
  export NODE_USE_ENV_PROXY=1 NODE_EXTRA_CA_CERTS="${SSL_CERT_FILE:-/root/.ccr/ca-bundle.crt}"
fi
HYPERFRAMES_DIR="$TOOLS_DIR/heygen-com/hyperframes"

echo "== 1. ffmpeg: subtitles + zscale =="
N=$(ffmpeg -filters 2>/dev/null | grep -cE "subtitles|zscale")
if [ "${N:-0}" -ge 2 ]; then echo "OK ($N filtros)"; else echo "FALHOU (esperado >=2, obtido ${N:-0})"; fi

echo "== 2. video-use helpers =="
if (cd "$VIDEO_USE" && { [ -d .venv ] && .venv/bin/python helpers/timeline_view.py --help >/dev/null 2>&1 || python3 helpers/timeline_view.py --help >/dev/null 2>&1; }); then
  echo "OK (helpers importam)"
else
  echo "FALHOU (helpers não rodam em $VIDEO_USE)"
fi
# Testa o comportamento, nao a presenca de um patch: gera tres arquivos
# sinteticos (retrato, paisagem e paisagem com matriz de rotacao 90, que e o
# caso da camera que grava em pe) e confere as tres respostas.
_tmp="$(mktemp -d)"
ffmpeg -hide_banner -v error -f lavfi -i testsrc=size=540x960:duration=1:rate=10 \
  -c:v libx264 -pix_fmt yuv420p -y "$_tmp/retrato.mp4" 2>/dev/null
ffmpeg -hide_banner -v error -f lavfi -i testsrc=size=960x540:duration=1:rate=10 \
  -c:v libx264 -pix_fmt yuv420p -y "$_tmp/paisagem.mp4" 2>/dev/null
ffmpeg -hide_banner -v error -display_rotation 90 -i "$_tmp/paisagem.mp4" \
  -c copy -y "$_tmp/girado.mp4" 2>/dev/null
if python3 - "$VIDEO_USE" "$_tmp" <<'PYEOF'
import sys
from pathlib import Path
sys.path.insert(0, sys.argv[1])
from helpers import render
tmp = Path(sys.argv[2])
casos = [("retrato.mp4", True), ("paisagem.mp4", False), ("girado.mp4", True)]
ruins = [n for n, esperado in casos if render.is_portrait_source(tmp / n) != esperado]
if ruins:
    print("falhou em: " + ", ".join(ruins))
    sys.exit(1)
PYEOF
then
  echo "OK (is_portrait_source acerta retrato, paisagem e girado)"
else
  echo "FALHA: is_portrait_source erra a orientação; vertical vai sair em paisagem"
fi
rm -rf "$_tmp"

echo "== 3. ElevenLabs =="
if grep -q '^ELEVENLABS_API_KEY=sk_' "$VIDEO_USE/.env" 2>/dev/null; then
  echo "OK (chave sk_ presente; transcrição real gasta créditos, rodar sob demanda)"
else
  echo "PENDENTE: ELEVENLABS_API_KEY sk_ ausente no .env do video-use"
fi

echo "== 4. Rede (environment com domínios liberados) =="
for D in https://drive.google.com/ https://drive.usercontent.google.com/ https://api.elevenlabs.io/v1/user; do
  C=$(curl -s -o /dev/null -w "%{http_code}" --max-time 20 "$D")
  if [ "$C" = "000" ]; then echo "FALHOU $D (000: domínio não liberado)"; else echo "OK $D (HTTP $C)"; fi
done

echo "== 5. Remotion =="
REMOTION="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)/remotion"
if [ ! -d "$REMOTION/node_modules/remotion" ]; then
  echo "PENDENTE: deps do Remotion não instaladas (rode scripts/setup.sh)"
else
  _shell="/opt/pw-browsers/chromium_headless_shell-1194/chrome-linux/headless_shell"
  if [ ! -x "$_shell" ]; then
    echo "AVISO: headless_shell do Playwright ausente; o render do Remotion vai falhar"
  else
    # Prova real: renderiza 1 frame. O Chromium normal do Playwright nao serve
    # (removeu o headless antigo), por isso o config aponta para o headless_shell.
    _png="$(mktemp -d)/frame.png"
    if (cd "$REMOTION" && npx --no-install remotion still src/index.ts \
        CartaoTituloVertical "$_png" --frame=90 >/dev/null 2>&1) && [ -s "$_png" ]; then
      echo "OK (render de 1 frame funciona: $(node -p "require('$REMOTION/package.json').dependencies.remotion"))"
    else
      echo "FALHA: Remotion não renderizou; ver remotion/remotion.config.ts"
    fi
    rm -rf "$(dirname "$_png")"
  fi
fi

echo "== 6. Skills registradas =="
[ -e ~/.claude/skills/video-use/SKILL.md ] && echo "OK video-use" || echo "PENDENTE video-use"
HF=$(ls -d ~/.claude/skills/*/ 2>/dev/null | while read -r d; do [ -f "$d/SKILL.md" ] && basename "$d"; done | grep -cE 'hyperframes|media-use|motion-graphics|embedded-captions')
if [ "${HF:-0}" -ge 4 ]; then echo "OK hyperframes ($HF skills com SKILL.md)"; else echo "PENDENTE hyperframes (rode scripts/setup.sh)"; fi

echo "== 7. HyperFrames (render real de um projeto em branco) =="
REPO_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
HF_SHELL="${HYPERFRAMES_BROWSER_PATH:-/usr/local/bin/hf-headless-shell}"
if [ ! -x "$HF_SHELL" ]; then
  echo "PENDENTE: headless_shell para o HyperFrames ausente em $HF_SHELL (rode scripts/setup.sh)"
else
  # O template referencia o GSAP por CDN. O Chrome do render nao confia no CA do
  # agent proxy, entao qualquer asset remoto morre com ERR_CERT_AUTHORITY_INVALID
  # (nao e allowlist). scripts/hf_vendor.sh baixa com curl e reescreve para local;
  # e assim que peca do estudio deve nascer, com asset congelado.
  _hf="$(mktemp -d)"
  if (cd "$_hf" && HYPERFRAMES_SKIP_SKILLS=1 HYPERFRAMES_BROWSER_PATH="$HF_SHELL" \
        npx --yes hyperframes init hfsmoke --example blank --non-interactive --resolution portrait >/dev/null 2>&1) \
     && bash "$REPO_ROOT/scripts/hf_vendor.sh" "$_hf/hfsmoke" >/dev/null 2>&1 \
     && (cd "$_hf/hfsmoke" && HYPERFRAMES_SKIP_SKILLS=1 HYPERFRAMES_BROWSER_PATH="$HF_SHELL" \
        npx --yes hyperframes render . --output "$_hf/out.mp4" >/dev/null 2>&1) \
     && [ -s "$_hf/out.mp4" ]; then
    echo "OK (init + hf_vendor.sh + render: $(ffprobe -v error -select_streams v -show_entries stream=nb_frames -of csv=p=0 "$_hf/out.mp4") frames)"
  else
    echo "FALHA: HyperFrames nao renderizou; rode npx hyperframes doctor e confira $HF_SHELL"
  fi
  rm -rf "$_hf"
fi

echo "== 8. HyperFrames: registry e skills (fetch do Node pelo proxy) =="
if [ "${NODE_USE_ENV_PROXY:-}" != "1" ]; then
  echo "AVISO: NODE_USE_ENV_PROXY nao esta 1; o fetch do Node ignora o proxy e o registry fica inalcancavel"
fi
N=$(npx --yes hyperframes catalog --json 2>/dev/null | python3 -c 'import sys,json;d=json.load(sys.stdin);print(len(d if isinstance(d,list) else d.get("items",[])))' 2>/dev/null)
if [ "${N:-0}" -gt 100 ]; then echo "OK (registry com $N itens)"; else echo "FALHA: registry inalcancavel ou vazio (${N:-0} itens)"; fi

echo "== 9. Navegador do render x CA do proxy (gotcha permanente) =="
_dom=$(timeout 90 "$HF_SHELL" --headless --no-sandbox --disable-gpu --proxy-server="${HTTPS_PROXY:-}" \
  --dump-dom "https://cdn.jsdelivr.net/npm/gsap@3.14.2/package.json" 2>/dev/null | wc -c)
if [ "${_dom:-0}" -gt 100 ]; then
  echo "OK (o navegador passou a buscar asset remoto; hf_vendor.sh vira opcional, nao obrigatorio)"
else
  echo "ESPERADO: navegador nao busca asset remoto (ERR_CERT_AUTHORITY_INVALID). Toda peca precisa de scripts/hf_vendor.sh"
fi

echo "== 10. Na sessão do Claude, validar ainda: =="
echo " - Metricool: getBrandSettings lista a marca porcin.ia com blog_id 6741530"
echo " - Kairogen: get_me_context mostra plano e créditos (conta atual: FREE, 0 créditos)"
