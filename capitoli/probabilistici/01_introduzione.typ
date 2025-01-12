// Setup

#import "../alias.typ": *

#import "@preview/lovelace:0.3.0": pseudocode-list

#let settings = (
  line-numbering: "1:",
  stroke: 1pt + blue,
  hooks: 0.2em,
  booktabs: true,
  booktabs-stroke: 2pt + blue,
)

#let pseudocode-list = pseudocode-list.with(..settings)

#import "@local/typst-theorems:1.0.0": *
#show: thmrules.with(qed-symbol: $square.filled$)


// Capitolo

= Introduzione

Introduciamo gli *algoritmi probabilistici*: quello che cambia, rispetto a quanto fatto fino a questo momento, è il *paradigma* che utilizziamo.

Gli *algoritmi deterministici* che abbiamo usato prendevano in input $x in I_Pi$ e restituivano un output $y in O_Pi$ in maniera totalmente deterministica.

Gli *algoritmi probabilistici* hanno la possibilità di pescare da una *sorgente* casuale, che estrae bit con probabilità uniforme. In termini di MdT, la sorgente casuale è un nastro casuale che contiene $0$ e $1$. L'algoritmo non è più deterministico: se conoscessimo a prescindere l'input e la porzione di _"nastro random"_ visitata potremmo simulare deterministicamente il comportamento, ma visto che non lo conosciamo il processo non è deterministico.

Anche l'output viene modificato: infatti, non abbiamo più un output specifico ma abbiamo una distribuzione di probabilità $P(y bar.v x)$ che mi descrive la probabilità di avere l'output $y$ sapendo che è stato inserito in input $x$.

L'essere probabilistico influisce su due fattori:
- *output*: definito già come distribuzione di probabilità;
- *tempo di esecuzione*: in base ad alcune _"scelte"_ dell'algoritmo potremmo metterci più o meno tempo.

A volte i due fattori sono influenzati contemporaneamente dal probabilismo.

Prima di vedere il nostro primo algoritmo probabilistico, vediamo un *piccolo problema* di questo paradigma. Infatti, nessuna macchina deterministica è in grado di simulare una vera MdT probabilistica, ovvero non esistono macchine in grado di produrre dei bit random.

Per ovviare a questo problema, intrinseco dell'architettura che stiamo utilizzando, ci accontentiamo dei *generatori di numeri pseudo-randomici* (_PRNG Pseudo-Random Number Generator_). Queste strutture sono deterministiche ma la loro esecuzione fa sembrare la generazione effettivamente casuale. In poche parole, sono funzioni deterministiche che generano sequenze deterministiche che però sembrano essere sequenze casuali.
