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

- Instagram da marca: **PENDENTE** (handle e demais redes conectadas).
- Metricool: conta da agência. Marca no painel: **PENDENTE conectar (blog_id PENDENTE)**, timezone America/Sao_Paulo. Melhor horário de publicação: medir com getBestTimeToPostByNetwork após conectar.
- **Regra de agendamento (todas as marcas da agência)**: sempre incluir TODOS os canais conectados da marca no post, exceto YouTube horizontal. YouTube entra como **Short** (`youtubeData: {type: "short", title, madeForKids: false}`); Instagram como REEL; Facebook como REEL; TikTok, LinkedIn e Pinterest com networkData padrão. Nunca publicar vídeo vertical como YouTube horizontal comum.
- Kairogen: conta da agência. Plano e créditos: **PENDENTE conferir** antes de usar para b-roll.
- ElevenLabs: chave `sk_` (51 chars) na env var `ELEVENLABS_API_KEY` do environment; o setup grava em `.env` na raiz do video-use. Escopos necessários: TTS, STT Scribe, sound-generation, voices_read. Plano e cota: **PENDENTE conferir**. Voz da marca para narração: **PENDENTE (voice_id, modelo e settings)**.
- Drive (brutos): pasta do projeto **PENDENTE: criar/apontar** (padrão: pasta com "qualquer pessoa com o link: leitor" para download direto).

## Gotchas essenciais (herdados dos estúdios da agência, todos validados)

- Brutos de iPhone são HLG 10-bit: gerar proxy SDR uma vez antes de editar (filtro `colorspace=all=bt709:itrc=bt2020-10:iprimaries=bt2020:ispace=bt2020nc`).
- Legendas SEMPRE por último no filter chain; overlays via PIL em PNG sequence + qtrle (ou PNG estático com fade de alpha).
- Zoom animado com `zoompan`, não `crop` (crop não aceita `t` em w/h).
- video-use precisa do patch `patches/video-use-is-portrait-source.patch` (senão vertical vira paisagem).
- Metricool MCP: sem delete (cancelar = update draft:true; update devolve id novo); mídia por URL pública (o Metricool copia para o CDN dele na hora).
- Mac: usar ffmpeg-full keg-only com PATH explícito. Linux: ffmpeg do apt já serve.
- Cloud, brutos do Drive: environment com network Custom e `drive.google.com` + `drive.usercontent.google.com` + `api.elevenlabs.io` liberados. Download direto de arquivo público, qualquer tamanho: `curl -L "https://drive.usercontent.google.com/download?id=<ID>&export=download&confirm=t"`. O conector MCP do Drive serve para busca e metadados; download por ele só até ~4 MB. Fallback para arquivo público pequeno: Kairogen `download_audio_from_url`.
- Cloud, mídia pública para o Metricool: commit temporário do render na branch (repo público, raw.githubusercontent.com passa no proxy), agendar e remover o arquivo em seguida. Exige `git add -f` (o .gitignore barra mídia) com autorização do usuário. **Por isso este repo deve ser público.**
- Trilhas/SFX: ElevenLabs sound-generation (`/v1/sound-generation`, máx ~22s) gera beds e SFX ótimos; para trilha maior, gerar build+drop e costurar com acrossfade. Detecção de BPM/batidas: script próprio com numpy (fluxo de energia + autocorrelação).
