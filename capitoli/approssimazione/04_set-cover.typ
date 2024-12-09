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

= Set Cover

Il prof dell'aula accanto è un chad: #align(center)[
  #block(
    fill: rgb("#9FFFFF"),
    inset: 8pt,
    radius: 4pt,

    [*non è qui per trasmettere informazioni, ma per trasmettere emozioni*],
  )
]

== Funzione armonica

Diamo prima una definizione di *funzione armonica*: essa è la funzione $ H : NN^(>0) arrow.long RR $ tale che $ H(n) = sum_(i=1)^n 1/i space . $

#v(12pt)

#figure(
  image("assets/04_armonica.svg", width: 50%),
)

#v(12pt)

Vediamo due proprietà importanti di questa funzione.

La prima proprietà ci dà un *upper bound* alla funzione armonica, ovvero $ H(n) lt.eq 1 + integral_1^n 1/x dif x = 1 + [ln(x)]_1^n = 1 + ln(n) - cancel(ln(1)) = 1 + ln(n) . $ Questa la possiamo capire dal grafico: tutta l'area tra i rettangoli e la funzione $1/x$ la andiamo a prendere nella maggiorazione.

La seconda proprietà afferma che $ integral_t^(t+1) 1/x dif x lt.eq integral_t^(t+1) 1 dot 1/t dif x = 1/t integral_t^(t+1) 1 dif x = 1/t dot [x]_t^(t+1) = 1/t (t + 1 - t) = 1/t . $ Stiamo dando un altro upper bound: visto che $1/x$ è decrescente possiamo stimare la sua area tra $t$ e $t+1$ usando un rettangolo con altezza uguale all'altezza della funzione calcolata in $t$.

Questa proprietà ci dà un *lower bound* alla funzione armonica, ovvero $ H(n) = 1/1 + dots + 1/n gt.eq integral_1^2 1/x dif x + dots + integral_n^(n+1) 1/x dif x = integral_1^(n+1) 1/x dif x = ln(n+1) . $

Grazie a queste proprietà abbiamo trovato dei *bound* per la funzione armonica: $ ln(n+1) lt.eq H(n) lt.eq 1 + ln(n) . $

== Algoritmi

Il problema di (_Min_) *Set Cover* ci chiede di coprire tutte le zone di una città con i mezzi di trasporto spendendo il meno possibile scegliendo tra una serie di offerte che coprono un certo numero di aree.

Vediamo la definizione di questo problema:
- *input*:
  - $m$ insiemi $S_0, dots, S_(m-1)$ non per forza disgiunti tali che $U = limits(union.big)_(i in m) S_i$; questo insieme viene detto *insieme universo* (_tutte le zone della città_);
  - $m$ costi $w_0, dots, w_(m-1)$ associati ad ogni insieme $S_i$ (_costo delle offerte_);
- *soluzioni ammissibili*: $I subset.eq m$ tale che $limits(union.big)_(i in I) S_i = U$ (_scelgo offerte che mi coprono tutta la città_);
- *obiettivo*: $limits(sum)_(i in I) w_i$;
- *tipo*: $min$.

Questo problema è $NPOC$. La motivazione principale è la presenza di due tendenze contrastanti:
- scelgo insiemi grandi per coprire il più possibile subito, ma vado a spendere troppo;
- scelgo insiemi piccoli che mi vanno a costare poco, ma potrei prenderne così tanti da superare la soluzione precedente.

Costruiremo la nostra soluzione aggiungendo mano a mano ad un insieme le offerte scelte. La scelta di un'offerta la andiamo a fare guardando il numero di elementi nuovi che andrebbe a coprire: per avere una buona metrica guarderemo il rapporto tra quanto paghiamo e quanti elementi nuovi inseriamo, e lo andremo a minimizzare.

#align(center)[
  #pseudocode-list(title: [Greedy Set Cover])[
    + $R arrow.l U$
    + $I arrow.l emptyset.rev$
    + while $R eq.not emptyset.rev$:
      + Scegli $S_i$ che minimizzi $frac(w_i, abs(S_i sect R))$
      + $I arrow.l I union {i}$
      + $R arrow.l R slash S_i$
    + *output* $I$
  ]
]

Il valore $ frac(w_i, abs(S_i sect R)) $ è un *costo* che associamo ad ogni insieme: infatti, questo ci dà una indicazione di quanto paghiamo nello scegliere quell'insieme considerando sia il suo costo sia quanti nuovi elementi va a coprire. Indichiamo con $c(s)$ questa quantità $forall s in S_i sect R$.

#lemma()[
  Alla fine di Greedy Set Cover abbiamo $ w = sum_(s in U) c(s) . $
]

#proof()[
  Il costo totale delle offerte scelte è $w = limits(sum)_(i in I) w_i$, ma $w_i$ è la somma di tutti i costi $c(s)$ associati ad ogni elemento di $s in S_i sect R$, quindi $ w = sum_(i in I) sum_(s in S_i sect R) c(s) = sum_(s in U) c(s) . $
]

#lemma()[
  Per ogni $k$ vale $ sum_(s in S_k) c(s) lt.eq H(abs(S_k)) w_k . $
]

#proof()[
  Assumo $S_k = {s_1, dots, s_d}$ enumerato in ordine di copertura.

  Consideriamo l'iterazione che copre $s_j$ usando un certo $S_h$, cosa possiamo dire di $R$?

  Sicuramente ${s_j, s_(j+1), dots, s_d} subset.eq R$ ma allora $abs(S_k sect R) gt.eq d - j + 1$ e quindi $ c(s_j) = frac(w_h, abs(S_k sect R)) lt.eq frac(w_k, abs(S_k sect R)) lt.eq frac(w_k, d - j + 1) . $

  Andiamo a valutare $ sum_(s in S_k) c(s) lt.eq sum_(j=1)^d c(s_j) lt.eq sum_(j=1)^d frac(w_k, d-j+1) &= frac(w_k, d) + frac(w_k, d-1) + dots + frac(w_k, 1) = \ &= w_k (1/1 + dots + 1/d) = w_k H(abs(S_k)) . qedhere $
]

#theorem()[
  Sia $M = max_i abs(S_i)$, allora Greedy Set Cover è una $H(M)$-approssimazione per Set Cover.
]

#proof()[
  Sia $I^*$ una soluzione ottima, ovvero un insieme di indici tali che $ w^* = sum_(i in I^*) w_i . $ Per il lemma 2 vale $ w_i gt.eq frac(sum_(s in S_i) c(s), H(abs(S_i))) gt.eq frac(sum_(s in S_i) c(s), H(M)) $ perché $H(M) gt.eq H(abs(S_i))$ vista la monotonia di $H$.

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
    image("assets/04_esempio_sc.svg", width: 75%),
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
