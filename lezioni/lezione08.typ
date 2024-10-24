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


= Lezione 08 [24/10]

== Vertex Cover, il ritorno

=== Programmazione lineare, intera e non

Introduciamo la *programmazione lineare* ($LP$): essa è un problema di ottimizzazione definito da:
- *input*:
  - $A in QQ^(m times n)$ matrice di coefficienti;
  - $b in QQ^m$ vettore di termini noti;
  - $c in QQ^n$ vettore di pesi;
- *soluzioni ammissibili*: $x in QQ^n$ tali che $A x gt.eq b$;
- *funzione obiettivo*: $c^T x$;
- *tipo*: $min$ (_in realtà non cambia niente_).

Ogni riga della matrice $A x$ rappresenta un vincolo di disuguaglianza con $b$. Sia i vincoli sia la funzione obiettivo sono delle *funzioni lineari*.

Un po' di storia: negli anni $'50$ escono le prime tecniche di risoluzione, la più popolare è l'*algoritmo del simplesso*, molto efficiente nella realtà ma esponenziale nella teoria. Per $30$ anni circa la questione $LP in PO$ è rimasta aperta, quando nel $1984$ si è avuta la conferma di quella relazione grazie all'*algoritmo di Karmarkan*.

Vediamo una versione leggermente diversa di $LP$ nelle premesse, ma profondamente diversa nei risultati. Introduciamo la *programmazione lineare intera* ($ILP$), un problema definito da:
- *input*:
  - $A in QQ^(m times n)$ matrice di coefficienti;
  - $b in QQ^m$ vettore di termini noti;
  - $c in QQ^n$ vettore di pesi;
- *soluzioni ammissibili*: $x in ZZ^n$ tali che $A x gt.eq b$;
- *funzione obiettivo*: $c^T x$;
- *tipo*: $min$ (_in realtà non cambia niente_).

La differenza sembra minima, ma è in realtà enorme: infatti, $ILP in NPOC$ solo per l'imposizione di soluzioni intere.

=== Vertex Cover con arrotondamento

Vediamo una soluzione di *Vertex Cover con arrotondamento* (_rounding_) che utilizza la $LP$.

Il problema Vertex Cover ha in input un grafo $G = (V,E)$ non orientato con una serie di pesi $w_i in QQ^(>0) quad forall i in V$. Sia $pi$ un'istanza di Vertex Cover. Creo il problema $ILP(pi)$ con:
- *variabili*: $x in ZZ^n$;
- *vincoli*: $ cases(x_i + x_j gt.eq 1 quad & forall{i,j} in E, x_i gt.eq 0 & forall i in V, x_i lt.eq 1 & forall i in V) ; $
- *obiettivo*: $min_(x) (sum_(i in V) w_i x_i)$.

Con il primo vincolo imponiamo che ogni lato abbia almeno un vincolo selezionato nella variabile $x$, mentre gli altri due vincoli impongono che $x_i in {0,1} quad forall i in V$.

Consideriamo ora il rilassamento di questo problema, chiamato $ILP(pi)$, identico al problema precedente tranne che la variabile ora è $x in QQ^n$. Il risultato è un vettore che contiene anche dei valori razionali in $QQ$. Come ci comportiamo? Useremo questa soluzione intermedia come input al *rounding*. Come?

Sia $pi : (G = (V,E), w_i)$, allora $ pi arrow.squiggly "ILP"(pi) arrow.squiggly "LP"(pi) = x^* arrow.squiggly rounding(x^*) = overline(x) arrow.squiggly overline(x)_i = cases(0 & "se" x_i^* < 0.5, 1 quad & "se" x_i^* gt.eq 0.5) quad forall i in V . $

Sia $w^*_(ILP)$ l'ottimo ottenuto nel problema ILP, e sia $w^*_(LP)$ l'ottimo ottenuto nel problema LP rilassato.

#lemma()[
  $ w^*_(LP) lt.eq w^*_(ILP) . $
]

#proof()[
  Il problema rilassato LP ha un super-insieme di soluzioni ammissibili rispetto al problema originale, quindi l'ottimo può solo essere migliore, o al massimo uguale.
]

#lemma()[
  $overline(x)$ è una soluzione ammissibile di $ILP(pi)$.
]

#proof()[
  I vincoli da verificare sono $ cases(overline(x)_i + overline(x)_j gt.eq 1 quad & forall{i,j} in E, 0 lt.eq overline(x)_i lt.eq 1 & forall i in V) $ con $x in ZZ^n$. Partiamo dal secondo vincolo: Come abbiamo ottenuti i vari $x_i$? Sappiamo che $ overline(x)_i = cases(0 & "se" x_i^* < 0.5, 1 quad & "se" x_i^* gt.eq 0.5) quad forall i in V , $ ma allora il secondo vincolo è verificato, avendo ogni $x_i$ valore nell'insieme ${0,1}$.

  Vediamo ora il primo vincolo: l'unico caso nel quale non è rispettato è quando $overline(x)_i + overline(x)_j = 0$, ovvero $overline(x)_i = overline(x)_j = 0$. Se ai due vertici è assegnato $0$ vuol dire che $x_i^* < 0.5$ e $x_j^* < 0.5$, ma questo è assurdo: infatti, nella soluzione ottima in LP vale il vincolo $x_i^* + x_j^* gt.eq 1$, che non è però soddisfatto dalla somma di due quantità minori di $0.5$.
]

#lemma()[
  $ forall i quad overline(x)_i lt.eq 2 x_i^* . $
]

#proof()[
  Dobbiamo controllare i due possibili valori di $overline(x)_i$.

  Se $overline(x)_i = 0$ allora $ 0 lt.eq x_i^* < 0.5 arrow.long.double overline(x)_i = 0 lt.eq 2 x_i^* < 1 arrow.long.double overline(x)_i lt.eq 2 x_i^* . $

  Se $overline(x)_i = 1$ allora $ x_i^* gt.eq 1/2 arrow.long.double 2 x_i^* gt.eq 1 = overline(x)_i arrow.long.double overline(x)_i lt.eq 2 x_i^* qedhere . $
]

#lemma()[
  $ w lt.eq 2 w^*_(LP) . $
]

#proof()[
  Molto facile: $ w = sum_i w_i overline(x)_i lt.eq_3 2 sum_i w_i x_i^* = 2 w^*_("LP") . qedhere $
]

#theorem()[
  L'algoritmo basato su rounding è una $2$-approssimazione per Vertex Cover.
]

#proof()[
  Dopo quattro estenuanti lemmi possiamo affermare che $ frac(w, w^*_("ILP")) lt.eq_1 frac(w, w_("LP")) lt.eq_4 frac(2 w^*_("LP"), w^*_("LP")) = 2 . qedhere $
]
