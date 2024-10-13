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


= Lezione 05 [11/10]

== Ancora Center Selection

Ricordiamo il nostro obiettivo: scegliere dei centri che minimizzino il raggio di copertura, ovvero il massimo tra tutte le distanze punto-centro più vicino.

Vediamo come l'algoritmo della scorsa lezione approssima il mio Center Selection.

#theorem()[
  Greedy Center Selection è una $2$-approssimazione per Center Selection.
]

#proof()[
  Ci servirà Center Selection Plus v2 per dimostrare questo teorema.

  Per assurdo supponiamo che l'algoritmo Greedy Center Selection emetta una soluzione con $rho > 2 rho^*$. Questo vuol dire che esiste un certo elemento $over(s,tilde) in S$ tale che $d(over(s,tilde),C) > 2 rho^*$.

  Sia $overline(s)_i$ l'$i$-esimo centro aggiunto a $C$ e sia $overline(C)_i$ l'insieme dei centri in quel momento; possiamo dire che $ underbracket(d(overline(s)_i, overline(C)_i) gt.eq d(over(s,tilde),C_i), "prendo massima distanza") gt.eq d(over(s,tilde),C) > 2 rho^* . $

  Questa esecuzione è una delle esecuzioni possibili di Center Selection Plus v2 quando $r = rho^*$. Noi sappiamo che questo algoritmo produce un output corretto, quindi termina entro $k$ iterazioni quando non ci sono più elementi a distanza maggiore di $2 rho^*$, quindi tutti gli $s in S$ sono tali che $d(s,C) lt.eq 2 rho^*$ ma questo non è vero, perché esiste $over(s,tilde)$ tale che $d(over(s,tilde),C) > 2 rho^*$.

  Questo è un assurdo, quindi la soluzione è tale che $rho lt.eq 2 rho^*$ e quindi $ frac(rho,rho^*) lt.eq 2 . qedhere $
]

Questo algoritmo è un esempio di *inapprossimablità* o di *algoritmo tight*, ovvero non esistono algoritmi che approssimano Center Selection in un modo migliore di una $2$-approssimazione.

#theorem()[
  Se $P eq.not NP$ non esiste un algoritmo polinomiale che $alpha$-approssimi Center Selection per qualche $alpha < 2$.
]

#proof()[
  Usiamo il problema $NPC$ Dominating Set (_addome degli insetti_):
  - input: grafo $G = (V,E)$ e $k > 0$;
  - output: ci chiediamo se $exists D subset.eq V bar.v abs(D) lt.eq k$ tale che $ forall x in V slash {D} quad exists d in D bar.v x y in E . $

  Questo problema deve scegliere dove mettere delle guardie in un grafo, ovvero dei nodi che coprono i nodi a loro adiacenti, in modo che tutti i nodi siamo coperti.

  // Per i problemi NCP esiste il libro di David Johnson

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

  Quando ho distanza $1$? Devo scegliere $C$ con $abs(C) lt.eq k$ tale che tale che $ forall s in S quad d(s,C) lt.eq 1 , $ ovvero tutti i punti sono a distanza $1$ dai loro centri. Ma allora $exists C^* subset.eq S$ tale che $ min_(c in C^*) space d(s,c) = 1 . $

  Essendo a distanza possiamo dire che $exists C^* subset.eq S$ tale che $ forall s in S quad exists c in C^* bar.v s c in E . $

  Questa è esattamente la definizione di Dominating Set, e il nostro Dominating Set è esattamente $C^*$.

  Noi abbiamo un algoritmo $alpha$-approssimante per Center Selection con $alpha < 2$, che fa $ (S,k) arrow.long.squiggly "ALGORITMO" arrow.long.squiggly rho^* (S,k) lt.eq underbracket(rho(S,k), "risultato") lt.eq alpha rho^* (S,k) . $

  Sappiamo che la distanza migliore è $1$ o $2$, ma allora:
  - se $rho^* = 1$ ottengo $1 lt.eq rho(S.k) lt.eq alpha$;
  - se $rho^* = 2$ ottengo $2 lt.eq rho(S,k) lt.eq 2 alpha$.

  Nel primo caso dico devo rispondere _SI_ al problema di Dominating Set, nel secondo caso devo rispondere _NO_.

  Ma questi è un assurdo: avrei un algoritmo polinomiale per Dominating Set, quindi deve valore per forza $alpha gt.eq 2$
]

== Set Cover

=== Funzione armonica

Il prof dell'aula accanto è un chad: #align(center)[
  #block(
    fill: rgb("#9FFFFF"),
    inset: 8pt,
    radius: 4pt,

    [*non è qui per trasmettere informazioni, ma per trasmettere emozioni*],
  )
]

Diamo prima una definizione di *funzione armonica*: essa è la funzione $ H : NN^(>0) arrow.long RR $ tale che $ H(n) = sum_(i=1)^n 1/i space . $

#v(12pt)

#figure(
  image("assets/05_armonica.svg", width: 50%),
)

#v(12pt)

Vediamo due proprietà importanti di questa funzione.

La prima proprietà ci dà un *upper bound* alla funzione armonica, ovvero $ H(n) lt.eq 1 + integral_1^n 1/x dif x = 1 + [ln(x)]_1^n = 1 + ln(n) - cancel(ln(1)) = 1 + ln(n) . $ Questa la possiamo capire dal grafico: tutta l'area tra i rettangoli e la funzione $1/x$ la andiamo a prendere nella maggiorazione.

La seconda proprietà afferma che $ integral_t^(t+1) 1/x dif x lt.eq integral_t^(t+1) 1/t dif x = 1/t integral_t^(t+1) 1 dif x = 1/t dot [x]_t^(t+1) = 1/t (t + 1 - t) = 1/t . $ Stiamo dando un altro upper bound: visto che $1/x$ è decrescente possiamo stimare la sua area tra $t$ e $t+1$ usando un rettangolo con altezza uguale all'altezza della funzione calcolata in $t$.

Questa proprietà ci dà un *lower bound* alla funzione armonica, ovvero $ H(n) = 1/1 + dots + 1/n gt.eq integral_1^2 1/x dif x + dots + integral_n^(n+1) 1/x dif x = integral_1^(n+1) 1/x dif x = ln(n+1) . $

Grazie a queste proprietà abbiamo trovato dei *bound* per la funzione armonica: $ ln(n+1) lt.eq H(n) lt.eq 1 + ln(n) . $

=== Definizione del problema

Il problema di (_Min_) *Set Cover* ci chiede di coprire tutte le zone di una città con i mezzi di trasporto spendendo il meno possibile scegliendo tra una serie di offerte che coprono un certo numero di aree.

Vediamo la definizione di questo problema:
- *input*:
  - $m$ insiemi $S_0, dots, S_(m-1)$ non per forza disgiunti tali che $U = limits(union.big)_(i in m) S_i$; questo insieme viene detto *insieme universo* (_tutte le zone della città_);
  - $m$ costi $w_0, dots, w_(m-1)$ associati ad ogni insieme $S_i$ (_costo delle offerte_);
- *soluzioni ammissibili*: $I subset.eq m$ tale che $limits(union.big)_(i in I) S_i = U$ (_scelgo offerte che mi coprono tutta la città_);
- *obiettivo*: $limits(sum)_(i in I) w_i$;
- *tipo*: $min$.

Questo problema è $NPOC$. La motivazione principale è la presenza di due tendenze contrastanti:
- scelgo insiemi grandi per coprire il più possibile subito, ma vado a spendere troppo
- scelgo insiemi piccoli che mi vanno a costare poco, ma potrei prenderne così tanti da superare la soluzione precedente.

Costruiremo la nostra soluzione aggiungendo mano a mano ad un insieme le "offerte" scelte. La scelta di un'offerta la andiamo a fare guardando il numero di elementi nuovi che andrebbe a coprire: per avere una buona metrica guarderemo il rapporto tra quanto paghiamo e quanti elementi nuovi inseriamo, e lo andremo a minimizzare.

#align(center)[
  #pseudocode-list(title: [Greedy Set Cover])[
    - $R arrow.l U$
    - $I arrow.l emptyset.rev$
    - while $R eq.not emptyset.rev$:
      - scegli $S_i$ che minimizzi $frac(w_i, abs(S_i sect R))$
      - $I arrow.l I union {i}$
      - $R arrow.l R slash S_i$
    - output $I$
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

  Andiamo a valutare $ sum_(s in S_k) c(s) lt.eq sum_(j=1)^d c(s_j) lt.eq sum_(j=1)^d frac(w_k, d-j+1) &= frac(w_k, d) + frac(w_k, d-1) + dots + frac(w_k, 1) = \ &= w_k (1/1 + dots + 1/d) = w_k H(abs(S_k)) . $

  Non ho capito la prima minorazione.
]
