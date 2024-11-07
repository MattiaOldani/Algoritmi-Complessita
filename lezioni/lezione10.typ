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


= Lezione 10 [07/11]

== Problema del commesso viaggiatore [TSP]

Il problema del *commesso viaggiatore* (_travelling salesman problem_) è il seguente: abbiamo un insieme di città collegate da strade di una certa lunghezza e il commesso vuole partire da un punto (_casa sua_), passare per tutte le città una sola volta, tornare al punto di partenza e camminare il meno possibile.

Vediamo ora la definizione rigorosa:
- *input*: grafo non orientato $G = (V,E)$ con delle lunghezze $angle.l delta_e angle.r_(e in E)$;
- *soluzioni ammissibili*: circuiti che passano per ogni vertice esattamente una volta; i circuiti che hanno questa proprietà sono detti *circuiti hamiltoniani*;
- *funzione obiettivo*: lunghezza del circuito, ovvero la somma delle lunghezze dei lati scelti per il circuito hamiltoniano;
- *tipo*: $min$.

Questo problema è molto difficile, anche nella sua versione approssimata, per due motivi:
- non è detto che un circuito hamiltoniano esista;
- riusciamo a fare bene solo in alcuni casi speciali, ovvero con particolari grafi o lunghezze.

Noi faremo due modifiche al problema TSP per renderlo _"studiabile"_.

#lemma()[
  TSP $equiv$ TSP su cricche.
]

#proof()[
  Da chiedere, non l'ho capita.

  /*
  <-- banale.
  --> tutti i lati che mancano gli aggiungiamo con lunghezze esagerate, se uso un lato fittizio allora non avevo un circuito prima, altrimenti si.
  */
]

La prima modifica che facciamo a TSP è questa: assumiamo che i nostri grafi siano completi, ovvero siano delle *cricche*. Chiamiamo $G = K_m$ la cricca di $m$ nodi.

La seconda modifica che introduciamo è rendere la distanza uno *spazio metrico*, ovvero le distanze rispettano la disuguaglianza triangolare $ forall x,y,z quad delta_(x y) lt.eq delta_(x z) + delta_(z y) . $

Queste due modifiche rendono trasformando TSP nel problema *TSP metrico*.

Ci mancano infine _due ingredienti_, _due algoritmi_:
- *minimum spanning tree*: dato un grafo connesso pesato (_sui lati_), trovare un *albero di copertura* (_ovvero che tocca tutti i vertici_) di peso totale minimo. Un *albero* in teoria dei grafi è un grafo connesso aciclico. Se il grafo non è connesso si chiama foresta. Gli alberi in informatica sono invece *alberi radicati*, ovvero viene scelto un vertice come radice e il grafo viene _"appeso"_ a questo vertice e il resto cade per gravità. Questo problema si risolve in tempo polinomiale con vari algoritmi, il più famoso è l'*algoritmo di Kruskal*;
- *minimum-weight perfect matching*: data una cricca pesata con un numero pari di vertici, trovare un matching perfetto di peso minimo. In modo informale: i nodi si amano tutti (_cricca_), c'è attrito tra le coppie (_peso_), ma devo far sposare tutti (_matching perfetto_). Questo problema si risolve in tempo polinomiale con l'*algoritmo di Blossom*.

== Algoritmo di Christofides

Possiamo finalmente vedere l'algoritmo per il TSP metrico.

#align(center)[
  #pseudocode-list(title: [Algoritmo di Christofides])[
    - *input*
      - cricca $G = (V,E)$
      - pesi $angle.l delta_e angle.r_(e in E)$ che sono una metrica
    + $T = $ minimum spanning tree di $G$
    + $D = $ insieme dei vertici di grado dispari in $T$
    - Per l'handshaking lemma, $abs(D)$ ha cardinalità pari
    + $M = $ minimum-weight perfect matching su $D$
    - Può succedere che $T sect.big M eq.not emptyset.rev$, ovvero dei lati sono usati per entrambi gli insiemi
    + $H = T union.big.dot M$ unione disgiunta che contiene i doppioni, quindi ho un multigrafo
    - $D$ ora ha tutti vertici di grado pari, visto che ho aggiunto i lati del match $M$
    + $pi = $ cammino euleriano, la cui esistenza è garantita dal teorema di Eulero
    + $over(pi,tilde)$ = trasformazione di $pi$ in un circuito hamiltoniano tramite strozzatura dei cappi
      - se ho un arco $(x,y)$, con $y$ già toccato una volta, vado nel nodo dopo $y$
      - sotto ho una cricca, quindi posso andare dove voglio con gli archi
      - prendo tutti i vertici ma saltando i doppioni
    + *output* $over(pi,tilde)$
  ]
]

Vediamo due lemmi che saranno utili per calcolare l'approssimazione che fornisce questo algoritmo.

#lemma()[
  $ delta(T) lt.eq delta^* . $
]

#proof()[
  Sia $pi^*$ un TSP ottimo. Se da $pi^*$ togliamo un qualunque lato $e$ otteniamo un albero di copertura. Siccome $T$ è albero di copertura minimo, allora $ delta(T) lt.eq delta^* - delta_e lt.eq delta^* . qedhere $
]

#lemma()[
  $ delta(M) lt.eq 1 / 2 delta^* . $
]

#proof()[
  Sia $pi^*$ il TSP ottimo. Dentro questo TSP ho anche i vertici di $D$, nodi che nell'albero avevano grado dispari. Costruiamo un circuito sui vertici di $D$ nell'ordine in cui questi vertici compaiono in $pi^*$. Chiamiamo questo circuito $overline(pi)^*$.

  Sappiamo che $ delta(overline(pi)^*) lt.eq delta(pi^*) $ perché sto prendendo delle scorciatoie e quindi vale la disuguaglianza triangolare.

  Dividiamo i lati di $overline(pi)^*$ in due insiemi $M_1$ e $M_2$
  alternando l'inserimento dei lati. Ognuno dei due insiemi è un perfect matching su $D$. Ma $M$ è il minimum perfect matching, quindi $ delta(M) lt.eq delta(M_1) quad "e" quad delta(M) lt.eq delta(M_2), $ quindi $ 2 delta(M) lt.eq delta(M_1) + delta(M_2) = delta(overline(pi)^*) lt.eq delta(pi^*) = delta^* . $ Ma allora $ delta(M) lt.eq 1/2 delta^* . qedhere $
]

#theorem()[
  L'algoritmo di Christofides è una $3/2$-approssimazione per il TSP metrico.
]

#proof()[
  Osserviamo che $delta(pi) = delta(T) + delta(M)$, ma per i due lemmi precedenti sappiamo che $ delta(pi) lt.eq_(l_1 + l_2) delta^* + 1/2 delta^* = 3/2 delta^* . $ Noi però diamo in output $over(pi,tilde)$. Per la disuguaglianza triangolare, visto che noi strozziamo quando passiamo al circuito hamiltoniano, abbiamo che $ delta(over(pi,tilde)) lt.eq delta(pi) lt.eq 3/2 delta^*, $ quindi $ frac(delta(over(pi,tilde)), delta^*) lt.eq 3/2 . qedhere $
]

#theorem()[
  L'analisi fatta è stretta.
]

#proof()[
  Dato $n$ un numero intero pari e $epsilon in (0,1)$ l'errore, costruisco il grafo $G_((n,epsilon))$ formato dai vertici $v_1, v_2, dots, v_n$ collegati da:
  - lati $(v_i,v_(i+1))$ di lunghezza $1$;
  - lati $(v_i, v_(i+2))$ di lunghezza $1 + epsilon$.

  Devo avere quel bound sulla $epsilon$ perché senza la distanza considerata non sarebbe una metrica.

  #v(12pt)

  #figure(
    image("assets/10_tight.svg", width: 75%),
  )

  #v(12pt)

  Trasformo il grafo in una cricca ma i lati aggiunti devono mantenere la metrica. Costruiamo quindi $K_((n,epsilon))$ a partire da $G_((n,epsilon))$ con i lati nuovi di lunghezza uguale allo shortest path tra i due vertici incidenti. In questo modo rispetto naturalmente la disuguaglianza triangolare, essendo uguale alla somma dei due cammini minimi.

  L'algoritmo di Christofides per prima cosa trova l'albero di copertura minimo $T$, che è quello formato dai soli lati di lunghezza $1$. Non conviene scegliere i lati lunghi $1 + epsilon$ perché prendendoli siamo obbligati a prendere un altro lato (_quello per collegare il vertice saltato_) e avere quindi $2 + epsilon > 1$. Abbiamo quindi $delta(T) = n - 1$.

  Tutti i vertici interni a $T$ hanno grado pari, mentre i due vertici sugli estremi hanno grado dispari, quindi il minimum-weight perfect matching è quello che collega $v_1$ con $v_n$. Per fare ciò prendo i lati di lunghezza $1 + epsilon$ fino all'ultimo vertice di indice dispari $v_(n-1)$, e infine prendo l'ultimo lato di lunghezza $1$. Abbiamo quindi $delta(M) = (1 + epsilon) n/2 + 1$.

  Ma allora $ delta = delta(T) + delta(M) = (n - 1) + (n/2 + epsilon n / 2 + 1) = 3/2 n + epsilon n/2 . $

  Il circuito hamiltoniano minimo si trova partendo da $v_2$. Esso si trova facendo:
  - $v_2 arrow.long v_1$ di lunghezza $1$;
  - $v_1 arrow.long^* v_(n-1)$ di lunghezza $(1 + epsilon) n/2$;
  - $v_(n-1) arrow.long v_n$ di lunghezza $1$;
  - $v_n arrow.long^* v_2$ di lunghezza $(1 + epsilon) n/2$.

  Ma allora $ delta^* = 1 + (1 + epsilon) n/2 + (1 + epsilon) n/2 + 1 = (1 + epsilon) n + 2 . $

  Calcoliamo infine $ frac(delta, delta^*) = frac(3/2 n + epsilon n/2, (1 + epsilon) n + 2) space arrow.long_(n arrow infinity) space 3/2 . qedhere $
]

Si può dimostrare che TSP metrico è $3/2$-approssimabile, e che l'algoritmo di Christofides è il migliore disponibile.
