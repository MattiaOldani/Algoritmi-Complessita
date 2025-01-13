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

= Codice di Elias-Fano per sequenze monotone

Nei web crawler, quando salvo il grafo del web, per ogni nodo ho una lista dei successori, che dice quali a pagine punta la pagina corrente. Vogliamo ordinare queste sequenze in maniera crescente, e useremo il *codice di Elias-Fano* per fare tutto ciò.

Data una sequenza di valori $0 lt.eq x_0 lt.eq dots lt.eq x_(n-1) < u$ vogliamo memorizzare questa lista.

Calcoliamo $ l = max{0, floor(log_2(u/n))} . $

Memorizziamo esplicitamente gli $l$ bit inferiori (_meno significativi_) $ l_0 = x_0 mod 2^l quad bar.v quad dots quad bar.v quad l_(n-1) = x_(n-1) mod 2^l $ di ogni numero. I bit superiori, che sono $ floor(x_0 / 2^l) quad bar.v quad dots quad bar.v quad floor(x_(n-1) / 2^l) $ li memorizziamo come differenze, ovvero memorizziamo $ u_i = floor(x_i / 2^l) - floor(x_(i-1) / 2^l) $ assumendo che $x_(-1) = 0$.

La sequenza iniziale è non decrescente, quindi tutte queste differenze sono maggiori o uguali a $0$.

Questi valori vengono memorizzati in *unario* in un unico vettore $u$. Scrivere in unario vuol dire tanti zeri quanto vale $u_i$ e poi un uno. Quanto occupiamo in memoria?

Per i bit inferiori ci servono $l n$ bit, ovvero $n$ valori diversi ognuno di $l$ bit. Per i bit superiori ci serve $ sum_(i=0)^(n-1) u_i + 1 &= sum_(i=0)^(n-1) floor(x_i / 2^l) - floor(x_(i-1) / 2^l) + 1 = \ &= n + sum_(i=0)^(n-1) floor(x_i / 2^l) - floor(x_(i-1) / 2^l) = \ &= "la serie è telescopica" = \ &= n + floor(x_(n-1)/2^l) - floor(x_(-1) / 2^l) = \ &= n + x_(n-1)/2^l lt.eq n + u / 2^l = n + frac(u, 2^(floor(log_2(u/n)))) lt.eq n + frac(u, 2^(log(u/n) - 1)) = n + frac(2u, u/n) = 3n . $

In totale abbiamo quindi $ D_n = l n + 3 n = (l + 3) n = (floor(log_2(u/n)) + 3) n = 2n + n ceil(log_2(u/n)) . $

Cosa ci rappresenta l'operazione $select(u,i)$? Ci dice dove è l'$i$-esimo $1$, ma il vettore $u$ contiene una serie di zeri unari e poi un uno che fa da separatore. Quindi $ select(b,i) &= i + u_0 + dots + u_i = \ &= i + floor(x_0 / 2^l) + (floor(x_1 / 2^l) - floor(x_0 / 2^l)) + dots = \ &= "serie telescopica" = \ &= i + floor(x_(i) / 2^l) . $

Vogliamo calcolare l'information theoretical lower bound. Fissati $n$ e $u$, quante sono le sequenze monotone $0 lt.eq x_0 lt.eq dots lt.eq x_(n-1) < u$ possibili?

Vogliamo sapere quanti insiemi di cardinalità $n$ ci sono nell'insieme ${0,dots,u-1}$. Questo è abbastanza complicato, quindi usiamo un trick. Un altro modo per vedere questa domanda è chiedersi quante soluzioni ha, in $NN^n$, l'equazione $ c_0 + c_1 + dots + c_(n-1) = n . $

Le $c_i$ sono delle variabili che ci dicono quante volte nella sequenza delle $x$ compare il numero $x_i$.

Per contare si usa la *tecnica delle stelle e delle barre* (_stars & stripes counting_).

#example()[
  La sequenza $ * * bar bar * bar bar bar bar * bar $ indica che ci sono $8$ numeri da selezionare e che viene scelto il primo numero $2$ volte e il terzo e il settimo numero $1$ volta.
]

In generale, le barre vengono usate per dividere i numeri, e le stelle vengono usate per indicare il numero di $x_i$ che sono presenti nell'insieme. Devo avere $n$ stelle, purché le metta in mezzo alle barre. Le barre sono $u-1$ e le stelle sono $n$. Quante sequenze di $n$ stelle e $u-1$ barre esistono?

Ho $u + n - 1$ caratteri nello stringone, devo scegliere dove sono le barre, quindi ho $ binom(u+n-1, u-1) = frac((u+n-1)!, (u-1)! (u+n-1-u+1)!) = frac((u+n-1)!, n! (u-1)!) $ possibili scelte. Quindi $ Z_n = log_2(binom(u+n-1, u-1)) = log_2(binom(u+n-1, n))
= log_2(frac((u+n-1)!, n! (u-1)!)) . $

Sappiamo che $ log(binom(A,B)) tilde B log(A/B) + (A-B) log(frac(A, A-B)) . $

Quindi $ Z_n &= log(binom(u+n-1, n)) tilde n log(frac(u + n - 1, n)) + (u-1) underbracket(log(frac(u+n-1, u-1)), = 0 "trascurabile se" n lt.double u) = \ &= n log((u/n)(1 + n/u - 1/u)) = \ &= n log(u/n) + n log(1 + n/u - 1/u) = \ &= "sappiamo che" x approx log(1+x) = \ &approx n log(u/n) + n(n/u - 1/u) = \ &lt.eq n log(u/n) + n^2/u . $

Assumiamo, per semplicità, che $n lt.eq sqrt(u)$, ma allora $ Z_n = n log(u/n) + 1 . $

Ricordiamoci che $ D_n = 2n + n ceil(log(u/n)) + o(n) . $ Ma allora $D_n = O(Z_n)$. Non abbiamo una struttura succinta ma almeno abbiamo lo stesso ordine di grandezza, quindi è una *struttura compatta*.
