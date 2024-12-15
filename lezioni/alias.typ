// Alias

#import "@preview/ouset:0.2.0": *


// Lezione 01

#let sol(x) = {
  let solop = math.class(
    "unary",
    $"Sol"$,
  )
  $solop_(#x)$
}

// Lezione 02

#let over(base, simbolo) = $overset(base, simbolo)$

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

// Lezione 03

#let NPOC = $italic("NPO-C")$

// Lezione 04

#let task(n) = $over(square.filled, #n)$

#let dist = "dist"

// Lezione 08

#let LP = "LP"
#let ILP = "ILP"

#let rounding(x) = {
  let roundop = math.class(
    "unary",
    "rounding",
  )
  $roundop(#x)$
}

// Lezione 17

#let PCP = $italic("PCP")$

#let pcprq(r, q) = {
  let pcprqop = math.class(
    "unary",
    "PCP",
  )
  $pcprqop[#r,#q]$
}

// Lezione 19

#let rank(a) = {
  let rankop = math.class(
    "unary",
    "rank",
  )
  $rankop(#a)$
}

#let select(a) = {
  let selectop = math.class(
    "unary",
    "select",
  )
  $selectop(#a)$
}
