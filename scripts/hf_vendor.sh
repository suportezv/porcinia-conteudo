#!/usr/bin/env bash
# Baixa para dentro do projeto HyperFrames todo asset que o HTML carrega de CDN
# e reescreve as URLs para caminho local.
#
# Por que existe: o Chrome que o HyperFrames usa para renderizar NAO confia no
# CA do agent proxy (NSS store vazio, certutil ausente na imagem), entao toda
# requisicao HTTPS de dentro da pagina morre com ERR_CERT_AUTHORITY_INVALID e o
# render e bloqueado com "sub_timeline_script_failure". Nao e allowlist: um host
# liberado falha igual. O `curl` do container, esse sim, passa pelo proxy com o
# CA certo, entao quem baixa e o script, nao o navegador.
#
# Efeito colateral bom: render com asset congelado e deterministico, que e o que
# a propria skill media-use recomenda ("resolve into a frozen local file").
#
# Uso:
#   bash scripts/hf_vendor.sh <dir-do-projeto>        # baixa e reescreve
#   bash scripts/hf_vendor.sh <dir-do-projeto> --dry  # so lista o que faria
set -uo pipefail

PROJ="${1:-.}"
DRY=""
[ "${2:-}" = "--dry" ] && DRY=1

[ -d "$PROJ" ] || { echo "diretorio nao existe: $PROJ"; exit 1; }

# index.html e qualquer composicao/bloco em html dentro do projeto
mapfile -t HTMLS < <(find "$PROJ" -name "*.html" -not -path "*/node_modules/*" -not -path "*/vendor/*" | sort)
[ "${#HTMLS[@]}" -gt 0 ] || { echo "nenhum .html em $PROJ"; exit 1; }

VENDOR="$PROJ/vendor"
[ -n "$DRY" ] || mkdir -p "$VENDOR"
BAIXADOS=0
FALHAS=0

for html in "${HTMLS[@]}"; do
  # URLs em src="..." e href="..."; ignora as que ja sao locais
  mapfile -t URLS < <(grep -ohE '(src|href)="https?://[^"]+"' "$html" \
    | sed -E 's/^(src|href)="//; s/"$//' | sort -u)
  for url in "${URLS[@]:-}"; do
    [ -n "$url" ] || continue
    nome="$(basename "${url%%\?*}")"
    case "$nome" in *.*) ;; *) nome="$nome.asset" ;; esac
    destino="$VENDOR/$nome"
    if [ -n "$DRY" ]; then
      echo "baixaria: $url -> vendor/$nome  (em $(basename "$html"))"
      continue
    fi
    if [ ! -s "$destino" ]; then
      if curl -sfL --max-time 120 -o "$destino" "$url"; then
        echo "baixado: vendor/$nome ($(wc -c < "$destino") bytes)"
        BAIXADOS=$((BAIXADOS+1))
      else
        echo "FALHOU baixar $url (host fora da allowlist do environment?)"
        rm -f "$destino"
        FALHAS=$((FALHAS+1))
        continue
      fi
    fi
    # reescreve a URL para o caminho local, no arquivo onde ela aparece
    esc="$(printf '%s' "$url" | sed -e 's/[]\/$*.^[]/\\&/g')"
    sed -i "s|$esc|./vendor/$nome|g" "$html"
  done
done

if [ -n "$DRY" ]; then
  exit 0
fi

RESTANTES=$(grep -ohE '(src|href)="https?://[^"]+"' "${HTMLS[@]}" | wc -l)
echo "---"
echo "$BAIXADOS asset(s) baixado(s), $FALHAS falha(s), $RESTANTES URL(s) remota(s) restante(s) no HTML"
[ "$FALHAS" -eq 0 ] || exit 1
