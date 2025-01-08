// Setup

#import "@preview/ouset:0.2.0": *


// Alias

#let over(base, top) = overset(base, top)

#let sol(x) = {
  let solop = math.class(
    "unary",
    $"Sol"$,
  )
  $solop_(#x)$
}

#let NP = $italic("NP")$
#let NPC = $italic("NP-C")$
#let PO = $italic("PO")$
#let APX = $italic("APX")$
#let gAPX(x) = $#x"-"APX$
#let NPO = $italic("NPO")$
#let PTAS = $italic("PTAS")$
#let FPTAS = $italic("FPTAS")$

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

#let NPOC = $italic("NPO-C")$

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

#let PCP = $italic("PCP")$

#let pcprq(r, q) = {
  let pcprqop = math.class(
    "unary",
    "PCP",
  )
  $pcprqop[#r,#q]$
}
