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

= Center Selection

Vediamo un esempio: abbiamo un insieme di magazzini di Amazon e vogliamo scegliere tra questi dei "_super magazzini_", ovvero magazzini ai quali gli altri magazzini si riferiscono. L'insieme di super magazzino più magazzini che si riferiscono al super magazzino è detto *cella di Voronoi*.

Uno *spazio metrico* è una coppia $(Omega,d)$ con $Omega$ insieme e $d : Omega times Omega arrow.long RR^(gt.eq 0)$ *metrica* che rispetta le seguenti proprietà:
- *simmetria*: $d(x,y) = d(y,x)$;
- *identità degli indiscernibili*: $d(x,y) = 0$ se e solo se $x = y$;
- *disuguaglianza triangolare*: $d(x,y) lt.eq d(x,z) + d(z,y)$, ovvero aggiungere una tappa intermedia al mio percorso non mi può mai far guadagnare della distanza.

Il nostro mondo, ad esempio, non è uno spazio metrico perché non rispetta la simmetria.

Su $Omega = RR^n$ si usa quasi sempre la *metrica euclidea*, ovvero $ d(overline(x), overline(y)) = sqrt(sum_i (x_i - y_i)^2) . $

Un'altra metrica molto famosa è quella *Manhattan*, la _"metrica dei taxi"_, ovvero mi è permesso spostarmi come a Manhattan, cioè in orizzontale e verticale, a gradino. La metrica è tale che $ d(overline(x), overline(y)) = sum_i abs(x_i - y_i) $ e, oltre ad essere uno spazio metrico, è una *ultra metrica*, ovvero $d(x,y) lt.eq max{d(x,z), d(y,z)}$.

Fissato $(Omega,d)$ spazio metrico, definiamo:
- *input*:
  - insieme $S subset.eq Omega$ di $n$ punti in uno spazio metrico;
  - budget $k > 0$ che indica quanti magazzini voglio costruire;
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
      + *output* $C$
    + else
      + *output* impossibile
  ]
]

#theorem()[
  Se Center Selection Plus emette un output allora esso è una $ frac(2r, rho^*) $ approssimazione.
]

#proof()[
  Se arriviamo alla fine dell'algoritmo vuol dire che $S$ è stato svuotato, perché ogni $s in S$ è stato cancellato da un certo $overline(s)$ per la sua distanza. Sappiamo che $ rho_C lt.eq d(s,overline(s)) lt.eq 2r , $ ma allora $ frac(rho_C, rho^*) lt.eq frac(2r, rho^*) . #qedhere $
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

Vediamo una versione di Greedy Center Selection che sarà utile per dimostrare alcune proprietà.

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
      + *output* $C$
    + else
      + *output* impossibile
  ]
]

Vediamo finalmente l'algoritmo che andremo poi a studiare, ovvero quello senza le indicazioni sul valore di $r$ che tanto vorremmo.

#align(center)[
  #pseudocode-list(title: [Greedy Center Selection])[
    - *input*:
      - $S subset.eq Omega bar.v abs(S) = n > 0$
      - $k > 0$
    + if $abs(S) lt.eq k$:
      + *output* $S$
    + $C arrow.l {overline(s)}$ per un certo $overline(s) in S$
    + while $abs(C) < k$:
      + seleziona $overline(s) in S$ che massimizzi $d(overline(s),C)$
      + $C arrow.l C union {overline(s)}$
    + *output* $C$
  ]
]

Con questo algoritmo scelgo esattamente $k$ centri, il primo scelto a caso, gli altri $k-1$ il più lontano possibile da quelli che ho già scelto.

#theorem()[
  Greedy Center Selection è una $2$-approssimazione per Center Selection.
]

#proof()[
  Ci servirà Center Selection Plus v2 per dimostrare questo teorema.

  Per assurdo supponiamo che l'algoritmo Greedy Center Selection emetta una soluzione con $rho > 2 rho^*$. Questo vuol dire che esiste un certo elemento $hat(s) in S$ tale che $d(hat(s),C) > 2 rho^*$.

  Sia $overline(s)_i$ l'$i$-esimo centro aggiunto a $C$ e sia $overline(C)_i$ l'insieme dei centri in quel momento; possiamo dire che $ underbracket(d(overline(s)_i, overline(C)_i) gt.eq d(hat(s), overline(C)_i), "prendo massima distanza") gt.eq d(hat(s),C) > 2 rho^* . $

  Questa esecuzione è una delle esecuzioni possibili di Center Selection Plus v2 quando $r = rho^*$. Noi sappiamo che questo algoritmo produce un output corretto, quindi termina entro $k$ iterazioni quando non ci sono più elementi a distanza maggiore di $2 rho^*$, quindi tutti gli $s in S$ sono tali che $d(s,C) lt.eq 2 rho^*$ ma questo non è vero, perché esiste $hat(s)$ tale che $d(hat(s),C) > 2 rho^*$.

  Questo è un assurdo, quindi la soluzione è tale che $rho lt.eq 2 rho^*$ e quindi $ frac(rho,rho^*) lt.eq 2 . qedhere $
]

Questo algoritmo è un esempio di *inapprossimabilità* o di *algoritmo tight*, ovvero non esistono algoritmi che approssimano Center Selection in un modo migliore di una $2$-approssimazione.

#theorem()[
  Se $P eq.not NP$ non esiste un algoritmo polinomiale che $alpha$-approssimi Center Selection per qualche $alpha < 2$.
]

#proof()[
  Usiamo il problema $NPC$ Dominating Set:
  - *input*:
    - grafo $G = (V,E)$;
    - $k > 0$;
  - *output*: ci chiediamo se $exists D subset.eq V bar.v abs(D) lt.eq k$ tale che $ forall x in V slash {D} quad exists d in D bar.v x d in E . $

  Questo problema deve scegliere dove mettere delle _guardie_ in un grafo, ovvero dei nodi che coprono i nodi a loro adiacenti, in modo che tutti i nodi siamo coperti.

  Dati $G$ e $k$ input di Dominating Set dobbiamo costruire una istanza di Center Selection.

  Partiamo con il definire lo spazio metrico $(Omega,d)$ con:
  - insieme $Omega = S = V$;
  - funzione distanza $ d(x,y) = cases(0 & "se" x = y, 1 & "se" x y in E, 2 quad & "se" x y in.not E) . $

  Dimostriamo che è uno spazio metrico:
  - simmetria: banale;
  - identità degli indiscernibili: banale;
  - disuguaglianza triangolare: notiamo che in questa disuguaglianza $ d(x,y) lt.eq d(x,z) + d(z,y) $ abbiamo il membro di sinistra che può assumere valori in ${1,2}$, stessa cosa per i due addendi del membro di destra, ma allora il membro di destra ha come valori possibili ${2,3,4}$, quindi vale la disuguaglianza triangolare.

  Come budget prendiamo esattamente $k$ numero di guardie.

  Ho creato il mio input per Center Selection. Chiediamoci quanto vale $rho^* (S,k)$, ma questa assume solo valori in ${1,2}$ per come ho definito la distanza.

  Quando ho distanza $1$? Devo scegliere $C$ con $abs(C) lt.eq k$ tale che $ forall s in S quad d(s,C) lt.eq 1 , $ ovvero tutti i punti sono a distanza $1$ dai loro centri. Ma allora $exists C^* subset.eq S$ tale che $ min_(c in C^*) space d(s,c) = 1 . $

  Essendo a distanza $1$ possiamo dire che $exists C^* subset.eq S$ tale che $ forall s in S quad exists c in C^* bar.v s c in E . $

  Questa è esattamente la definizione di Dominating Set, e il nostro Dominating Set è esattamente $C^*$.

  Noi abbiamo un algoritmo $alpha$-approssimante per Center Selection con $alpha < 2$, che fa $ (S,k) arrow.long.squiggly "ALGORITMO" arrow.long.squiggly rho^* (S,k) lt.eq underbracket(rho(S,k), "risultato") lt.eq alpha rho^* (S,k) . $

  Sappiamo che la distanza migliore è $1$ o $2$, ma allora:
  - se $rho^* = 1$ ottengo $1 lt.eq rho(S,k) lt.eq alpha$;
  - se $rho^* = 2$ ottengo $2 lt.eq rho(S,k) lt.eq 2 alpha$.

  Nel primo caso devo rispondere _SI_ al problema di Dominating Set, nel secondo caso devo rispondere _NO_. I due insiemi sono ovviamente disgiunti.

  Ma questo è un assurdo: avrei un algoritmo polinomiale per Dominating Set, quindi deve valere per forza $alpha gt.eq 2$
]
