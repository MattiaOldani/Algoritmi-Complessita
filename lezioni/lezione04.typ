#import "alias.typ": *

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


= Lezione 04 [10/10]

== Ancora Load Balancing

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

  Sia $over(i,tilde)$ la macchina tale che $L_(over(i,tilde)) = L$ indice della macchina con carico massimo. Se $over(i,tilde)$ ha un compito solo, la soluzione è ottima.

  Consideriamo allora $over(i,tilde)$ con più di un compito: sia $over(j,tilde)$ l'ultimo compito assegnato a quella macchina. So che $over(j,tilde) gt.eq m$, perché le prime $m$ task le do ad ogni macchina $i$ distinta, allora $ L = L_(over(i,tilde)) = underbracket(L_(over(i,tilde)) - t_(over(j,tilde)), lt.eq L^*) - underbracket(t_(over(j,tilde)), lt.eq t_m lt.eq 1/2 L^*) lt.eq 3/2 L^* . $ Ma allora $ frac(L,L^*) lt.eq 3/2 . #qedhere $
]

Graham nel 1969 ha poi dimostrato che questo algoritmo è una $4/3$-approssimazione.

Hochbaum e Shmoys hanno dimostrato, nel 1988, che:
- Load Balancing è un problema $PTAS$;
- Load Balancing non è un problema $FPTAS$.

== Center Selection

Vediamo un esempio: abbiamo un insieme di magazzini di Amazon e vogliamo scegliere tra questi dei "_super magazzini_", ovvero magazzini ai quali gli altri magazzini si riferiscono. L'insieme di super magazzino più magazzini che si riferiscono al super magazzino è detto *cella di Voronoi*.

Uno *spazio metrico* è una coppia $(Omega,d)$ con $Omega$ insieme e $d : Omega times Omega arrow.long RR^(gt.eq 0)$ *metrica* che rispetta le seguenti proprietà:
- *simmetria*: $d(x,y) = d(y,x)$;
- *identità degli indiscernibili*: $d(x,y) = 0$ se e solo se $x = y$;
- *disuguaglianza triangolare*: $d(x,y) lt.eq d(x,z) + d(z,y)$, ovvero aggiungere una tappa intermedia al mio percorso non mi può mai far guadagnare della distanza.

Il nostro mondo, ad esempio, non è uno spazio metrico perché non rispetta la simmetria.

Su $Omega = RR^n$ si usa quasi sempre la *metrica euclidea*, ovvero $ d(overline(x), overline(y)) = sqrt(sum_i (x_i - y_i)^2) . $

Un'altra metrica molto famosa è quella *Manhattan*, la _"metrica dei taxi"_, ovvero mi è permesso spostarmi come a Manhattan, cioè in orizzontale e verticale, a gradino. La metrica è tale che $ d(overline(x), overline(y)) = sum_i abs(x_i - y_i) $ e, oltre ad essere uno spazio metrico, è una *ultra metrica*, ovvero $d(x,y) lt.eq max{d(x,z), d(y,z)}$.

Fissato $(Omega,d)$ spazio metrico, definiamo:
- *input*: insieme $S subset.eq Omega$ di $n$ punti in uno spazio metrico e un budget $k > 0$ che indica quanti magazzini voglio costruire;
- *soluzione accettabile*: insieme $C subset.eq S$ di centri, con $abs(C) lt.eq k$. Definisco:
  - $dist(x,A) = min_(y in A) d(x,y)$ minima distanza tra $x$ e gli elementi di $A$;
  - $forall s in S quad delta_C (s) = dist(s,C)$ raggio di copertura del nodo $s$;
  - $rho_C = max_(s in S) delta_C (s)$ il massimo raggio di copertura;
- *obiettivo*: $rho_C$;
- *tipo*: $min$.

Vogliamo minimizzare il massimo raggio di copertura. Questo problema è un problema $NPOC$.

Costruiamo una prima soluzione facendo finta di sapere un dato che però dopo non sapremo.

#align(center)[
  #pseudocode-list(title: [Center Selection Plus v1])[
    - *input*:
      - $S subset.eq Omega bar.v abs(S) = n > 0$
      - $k > 0$
      - $r in RR^(> 0)$
    + $C arrow.l emptyset.rev$ insieme dei centri scelti
    + while $S eq.not emptyset.rev$:
      + $overline(s) arrow.l "take-any-from"(S)$
      + $C arrow.l C union {overline(s)}$
      + for $s$ in $S$ tali che $d(s,overline(s)) lt.eq 2r$:
        + $S arrow.l S slash {s}$
    + if $abs(C) lt.eq k$
      + output $C$
    + else
      + output "Impossibile"
  ]
]

#theorem()[
  Se Center Selection Plus emette un output allora esso è una $frac(2r, rho^*)$-approssimazione.
]

#proof()[
  Se arriviamo alla fine dell'algoritmo vuol dire che $S$ è stato svuotato, perché ogni $s in S$ è stato cancellato da un certo $overline(s)$ per la sua distanza. Sappiamo che $ rho_C lt.eq delta_C (s) lt.eq d(s,overline(s)) lt.eq 2r , $ ma allora $ frac(rho_C, rho^*) lt.eq frac(2r, rho^*) . #qedhere $
]

#theorem()[
  Se $r gt.eq rho^*$ l'algoritmo emette un output.
]

#proof()[
  Sia $C^*$ una soluzione ottima, cioè una serie di centri che ha come raggio di copertura $rho^*$. Sia $overline(s) in C$, chiamiamo $overline(c)^* in C^*$ il centro al quale si riferisce $overline(s)$ nella soluzione ottima.

  Sia $X$ l'insieme dei punti che nella soluzione ottima $C^*$ si rivolgono a $overline(c)^*$, allora $forall s in X$ posso dire che $ d(s,overline(s)) lt.eq d(s, overline(c)^*) + d(overline(c)^*, overline(s)) $ ma le due distanze sono più piccole del raggio di copertura ottimo perché si riferiscono a lui, quindi $ d(s,overline(s)) lt.eq 2 rho^* lt.eq 2r $ ma allora verrebbero tutti cancellati da $X$ quando seleziono $s$, come abbiamo scritto nell'algoritmo sopra.

  Dopo $lt.eq k$ passi ho cancellato tutto, quindi ho un output.
]

Questi teoremi ci dicono che l'output è approssimato in base a $r$, che poi mi dà anche una cosa in più per capire se ho soluzioni. Ma che valori possiamo scegliere per $r$? Andiamo a vedere:
- se $r = rho^*$ allora ho una $2$-approssimazione;
- se $r > rho^*$ allora l'approssimazione diventa peggiore, ma abbiamo comunque un output;
- se $r < 1/2 rho^*$ sto approssimando con $frac(2r, rho^*) < frac(rho^*, rho^*) = 1$ che però è impossibile:
- se $1/2 rho^* lt.eq r < rho^*$ è random.

Vorremmo sempre avere $rho^*$ ma non ce l'abbiamo.

Vediamo una versione di Greedy Center Selection che sarà utile la prossima lezione per dimostrare alcune proprietà.

#align(center)[
  #pseudocode-list(title: [Center Selection Plus v2])[
    - *input*:
      - $S subset.eq Omega bar.v abs(S) = n > 0$
      - $k > 0$
      - $r in RR^(> 0)$
    + $C arrow.l {overline(s)}$ per un certo $overline(s) in S$
    + while true:
      + if $exists overline(s) in S bar.v d(overline(s),C) > 2r$:
        + $C arrow.l C union {overline(s)}$
      + else
        + break
    + if $abs(C) lt.eq k$
      + output $C$
    + else
      + output "Impossibile"
  ]
]

Vediamo finalmente l'algoritmo che andremo poi a studiare, ovvero quello senza le indicazioni sul valore di $r$ che tanto vorremmo.

#align(center)[
  #pseudocode-list(title: [Greedy Center Selection])[
    - *input*:
      - $S subset.eq Omega bar.v abs(S) = n > 0$
      - $k > 0$
    + if $abs(S) lt.eq k$:
      + output $S$
    + $C arrow.l {overline(s)}$ per un certo $overline(s) in S$
    + while $abs(C) < k$:
      + seleziona $overline(s) in S$ che massimizzi $d(overline(s),C)$
      + $C arrow.l C union {overline(S)}$
    + output $C$
  ]
]

Con questo algoritmo scelgo esattamente $k$ centri, il primo scelto a caso, gli altri $k-1$ il più lontano possibile da quelli che ho già scelto.
