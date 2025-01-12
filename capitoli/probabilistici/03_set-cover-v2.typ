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

= Set Cover, il ritorno

== Concetti preliminari

Vediamo *cose*: introduciamo qualche risultato matematico preliminare che però non dimostriamo.

#definition([Chain rule])[
  Legge comodissima nella probabilità, essa afferma che $ P(E_1 and dots and E_n) = P(E_1) dot P(E_2 bar.v E_1) dot dots dot P(E_n bar.v E_1, dots, E_(n-1)) . $
]

#definition([Analisi 1])[
  Vale $ forall x > 1 quad 1/4 lt.eq (1 - 1/x)^x lt.eq 1/e . $
]

#definition([Analisi 2])[
  Vale $ forall x in [0,1] quad 1 - x lt.eq e^(-x) . $
]

#definition([Union bound])[
  Legge comoda in molte dimostrazioni, essa afferma che $ P(union.big_i E_i) lt.eq sum_i P(E_i) . $ Questa legge afferma che la probabilità dell'unione non supera la somma delle singole probabilità, questo perché gli eventi potrebbero sovrapporsi e quindi essere contati più volte.
]

#definition([Disuguaglianza di Markov])[
  Date
  - $XX gt.eq 0$ variabile aleatoria non negativa con media finita e
  - $alpha > 0$ valore reale positivo
  vale $ P(XX gt.eq alpha) lt.eq frac(EE[XX], alpha) . $
]

Le disuguaglianze che hanno questa forma sono dette *leggi di concentrazione*, e sono molto comode perché ci indicano la probabilità che una variabile aleatoria si discosti da un valore considerando la media di quella variabile. Notiamo inoltre come questa relazione sia *indipendente* da come è distribuita la variabile $XX$.

== Algoritmo probabilistico

Avevamo già visto Set Cover, e come *metafora* avevamo usato quella degli spazi pubblicitari o degli abbonamenti di Milano: vogliamo scegliere dei pacchetti per coprire tutto un insieme universo spendendo il meno possibile.

Definiamo nuovamente il problema in termini formali:
- *input*:
  - $m > 0$ insiemi $S_0, dots, S_(m-1)$ tali che $union.big_(i in m) S_i = U$;
  - $m > 0$ pesi $w_0, dots, w_(m-1) in QQ^+$;
- *soluzione ammissibile*: sottoinsieme di abbonamenti $I subset.eq m$ tale che $union.big_(i in I) S_i = U$;
- *funzione obiettivo*: $w = sum_(i in I) w_i$;
- *tipo*: $min$.

Avevamo già visto un algoritmo di approssimazione per questo problema, oggi vediamo invece un *algoritmo probabilistico*. Prima di tutto, sia $m$ il numero di insiemi e $n = abs(U)$.

Questo problema lo possiamo scrivere nei termini della *programmazione lineare intera*:
- *variabili*: $x_0, dots, x_(m-1)$ booleane che ci dicono se prendiamo o meno l'insieme $S_i bar.v i in m$;
- *funzione obiettivo*: $min space w_0 x_0 + dots + w_(m-1) x_(m-1)$;
- *vincoli*:
  + $forall i in m quad 0 lt.eq x_i lt.eq 1$, ovvero ogni variabile deve essere $0$ oppure $1$;
  + $forall p in U quad sum_(i bar.v p in S_i) x_i gt.eq 1$, ovvero per ogni elemento dell'universo da coprire prendo gli insiemi che lo contengono e richiedo l'esistenza di una variabile che lo copre.

Chiamiamo questo problema $Pi$. Se rilassiamo $Pi$ sui numeri reali otteniamo un problema $hat(Pi)$ con risultato approssimato ma sicuramente migliore perché abbiamo ampliato lo spazio delle soluzioni ammissibili.

#align(center)[
  #pseudocode-list(title: [Arrotondamento aleatorio])[
    - *input*
      - insiemi $S_0, dots, S_(m-1)$
      - pesi $w_0, dots, w_(m-1) in QQ^+$;
      - $k in ZZ$
    + Costruiamo il problema $Pi$ di PLI
    + Risolviamo la sua versione rilassata $hat(Pi)$ ottenendo $hat(x)$
    + $I arrow.l emptyset.rev$
    - *PRIMA VERSIONE DEL FOR*
    + for $i in m$
      + for $t = 1, dots, ceil(k + ln(n))$
        + Con probabilità $hat(x)_i$ aggiungiamo $i$ a $I$
    - *SECONDA VERSIONE DEL FOR*
    + for $i in m$
      + Aggiungiamo $i$ a $I$ con probabilità $1 - (1 - hat(x))^(k + ln(n))$
    + *output* $I$
  ]
]

Questo algoritmo è molto semplice: lancio _"tante volte"_ la moneta con probabilità $hat(x)_i$ per decidere se inserire l'insieme $S_i$ nella copertura. Purtroppo, questo algoritmo non dà garanzie di dare una soluzione ammissibile, è improbabile ma potrebbe succedere. Se invece la soluzione data è ammissibile, non è detto che sia ottima. Uno sfigato praticamente.

L'algoritmo di Karger era *GG* perché dava sempre una soluzione ammissibile (_visto che i tagli non sono soggetti a vincoli_) ma spesso dava anche l'ottimo. Qua abbiamo una $P > 0$ di restituire soluzioni non ammissibili, e, se per puro caso abbiamo una soluzione ammissibile, non sempre sarà ottima, ma menomale non lo sarà con bassa probabilità.

#theorem()[
  L'algoritmo di arrotondamento aleatorio ha le seguenti proprietà:
  + produce una soluzione ammissibile con probabilità $ P gt.eq 1 - e^(-k) ; $
  + per ogni $alpha gt.eq 1$ vale $ P("TA" gt.eq alpha (k + ln(n))) lt.eq 1/alpha $ con $"TA"$ tasso di approssimazione della soluzione.
]

Il primo punto riguarda l'ammissibilità, mentre il secondo punto ci dice che la probabilità che l'algoritmo vada male è bassa. Nel primo punto notiamo che se $k$ assume valori grandi allora facciamo molti più conti, però abbiamo una buona probabilità di ottenere una soluzione ammissibile.

#proof()[
  Diamo prima un po' di notazione. Per questa dimostrazione abbiamo bisogno di:
  - insiemi $S_0, dots, S_(m-1)$;
  - pesi $w_0, dots, w_(m-1)$;
  - insieme universo $U = union.big_(i=0)^m S_i$ con $n = abs(U)$;
  - problemi $Pi$ (_normale_) e $hat(Pi)$ (_rilassato_);
  - soluzione $hat(x)_0, dots, hat(x)_(m-1) in [0,1]$ del problema $hat(Pi)$;
  - valore della funzione obiettivo $hat(w) = w_0 hat(x)_0 + dots + w_(m-1) hat(x)_(m-1)$;
  - conosciamo a culo anche $w^*$.

  Ovviamente vale $hat(w) lt.eq w^*$ perché il rilassamento di un problema di PLI è migliore del problema originale (_problema di minimo_).

  [*PRIMO PUNTO*]

  Sia $E_p$ l'evento "il punto $p in U$ non è coperto". Sia $"amm"$ l'evento "la soluzione che abbiamo davanti è ammissibile". Valutiamo $ P("amm") &= 1 - P(overline("amm")) = \ &= 1 - P("almeno un punto di" U "non è coperto") = \ &= 1 - P(union.big_(p in U) E_p) \ &gt.eq_("UB") 1 - sum_(p in U) P(E_p) = \ &= 1 - sum_(p in U) P(p "non è coperto") = \ &= "nessun insieme che contiene" p "è stato scelto, visto che non lo copriamo" = \ &= 1 - sum_(p in U) (product_(i in m and p in S_i) P(i "non è stato scelto")) = \ &= 1 - sum_(p in U) (product_(i in m and p in S_i) (1 - hat(x)_i)^(ceil(k + ln(n)))) \ &gt.eq 1 - sum_(p in U) (product_(i in m and p in S_i) (1 - hat(x)_i)^(k + ln(n))) \ &gt.eq_(a 2) 1 - sum_(p in U) (product_(i in m and p in S_i) e^(-hat(x)_i (k + ln(n)))) = \ &= "faccio il prodotto di esponenziali, portando la sommatoria all'esponente" = \ &= 1 - sum_(p in U) e^(-(k + ln(n)) sum_(i in m and p in S_i) hat(x)_i) \ &= "la sommatoria all'esponente somma valori" gt.eq 1 "per il vincolo PLI" = \ &gt.eq 1 - sum_(p in U) e^(-(k + ln(n))) = \ &= 1 - sum_(p in U) 1/n e^(-k) = \ &= 1 - e^(-k) underbracket(sum_(p in U), abs(U) = n) 1/n = 1 - e^(-k) . $

  [*SECONDO PUNTO*]

  Valutiamo la quantità $ P(S_i "scelto") = P(union.big_(j=1)^(k ln(n)) hat(x)_i) lt.eq_("UB") sum_(j=1)^(k ln(n)) hat(x)_i = (k + ln(n)) hat(x)_i . $ Questo vale perché mi basta che l'insieme venga scelto in una di quelle volte.

  Valutiamo ora $ EE[w] &= sum_(i in m) w_i P(S_i "sia scelto") \ &lt.eq sum_(i in m) w_i (k + ln(n)) hat(x)_i = \ &= (k + ln(n)) sum_(i in m) w_i hat(x)_i = \ &= (k + ln(n)) hat(w) \ &lt.eq (k + ln(n)) w^* . $

  Usiamo la disuguaglianza di Markov $ P(XX gt.eq beta) lt.eq frac(EE[XX], beta) quad (*) $ scegliendo $beta = alpha(k + ln(n)) w^*$. Valutiamo infine $ P(frac(w, w^*) gt.eq alpha (k + ln(n))) &= P(w gt.eq alpha (k + ln(n)) w^*) = \ &= P(w gt.eq beta) \ &lt.eq_((*)) EE[w] / beta lt.eq frac((k + ln(n)) w^*, alpha (k + ln(n)) w^*) = 1/alpha . $

  Madonna abbiamo finito.
]

Questo bound è molto largo: possiamo dare un bound più preciso scegliendo un preciso valore di $k$.

#corollary()[
  Per $k = 3$ abbiamo il $45%$ di probabilità di ottenere una soluzione ammissibile con rapporto di approssimazione $lt.eq 6 + 2ln(n)$.
]

#proof()[
  Dato il nostro insieme degli eventi possibili, lo possiamo dividere in tre zone:
  + zona degli eventi con soluzione non ammissibile, che indichiamo con $E_("na")$;
  + zona degli eventi con soluzione ammissibile ma con tasso di approssimazione cattivo, ovvero $gt 6 + 2ln(n)$, che indichiamo con $E_("bad")$;
  + zona degli eventi con soluzione ammissibile, che indichiamo con $P_("ok")$.

  La probabilità è uno strumento matematico, definito in teoria delle misure, usato per misurare delle quantità. Noi andremo a misurare queste aree.

  Valutiamo in ordine le zone, partendo dalla prima, ovvero $ P(E_("na")) lt.eq_("th") e^(-k) = e^(-3) . $

  Valutiamo poi la seconda, ovvero $ P(E_("bad")) = P("TA" > 6 + 2ln(n)) lt.eq_(alpha = 2) 1/2 . $

  Valutiamo infine la terza zona, quella che ci interessa, ovvero $ P_("ok") = 1 - P(E_("na") union E_("bad")) gt.eq_("UB") 1 - (P(E_("na")) + P(E_("bad"))) = 1 - (e^(-3) + 1/2) approx 45% . qedhere $
]

Come in tutti gli algoritmi probabilistici, più volte eseguo l'algoritmo e più pompo la probabilità di ottenere un risultato prima ammissibile e poi ottimo.

#v(12pt)

#figure(image("assets/03_ronnie.jpg", width: 75%))

#v(12pt)
