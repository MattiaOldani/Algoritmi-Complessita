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

== Load Balancing

Usciamo fuori dai problemi in $PO$ e vediamo il problema del *Load Balancing*. Esso è definito da:
- *input*::
  - $m > 0$ numero di macchine;
  - $n > 0$ numero di task;
  - $(t_i)_(i in n) > 0$ durate dei task;
- *soluzione ammissibile*: funzione $ alpha : n arrow.long m $ che assegna ogni task ad una macchina. Il *carico* di una macchina $j$ è la quantità $ L_j = sum_(i bar.v alpha(i) = j) t_i . $ Il *carico generale* è $ L = max_j L_j ; $
- *funzione obiettivo*: $L$;
- *tipo*: $max$.

#theorem()[
  Load Balancing è $NPO$-completo.
]

Che problemi stanno in $NPO$? È difficile dare una definizione di non determinismo nei problemi di ottimizzazione, però possiamo definire $NPOC$: un problema di ottimizzazione $Pi$ è $NPO$-completo se e solo se:
- $Pi in NPO$;
- $hat(Pi) in NPC$.

Se un problema in $NPOC$ fosse polinomiale allora il suo problema di decisione associato sarebbe polinomiale, e questo non può succedere.

Vediamo un *algoritmo greedy*, una tecnica di soluzione che cerca di ottimizzare _"in modo miope"_, ovvero costruisce passo dopo passo la soluzione prendendo ogni volta la direzione che sembra ottima in quel momento.

DA QUA

#align(center)[
  #pseudocode-list(title: [Greedy Load Balancing])[
    - *input*
      - $m > 0$ numero di macchine
      - $n > 0$ numero di task
      - $(t_i)_(i in n)$ durata di ogni task
    + for $i$ in $m$:
      + $A_i arrow.l emptyset.rev$ (task assegnate alla macchina)
      + $L_i arrow.l 0$ (carico della macchina)
    + for $j$ in $n$:
      + $i arrow.l arg min_(t in m) L_t$ (indice macchina con meno carico)
      + $A_i arrow.l A_i union {j}$
      + $L_i arrow.l L_i + t_j$
    + *output* $alpha$ assegna ogni elemento di $A_i$ alla macchina $i$
  ]
]

Il tempo d'esecuzione di questo algoritmo è $O(n m)$, ed è molto comodo perché è possibile utilizzarlo anche *online*, ovvero quando i task non sono tutti conosciuti ma possono arrivare anche durante l'esecuzione dell'algoritmo.

#theorem()[
  Greedy Load Balancing è una $2$-approssimazione per Load Balancing.
]

#proof()[
  Chiamiamo $L^*$ il valore della funzione obiettivo nella soluzione ottima.

  Osserviamo che:
  + vale $ L^* gt.eq 1/m sum_j t_j , $ ovvero il carico migliore ci mette almeno un tempo uguale allo "spezzamento perfetto", cioè quello che assegna ad ogni macchina lo stesso carico (_caso ideale, che segue la media_);
  + vale $ L^* gt.eq max_j t_j , $ ovvero una macchina deve impiegare almeno il tempo più grande tra quelli disponibili.

  Guardiamo la macchina che dà il massimo carico, ovvero sia $hat(i)$ tale che $L_(hat(i)) = L$ e sia $hat(j)$ l'ultimo compito che le è stato assegnato. Se assegno $hat(j)$ vuol dire che poco prima questa macchina era la più scarica, quindi $ L_(hat(i)) - t_(hat(j)) = underbracket(L_(hat(i)) ', "carico in quel momento") lt.eq L_i quad forall i in m . $

  Sommiamo rispetto al numero di macchine, quindi $ sum_(i in m) L_(hat(i)) - t_(hat(j)) = m (L_(hat(i)) - t_(hat(j))) lt.eq sum_(i in m) L_i = sum_(j in n) t_j . $ Dividiamo tutto per $m$ e otteniamo $ L_(hat(i)) - t_(hat(j)) lt.eq 1/m sum_j t_j lt.eq^((1)) L^* . $

  Sappiamo che $ L = L_(hat(i)) = underbracket(L_(hat(i)) - t_(hat(j)), lt.eq L^*) + underbracket(t_(hat(j)), lt.eq L^* "per" (2)) lt.eq 2L^* $ quindi $ frac(L, L^*) lt.eq 2 . #qedhere $
]

L'algoritmo Greedy Load Balancing non è *tight*, ovvero posso costruire un input che si avvicini molto all'approssimazione alla quale appartiene il problema.

#theorem()[
  $forall epsilon > 0$ esiste un input per Load Balancing tale che Greedy Load Balancing produce un output $ 2 - epsilon lt.eq frac(L,L^*) lt.eq 2 . $
]

#proof()[
  Scelgo un numero di macchine $m > 1/epsilon$ e un numero di task $n = m(m-1) + 1$. Come sono fatti questi task? Li dividiamo come $ underbracket(task(1) dots task(1), m(m-1)) + task(m) . $

  Ragionando con un approccio greedy, assegno tutti gli $m(m-1)$ task da $1$ alle $m$ macchine, quindi ognuna ha $m-1$ task, poi manca solo quella che dura $m$, che assegno a caso visto che hanno tutte lo stesso carico. Il carico della macchina scelta sarà $L = m - 1 + m = 2m - 1$.

  Ragionando invece su come dovrebbe essere la configurazione ottima, questa dovrebbe assegnare la task grande $m$ alla prima macchina e le altre $m(m-1)$ alle restanti $m-1$ macchine, quindi ognuna, compresa la prima, ha ora un carico di $m$, quindi $L^* = m$.

  Confrontiamo i due valori: $ frac(L,L^*) = frac(2m - 1, m) = 2 - 1/m gt.eq 2 - epsilon . #qedhere $
]

Vediamo ora un algoritmo migliore per il Load Balancing.

#align(center)[
  #pseudocode-list(title: [Sorted Greedy Load Balancing])[
    - *input*
      - $m > 0$ numero di macchine
      - $n > 0$ numero di task
      - $(t_i)_(i in n)$ durata di ogni task
    + Ordina in maniera decrescente l'insieme $(t_i)_(i in n)$
    + Usa l'algoritmo Greedy Load Balancing
  ]
]

#theorem()[
  Sorted Greedy Load Balancing è una $3/2$-approssimazione per Load Balancing.
]

#proof()[
  Osserviamo che se $n lt.eq m$ la soluzione prodotta è ottima. Consideriamo quindi il caso $n > m$.

  Osserviamo inoltre che $L^* gt.eq 2 t_m$, ovvero che $1/2 L^* gt.eq t_m$, con $ underbracket(t_0 gt.eq dots gt.eq t_m, m+1 "task") gt.eq t_(m+1) gt.eq dots gt.eq t_(n-1) . $ Infatti, la macchina che riceve $2$ task ha carico $ gt.eq t_i + t_j gt.eq 2 t_m . $

  Sia $hat(i)$ l'indice della macchina con carico massimo, ovvero $L_(hat(i)) = L$. Se $hat(i)$ ha un compito solo, la soluzione è ottima.

  Consideriamo allora $hat(i)$ con più di un compito: sia $hat(j)$ l'ultimo compito assegnato a quella macchina. So che $hat(j) gt.eq m$, perché le prime $m$ task le do ad ogni macchina $i$ distinta, allora $ L = L_(hat(i)) = underbracket(L_(hat(i)) - t_(hat(j)), lt.eq L^*) - underbracket(t_(hat(j)), lt.eq t_m lt.eq 1/2 L^*) lt.eq 3/2 L^* . $ Ma allora $ frac(L,L^*) lt.eq 3/2 . #qedhere $
]

Graham nel $1969$ ha poi dimostrato che questo algoritmo è in realtà in $gAPX(4/3)$.

Hochbaum e Shmoys hanno dimostrato, nel $1988$, che:
- Load Balancing è un problema $PTAS$;
- Load Balancing non è un problema $FPTAS$.
