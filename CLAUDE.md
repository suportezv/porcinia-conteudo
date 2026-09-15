# Porcinia Conteúdo Studio (memória persistente do projeto)

Este repositório é o **Porcinia Conteúdo Studio**: edição e agendamento de conteúdo para as redes da **Porcinia**. Estúdio da agência com infraestrutura compartilhada; o posicionamento é o desta marca.

**Antes de editar qualquer vídeo ou escrever qualquer caption, leia `FRAMEWORK.md`** (posicionamento, regras inegociáveis, formatos, assinaturas de edição e todos os gotchas técnicos).

## Regras que valem em qualquer resposta pública

- Nunca usar travessão em texto público (caption, lettering, legenda): reescrever a frase.
- Quando citar a criadora ou criador: sempre a credencial completa **"PENDENTE (credencial completa de quem cria, para citação em texto público)"**.
- Palavrão em vídeo **se bipa, não se corta**.
- Loudness final: **-14 LUFS**.

## Working dirs

- Estúdio: este repo (symlink `~/porcinia-conteudo` aponta para cá). Projetos em `projects/<nome>/`.
- Ferramentas: `video-use` e `hyperframes` clonados em `/workspace/browser-use/` e `/workspace/heygen-com/` (Linux/cloud) ou `~/video-editor/` (Mac). Skills registradas em `~/.claude/skills/`.
- Ambiente novo (container limpo): rode `bash scripts/setup.sh` e depois `bash scripts/validate.sh`.

## IDs e contas

- Instagram da marca: **@porcin.ia** (IG account id no Meta: **17841431711328936**). Facebook: página **1109846745525768**.
- Metricool: conta da agência. Marca no painel: **porcin.ia (blog_id 6741530)**, timezone America/Sao_Paulo. Redes conectadas (validado 2026-09-15): **Instagram (porcin.ia) e Facebook (página 1109846745525768)**. Melhor horário FB (getBestTimeToPostByNetwork, base ago/set 2026): dias úteis, pico 10h (quarta 12h); fim de semana fraco.
- Meta Ads MCP (conector autorizado): business **Porcin.IA** id 842716668858010, ad account C01 **1404292144836626**. `ads_get_ig_accounts` + `ads_get_ig_media` listam os posts publicados do IG com legenda exata, permalink e media_url (só a capa nos carrosséis).
- **Sincronização IG -> Facebook (2026-09-15)**: 22 posts do IG (27/05 a 09/09) que não existiam na página foram agendados no Metricool como posts de Facebook APENAS (1 por dia útil, 16/09 a 15/10, 10h, quartas 12h), legendas idênticas exceto travessões reescritos. Já estavam na página (cross-post da plataforma antiga): SBSS dia 3 (13/08), IA genérica (17/08), pós-desmame (19/08), água/pH (21/08), diagnóstico método (02/09). Post do QR da feira SBSS (12/08) não foi replicado (evento datado). Ao sincronizar redes, NUNCA incluir instagram nos providers: só a rede que falta.
- **Regra de agendamento (todas as marcas da agência)**: sempre incluir TODOS os canais conectados da marca no post, exceto YouTube horizontal. YouTube entra como **Short** (`youtubeData: {type: "short", title, madeForKids: false}`); Instagram como REEL; Facebook como REEL; TikTok, LinkedIn e Pinterest com networkData padrão. Nunca publicar vídeo vertical como YouTube horizontal comum.
- Kairogen: conta da agência (suporte@zavi.ag). Plano **FREE, 0 créditos** (validado 2026-08-18): sem créditos para b-roll até upgrade ou compra de créditos.
- ElevenLabs: chave `sk_` (51 chars) na env var `ELEVENLABS_API_KEY` do environment; o setup grava em `.env` na raiz do video-use. Escopos TTS, STT Scribe, sound-generation e voices_read **confirmados** (validado 2026-08-18). Plano **free: 10.000 créditos/mês** (261 usados em 2026-08-18); cota apertada para produção regular, avaliar upgrade. Voz da marca para narração: **PENDENTE (voice_id, modelo e settings)**. Validar escopo sem gastar créditos: POST com body `{}` devolve 422 de validação se o escopo existe e `missing_permissions` se não.
- Drive (brutos): pasta do projeto **PENDENTE: criar/apontar** (padrão: pasta com "qualquer pessoa com o link: leitor" para download direto).

## Gotchas essenciais (herdados dos estúdios da agência, todos validados)

- Brutos de iPhone são HLG 10-bit: gerar proxy SDR uma vez antes de editar (filtro `colorspace=all=bt709:itrc=bt2020-10:iprimaries=bt2020:ispace=bt2020nc`).
- Legendas SEMPRE por último no filter chain; overlays via PIL em PNG sequence + qtrle (ou PNG estático com fade de alpha).
- Zoom animado com `zoompan`, não `crop` (crop não aceita `t` em w/h).
- video-use precisa do patch `patches/video-use-is-portrait-source.patch` (senão vertical vira paisagem).
- Metricool MCP: sem delete (cancelar = update draft:true; update devolve id novo); mídia por URL pública (o Metricool copia para o CDN dele na hora).
- Mac: usar ffmpeg-full keg-only com PATH explícito. Linux: ffmpeg do apt já serve. Cloud com apt bloqueado pelo proxy (403 em archive.ubuntu.com): `pip3 install imageio-ffmpeg` traz ffmpeg estático completo (subtitles, zscale, zoompan, qtrle) dentro do wheel do PyPI (liberado); symlink em /usr/local/bin/ffmpeg. ffprobe via npm: `npm install @ffprobe-installer/linux-x64` (binário no tarball do npm, também liberado). `static-ffmpeg` do pip NÃO funciona (baixa de GitHub raw, bloqueado).
- Cloud: `npx hyperframes skills update` falha na checagem de manifesto (GitHub raw bloqueado); fallback: clonar o repo e symlink manual de `skills/*/` para `~/.claude/skills/`. O setup.sh já faz os dois fallbacks.
- Cloud, brutos do Drive: environment com network Custom e `drive.google.com` + `drive.usercontent.google.com` + `api.elevenlabs.io` liberados. Download direto de arquivo público, qualquer tamanho: `curl -L "https://drive.usercontent.google.com/download?id=<ID>&export=download&confirm=t"`. O conector MCP do Drive serve para busca e metadados; download por ele só até ~4 MB. Fallback para arquivo público pequeno: Kairogen `download_audio_from_url`.
- Cloud, mídia pública para o Metricool: commit temporário do render na branch (repo público, raw.githubusercontent.com passa no proxy), agendar e remover o arquivo em seguida. Exige `git add -f` (o .gitignore barra mídia) com autorização do usuário. **Por isso este repo deve ser público.** Para repost de conteúdo já publicado no IG, não precisa: as URLs assinadas de `scontent-*.cdninstagram.com` passam no proxy e o Metricool copia para o CDN dele na criação do agendamento (confirmado: media volta como static.metricool.com).
- Posts publicados no Facebook (fora do planner) listam-se via analytics do Metricool: `getAnalyticsDataByMetrics` com FBPO02 (data), FBPO03 (texto), FBPO06 (link), FBPO07 (tipo). Fotos de perfil/capa aparecem como "photo" com texto vazio: não confundir com post de conteúdo.
- Lâminas de carrossel do IG (a API de ads só dá a capa): `https://www.instagram.com/p/<shortcode>/embed/captioned/` contém `"contextJSON"` (string JSON escapada) com `gql_data.shortcode_media.edge_sidecar_to_children[].node.display_url` e a legenda em `edge_media_to_caption`. Para post de imagem única o contextJSON vem null: usar a media_url do `ads_get_ig_media`. No proxy, cdninstagram.com e www.instagram.com passam; fbcdn.net e app.metricool.com são bloqueados.
- Trilhas/SFX: ElevenLabs sound-generation (`/v1/sound-generation`, máx ~22s) gera beds e SFX ótimos; para trilha maior, gerar build+drop e costurar com acrossfade. Detecção de BPM/batidas: script próprio com numpy (fluxo de energia + autocorrelação).
