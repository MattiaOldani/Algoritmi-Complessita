// Setup teoremi

#import "@preview/ctheorems:1.1.2": *

#let theorem = thmbox(
  "teorema",
  "Teorema",
  fill: rgb("#eeffee"),
).with(numbering: none)

#let corollary = thmbox(
  "corollario",
  "Corollario",
  base: "teorema",
  fill: rgb("#eeffee"),
).with(numbering: none)

#let definition = thmbox(
  "definizione",
  "Definizione",
  inset: (x: 1.2em, top: 1em),
).with(numbering: none)

#let example = thmplain(
  "esempio",
  "Esempio",
).with(numbering: none)

#let proof = thmproof(
  "dimostrazione",
  "Dimostrazione",
).with(numbering: none)
