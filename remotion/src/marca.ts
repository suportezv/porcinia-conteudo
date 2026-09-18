/**
 * Paleta e tokens da Porcin.IA.
 *
 * HIPOTESE, nao manual de marca: os hexes foram medidos no Logo_Porcin.png do
 * Drive em 18/set/2026 (degrade azul -> lavanda -> magenta, com pontas ciano,
 * sobre fundo branco). O site porcin.ia.br e o deck de marca estao fora do
 * alcance deste container, entao confirmar com o material oficial antes da
 * primeira peca publicada. Os nomes das chaves sao herdados do template da
 * agencia (Aurora.tsx e CartaoTitulo.tsx leem por nome); o que muda e o valor.
 */
export const marca = {
  /** Magenta da orelha direita: e o acento (palavra em destaque, mancha 1). */
  rosaVivo: "#F55CEB",
  rosa: "#D94BD0",
  /** Lavanda do meio do degrade (mancha 4). */
  rosaSuave: "#B48CE4",
  /** Violeta entre o azul e o magenta (mancha 2). */
  violeta: "#8E7BDC",
  /** Ciano das pontas da esquerda (mancha 3). */
  ciano: "#5BC6EE",
  azulNeon: "#94ACE4",
  /** Azul profundo da orelha esquerda. */
  azulProfundo: "#2F4DB8",
  fundoEscuro: "#0B0F2A",
  superficie: "#141B3F",
  /** Base clara dos fundos aurora: branco com um fio de azul, como o fundo do logo. */
  auroraBase: "#F4F5FB",
  /** Tinta do texto: navy, nao preto, para casar com o azul do logo. */
  tinta: "#141B3F",
  /** Fonte da marca: PENDENTE (deck de marca inacessivel daqui). Cai na sans do sistema. */
  fonte: '"Inter Tight", "Inter", system-ui, -apple-system, sans-serif',
} as const;
