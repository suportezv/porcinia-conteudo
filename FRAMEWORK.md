# Porcin.IA Conteúdo Studio: FRAMEWORK

Estúdio de edição e agendamento para as redes da **Porcin.IA** (IA para suinocultura brasileira, no WhatsApp). Framework compartilhado da agência, adaptado para esta marca.

> Os blocos marcados **PENDENTE** dependem do briefing de posicionamento da marca e serão preenchidos e commitados quando confirmados. O que está marcado **hipótese** veio do material que a agência já produziu para a marca (ver `CLAUDE.md`, "O que já se sabe da marca") e serve para começar, não para publicar sem confirmar.

## Persona e voz do perfil

- **PENDENTE**: persona, tom de voz e posicionamento da Porcin.IA (definir no primeiro briefing).
  - Hipótese a validar: voz técnica e direta, "sem achismo", que fala a língua do produtor e do veterinário; autoridade vem da ciência aplicada ao chão da granja, não de jargão. As pautas já produzidas usam frase curta, pergunta provocadora na capa e resposta objetiva.
- CTA padrão: **PENDENTE**. Hipótese: "Tire suas dúvidas com a Porcin.IA no WhatsApp" (é o que as artes da agência já usam).
- Quando citar a criadora: credencial sempre completa, **PENDENTE confirmar a forma** (base: Dra. Vera Letticie de Azevedo Ruiz, médica veterinária, professora da FZEA-USP, fundadora da Porcin.IA).

### REGRAS INEGOCIÁVEIS

1. **A marca se escreve `Porcin.IA` em texto público.** Nunca `Porcini`, `Porcini.ai`, `Porcin.ai` nem `Porcinia`. Exceções: o perfil `@porcin.ia` e o domínio `porcin.ia.br`, que são endereços.
2. **Nunca usar travessão em texto público.** Reescrever a frase.
3. Credencial sempre completa quando citar a criadora (forma **PENDENTE confirmar**).
4. Palavrão em vídeo **se bipa, não se corta** (sine 1000 Hz curto, voz mutada no trecho).
5. Loudness final: **-14 LUFS**.

## Pilares de conteúdo

**PENDENTE**: definir com o primeiro briefing (tratar como hipóteses iniciais e validar com desempenho).

Hipóteses tiradas das pautas já produzidas pela agência (julho a outubro de 2026):

1. **Sanidade e biosseguridade**: higienização, biofilme, detergente antes do desinfetante, gestação e maternidade, fatores de risco.
2. **Nutrição e desempenho**: proteína ideal e energia, água como nutriente, desmame e as 48 horas críticas da creche.
3. **Mercado e decisão**: ajustar dieta e manejo ao mercado, índices zootécnicos, custo.
4. **Produto em uso**: a Porcin.IA no WhatsApp, lembretes de vacina e manejo, "IA comum espera você perguntar, ela cobra".

## Escolha do framework de motion: HyperFrames ou Remotion

O estúdio mantém os dois, e a escolha **não é preferência do momento**: cada peça declara o seu no `BRIEFING.md`, na primeira linha. Sem isso, quem pegar o projeto depois não sabe onde mexer.

**O que decide**: a ponte entre os dois só existe num sentido. Há a skill `remotion-to-hyperframes`; **não existe o inverso**. Então peça feita em HyperFrames é definitiva, e peça feita em Remotion ainda pode migrar. Na dúvida, Remotion é a aposta reversível.

| Use **HyperFrames** quando | Use **Remotion** quando |
|---|---|
| É peça da série recorrente, na gramática já documentada | A peça é exceção, fora do padrão da série |
| Você quer o fluxo pronto: brief, storyboard, registry de ~400 blocos, legendas, áudio, render em nuvem | A composição precisa de lógica de programação, dados ou parametrização |
| O visual pedido já existe no registry (scanlines, glitch, gráfico, janela de terminal) | Você vai gerar **N variações** da mesma peça mudando nome, cupom, idioma ou número |
| Ninguém vai reprocessar a peça em outro framework | Há chance real de a peça mudar de destino depois |

**Padrão declarado: HyperFrames.** Ele é o que está integrado ao fluxo do estúdio e o que tem as 20 skills. O Remotion entra por decisão consciente, não por inércia.

Estado em 18/set/2026: os dois renderizam. O HyperFrames tem o pipeline local validado (browser, captura, encode) e o registry de 394 blocos e componentes acessível. Regra de ouro dele neste ambiente: **rodar `bash scripts/hf_vendor.sh <projeto>` antes do primeiro render**, porque o navegador do render não busca asset remoto (motivo técnico no `CLAUDE.md`). Sem isso o render é bloqueado com `sub_timeline_script_failure`.

**Custo de manter os dois, para vigiar**: dois `node_modules`, dois caminhos de render e dois lugares onde a paleta pode divergir. O terceiro está mitigado: os tokens do Remotion vivem em `remotion/src/marca.ts`. **Se a paleta da marca mudar, atualizar os dois lados.** Se em alguns meses o Remotion não tiver sido usado em nada, ele vira peso morto e se corta; o inverso não vale, porque o HyperFrames é o que sustenta o fluxo.

Componentes Remotion já prontos: `Aurora` (fundo com manchas desfocadas nas cores da marca sobre base clara) e `CartaoTitulo` (título com revelação palavra a palavra e uma palavra em destaque no magenta). Composições `CartaoTituloVertical` (1080x1920) e `CartaoTituloQuadrado` (1080x1080).

## Assinaturas de edição

Padrão validado da agência:

- Hook verbal ou visual + título na tela nos **2 primeiros segundos**.
- Lettering condensado caps branco com sombra dura; acento colorido nas ênfases. Cor de acento: **hipótese** magenta `#F55CEB` (medido no logo; confirmar com o manual da marca). Fonte: Helvetica Neue Condensed Black no Mac; Liberation Sans Bold como fallback Linux; fonte da marca **PENDENTE**.
- Legendas frase a frase em branco (não karaokê), terço inferior, SEMPRE por último no filter chain.
- Cortes secos; punch-ins de zoom 1.10 a 1.22x; freeze frames P&B com card para punchlines; cutaways como payoff de piada.
- Palavrão não corta: **bipa**.
- Trilha discreta (vol ~0.12 a 0.15) gerada via ElevenLabs sound-generation; SFX (whoosh, impact, riser, scratch) sincronizados aos cortes.
- Duração alvo: **20 a 60s**. Loudness final: **-14 LUFS**.

## Fórmula da caption

1. Hook em 1 linha (dor ou cena concreta, sem travessão)
2. 2 a 3 parágrafos curtos
3. CTA: **PENDENTE** (hipótese: "Tire suas dúvidas com a Porcin.IA no WhatsApp")
4. Pergunta de engajamento

## Fluxo por vídeo

1. Bruto (Drive público ou anexo na conversa) + briefing (framework de motion na primeira linha, pilar, mensagem central, duração, data)
2. Proxy SDR (se HLG) ou LUT S-Log2 (se Sony; `scripts/gera_lut_slog2.py`) + transcrição Scribe (timestamps por palavra)
3. Decupagem por âncora de texto (`scripts/decupar.py` com `edl.json`) e relatório (`scripts/relatorio_decupagem.py`)
4. Cor
5. Lettering/motion (PIL, PNGs com fade de alpha; ou cartão Remotion/HyperFrames)
6. **Legendas por último**
7. Trilha + SFX (sound-generation; batidas detectadas por script)
8. Preview 720p+ para aprovação na conversa
9. Caption
10. Agendamento no Metricool como rascunho na marca `porcin.ia` (blog_id 6741530), em todos os canais conectados (hoje Instagram REEL + Facebook REEL); tirar do rascunho na mesma sessão e confirmar com `getScheduledPosts`

## Gotchas técnicos

Ver a seção "Gotchas essenciais" do `CLAUDE.md` deste repo (herdados dos estúdios da agência, todos validados).
