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


= Lezione 09 [25/10]

== Implementazione di Vertex Cover

Citazioni più importanti della prima parte della lezione.

#align(center)[
  #block(
    fill: rgb("#9FFFFF"),
    inset: 8pt,
    radius: 4pt,

    [*Mi faccio prendere dal vento autistico (_cit. Boldi_)*],
  )
]

#align(center)[
  #block(
    fill: rgb("#9FFFFF"),
    inset: 8pt,
    radius: 4pt,

    [*Implementiamo, non so se sarò in grado di comunicarvi delle emozioni come il docente della porta accanto (_cit. Boldi_)*],
  )
]

#align(center)[
  #block(
    fill: rgb("#9FFFFF"),
    inset: 8pt,
    radius: 4pt,

    [*Mi hanno fornito un'emozione (_cit. Boldi_)*],
  )
]

#align(center)[
  #block(
    fill: rgb("#9FFFFF"),
    inset: 8pt,
    radius: 4pt,

    [*Sto facendo delle osservazioni assurde (_cit. Boldi_)*],
  )
]

Sappiamo che Vertex Cover è tight, si può dimostrare ma non lo facciamo.

Sarebbe bello avere algoritmi che, oltre a darti un valore con una data approssimazione (_teorica_) ti dica anche quanto è l'approssimazione vera del risultato fornito. Così posso capire al massimo quanto sono lontano dall'approssimazione teorica.

== La nascita della teoria dei grafi

La *teoria dei grafi* nasce con Eulero a fine $'700$ con il *problema dei ponti di Konigsberg* (_oggi Kaliningrad_): abbiamo un fiume con due isole, e i collegamenti argine-isole e isole-isole sono definiti da $7$ ponti.

IMMAGINE

Possiamo scegliere un punto di partenza della città che mi permetta di passare per tutti i punti una e una sola volta per poi tornare al punto di partenza? Eulero, un fratello, astrae, quindi il problema si riduce alla ricerca di un *circuito euleriano* in un grafo non orientato.

In realtà, quello che stiamo utilizzando è un *multigrafo*: questo perché esistono due vertici che hanno almeno due lati incidenti.

#theorem([di Eulero])[
  Esiste un circuito euleriano se e solo se il grafo è connesso e tutti i vertici hanno grado pari.
]

#proof()[
  Dimostriamo solo una delle due implicazioni in modo non formale.

  {$arrow.long.double.l$}

  Partiamo da un vertice $x_0$ e ci spostiamo su un lato che incide su $x_0$ fino al vertice $x_1$. Ora, $x_1$ ha grado pari quindi da $x_1$ ho almeno un altro lato, che va a $x_2$. Ora, eccetera.

  Cosa può succedere in questa costruzione? Abbiamo due alternative:
  - incappiamo in un ciclo con un nodo che abbiamo già visitato, ma non ci sono problemi; infatti, se per esempio da $x_3$ vado a $x_1$ devo avere un altro nodo per avere il grado di $x_1$ pari;
  - arriviamo a $x_0$: abbiamo ancora due casi:
    - abbiamo esaurito i lati;
    - abbiamo cancellato un numero pari di lati da ogni nodo e ripartiamo con il percorso. $qedhere$
]

Vediamo ora il lemma delle strette di mano: dato un gruppo di persone che si stringono la mano, il numero di persone che stringono la mano ad un numero dispari di persone è pari. Come si formalizza?

#lemma([Handshaking lemma])[
  In un grafo, il numero di vertici di grado dispari è pari.
]

#proof()[
  Calcoliamo $ S = sum_(x in V) d(x) . $ Sicuramente $S$ è un numero pari, questo perché stiamo contando ogni lato due volte, visto che ogni lato incide su due vertici. Visto che la somma di numeri pari è ancora un numero pari, togliamo da $S$ tutti gli addendi pari, rimanendo solo con i dispari.

  Ma allora sto sommando tutti gli $x in V$ tali che $d(x)$ è dispari.
]

Questo proprietà sono tipo delle Ramsey-type, ovvero teorie trovare per il meme che cercano la regolarità nel caos.