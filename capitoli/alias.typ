// Setup

#import "@preview/ouset:0.2.0": *

#let over(base, top) = overset(base, top)


// Alias

// Classi di complessità

#let NP = $italic("NP")$
#let NPC = $italic("NP-C")$
#let PO = $italic("PO")$
#let APX = $italic("APX")$
#let gAPX(x) = $#x"-"APX$
#let NPO = $italic("NPO")$
#let PTAS = $italic("PTAS")$
#let FPTAS = $italic("FPTAS")$
#let NPOC = $italic("NPO-C")$
#let PCP = $italic("PCP")$

#let pcprq(r, q) = {
  let pcprqop = math.class(
    "unary",
    "PCP",
  )
  $pcprqop[#r,#q]$
}

// Problemi di ottimizzazione

#let sol(x) = {
  let solop = math.class(
    "unary",
    $"Sol"$,
  )
  $solop_(#x)$
}

#let amm(x) = {
  let ammop = math.class(
    "unary",
    $"Amm"$,
  )
  $ammop_(#x)$
}

#let obj(x) = {
  let objop = math.class(
    "unary",
    $c$,
  )
  $objop_(#x)$
}

#let type(x) = {
  let typeop = math.class(
    "unary",
    $T$,
  )
  $typeop_(#x)$
}

#let opt(x) = {
  let optop = math.class(
    "unary",
    $"opt"$,
  )
  $optop_(#x)$
}

#let rappr(x) = {
  let rapprop = math.class(
    "unary",
    $R$,
  )
  $rapprop_(#x)$
}

// Algoritmi

#let task(n) = $over(square.filled, #n)$

#let dist = "dist"

#let LP = "LP"
#let ILP = "ILP"

#let rounding(x) = {
  let roundop = math.class(
    "unary",
    "rounding",
  )
  $roundop(#x)$
}

// Strutture succinte

#let rank(array, index) = {
  let rankop = math.class(
    "unary",
    "rank",
  )
  $rankop_(#array) (#index)$
}

#let select(array, index) = {
  let selectop = math.class(
    "unary",
    "select",
  )
  $selectop_(#array) (#index)$
}

// Citazioni

#let citazione(cit) = align(center)[
  #block(
    fill: rgb("#c4ffff"),
    inset: 8pt,
    radius: 4pt,

    [*#cit*],
  )
]
