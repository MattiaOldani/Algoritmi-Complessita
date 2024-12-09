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

= Vertex Cover

Il problema di *Vertex Cover* assomiglia spaventosamente a Dominating Set, più problemi per noi durante l'esame.

Vediamo come è definito:
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

// da rifare assolutamente, terribile
#columns(2)[
  #figure(
    image("assets/05_ds.svg", width: 100%),
  )

  #colbreak()

  #figure(
    image("assets/05_vc.svg", width: 100%),
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

    [*I vertici sono una gang, una mafia, vogliono massimizzare quello che portano a casa (_cit. Boldi_)*],
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
    + *output* ${i in V bar.v p_e "non è stretto su" i}$ insieme dei vertici contenti
  ]
]

// Sistema italiano
#example()[
  Nelle seguenti figure abbiamo il peso di un vertice $w_i$ indicato in violetto e quanto il vertice $i in V$ viene pagato dai lati $p_i$ indicato in rosso.

  All'inizio dell'algoritmo siamo nella seguente configurazione, con il pricing banale.

  #v(12pt)

  #figure(
    image("assets/05_esempio_vc_01.svg", width: 60%),
  )

  #v(12pt)

  Alla prima iterazione del while tutti i lati hanno entrambi i vertici con pricing stretto e tutti i lati verrebbero aggiornati con il valore $3$. Scegliamo di modificare il lato $A B$.

  #v(12pt)

  #figure(
    image("assets/05_esempio_vc_02.svg", width: 60%),
  )

  #v(12pt)

  Alla seconda iterazione del while i lati $B C$ e $C D$ hanno entrambi i vertici con pricing stretto, il lato $B C$ verrebbe aggiornato con il valore $1$. Scegliamo di modificare il lato $B C$.

  #v(12pt)

  #figure(
    image("assets/05_esempio_vc_03.svg", width: 60%),
  )

  #v(12pt)

  Alla terza iterazione del while il lato $C D$ ha entrambi i vertici con pricing stretto e verrebbe aggiornato con il valore $2$. Scegliamo di modificare il lato $C D$.

  #v(12pt)

  #figure(
    image("assets/05_esempio_vc_04.svg", width: 60%),
  )

  #v(12pt)

  Non eseguiamo più nessuna iterazione del while perché ogni lato ha almeno un vertice con pricing non stretto.

  Selezioniamo quindi i vertici $A$,$B$ e $C$ che sono gli unici che hanno il pricing non stretto.
]

Perché siamo sicuri che questo algoritmo sia uno di approssimazione? Perché i lati non parlano tra di loro, non si mettono d'accordo su cosa fare.

#align(center)[
  #block(
    fill: rgb("#9FFFFF"),
    inset: 8pt,
    radius: 4pt,

    [*Chiudiamo la porta, c'è il prof che regala emozioni (_cit. Boldi_)*],
  )
]

L'algoritmo che abbiamo visto non vuole avere lati con entrambi i vertici incidenti stretti: infatti, se così fosse quel lato non verrebbe coperto perché i vertici non sono invogliati ad entrare nell'affare.

#lemma()[
  Alla fine di Pricing Vertex Cover abbiamo $ w lt.eq 2 sum_(e in E) p_e . $
]

#proof()[
  Noi paghiamo $ w = sum_(i in V_"out") w_i $ ma in output ho tutti i vertici non stretti sul pricing, quindi $ w = sum_(i in V bar.v p_e "non" \ "è stretto su" i) w_i $ ma il costo $w_i$ è la somma di tutte le offerte dei lati incidenti, quindi $ w = sum_(i in V_"out") space sum_(e in E and i in e) p_e . $

  Stiamo sommando per ogni vertice nell'output i lati a che incidono su di esso, ma questi compaiono al massimo due volte, ovvero se entrambi i vertici di un lato stanno nell'output, quindi $ w lt.eq 2 sum_(e in E) p_e . qedhere $
]

#theorem()[
  Pricing Vertex Cover è una $2$-approssimazione per Vertex Cover.
]

#proof()[
  Vediamo $ frac(w,w^*) lt.eq_(l 2) frac(2 sum_(e in E) p_e, w^*) lt.eq_(l 1) frac(2 sum_(e in E) p_e, sum_(e in E) p_e) = 2 . qedhere $
]

Non sappiamo molto di più: non sappiamo se possiamo andare meglio di $2$, ma sappiamo che esiste un PTAS, ovvero non si conosce una $gamma$-approssimazione con $gamma < 2$. Siamo quindi in un caso di inapprossimabilità, ci sarà un minimo tasso ma non sappiamo quanto è.

#align(center)[
  #block(
    fill: rgb("#9FFFFF"),
    inset: 8pt,
    radius: 4pt,

    [*Networkx riempie di emozioni (_cit. Boldi_)*],
  )
]
