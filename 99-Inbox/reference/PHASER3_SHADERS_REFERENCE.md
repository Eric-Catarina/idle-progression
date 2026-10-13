# 📚 Referência: Shaders no Phaser 3
> **ARQUIVO DE REFERÊNCIA BRUTO — NÃO carregar por padrão.** Consultar ao trabalhar em **efeitos visuais/shaders** (ver `00-Context/CONTEXT-007 Raridades.md`).
> Fonte: docs Phaser + uso comum em Phaser 3.

## 1. Regra de ouro
- Shaders só funcionam no **renderer WebGL** (o fallback Canvas ignora custom shaders).
- São **camada de render** apenas — no paradigma *Headless Simulation First* do projeto, **nunca** afetam lógica/estado.

## 2. Nível 1 — FX embutidas (`preFX` / `postFX`, Phaser 3.60+)
Efeitos prontos aplicados a GameObjects/Câmeras:

| FX | Uso |
| :--- | :--- |
| Glow | `sprite.postFX.addGlow(color, outerStrength, innerStrength, scale, knockout, quality, distance)` |
| Shine | `this.actions.addEffectShine(obj, { duration, radius, colorFactor, ... })` |
| Bloom | `Phaser.Actions.AddEffectBloom(obj, config)` (ParallelFilters + Threshold + Blur) |
| Displacement | `obj.postFX.addDisplacement(...)` / `camera.filters.internal.addDisplacement()` |
| Gradient/Pixelate/etc. | `postFX.addGradient(...)`, `postFX.addPixelate(...)` |

> `preFX` roda **antes** do desenho (distorce a textura); `postFX` roda **depois** (brilho, bloom).

## 3. Nível 2 — Shader próprio
Duas formas:

### (a) Shader Game Object
`this.add.shader(fragmentShader, x, y, width, height, textures)` — um quad com GLSL. Útil para fundos/máscaras.
- Uniform `uProjectionMatrix` é automático; demais via `setupUniforms`.
- `shader.setRenderToTexture('key')` → usa a saída como textura em sprites.

### (b) PostFXPipeline customizada
1. `class MeuFx extends Phaser.Renderer.WebGL.Pipelines.PostFXPipeline { onPreRender() { this.set1f('uTime', t); } }`
2. `fragShader` = GLSL (fragment).
3. Registrar: `this.renderer.pipelines.addPostPipeline('meuFx', MeuFx)`.
4. Aplicar: `sprite.setPostPipeline('meuFx')`.

### GLSL (fragment) — esqueleto
```glsl
precision mediump float;
uniform sampler2D uMainSampler;  // textura de entrada
uniform float uTime;
varying vec2 outTexCoord;
void main() {
  vec2 uv = outTexCoord;
  vec4 color = texture2D(uMainSampler, uv);
  // ex: brilho -> color.rgb += uTime * 0.0;  (exemplo)
  gl_FragColor = color;
}
```

## 4. Padrões úteis por raridade (ver CONTEXT-007)
- **Pulso:** uniform `uTime` modulando `intensity`.
- **Shine sweep:** gradiente deslocado por `x = fract(uTime)` + `mix`.
- **Hue-shift (arco-íris):** converter RGB→HSV, somar `uTime`, voltar.
- **Bloom:** `AddEffectBloom` (não precisa escrever GLSL).
- **Obsidiana (Divino):** displacement leve + alto contraste + bloom.

## 5. Obsidian (visual de documentação)
- Notas não rodam JS → use **CSS snippets** (gradientes, `filter:hue-rotate`, `@keyframes`) ou **SVG filters**.
- Shader real em nota só via **DataviewJS + `<canvas>` WebGL**.
