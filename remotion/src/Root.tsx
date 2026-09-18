import React from "react";
import { Composition } from "remotion";
import { CartaoTitulo } from "./CartaoTitulo";

export const RemotionRoot: React.FC = () => (
  <>
    <Composition
      id="CartaoTituloVertical"
      component={CartaoTitulo}
      durationInFrames={150}
      fps={30}
      width={1080}
      height={1920}
      defaultProps={{
        titulo: "A primeira IA do Brasil só de suinocultura",
        destaque: "suinocultura",
        rodape: "porcin.ia",
      }}
    />
    <Composition
      id="CartaoTituloQuadrado"
      component={CartaoTitulo}
      durationInFrames={150}
      fps={30}
      width={1080}
      height={1080}
      defaultProps={{
        titulo: "A primeira IA do Brasil só de suinocultura",
        destaque: "suinocultura",
        rodape: "porcin.ia",
      }}
    />
  </>
);
