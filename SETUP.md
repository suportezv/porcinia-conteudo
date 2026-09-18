# Setup do Porcin.IA Conteúdo Studio

Espelho do setup dos estúdios irmãos. No cloud, basta:

```bash
bash /home/user/porcinia-conteudo/scripts/setup.sh
bash scripts/validate.sh
```

No Mac: clonar `video-use` e `hyperframes` em `~/video-editor/`, usar o ffmpeg-full keg-only com PATH explícito, e rodar o `validate.sh` (ele acha o video-use em `~/video-editor/` sozinho).

## Environment (Claude Code cloud)

Network **Custom** com `drive.google.com`, `drive.usercontent.google.com` e `api.elevenlabs.io` na lista de domínios, mais a env var `ELEVENLABS_API_KEY` e o setup script com **caminho absoluto**: `bash /home/user/porcinia-conteudo/scripts/setup.sh` (o relativo falha, ver `CLAUDE.md`, "Rede do environment"). Configura-se no seletor de nuvem acima da caixa de mensagem em claude.ai/code. **Mudanças valem para sessões novas.**

Para ligar a geração de imagem e o upload para o Drive, faltam neste environment (estado em 18/set/2026):

| Item | Para quê | Estado |
|---|---|---|
| env var `OPENAI_API_KEY` | `scripts/gera_imagem.py openai` | ausente |
| env var `GEMINI_API_KEY` | `scripts/gera_imagem.py gemini` | ausente |
| host `api.openai.com` | idem | 403 no CONNECT |
| host `generativelanguage.googleapis.com` | idem (liberar `www.googleapis.com` não cobre) | 403 no CONNECT |
| host `www.googleapis.com` | `scripts/sobe_para_drive.py` | 403 no CONNECT |

Conferir depois de cadastrar, em sessão nova: `printenv | grep -c API_KEY` (esperado 3) e `python3 scripts/gera_imagem.py --listar`.

## Conectores (cada um exige ação do usuário)

- **Google Drive**: conector oficial do Claude + pastas de brutos com "qualquer pessoa com o link: leitor" (download direto por curl, qualquer tamanho). Pasta de brutos da Porcin.IA: **PENDENTE**. Material da marca já localizado: ids no `CLAUDE.md`.
- **Metricool**: conta da agência. Marca **`porcin.ia`**, **blog_id 6741530**. Instagram e Facebook conectados; **TikTok, YouTube, LinkedIn e Pinterest não**.
- **Kairogen**: conta da agência, plano **FREE com 0 créditos** (18/set/2026). B-roll por IA indisponível até haver créditos.
- **ElevenLabs**: chave `sk_...` (51 chars). Escopos medidos em 18/set/2026 por status HTTP, sem gastar crédito: ver tabela abaixo.

| Escopo | Chamada de teste | Resultado |
|---|---|---|
| `user_read` | `GET /v1/user` | 200 (presente) |
| `voices_read` | `GET /v1/voices` | 200 (presente) |
| `models_read` | `GET /v1/models` | 200 (presente) |
| `text_to_speech` | `POST /v1/text-to-speech/invalido` | 422 (presente) |
| `sound_generation` | `POST /v1/sound-generation` com body vazio | 422 (presente) |
| `speech_to_text` | `POST /v1/speech-to-text` sem arquivo | 422 (presente) |

Leitura: `401` é escopo ausente; `400`, `404` ou `422` é escopo presente e pedido inválido.

## Validação final

1. `bash scripts/validate.sh` todo verde: filtros do ffmpeg, `is_portrait_source` acertando retrato, paisagem e girado, chave da ElevenLabs, rede, render de 1 frame no Remotion, skills registradas.
2. Metricool: `getBrandSettings` lista `porcin.ia` com blog_id 6741530.
3. Kairogen: `get_me_context` mostra plano e créditos.
4. Teste de fumaça dos scripts: `python3 scripts/gera_imagem.py --listar` (depende das chaves) e `python3 scripts/zip_index_remoto.py list <id de ZIP público>`.
5. Memória persistente: `CLAUDE.md` deste repo.

## Pendências de marca (bloqueiam produção de texto público)

Ver as seções marcadas **PENDENTE** no `FRAMEWORK.md`: persona, credencial de quem assina, CTA, pilares, paleta e fonte confirmadas, e voz da ElevenLabs.
