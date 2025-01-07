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

= Taglio minimo globale (mincut)

Il primo problema che vediamo risolto con algoritmi probabilistici è il problema del *taglio minimo globale* (_o *mincut*_). Esso è definito da:
- *input*: grafo non orientato $G = (V,E)$;
- *soluzione ammissibile*: insieme di vertici $X subset.eq V$ tale che:
  - $X eq.not emptyset.rev$;
  - $X^C eq.not emptyset.rev$;
- *funzione obiettivo*: vogliamo valutare la quantità $k = abs({e in E bar.v e sect X eq.not emptyset.rev and e sect X^C eq.not emptyset.rev})$, ovvero il numero di lati che hanno un vertice in $X$ e l'altro nel suo complemento; in poche parole, se disegno $G$, voglio contare il numero di lati che fanno da ponte dalla zona $X$ alla zona $X^C$;
- *tipo*: $min$.

Il problema è $NPOC$ anche se non sembra.

#lemma()[
  Il taglio minimo è $lt.eq$ del grado minimo dei vertici.
]

Questo è un bound molto molto ampio: unendo due cricche $K_n$ e $K_m$ con un lato, il taglio minimo vale $k = 1$, che è molto più piccolo del grado minimo $n-1$ o $m-1$.

Prima di vedere l'algoritmo risolutivo per mincut diamo la definizione di *contrazione di grafi*: dato un grafo $G$, la contrazione $G arrow.b e$ sul lato $e$ si calcola con i seguenti passi:
- eliminare il lato $e$ dal grafo;
- unire i due vertici sui quali $e$ incideva in un unico vertice;
- unire ogni vicino dei vertici fusi al nuovo vertice;
  - questa operazione può causare la creazione di due lati paralleli e quindi di un multigrafo.

Visto l'ultimo punto, di solito la definizione di contrazione è data sui multigrafi.

Questa operazione va a ridurre ad ogni iterazione il numero di lati e di vertici del multigrafo.

#align(center)[
  #pseudocode-list(title: [Algoritmo di Karger])[
    - *input*
      - multigrafo $G = (V,E)$
    + if $G$ non connesso
      + *output* una componente connessa qualunque
        - il taglio vale $0$
    + else
      + while $abs(V) > 2$
        + Sia $e$ un lato a caso
        + Calcola $G arrow.b e$
          - Questa operazione contrae tutti i lati paralleli ad $e$
    + *output* la classe di equivalenza di uno dei due vertici rimanenti
      - I vertici finali sono insiemi di vertici, ma anche classi di equivalenza
  ]
]

Mostreremo che esiste una probabilità non nulla di ottenere la soluzione ottima. Negli altri casi, il risultato ottenuto sarà arbitrariamente brutto.

Durante l'esecuzione dell'algoritmo abbiamo una serie di multigrafi $G_1 arrow.long G_2 arrow.long dots$ che parte da $G_1 = G$. Sia $G_i$ il multigrafo che abbiamo prima dell'$i$-esima iterazione. Chiamiamo $X^*$ il taglio minimo e $k^*$ la sua *dimensione*, ovvero il numero di archi che tagliano il taglio minimo.

Vista l'operazione di contrazione, abbiamo che:
- $G_i$ ha $n - i + 1$ vertici (_in ogni iterazione perdiamo un vertice_);
- $G_i$ ha $lt.eq m - i + 1$ lati (_in ogni iterazione cancelliamo tutti i lati paralleli_).

Inoltre, ogni taglio di $G_i$ corrisponde ad un taglio di $G$ con la stessa dimensione. Infatti, se isolo in $G_i$ un taglio e vedo la sua dimensione, essa è uguale in $G$ perché tutti i lati che non ho contratto e che sono in $G_i$ li trovo anche in $G$.

In particolare, il grado minimo di $G_i$ è $gt.eq k^*$: infatti, se avessi un taglio più piccolo anche $G$ ce l'avrebbe ma questo è impossibile perché $X^*$ con $k^*$ è il taglio minimo.

Sia ora $m_i$ il numero di lati di $G_i$, allora $ 2 m_i = sum_(v in V_G_i) d_G_i (v) , $ ma il numero di vertici in $G_i$ è $n - i + 1$ e sappiamo che il grado minimo è $gt.eq$ della dimensione ottima, quindi $ 2 m_i gt.eq (n-i+1) k^* arrow.long.double m_i gt.eq frac(k^* (n-i+1), 2) . $

Sia $E_i$ l'evento che ci dice se all'$i$-esima iterazione *NON* contraiamo uno dei lati tagliati dal taglio minimo. Dio ci ha detto qual è il taglio minimo, sappiamo quali sono i lati del taglio minimo. Vogliamo sapere la probabilità che all'$i$-esimo passo noi contraiamo uno dei lati _"preziosi"_.

#lemma()[
  Vale $ P(E_i bar.v E_1, dots, E_(i-1)) gt.eq frac(n-i-1,n-i+1) . $
]

#proof()[
  Valutiamo $ P(E_i bar.v E_1, dots, E_(i-1)) &= 1 - P(overline(E)_i bar.v E_1, dots, E_(i-1)) = 1 - frac(k^*, m_i) \ &gt.eq 1 - frac(2 k^*, k^* (n - i + 1)) = frac(n - i + 1 - 2, n - i + 1) = frac(n-i-1,n-i+1) . $

  Fanculo il quadrato.
]

Questo lemma vuole vedere la probabilità di non contrarre un lato prezioso sapendo le probabilità dello stesso evento nei multigrafi precedenti.

#theorem()[
  L'algoritmo di Karger emette il taglio minimo con probabilità $ P gt.eq frac(1, binom(n, 2)) . $
]

#proof()[
  Il taglio minimo si ottiene quando non contraggo mai i lati preziosi, quindi $ P &= P(E_1 and E_2 and dots and E_(n-2)) = \ &=_("CR") P(E_1) dot P(E_2 bar.v E_1) dot P(E_3 bar.v E_2,E_1) dot dots dot P(E_(n-2) bar.v E_(n-3), dots, E_1) $ per la Chain Rule della probabilità. Noi queste quantità le conosciamo, ovvero $ P &gt.eq_("lemma") frac(n-2,n) dot frac(n-3,n-1) dot dots dot 1/3 = \ & space = frac((n-2)!, n dot (n-1) dot dots dot 3) dot 2/2 = frac(2 (n-2)!, n (n-1) (n-2)!) = frac(2, n(n-1)) . $

  Ricordando che $ binom(n,2) = frac(n!, (n-2)! 2!) = frac(n (n-1) (n-2)!, (n-2)! 2) = frac(n (n-1), 2), $ allora $ P gt.eq 1/binom(n,2) . qedhere $
]

Questa quantità decresce quadraticamente con $n$, ovvero più è grande il multigrafo e più ho probabilità bassa di trovare il taglio minimo.

#corollary()[
  Eseguendo l'algoritmo di Karger $ binom(n,2) ln(n) $ volte si ottiene il taglio minimo con probabilità $ P gt.eq 1 - 1/n .$
]

#proof()[
  Dall'analisi matematica si sa che (_non lo sapevo_) $ forall x > 1 quad 1/4 lt.eq (1 - 1/x)^x lt.eq 1/e . quad (*) $

  Valutiamo la probabilità di *NON* ottenere il taglio minimo, ovvero nessuna delle prove che abbiamo fatto ha dato il taglio minimo, ma allora, per il teorema precedente, vale $ P_("singolo") lt.eq 1 - 1/binom(n,2) arrow.long_("ind") P lt.eq (1 - 1/binom(n,2))^(binom(n,2) ln(n)) lt.eq^(*) (1/e)^ln(n) = 1/n . $

  Noi vogliamo la probabilità di ottenere il taglio minimo, quindi $ P gt.eq 1 - 1/n . qedhere $
]

I bro statistici dicono che questo evento è *quasi certo*, ovvero se $n$ va a infinito allora la probabilità di trovare il taglio minimo va a $1$.
