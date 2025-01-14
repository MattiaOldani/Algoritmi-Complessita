// Setup

#import "../alias.typ": *

#import "@preview/fletcher:0.5.4": diagram, node, edge

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

= Commesso Viaggiatore (TSP)

== Teoria dei grafi

La *teoria dei grafi* nasce con Eulero a fine $'700$ con il *problema dei ponti di Konigsberg* (_oggi Kaliningrad_): abbiamo un fiume con due isole, e i collegamenti argine-isole e isole-isole sono definiti da $7$ ponti.

#v(12pt)

#align(center)[
  #diagram(
    node-stroke: .1em,
    spacing: 4em,

    node((1, 0), `sponda1`, radius: 2em, fill: green.lighten(50%)),
    node((0, 1), `sponda2`, radius: 2em, fill: green.lighten(50%)),
    node((2, 1), `sponda3`, radius: 2em, fill: green.lighten(50%)),
    node((1, 1), `isola`, radius: 2em, fill: blue.lighten(50%)),

    edge((1, 0), (0, 1), ``, "-|"),
    edge((1, 0), (1, 1), ``, "-|"),
    edge((1, 0), (2, 1), ``, "-|"),
    edge((0, 1), (1, 1), ``, "-|", bend: -20deg),
    edge((1, 1), (0, 1), ``, "-|", bend: -20deg),
    edge((1, 1), (2, 1), ``, "-|", bend: -20deg),
    edge((2, 1), (1, 1), ``, "-|", bend: -20deg),
  )
]

#v(12pt)

Possiamo scegliere un punto di partenza della città che mi permetta di passare per tutti i punti una e una sola volta per poi tornare al punto di partenza? Eulero, un fratello, astrae, quindi il problema si riduce alla ricerca di un *circuito euleriano* in un grafo non orientato.

In realtà, quello che stiamo utilizzando è un *multigrafo*: questo perché esistono due vertici che hanno almeno due lati incidenti.

#theorem([di Eulero])[
  Esiste un circuito euleriano se e solo se il grafo è connesso e tutti i vertici hanno grado pari.
]

#proof()[

  {$arrow.long.double.l$ solo questo}

  Partiamo da un vertice $x_0$ e ci spostiamo su un lato che incide su $x_0$ fino al vertice $x_1$. Ora, $x_1$ ha grado pari quindi da $x_1$ ho almeno un altro lato, che va a $x_2$. Ora, eccetera.

  Cosa può succedere in questa costruzione? Abbiamo due alternative:
  - incappiamo in un ciclo con un nodo che abbiamo già visitato, ma non ci sono problemi; infatti, se per esempio da $x_3$ vado a $x_1$ devo avere un altro nodo per avere il grado di $x_1$ pari;
  - arriviamo a $x_0$: abbiamo ancora due casi:
    - abbiamo esaurito i lati;
    - abbiamo cancellato un numero pari di lati da ogni nodo e ripartiamo con il percorso.

  Finito, odio il quadratino.
]

Vediamo ora il lemma delle strette di mano: dato un gruppo di persone che si stringono la mano, il numero di persone che stringono la mano ad un numero dispari di persone è pari.

#lemma([Handshaking lemma])[
  In un grafo, il numero di vertici di grado dispari è pari.
]

#proof()[
  Calcoliamo $ S = sum_(x in V) d(x) . $ Sicuramente $S$ è un numero pari, questo perché stiamo contando ogni lato due volte, visto che ogni lato incide su due vertici. Visto che la somma di numeri pari è ancora un numero pari, togliamo da $S$ tutti gli addendi pari, rimanendo solo con i dispari.

  Ma allora sto sommando tutti gli $x in V$ tali che $d(x)$ è dispari.
]

== Algoritmi

Il problema del *commesso viaggiatore* (_travelling salesman problem_) è il seguente: abbiamo un insieme di città collegate da strade di una certa lunghezza e il commesso vuole partire da un punto (_casa sua_), passare per tutte le città una sola volta, tornare al punto di partenza e camminare il meno possibile.

Vediamo ora la definizione rigorosa:
- *input*:
  - grafo non orientato $G = (V,E)$;
  - lunghezze $angle.l delta_e angle.r_(e in E)$;
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
  Se abbiamo a disposizione un algoritmo che risolve il TSP su cricche e vogliamo risolvere il TSP generale, basta aggiungere dei lati di peso spropositato fino a creare una cricca, e passare la nuova istanza al nostro algoritmo.

  Se abbiamo a disposizione un algoritmo che risolve il TSP generale e vogliamo risolvere il TSP su cricche, non dobbiamo modificare niente: il TSP generale lavora su qualsiasi grafo, quindi anche sulle cricche.
]

La prima modifica che facciamo a TSP è questa: assumiamo che i nostri grafi siano completi, ovvero siano delle *cricche*. Chiamiamo $G = K_m$ la cricca di $m$ nodi.

La seconda modifica che introduciamo è rendere la distanza uno *spazio metrico*, ovvero le distanze rispettano la disuguaglianza triangolare $ forall x,y,z quad delta_(x y) lt.eq delta_(x z) + delta_(z y) . $

Queste due modifiche rendono trasformando TSP nel problema *TSP metrico*.

Ci mancano infine _due ingredienti_, _due algoritmi_:
- *minimum spanning tree*: dato un grafo connesso pesato (_sui lati_), trovare un *albero di copertura* (_ovvero che tocca tutti i vertici_) di peso totale minimo. Questo problema si risolve in tempo polinomiale con vari algoritmi, il più famoso è l'*algoritmo di Kruskal*;
- *minimum-weight perfect matching*: data una cricca pesata con un numero pari di vertici, trovare un matching perfetto di peso minimo. In modo informale: i nodi si amano tutti (_cricca_), c'è attrito tra le coppie (_peso_), ma devo far sposare tutti (_matching perfetto_). Questo problema si risolve in tempo polinomiale con l'*algoritmo di Blossom*.

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
  Sia $pi^*$ il TSP ottimo. Dentro questo TSP ho anche i vertici di $D$, nodi che nell'albero che avevano grado dispari. Costruiamo un circuito sui vertici di $D$ nell'ordine in cui questi vertici compaiono in $pi^*$. Chiamiamo questo circuito $overline(pi)^*$.

  Sappiamo che $ delta(overline(pi)^*) lt.eq delta(pi^*) $ perché sto prendendo delle scorciatoie e quindi vale la disuguaglianza triangolare.

  Dividiamo i lati di $overline(pi)^*$ in due insiemi $M_1$ e $M_2$
  alternando l'inserimento dei lati. Ognuno dei due insiemi è un perfect matching su $D$. Ma $M$ è il minimum perfect matching, quindi $ delta(M) lt.eq delta(M_1) quad "e" quad delta(M) lt.eq delta(M_2), $ quindi $ 2 delta(M) lt.eq delta(M_1) + delta(M_2) = delta(overline(pi)^*) lt.eq delta(pi^*) = delta^* . $ Ma allora $ delta(M) lt.eq 1/2 delta^* . qedhere $
]

#theorem()[
  L'algoritmo di Christofides è una $3/2$-approssimazione per il TSP metrico.
]

#proof()[
  Osserviamo che $delta(pi) = delta(T) + delta(M)$, ma per i due lemmi precedenti sappiamo che $ delta(pi) lt.eq_(l 1 + l 2) delta^* + 1/2 delta^* = 3/2 delta^* . $ Noi però diamo in output $over(pi,tilde)$. Per la disuguaglianza triangolare, visto che noi strozziamo quando passiamo al circuito hamiltoniano, abbiamo che $ delta(over(pi,tilde)) lt.eq delta(pi) lt.eq 3/2 delta^*, $ quindi $ frac(delta(over(pi,tilde)), delta^*) lt.eq 3/2 . qedhere $
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

  #figure(image("assets/08_tight.svg", width: 75%))

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

L'algoritmo di Christofides è stato ideato verso la fine degli anni $'70$, ed è il migliore attualmente a nostra disposizione. Possiamo fare di meglio modificando il grafo, imponendo le distanze tutte uguali a $1$ o $2$. Questo algoritmo è stato scoperto in parallelo da un personaggio russo durante la guerra fredda, ma visto che non si parlavano nessuno sapeva dell'altro.

#lemma()[
  Il problema di decidere se un grafo ammetta un circuito hamiltoniano è $NPC$.
]

#theorem()[
  Non esiste $alpha > 1$ tale che il TSP generale sia $alpha$-approssimabile.
]

#proof()[
  Supponiamo per assurdo di avere un algoritmo $alpha$-approssimante per TSP, con $alpha > 1$.

  Dato un grafo $G = (V,E)$ vogliamo sapere se esso ha un CH. Trasformiamo $G$ in una istanza accettabile per TSP: per fare ciò dobbiamo rendere il grafo una cricca e dare dei pesi ad ogni lato. Creiamo quindi la cricca $ G' = (V, binom(V,2), d) $ con $ d(x,y) = cases(1 & "se" {x,y} in E, ceil(alpha n) + 1 quad & "altrimenti") . $

  Se $G$ aveva un CH allora $G'$ ne ha uno di lunghezza $ lt.eq n$. Se $G$ non ha un CH allora qualunque CH di $G'$ ha lunghezza $gt.eq ceil(alpha n) + 1$.

  Valuto il mio algoritmo $alpha$-approssimante per TSP sull'istanza $G'$. Se questo fosse un algoritmo esatto allora troverebbe il migliore CH, e guardando l'output (_la lunghezza del CH_) potrei dire se lo stesso CH era in $G$, quindi otterrei un assurdo.

  Questo purtroppo è un algoritmo approssimato, quindi abbiamo due casi:
  - se $G$ ha un CH allora in $G'$ ho un CH di lunghezza $n$, ma essendo un algoritmo approssimato mi viene restituito un CH un pelo più lungo ma comunque $lt.eq alpha n$;
  - se $G$ non ha un CH allora in $G'$ ho un CH di lunghezza $gt.eq ceil(alpha n) + 1$.

  I due intervalli non si sovrappongono: infatti, se per assurdo $alpha n gt.eq ceil(alpha n) + 1$, allora $ alpha gt.eq frac(ceil(alpha n) + 1, n) gt.eq frac(alpha n + 1, n) = alpha + 1/n , $ che è un assurdo. I due insiemi quindi non si sovrappongono.

  Ma questo è impossibile: riesco a decidere se $G$ ha un CH in tempo polinomiale, ma per il lemma precedente questo questo non è possibile in tempo polinomiale.
]
