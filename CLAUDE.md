# Porcin.IA Conteúdo Studio (memória persistente do projeto)

Este repositório é o **Porcin.IA Conteúdo Studio** (nome do repo: `porcinia-conteudo`): edição e agendamento de conteúdo para as redes da **Porcin.IA**, a IA para suinocultura brasileira que roda no WhatsApp (site `porcin.ia.br`, Instagram `@porcin.ia`). Estúdio da agência com infraestrutura compartilhada; o posicionamento é o desta marca.

**Antes de editar qualquer vídeo ou escrever qualquer caption, leia `FRAMEWORK.md`** (posicionamento, regras inegociáveis, formatos, assinaturas de edição e todos os gotchas técnicos).

## O que já se sabe da marca (lido no Drive em 18/set/2026, ainda não confirmado em briefing)

Tudo abaixo veio do material que a agência já produziu para a marca (deck `Porcini_IA_v11_final`, pautas editoriais de julho, agosto e setembro/outubro, artes da feira SBSS de Chapecó). Vale como hipótese de trabalho até o primeiro briefing confirmar.

- **Produto**: "a primeira IA do Brasil só de suinocultura, no seu WhatsApp". IA treinada exclusivamente no universo técnico da suinocultura brasileira; responde dúvidas sem achismo (nutrição, sanidade, biosseguridade, manejo, mercado), faz análises e entrega conhecimento com profundidade de especialista, 24h.
- **Quem cria**: Dra. Vera Letticie de Azevedo Ruiz, idealizadora e fundadora da Porcin.IA. Formação declarada no deck: médica veterinária pela USP, residência em Medicina Veterinária Preventiva, mestrado em Microbiologia, doutorado em Epidemiologia pela USP, livre-docente em Biosseguridade e Epidemiologia de Doenças de Suídeos, professora associada da FZEA-USP. **A credencial curta para texto público continua PENDENTE**: confirmar com a marca qual forma ela quer ver escrita.
- **Público**: produtores de suínos, médicos veterinários, nutricionistas animais, profissionais de sanidade, gestores de granja e estudantes (MV, Zootecnia, Agro).
- **CTA que a agência já usa nas artes**: "Tire suas dúvidas com a Porcin.IA no WhatsApp" (variações: "Revise sua rotina com a Porcin.IA no WhatsApp", "Pergunte à Porcin.IA"). Candidato a CTA padrão; confirmar.
- **Temas já pautados**: higienização e biofilme, desinfetante e detergente, biosseguridade, nutrição (proteína ideal, energia, água), mercado e restrição alimentar, desmame e creche (as 48 horas críticas), lembretes de vacina e manejo.
- **Identidade visual**: logo de focinho de porco em traço de circuito, degradê azul profundo (esquerda) para magenta (direita) passando por lavanda, pontas ciano, sobre branco. Paleta medida no `Logo_Porcin.png` e registrada em `remotion/src/marca.ts` como hipótese. Fonte da marca: **PENDENTE** (deck inacessível deste container).

## Regras que valem em qualquer resposta pública

- Nunca usar travessão em texto público (caption, lettering, legenda): reescrever a frase.
- Quando citar a criadora: sempre a credencial completa, **PENDENTE confirmar a forma** (base: Dra. Vera Letticie de Azevedo Ruiz, médica veterinária, professora da FZEA-USP, fundadora da Porcin.IA).
- Palavrão em vídeo **se bipa, não se corta**.
- Loudness final: **-14 LUFS**.

## Working dirs

- Estúdio: este repo (symlink `~/porcinia-conteudo` aponta para cá). Projetos em `projects/<nome>/`.
- Ferramentas: `video-use` e `hyperframes` clonados em `/workspace/browser-use/` e `/workspace/heygen-com/` (Linux/cloud) ou `~/video-editor/` (Mac). Skills registradas em `~/.claude/skills/`.
- **Remotion**: composições versionadas em `remotion/` neste repo (React/TS); `node_modules` fora do git, instalado pelo `setup.sh`. `npm run studio` abre o editor, `npx remotion render src/index.ts <Composicao> saida.mp4` renderiza. Componentes prontos: `Aurora` (fundo da marca) e `CartaoTitulo`, com `marca.ts` guardando a paleta. Composições registradas: `CartaoTituloVertical` (1080x1920) e `CartaoTituloQuadrado` (1080x1080).
- **Scripts genéricos** (portados do estúdio Profissio.ai em 18/set/2026, zero marca): `scripts/decupar.py` (decupagem por âncora de texto), `scripts/relatorio_decupagem.py`, `scripts/gera_lut_slog2.py` (LUT S-Log2 para Rec.709), `scripts/zip_index_remoto.py` (índice de ZIP gigante no Drive por range request), `scripts/gera_imagem.py` (OpenAI ou Gemini), `scripts/sobe_para_drive.py`.
- Ambiente novo (container limpo): rode `bash /home/user/porcinia-conteudo/scripts/setup.sh` e depois `bash scripts/validate.sh`. **Em sessão nova, conferir `ls /workspace` antes de contar com video-use ou hyperframes**: se estiver vazio, o setup de boot não rodou e é só rodar à mão.

## IDs e contas (verificados em 18/set/2026)

- **Metricool**: conta da agência. Marca no painel: **`porcin.ia`, blog_id 6741530**, timezone **America/Sao_Paulo**. Criada em 18/ago/2026, primeira conexão em 21/ago/2026.
  - Redes conectadas: Instagram **@porcin.ia** e Facebook (página `1109846745525768`). **Sem TikTok, YouTube, LinkedIn nem Pinterest** no payload do `getBrandSettings`. Conectar no painel se o formato for previsto.
  - Melhor horário de publicação: medir com `getBestTimeToPostByNetwork` antes do primeiro agendamento.
- **Regra de agendamento (todas as marcas da agência)**: sempre incluir TODOS os canais conectados da marca no post, exceto YouTube horizontal. Hoje isso significa **Instagram como REEL + Facebook como REEL**. Se conectarem mais redes: YouTube entra como **Short** (`youtubeData: {type: "short", title, madeForKids: false}`); TikTok, LinkedIn e Pinterest com networkData padrão. Nunca publicar vídeo vertical como YouTube horizontal comum.
- **Kairogen**: conta da agência, plano **FREE**, **0 créditos**, 1 geração concorrente (medido em 18/set/2026). **B-roll por IA indisponível até haver créditos.** Antes de planejar b-roll, `get_credits`.
- **ElevenLabs**: chave `sk_` (51 chars) na env var `ELEVENLABS_API_KEY` do environment; o setup grava em `.env` na raiz do video-use. Escopos medidos em 18/set/2026 sem gastar crédito: **todos os seis presentes** (`user_read`, `voices_read`, `models_read`, `text_to_speech`, `sound_generation`, `speech_to_text`), tabela no `SETUP.md`. Plano **Creator**, ativo, 121.000 caracteres/mês (601 usados em 18/set/2026, reset no fim de setembro), 30 vozes, clonagem instantânea e profissional liberadas. Voz da marca para narração: **PENDENTE (voice_id, modelo e settings)**.
- **OpenAI (imagem)**: chave em `OPENAI_API_KEY`. **Funcionando e validado em 18/set/2026** com `gpt-image-1-mini` 1024x1024 (9 s). Modelos de imagem que a conta enxerga: `gpt-image-1`, `gpt-image-1-mini`, `gpt-image-1.5`, `gpt-image-2`, `gpt-image-2.5-flare`, `gpt-image-2.5-sunburst`, `chatgpt-image-latest`. Padrão do `scripts/gera_imagem.py`: `gpt-image-2`, 1024x1024, qualidade `high`; `--tamanho` e `--qualidade` só valem na OpenAI.
- **Gemini (imagem)**: chave em `GEMINI_API_KEY`. **Funcionando e validado em 18/set/2026** com `gemini-2.5-flash-image` (4 s), sem o `429` de tier gratuito, então o faturamento está vinculado ao projeto certo. Modelos: `gemini-2.5-flash-image`, `gemini-3-pro-image` (padrão do script), `gemini-3.1-flash-image`, `gemini-3.1-flash-lite-image`. O Gemini infere o formato pelo prompt; para dimensão exata usar a OpenAI com `--tamanho`.
  - Observado neste container: as duas chaves e a allowlist nova apareceram **na sessão em andamento**, sem sessão nova. Não contar com isso: a regra continua "cadastrou, confira com `printenv | grep -c API_KEY`", e se não aparecer, sessão nova.
- **Drive**: conector oficial conectado. Material da marca já localizado (buscar por nome no conector; só o logo é público):
  - pasta `Porcini.IA` no Drive da agência;
  - pastas compartilhadas pela marca: `Porcin.IA_Zavi-Letticie` e `Porcin.IA`;
  - logo: `Logo_Porcin.png` (id `1tyxcCYmbNj5_4phgAeS39B8vkkq0k92U`, **público, baixa por curl**) e `Logo_Porcin.pdf`;
  - deck de marca: `Porcini_IA_v11_final` (Slides e pptx, **não público**);
  - pautas editoriais (Docs compartilhados): "Porcini - Setembro/Outubro", "Porcini - Post Estaticos - Julho", "PORCINI - CHAPECO - BANNER FB".
  - Pasta de **brutos de vídeo**: **PENDENTE: criar/apontar** (padrão: pasta com "qualquer pessoa com o link: leitor" para download direto).
  - **Upload para o Drive**: `www.googleapis.com` liberado em 18/set/2026, então `scripts/sobe_para_drive.py` tem rede. O que falta é o **token OAuth**, que não dá para gerar daqui (`oauth2.googleapis.com` e `accounts.google.com` seguem 403): gerar no OAuth Playground com escopo `drive.file`, vale 1 hora, passar em `GOOGLE_OAUTH_TOKEN`. Ainda não testado ponta a ponta.

## Rede do environment (medido em 18/set/2026)

Network **Custom**. Diagnóstico de qualquer host: `curl -sv https://host/ 2>&1 | grep -m1 "^< HTTP/"`. `200 Connection Established` no CONNECT é allowlist OK; `403 Forbidden` no CONNECT é allowlist, não é o site.

| Host | Status | Observação |
|---|---|---|
| `api.elevenlabs.io` | OK | TTS, STT, SFX |
| `drive.google.com`, `drive.usercontent.google.com` | OK | download de brutos e de arquivo público por curl |
| `pypi.org`, `files.pythonhosted.org`, `registry.npmjs.org` | OK **pelo proxy** | vêm em `no_proxy` e contornam o agent proxy, batendo no firewall (403). O `setup.sh` limpa `no_proxy` e aponta pip, uv e npm para o proxy com o CA bundle `/root/.ccr/ca-bundle.crt` |
| `github.com`, `api.github.com`, `objects.githubusercontent.com` | OK | clone e ffmpeg estático (GitHub Releases) |
| `raw.githubusercontent.com` | 403 | não precisa liberar: skills do hyperframes vêm do clone local |
| `archive.ubuntu.com` | 403 | `apt-get` indisponível; ffmpeg vem estático do GitHub Releases |
| `api.openai.com` | OK (liberado em 18/set/2026) | `gera_imagem.py openai`, validado |
| `generativelanguage.googleapis.com` | OK (liberado em 18/set/2026) | `gera_imagem.py gemini`, validado; liberar `www.googleapis.com` **não** cobre este subdomínio |
| `www.googleapis.com` | OK (liberado em 18/set/2026) | `sobe_para_drive.py`; o token OAuth vem de fora |
| `oauth2.googleapis.com`, `accounts.google.com` | 403 | não gerar token aqui; usar o OAuth Playground no navegador |
| `porcin.ia.br`, `static.metricool.com` | 403 | site da marca e logos do Metricool fora do alcance; usar o Drive |

**Campo de setup script do environment**: usar **caminho absoluto**, `bash /home/user/porcinia-conteudo/scripts/setup.sh`. O comando de boot roda com o diretório de trabalho no pai do repo, então `bash scripts/setup.sh` falha com exit 127 e a sessão nasce sem `/workspace` e sem ffmpeg (foi exatamente o estado deste container em 18/set/2026). Versão à prova de diretório, se preferir não depender do nome do repo:

```bash
for p in ./scripts/setup.sh ./*/scripts/setup.sh; do [ -f "$p" ] && exec bash "$p"; done; p=$(find /home /workspace /repo /app /src -maxdepth 4 -type f -path "*/scripts/setup.sh" 2>/dev/null | head -1); [ -n "$p" ] && exec bash "$p"; echo "setup.sh nao encontrado no repo"; exit 1
```

## Gotchas essenciais (herdados dos estúdios da agência, todos validados)

- Brutos de iPhone são HLG 10-bit: gerar proxy SDR uma vez antes de editar (filtro `colorspace=all=bt709:itrc=bt2020-10:iprimaries=bt2020:ispace=bt2020nc`).
- **Brutos de Sony em S-Log2 (A7 III): converter, não "filtrar".** O XML lateral de cada clipe (`C00xxM01.XML`) declara `CaptureGammaEquation` e `CaptureColorPrimaries`; quando diz `s-log2`/`s-gamut`, a imagem chega chapada e precisa de conversão para Rec.709. `scripts/gera_lut_slog2.py` gera a LUT com a `colour-science` (log para linear, primárias, ombro, gama). Dois cuidados que a prática impôs: **exposição -0,5 stop e joelho em 0,65**, senão o branco estoura; e conferir que o ffmpeg aplica a `lut3d` **em RGB, não em YUV** (ele auto-insere `yuvj420p` para `rgb24`; verificar com `-v verbose`). Saída sempre com `out_range=tv` e `-color_range tv`, senão o arquivo sai `yuvj420p` e destoa entre players.
- **Câmera pode gravar na vertical sem gravar a flag de rotação.** O arquivo vem 3840x2160 deitado e o ffprobe não mostra rotação nenhuma; só olhando um frame se descobre. Corrigir com `transpose=1` (90° horário) antes de escalar. Checar um frame de qualquer lote novo antes de planejar o corte.
- **Decupagem por âncora de texto, não por timecode.** `scripts/decupar.py` recebe um `edl.json` onde cada trecho é "de tal frase até tal frase"; ele casa as âncoras contra a transcrição com timestamp por palavra do Scribe e resolve os tempos. Revisar um corte vira editar uma frase. O campo `apos` empurra o cursor quando a mesma frase aparece antes, dita fora de cena. `scripts/relatorio_decupagem.py` retranscreve as peças finais e relata o que ficou e o que caiu.
- **Processo em background com `nohup`/`setsid` é recolhido quando a tool call retorna.** Usar `run_in_background: true` da própria ferramenta Bash, que o harness rastreia, ou deixar estourar o timeout do primeiro plano. Em lote longo, `flock` num arquivo de lock evita a corrida de dois loops escrevendo o mesmo arquivo.
- **Remotion renderiza com o `headless_shell`, não com o Chromium do Playwright.** O `chromium-1194` removeu o headless antigo que o Remotion pede e o launch morre com "Old Headless mode has been removed". O binário certo é `/opt/pw-browsers/chromium_headless_shell-1194/chrome-linux/headless_shell`, fixado em `remotion/remotion.config.ts`. Baixar o browser próprio do Remotion não é opção: está fora da allowlist.
- **Remotion e HyperFrames resolvem o mesmo problema.** Só existe a ponte `remotion-to-hyperframes`, nunca o inverso. Regra de escolha no `FRAMEWORK.md`. Ao começar peça nova, escolher um e declarar na primeira linha do `BRIEFING.md`.
- **Licença do Remotion não é MIT.** Grátis para indivíduo, organização sem fins lucrativos, empresa de até 3 funcionários e avaliação; acima disso exige Company License paga (remotion.pro). **Confirmar o enquadramento da Porcin.IA antes de usar em produção.**
- **Sem rede de fontes no render.** Google Fonts está fora da allowlist; o Remotion cai para a sans do sistema. Para usar a fonte da marca, embutir o arquivo em `assets/fonts/` e carregar como asset local.
- **Ler o índice de um ZIP gigante no Drive sem baixar o arquivo.** `drive.usercontent.google.com` aceita `Range`, então dá para pegar os últimos ~64 KB, achar o EOCD (`PK\x05\x06`) e, em arquivo >4 GB, o ZIP64 EOCD via locator `PK\x06\x07`, ler o central directory e listar tudo. Entradas `method=0` (stored), como nos exports do OneDrive com MP4, podem ser extraídas uma a uma por outro `Range`. `scripts/zip_index_remoto.py list <id>` e `get <id> <entrada>`.
- **Allowlist do environment não cobre subdomínio.** A entrada é literal: `www.googleapis.com` não libera `generativelanguage.googleapis.com`. O campo aceita `*`, então para um site inteiro o certo é `*.dominio.com` junto do apex.
- **Chromium não contorna a allowlist.** O headless do Playwright usa o mesmo agent proxy e devolve `ERR_TUNNEL_CONNECTION_FAILED` no mesmo host que o `curl` recusa. Navegador só ajuda contra JS/SPA, nunca contra egresso bloqueado. WebFetch (ferramenta) tem rota própria e também não acompanha a allowlist: usar `curl` do container.
- **Instagram exige login, mesmo liberado na rede.** Perfil devolve 302 para login, `web_profile_info` devolve 401, embed devolve casca vazia. Para analisar feed: prints do usuário, conector do Metricool (contas conectadas à marca) ou Graph API da Meta com token.
- **A URL do ffmpeg estático tem uma pegadinha de uma palavra.** `releases/download/latest/…` é a tag rolante do BtbN e serve o arquivo; `releases/latest/download/…` devolve 404. O `setup.sh` tenta as duas em ordem e **confere a assinatura XZ (`fd377a585a00`) antes de extrair**. Os 403 do apt no início do passo 1 são ruído esperado.
- **O patch `video-use-is-portrait-source` está aposentado (18/set/2026).** O upstream reescreveu `is_portrait_source` para ler também o `rotation` do side data. O `validate.sh` testa **comportamento** (retrato, paisagem e paisagem com matriz de rotação 90) em vez de procurar o patch. O arquivo em `patches/` fica só como registro histórico.
- Legendas SEMPRE por último no filter chain; overlays via PIL em PNG sequence + qtrle (ou PNG estático com fade de alpha).
- Zoom animado com `zoompan`, não `crop` (crop não aceita `t` em w/h).
- Metricool MCP: sem delete (cancelar = update `draft:true`; update devolve id novo); mídia por URL pública (o Metricool copia para o CDN dele na hora).
- **Metricool, rascunho com data vencida não publica e não avisa.** Um post `draft:true` cuja data passa continua no calendário, aparece em `getScheduledPosts` como se estivesse agendado, e nunca dispara. Regra: **quem agenda tira do rascunho na mesma sessão e confirma com `getScheduledPosts`**; nunca deixar o flip de `draft` para uma sessão seguinte. Tirar do rascunho com a data no passado também não resolve, é preciso data nova.
- **Sessão filha para o Metricool**: follow-up na mesma sessão via `create_trigger` com `persistent_session_id` + `fire_trigger` **sem `text`** (com `text` o disparo cria sessão nova no environment do trigger). Sessão arquivada não aceita trigger: `unarchive_session` antes. O resumo da sessão filha engole números e ids; dado exato deve ser publicado num canal durável.
- Mac: usar ffmpeg-full keg-only com PATH explícito. Linux: ffmpeg estático do `setup.sh` (o do apt está bloqueado no cloud).
- Cloud, brutos do Drive: environment com network **Custom** e `drive.google.com` + `drive.usercontent.google.com` + `api.elevenlabs.io` liberados. Download direto de arquivo público, qualquer tamanho: `curl -L "https://drive.usercontent.google.com/download?id=<ID>&export=download&confirm=t"`. O conector MCP do Drive serve para busca e metadados; download por ele só até ~4 MB. Fallback para arquivo público pequeno: Kairogen `download_audio_from_url`.
- Cloud, mídia pública para o Metricool: commit temporário do render na branch (repo público, `raw.githubusercontent.com` passa para o servidor do Metricool, mesmo bloqueado para este container), agendar e remover o arquivo em seguida. Exige `git add -f` (o `.gitignore` barra mídia) com autorização do usuário. **Por isso este repo deve ser público.**
- Cloud: env var de environment antigo pode conter um key ID (64 hex) em vez da chave; a chave real da ElevenLabs é `sk_...` de 51 caracteres. Chave válida não significa quota: no Gemini, listar modelos funciona no tier gratuito e gerar imagem devolve `429` com `limit: 0` e `quotaId: ...-FreeTier` até o faturamento estar vinculado **ao projeto daquela chave**. Ler o campo `details` do erro, não só a mensagem.
- Testar escopo de chave da ElevenLabs sem gastar crédito: chamar o endpoint com parâmetro inválido. `401 missing_permissions` = escopo ausente; `400`/`404`/`422` = escopo presente.
- Trilhas/SFX: ElevenLabs `sound-generation` (`/v1/sound-generation`, máx ~22s, `duration_seconds` entre 0.5 e 30) gera beds e SFX ótimos; para trilha maior, gerar build+drop e costurar com `acrossfade`. Detecção de BPM/batidas: script próprio com numpy (fluxo de energia + autocorrelação).

## Histórico de decisões

- **18/set/2026**: cinto de ferramentas portado do estúdio Profissio.ai seguindo o `PORTAR.md` de lá: 6 scripts genéricos, `remotion/` com paleta trocada em `marca.ts` e rodapé em `Root.tsx`, `validate.sh` que testa comportamento, gotchas genéricos e a regra HyperFrames vs Remotion. Setup rodado e `validate.sh` verde de ponta a ponta (ffmpeg estático, video-use, 20 skills do hyperframes, Remotion 4.0.526 renderizando). Dois furos do guia corrigidos aqui: `colour-science` não era instalado pelo `setup.sh` (agora é) e o `titulo` padrão em `Root.tsx` também carregava marca (o guia só citava o rodapé). Kairogen conferido: FREE, 0 créditos, então o `validate.sh` deste repo, que citava "Essential+", estava errado. No mesmo dia o usuário liberou `api.openai.com`, `generativelanguage.googleapis.com` e `www.googleapis.com` e cadastrou as chaves; `gera_imagem.py` validado nos dois provedores com uma imagem de teste cada. Ficam pendentes para o usuário: caminho absoluto no campo de setup do environment, confirmação da paleta e da fonte, token OAuth para testar o upload ao Drive, e o briefing de posicionamento.
