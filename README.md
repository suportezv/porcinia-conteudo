# Porcin.IA Conteúdo Studio

Estúdio de edição e agendamento de conteúdo para as redes da **Porcin.IA**, a IA para suinocultura brasileira. Infraestrutura compartilhada da agência (mesmo cinto de ferramentas dos estúdios irmãos); posicionamento desta marca.

- **`FRAMEWORK.md`**: persona, regras, pilares, escolha de framework de motion, assinaturas de edição e fluxo por vídeo.
- **`CLAUDE.md`**: memória persistente do projeto (o que se sabe da marca, IDs, contas, rede, gotchas).
- **`SETUP.md`**: configuração do environment, conectores e validação.
- **`projects/`**: um subdiretório por vídeo (briefing, transcrição, `edl.json`, caption).
- **`scripts/`**: setup e validação do ambiente, mais os scripts genéricos do estúdio (decupagem por âncora de texto, relatório, LUT S-Log2, índice remoto de ZIP, geração de imagem, upload para o Drive).
- **`remotion/`**: composições Remotion (React/TS). Paleta em `src/marca.ts`, rodapé em `src/Root.tsx`.
- **`assets/fonts/`**: fontes embutidas para o render (sem rede de fontes no cloud).
- **`.claude/settings.json`**: variáveis de ambiente da sessão (browser e skills do HyperFrames).
- **`patches/`**: histórico. O patch do `is_portrait_source` está aposentado; o `validate.sh` testa o comportamento.

## Primeiro uso (cloud)

```bash
bash /home/user/porcinia-conteudo/scripts/setup.sh
bash scripts/validate.sh
```

Depois: coloque o bruto no Drive (pasta pública) ou anexe na conversa, escreva o briefing em `projects/<nome>/` e peça a edição.

| Serviço | Uso | Configuração |
|---|---|---|
| Google Drive | Brutos e material da marca | Conector oficial + domínios liberados no environment |
| Metricool | Agendamento | Marca `porcin.ia`, blog_id 6741530 (Instagram + Facebook) |
| ElevenLabs | Transcrição, trilha, SFX, TTS | Chave `sk_...` na env var e no `.env` do video-use |
| Kairogen | B-roll por IA | Conta da agência, plano FREE sem créditos (indisponível) |
| OpenAI / Gemini | Imagem (`scripts/gera_imagem.py`) | Chaves na env var, hosts liberados, validado em 18/set/2026 |

> Este repositório é **público** de propósito: o agendamento no Metricool depende de servir o render por `raw.githubusercontent.com`. Nunca commitar chaves aqui.
