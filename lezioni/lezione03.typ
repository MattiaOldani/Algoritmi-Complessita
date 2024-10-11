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


= Lezione 03

== Max Matching

Il primo (_e unico_) problema di ottimizzazione in $PO$ che vedremo sarà il problema di *Max Matching*.

Questo problema è definito da:
- *input*: grafo $G = (V,E)$ non orientato e bipartito, ma quest'ultima condizione può anche essere tolta. Un grafo bipartito è un grafo nel quale i vertici sono divisi in due blocchi e i lati vanno da un vertice del primo blocco ad un vertice del secondo blocco (_e viceversa, ma tanto è non orientato_). In poche parole, non ho lati che collegano vertici nello stesso blocco, quindi siamo #align(center)[
  #block(
    fill: rgb("#9FFFFF"),
    inset: 8pt,
    radius: 4pt,

    [*POCO LGBTQ+ FRIENDLY (godo)*],
  )
]
- *soluzioni ammissibili*: una soluzione ammissibile è un *matching* $M$, una scelta di lati tale che i vertici del grafo risultano incisi al più da un lato. In poche parole, *viva i matrimoni non poligami*, dobbiamo far sposare persone che si piacciono e solo una volta, ma accettiamo anche i single (_come me_);
- *obiettivo*: numero di match $abs(M)$;
- *tipo*: massimizzare il numero di match, quindi $max$.

Una soluzione in tempo polinomiale sfrutta l'*algoritmo del cammino aumentante*.

Un cammino aumentante si applica ad un grafo con un matching $M$ parziale. Per trovare i cammini aumentanti ci serviranno i *vertici esposti*, ovvero vertici sui quali non incidono i lati presi nel matching.

Un *cammino aumentante* (_augmenting path_) è un cammino che parte e arriva su un vertice esposto e alterna "lati liberi" e lati di $M$. Se so che esiste un cammino aumentante, scambio i lati presi e quelli non presi facendo un'operazione di *switch*: il matching cambia ma soprattutto aumenta di $1$ il numero di lati presi.

Questa è un'informazione pazza: se so che esiste un cammino aumentante il matching non è massimo e lo posso quindi migliorare.

#lemma()[
  Se esiste un cammino aumentante per il matching $M$ allora $M$ non è massimo.
]

#lemma()[
  Se il matching $M$ non è massimo allora esiste un cammino aumentante per $M$.
]

#proof()[
  Sia $M'$ un matching tale che $abs(M') > abs(M)$, che esiste per ipotesi. I matching sono un insieme di lati, quindi potremmo avere:
  - lati solo in $M$ ($M slash M'$);
  - lati solo in $M'$ ($M' slash M$);
  - lati sia in $M$ sia in $M'$ ($M sect M'$).

  Prendiamo i lati che sono in $ M Delta M' = (M slash M') union (M' slash M) = (M union M') slash (M sect M') $ differenza simmetrica dei due match.

  Osserviamo che nessun vertice può avere più di due lati incidenti in $M Delta M'$. Possiamo dire di più: se un vertice ha esattamente due lati incidenti allora questi arrivano da due match diversi per definizione di match.

  Se disegniamo il grafo con i soli vertici che sono incisi dai lati di $M Delta M'$, abbiamo solo vertici di grado $1$ e vertici di grado $2$. Un grafo di questo tipo ha solo cammini e cicli, non esiste altro.

  Se consideriamo i cicli, essi sono formati da vertici di grado $2$, che hanno due lati incidenti ma arrivano da due matching diversi. Questo implica che ogni ciclo copre lo stesso numero di lati di $M slash M'$ e lati di $M' slash M$ e hanno lunghezza pari. Ma visto che $abs(M') > abs(M)$ deve esistere qualcosa nel grafo che abbia più lati di $M'$ al suo interno.

  Se non è un ciclo, allora è un cammino: infatti, quello detto poco fa sui cicli implica che esiste un cammino nel grafo che è formato da più lati di $M' slash M$ (_esattamente uno in più_), ovvero un cammino che inizia a finisce con lati di $M' slash M$. Questo cammino, dal punto di vista di $M$, è aumentante: alterna lati di $M$ con lati che non sono in $M$ (_per definizione di differenza_) e ai bordi ci sono due vertici che non sono incisi da lati di $M$.
]

Per trovare un cammino aumentante dobbiamo fare una *visita di grafo*. Una visita è un modo sistematico che si usa per scoprire un grafo. Abbiamo tre tipi di nodi:
- nodi sconosciuti (_bianchi_);
- nodi conosciuti ma non ancora visitati, che sono in una zona detta *frontiera* (_grigi_);
- nodi visitati (_neri_).

Vediamo come funziona l'algoritmo di visita, usando la funzione $c(x) arrow.l t$ che assegna al vertice $x$ il colore $t$.

#align(center)[
  #pseudocode-list(title: [Algoritmo di visita])[
    + for $x$ in $V$:
      + $c(x) arrow.l W$
    + $F arrow.l {x_("seed")}$
    + $c(x_("seed")) arrow.l G$
    + while $F eq.not emptyset.rev$:
      + $x arrow.l "pick"(F)$
      + $"visit"(x)$
      + $c(x) arrow.l B$
      + for $y$ in $"neighbor"(x)$:
        + if $c(y) == W$:
          + $F arrow.l F union {y}$
          + $c(y) arrow.l G$
  ]
]

Se il grafo è *connesso* lo riesco a visitare tutto e ogni vertice lo visito una volta sola. Se non è connesso visito solo la componente connessa del seme e, per continuare la visita, devo mettere un nuovo seme nella frontiera per andare avanti. Questo algoritmo è quindi ottimo per trovare le *componenti connesse* del grafo.

La funzione `pick` determina il comportamento di questa visita: se utilizziamo uno *stack* stiamo facendo una DFS (_visita in profondità_), se utilizziamo invece una *pila* stiamo facendo una BFS (_visita in ampiezza_). Infatti, in base a come si comporta la funzione `pick` abbiamo un ordine di scelta dei nodi diverso.

La BFS è interessante perché, a partire dal seme, nella frontiera metto i nodi vicini al seme, poi i vicini dei vicini del seme, poi eccetera. In poche parole, visito nell'ordine i nodi alla stessa distanza dal seme. Questo è uno dei modi standard per calcolare le distanze in un grafo non orientato e non pesato. Andremo quindi ad usare una BFS per trovare i cammini aumentanti.

#align(center)[
  #pseudocode-list(title: [Find Augmenting])[
    + $X arrow.l$ vertici esposti in $M$
    + for $x$ in $X$:
      + $"BFS"(x)$ con alternanza di lati in $M$ e lati fuori da $M$
      + se durante la ricerca trovo un altro vertice di $X$
        + ritorno il cammino trovato
  ]
]

La BFS ha tempo proporzionale al numero di lati, quindi Find Augmenting impiega tempo $O(n m)$. Quanti aumenti posso fare? Al massimo $n/2$, quindi ho $O(n^2 / 2 m)$, che è al massimo $O(n^4)$.

#theorem()[
  Bipartite Max Matching è in $PO$.
]

#corollary()[
  Il problema di decisione Perfect Matching è in $P$.
]

Se il grafo non fosse bipartito avremmo l'*algoritmo di fioritura*, che non sfrutta la BFS.

== Load Balancing

Usciamo fuori dai problemi in $PO$ e vediamo il problema del *Load Balancing*. Esso è definito da:
- *input*: abbiamo tre dati:
  - $m > 0$ numero di macchine;
  - $n > 0$ numero di task;
  - $(t_i)_(i in n) > 0$ durate dei task;
- *soluzione ammissibile*: funzione $ alpha : n arrow.long m $ che assegna ogni task ad una macchina. Il carico di una macchina $j$ è la quantità $ L_j = sum_(i bar.v alpha(i) = j) t_i . $ Il carico generale è $ L = max_j L_j ; $
- *funzione obiettivo*: $L$;
- *tipo*: $max$.

#theorem()[
  Load Balancing è $NPO$-completo.
]

Che problemi stanno in $NPO$? È difficile dare una definizione di non determinismo nei problemi di ottimizzazione, però possiamo definire $NPOC$: un problema di ottimizzazione $Pi$ è $NPO$-completo se e solo se:
- $Pi in NPO$;
- $over(Pi,tilde) in NPC$.

Se un problema in $NPOC$ fosse polinomiale allora il suo problema di decisione associato sarebbe polinomiale, e questo non può succedere.

Vediamo un *algoritmo greedy*, una tecnica di soluzione che cerca di ottimizzare "in modo miope", ovvero costruisce passo dopo passo la soluzione prendendo ogni volta la direzione che sembra ottima in quel momento.

#align(center)[
  #pseudocode-list(title: [Greedy Load Balancing])[
    + for $i$ in $m$:
      + $A_i arrow.l emptyset.rev$ (task assegnate alla macchina)
      + $L_i arrow.l 0$ (carico della macchina)
    + for $j$ in $n$:
      + $i arrow.l arg min_(i in m) L_i$ (indice macchina con meno carico)
      + $A_i arrow.l A_i union {j}$
      + $L_i arrow.l L_i + t_j$
    + $alpha$ assegna ogni elemento di $A_i$ alla macchina $i$
  ]
]

Il tempo d'esecuzione di questo algoritmo è $O(n m)$, ed è molto comodo perché è possibile utilizzarlo anche *online*, ovvero quando i task non sono tutti conosciuti ma possono arrivare anche durante l'esecuzione dell'algoritmo.

#theorem()[
  Greedy Load Balancing è una $2$-approssimazione per Load Balancing.
]

#proof()[
  Chiamiamo $L^*$ il valore della funzione obiettivo nella soluzione ottima.

  Osserviamo che:
  + vale la relazione $ L^* gt.eq 1/m sum_j t_j , $ ovvero il carico migliore ci mette almeno un tempo uguale allo "spezzamento perfetto", cioè quello che assegna ad ogni macchina lo stesso carico (_caso ideale, che segue la media_);
  + vale la relazione $ L^* gt.eq max_j t_j , $ ovvero una macchina deve impiegare almeno il tempo più grande tra quelli disponibili.

  Guardiamo la macchina che dà il massimo carico, ovvero sia $over(i,tilde)$ tale che $L_(over(i,tilde)) = L$ e sia $over(j,tilde)$ l'ultimo compito che le è stato assegnato. Se assegno $over(j,tilde)$ vuol dire che poco prima questa macchina era la più scarica, quindi $ L_(over(i,tilde)) - t_(over(j,tilde)) = underbracket(L_(over(i,tilde)) ', "carico in quel momento") lt.eq L_i quad forall i in m . $

  Sommiamo rispetto al numero di macchine, quindi $ sum_(i in m) L_(over(i,tilde)) - t_(over(j,tilde)) = m (L_(over(i,tilde)) - t_(over(j,tilde))) lt.eq sum_(i in m) L_i = sum_(j in n) t_j . $ Dividiamo tutto per $m$ e otteniamo $ L_(over(i,tilde)) - t_(over(j,tilde)) lt.eq 1/m sum_j t_j lt.eq^((1)) L^* . $

  Sappiamo che $ L = L_(over(i,tilde)) = underbracket(L_(over(i,tilde)) - t_(over(j,tilde)), lt.eq L^*) + underbracket(t_(over(j,tilde)), lt.eq L^* "per" (2)) lt.eq 2L^* $ quindi $ rappr("GLB") = frac(L, L^*) lt.eq 2 . #qedhere $
]
