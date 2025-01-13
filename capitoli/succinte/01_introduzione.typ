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

= Introduzione alle strutture succinte

Le *strutture succinte* sono oggetti estremamente piccoli, talmente piccoli che andremo a contarne i bit per ridurli il più possibile. Come vedremo però, ci sarà un limite a tutto ciò.

Una *struttura dati* è un *Abstract Data Type* (_ADT_): esso rappresenta un insieme di primitive che devono essere implementate. In base a come implementiamo i metodi, avremo una certa occupazione in spazio e un certo dispendio temporale. Le implementazioni, ovviamente, non differiscono per funzioni, ma differiscono solo per complessità in spazio e tempo.

Le strutture succinte sono SD che occupano poco spazio. Per il tempo andremo nella soluzione _"a babbo"_, ovvero _"basta che vadano"_. In poche parole vogliamo tutto: SD piccola ma molto veloce. Di solito, questo trade-off è difficile da avere nella realtà.

#theorem([Information-theoretical lower bound])[
  Data una struttura dati di taglia $n$, che contiene $V_n$ valori possibili $v_1, dots, v_(V_n)$, ognuno dei quali utilizza $x_1, dots, x_(V_n)$ bit, il *teorema di Shannon* afferma che $ frac(x_1 + dots + x_(V_n), V_n) gt.eq log_2(V_n) . $
]

Quel fattore $log_2(V_n)$ si chiama *information-theoretical lower bound*, e ci dà una dimensione media minima in bit che serve per codificare una struttura dati di $V_n$ valori di taglia $n$.

Chiamiamo $Z_n$ questo bound sul numero di bit. Sia $D_n$ il numero di bit utilizzati per rappresentare una struttura. Allora la struttura è:
- *implicita* se $D_n = Z_n + O(1)$;
- *succinta* se $D_n = Z_n + o(Z_n)$;
- *compatta* se $D_n = O(Z_n)$.
