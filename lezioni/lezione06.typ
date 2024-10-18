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


= Lezione 06 [17/10]

== Ancora Set Cover

#theorem()[
  Sia $M = max_i abs(S_i)$, allora Greedy Set Cover è una $H(M)$-approssimazione per Set Cover.
]

#proof()[
  Sia $I^*$ una soluzione ottima, ovvero un insieme di indici tali che $ w^* = sum_(i in I^*) w_i . $ Per il lemma 2 della scorsa lezione vale $ w_i gt.eq frac(sum_(s in S_i) c(s), H(abs(S_i))) gt.eq frac(sum_(s in S_i) c(s), H(M)) $ perché $H(M) gt.eq H(abs(S_i))$ vista la monotonia di $H$.

  Possiamo scrivere anche che $ underbracket(sum_(i in I^*) sum_(s in S_i) c(s), "più di una volta") gt.eq sum_(s in U) c(s) = w . $

  Uniamo i due risultati e otteniamo $ w^* = sum_(i in I^*) w_i gt.eq^(*) sum_(i in I^*) frac(sum_(s in S_i) c(s), H(abs(M))) gt.eq^(**) frac(w, H(M)) . $

  Ma allora $ frac(w, w^*) lt.eq H(M) . qedhere $
]

L'approssimazione che ho non è esatta, ma dipende dall'input.

Notiamo che $M lt.eq abs(U) = n$, ma $H(M) lt.eq H(n)$ per monotonia di $H$ e quindi $ H(M) lt.eq H(n) = O(log(n)) . $

#corollary()[
  Greedy Set Cover è una $O(log(n))$-approssimazione per Set Cover.
]

Questo qui è un *algoritmo tight*: infatti, riusciremo a creare un input ad hoc che si avvicina al tasso di approssimazione a meno di un errore molto piccolo.

#example()[
  Il nostro universo è formato da:
  - $2$ insiemi $A,B$ di costo $1 + epsilon$ con $n/2$ punti;
  - $1$ insieme _giallo_ di costo $1$ con $n/2$ punti, $n/4$ punti da $A$ e $n/4$ punti da $B$;
  - $1$ insieme _arancio_ di costo $1$ con $n/4$ punti, $n/8$ punti da $A$ e $n/8$ punti da $B$;
  - $1$ insieme _rosso_ di costo $1$ con $n/8$ punti, $n/16$ punti da $A$ e $n/16$ punti da $B$;
  - eccetera.

  #v(12pt)

  #figure(
    image("assets/06_esempio_sc.svg", width: 75%),
  )

  #v(12pt)

  Simuliamo l'algoritmo Greedy Set Cover su questo particolare input.

  *Prima iterazione*:
  - gli insiemi $A,B$ hanno costo $frac(2+2epsilon,n)$;
  - gli insiemi che pescano da $A,B$ hanno costo $2/n$, $4/n$, $8/n$, eccetera.

  L'algoritmo seleziona quindi l'insieme giallo con costo $2/n$. Rimangono da coprire $n/2$ elementi.

  *Seconda iterazione*:
  - gli insiemi $A,B$ hanno costo $frac(4 + 4epsilon, n)$;
  - gli insiemi che pescano da $A,B$ hanno costo $4/n$, $8/n$, eccetera.

  L'algoritmo seleziona quindi l'insieme arancio con costo $4/n$. Rimangono da coprire $n/4$ elementi.

  E così via fino a quando non copro totalmente $A union B$ selezionando solo gli insiemi "trasversali". Ogni insieme costa $1$ e gli insiemi sono $log(n)$, quindi $ w = log(n) . $

  Il costo ottimo si ottiene scegliendo gli insiemi $A$ e $B$, quindi $ w^* = 2 + 2epsilon . $ L'approssimazione ottenuta è $ frac(w, w^*) = frac(log(n), 2 + 2epsilon) = Omega(log(n)) . $
]

#theorem()[
  Se $P eq.not NP$ non esiste un algoritmo che approssimi Set Cover meglio di $ (1-o(1)) log(n) . $
]

Visti questi risultati, Set Cover finisce in $gAPX(log(n))$.

== Vertex Cover

Il problema di *Vertex Cover* assomiglia spaventosamente a Dominating Set.

Vediamo da cosa è definito:
- *input*:
  - grafo non orientato $G = (V, E)$;
  - pesi $w_i in RR^(>0) quad forall i in V$;
- *soluzione ammissibile*: insieme di vertici $X subset.eq V$ tale che $forall e in E$ allora $e sect X eq.not emptyset.rev$, ovvero ogni lato deve avere almeno un vertice a lui incidente nell'insieme $X$;
- *funzione obiettivo*: $sum_(i in X) w_i$;
- *tipo*: $min$.

Sembra il problema di Dominating Set ma ci sono differenze:
- in Dominating Set andiamo a scegliere una serie di vertici $X$, dette guardie, e tutti i _vertici_ non scelti hanno un arco che va in almeno una guardia
- in Vertex Cover andiamo a scegliere una serie di vertici $X$ e tutti i _lati_ hanno almeno un vertice nell'insieme scelto.

#v(12pt)

// Da sistemare, magari in tikz
#columns(2)[
  #figure(
    image("assets/06_ds.svg", width: 100%),
  )

  #colbreak()

  #figure(
    image("assets/06_vc.svg", width: 100%),
  )
]

#v(12pt)

Questa differenza #align(center)[
  #block(
    fill: rgb("#9FFFFF"),
    inset: 8pt,
    radius: 4pt,

    [*mi manda in sbattimento (_cit. Boldi_)*],
  )
]

Se abbiamo un Vertex Cover allora abbiamo anche un Dominating Set.

Questo problema è ovviamente $NPOC$. Noi vedremo un algoritmo basato sul pricing.

I *problemi basati sul pricing* sono problemi economici dove ho:
- agenti che pagano una certa quota per avere un certo servizio;
- agenti che decidono se entrare o meno nel gioco accettando o meno le offerte degli altri agenti.

I primi agenti sono i _lati_, che pagano una certa quota $p_e$ per farsi coprire da un certo vertice, mentre i secondi sono i vertici, che vedono se entrare o meno nel gioco in base a quanto vengono pagati.

#align(center)[
  #block(
    fill: rgb("#9FFFFF"),
    inset: 8pt,
    radius: 4pt,

    [*I vertici sono una gang, una mafia, vogliono massimizzare quello che portano a casa*],
  )
]

Associamo ad ogni lato un prezzo che pagherebbero ai vertici incidenti per farsi coprire da loro.

Il *pricing* è un insieme di prezzi $ (p_e)_(e in E) . $ Un pricing è *equo* se e solo se $ forall i in V quad sum_(e in E and i in e) p_e lt.eq w_i . $ In poche parole, i lati che incidono sul vertice $i$ devono offrire al massimo quello che chiede il vertice. È una mafia, perché dovrei dare di più? Noi useremo solo pricing equi. Il pricing equo più ovvio è quello che vale $0$ su tutti i lati.

#lemma()[
  Se $(p_e)_(e in E)$ è un pricing equo allora $ sum_(e in E) p_e lt.eq w^* . $
]

#proof()[
  Sappiamo che $X^* subset.eq V$ è una soluzione ottima e $ w^* = sum_(i in X^*) w_i . $

  Per definizione di equità vale $ sum_(e in E and i in e) p_e lt.eq w_i . $

  Sommiamo su tutti gli $i in X^*$ quindi $ sum_(i in X^*) sum_(e in E and i in e) p_e lt.eq sum_(e in E) p_e lt.eq sum_(i in X^*) w_i = w^* . $

  La prima disuguaglianza è vera perché selezionando tutti i vertici nella soluzione ottima $X^*$ e poi tutti i lati che incidono su questi vertici potrei sommare più volte lo stesso lato.
]

Data un pricing, esso è *stretto* sul vertice $i$ se e solo se $ sum_(e in E and i in e) p_e < w_(i) . $ È una proprietà che vale su un vertice, non so tutto il grafo. Questa proprietà afferma che il vertice $i$ non è contento di quello che riceve, non riceve quello che vuole.

#align(center)[
  #pseudocode-list(title: [Pricing Vertex Cover])[
    - *input*
      - grafo $G = (V,E)$ non orientato
      - costi $w_i in RR^(>0) quad forall i in V$
    + $p_e arrow.l 0 quad forall e in E$
    + while $exists e = (i,j)$ tale che $(p_e)_(e in E)$ è stretto su $i$ e su $j$:
      + sia $overline(e)$ il lato che minimizza $Delta = min((w_(i) - limits(sum)_(e in E and i in e) p_e), (w_(j) - limits(sum)_(e in E and j in e) p_e))$
      + $p_(overline(e)) arrow.l p_(overline(e)) + Delta$, ovvero alzo l'offerta del minimo indispensabile
    + output ${i in V bar.v p_e "non è stretto su" i}$ insieme dei vertici contenti
  ]
]

// Sistema italiano
#example()[
  Nelle seguenti figure abbiamo il peso di un vertice $w_i$ indicato in violetto e quanto il vertice $i in V$ viene pagato dai lati $p_i$ indicato in rosso.

  All'inizio dell'algoritmo siamo nella seguente configurazione, con il pricing banale.

  #v(12pt)

  #figure(
    image("assets/06_esempio_vc_01.svg", width: 60%),
  )

  #v(12pt)

  Alla prima iterazione del while tutti i lati hanno entrambi i vertici con pricing stretto e tutti i lati verrebbero aggiornati con il valore $3$. Scegliamo di modificare il lato $A B$.

  #v(12pt)

  #figure(
    image("assets/06_esempio_vc_02.svg", width: 60%),
  )

  #v(12pt)

  Alla seconda iterazione del while i lati $B C$ e $C D$ hanno entrambi i vertici con pricing stretto, il lato $B C$ verrebbe aggiornato con il valore $1$. Scegliamo di modificare il lato $B C$.

  #v(12pt)

  #figure(
    image("assets/06_esempio_vc_03.svg", width: 60%),
  )

  #v(12pt)

  Alla terza iterazione del while il lato $C D$ ha entrambi i vertici con pricing stretto e verrebbe aggiornato con il valore $2$. Scegliamo di modificare il lato $C D$.

  #v(12pt)

  #figure(
    image("assets/06_esempio_vc_04.svg", width: 60%),
  )

  #v(12pt)

  Non eseguiamo più nessuna iterazione del while perché ogni lato ha almeno un vertice con pricing non stretto.

  Selezioniamo quindi i vertici $A$,$B$ e $C$ che sono gli unici che hanno il pricing non stretto.
]

Perché siamo sicuri che questo algoritmo sia uno di approssimazione? Perché i lati non parlano tra di loro, non si mettono d'accordo su cosa fare.
