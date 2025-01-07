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

= MAX $E_k$-SAT [$k gt.eq 3$]

#align(center)[
  #block(
    fill: rgb("#9FFFFF"),
    inset: 8pt,
    radius: 4pt,

    [*La lezione finirà prima, ho una perdita a casa e vorrei evitare la situazione che mi è successa tempo fa: sono dovuto tornare a casa in taxi perché il gatto aveva aperto il rubinetto ma il tappo era giù, e dalle videocamere vedevo l'acqua che saliva (_cit. Boldi_)*],
  )
]

Forse uno dei problemi più famosi del mondo nella sua versione di decisione, esso è definito da:
- *input*: formula CNF in cui ogni clausola contiene esattamente $k$ letterali;
- *soluzioni ammissibili*: assegnamenti di valori di verità alle variabili che compaiono nell'input;
- *funzione obiettivo*: numero di clausole soddisfatte (_true_) dall'assegnamento;
- *tipo*: $max$.

Le *formule CNF* sono congiunzioni di _"pezzi"_ $ P_1 and dots and P_t $ e ogni _"pezzo"_ $P_i$ è una disgiunzione di $k$ letterali $ l_1 or dots or l_k , $ che possiamo trovare positivi o negativi.

I pezzi sono le *clausole*, che contengono appunto i *letterali*.

Una proprietà interessante delle CNF è che ogni formula logica che coinvolge variabili booleane può essere trasformata in una CNF normale e poi in una $E_k$-CNF.

#theorem()[
  MAX $E_k$-SAT è un problema $NPOC$.
]

#proof()[
  Per assurdo, supponiamo di saper risolvere MAX $E_k$-SAT in tempo polinomiale. Sia $T$ il numero di clausole che vengono soddisfatte dall'assegnamento generato dall'algoritmo esatto polinomiale. Ma allora riesco a risolvere il problema di decisione $E_k$-SAT in tempo polinomiale, semplicemente osservando se $T$ è uguale al numero di clausole. Ma $E_k$-SAT è un problema $NPC$, quindi questo è un assurdo.
]

Vediamo quindi un algoritmo probabilistico per questo problema.

#align(center)[
  #pseudocode-list(title: [Algoritmo mega difficile])[
    - *input*
      - Formula CNF in cui ogni clausola contiene $k$ letterali;
    + Assegna ad ogni variabile un valore a caso in ${"true", "false"}$
    + *output* assegnamento fatto
  ]
]

#theorem()[
  L'algoritmo mega difficile, data una formula CNF formata da $t$ clausole, ne rende vere almeno $ frac(2^k - 1, 2^k) t , $ cioè $ EE[T] gt.eq frac(2^k - 1, 2^k) t . $
]

#proof()[
  Diamo prima un po' di notazione. Siano:
  - $phi$ la formula CNF di input;
  - $k$ il numero di letterali che compaiono in ogni clausola;
  - $n$ il numero di variabili diverse che compaiono in $phi$;
  - $x_1, dots, x_n$ le variabili che compaiono in $phi$;
  - $T$ il numero di clausole che vengono soddisfatte dall'assegnamento.

  Introduciamo $n$ variabili aleatorie $ X_i tilde U({0,1}) $ distribuite come un modello uniforme sull'insieme ${0,1}$. Ogni variabile $X_i$ indica se la variabile $i$-esima è vera o falsa.

  Introduciamo infine $t$ variabili aleatorie $C_j$ tali che $ C_j = cases(1 & "se la clausola" K_j "è soddisfatta", 0 quad & "altrimenti") . $

  Aggiungiamo un teorema alle *COSE*, un bel teorema, il *teorema delle probabilità totali*.

  Calcoliamo il valore atteso del numero di clausole coperte come $ EE[T] = sum_(b_1 in {0,1}) dots sum_(b_n in {0,1}) EE[T bar.v X_1 = b_1, dots, X_n = b_n] P(X_1 = b_1, dots, X_n = b_n) . $ Con il teorema delle probabilità totali stiamo condizionando ai valori delle variabili $X$, che coprono tutto il mio insieme di casi possibili. Sistemiamo questa quantità spezzando la probabilità in singole probabilità: $ EE[T] &= sum_(b_1) dots sum_(b_n) EE[C_1 + dots + C_t bar.v X_1 = b_1, dots, X_n = b_n] P(X_1 = b_1) dots P(X_n = b_n) = \ &= 1/2^n sum_b_1 dots sum_b_n EE[C_1 + dots + C_n bar.v X_1 = b_1, dots, X_n = b_n] . $

  Uso la linearità del valore atteso, quindi $ EE[T] = 1/2^n sum_b_1 dots sum_b_n sum_(j=1)^t EE[C_j bar.v X_1 = b_1, dots, X_n = b_n] . $

  Guardiamo il valore atteso. Sto assegnando un valore di verità a tutte le variabili, ma così facendo so esattamente il valore di $C_j$: dipende infatti dai valori che ho appena assegnato alle variabili. Come dice Boldi:

  #align(center)[
    #block(
      fill: rgb("#9FFFFF"),
      inset: 8pt,
      radius: 4pt,

      [*Non è una cosa a capocchia*],
    )
  ]

  Supponiamo di guardare la $j$-esima clausola, formata da $k$ variabili. Per avere questa clausola falsa, devo assegnare _VERO_ a tutte le variabili negative e _FALSO_ a tutte le variabili positive, visto che abbiamo una disgiunzione. Esiste quindi un solo modo per assegnare queste $k$ variabili per avere la clausola falsa. Le altre $n - k$ variabili le assegno a caso.

  Facendo ciò abbiamo $2^(n-k)$ modi per rendere $C_j$ falsa, visto che $n-k$ sono messe a caso con $2$ valori possibili. Ma allora $2^n - 2^(n-k)$ sono il numero di modi che rendono vera la clausola.

  Sistemiamo il valore atteso, considerando solo i casi che rendono vera la clausola, ovvero: $ EE[T] &= 1/2^n sum_(j=1)^t (2^n - 2^(n-k)) = \ &= frac(2^n - 2^(n-k), 2^n) t . $ Moltiplico tutto per $2^(k - n)$ ottenendo infine $ EE[T] = frac(2^k - 1, 2^k) t . qedhere $
]

#lemma()[
  Vale $ forall j = 0, dots, n quad exists b_1, dots, b_j in {0,1} bar.v EE[T bar.v X_1 = b_1, dots, X_j = b_j] gt.eq frac(2^k - 1, 2^k) t , $ dove $t$ è il numero di clausole.
]

Questo lemma è più generale rispetto al teorema precedente: ci sta dicendo che possiamo fissare un numero qualsiasi $j$ di variabili e mantenere comunque il numero di minimo di clausole soddisfatte.

#proof()[
  Dimostriamo per induzione sul numero di variabili fissate $j$.

  Passo base: se $j = 0$ sto dimostrando il teorema precedente, dove non fissavo niente.

  Passo induttivo: per HP di induzione sappiamo che $ EE[T bar.v X_1 = b_1, dots, X_(j-1) = b_(j-1)] gt.eq frac(2^k - 1, 2^k) t . $

  Usiamo il teorema delle probabilità totali, condizionando il valore atteso alla variabile $X_j$, ovvero: $ EE[T bar.v X_1 = b_1, dots, X_(j-1) = b_(j-1)] &= EE[T bar.v X_1 = b_1, dots, X_(j-1) = b_(j-1), X_j = 0] P(X_j = 0) + \ &+ space EE[T bar.v X_1 = b_1, dots, X_(j-1) = b_(j-1), X_j = 1] P(X_j = 1) . $ Le due probabilità valgono entrambe $1/2$ essendo le $X_i$ uniformi, quindi $ EE[T bar.v X_1 = b_1, dots, X_(j-1) = b_(j-1)] &= 1/2 (EE[T bar.v X_1 = b_1, dots, X_(j-1) = b_(j-1), X_j = 0] + \ & quad space + EE[T bar.v X_1 = b_1, dots, X_(j-1) = b_(j-1), X_j = 1]) . $

  Chiamo $A$ e $B$ i due valori attesi. Per assurdo siano $ A,B < frac(2^k - 1, 2^k) t . $ La loro somma è $ A + B < frac(2^k - 1, 2^k) 2t . $ Ma allora $ EE = 1/2 (A + B) < frac(2^k - 1, 2^k) . $

  Ma questo non è possibile: all'inizio avevamo, per ipotesi di induzione, che $ EE gt.eq frac(2^k - 1, 2^k) t , $ ma unendo l'ultima disuguaglianza otteniamo un assurdo.

  Visto l'assurdo, almeno uno dei due valori attesi deve essere maggiore o uguale a quella quantità, il che dimostra il nostro lemma.
]

Questo lemma ci dà l'idea di quella che è la *de-randomizzazione*: possiamo fare un assegnamento deterministico continuando a garantire il numero di clausole soddisfatte.

#corollary()[
  Esiste un assegnamento deterministico che soddisfa almeno $ frac(2^k - 1, 2^k) t $ clausole.
]

Non siamo più nel probabilistico. Ma come determiniamo questo assegnamento di variabili?

#align(center)[
  #pseudocode-list(title: [Assegnamento deterministico])[
    - *input*
      - formula $phi$ $E_k$-CNF
      - la formula contiene $t$ clausole $K_1 and dots and K_t$
      - la formula utilizza $n$ variabili $x_1, dots, x_n$
    + $D arrow.l emptyset.rev$
    + for $i = 1, dots, n$
      + $Delta_0 = 0$
      + $Delta_1 = 0$
      + $Delta_D_0 = emptyset.rev$
      + $Delta_D_1 = emptyset.rev$
      + for $j = 1, dots, t$
        + if $j in D$
          + continue
        + if $x_i$ non compare in $K_j$
          + continue
        + Sia $h$ il numero di variabili in $K_j$ con indice $gt.eq i$
        + if $x_i$ compare positiva in $K_j$
          + $Delta_0 = Delta_0 - 1 / 2^h$
          + $Delta_1 = Delta_1 + 1 / 2^h$
          + $Delta_D_1 = Delta_D_1 union {j}$
        + else
          + $Delta_0 = Delta_0 + 1 / 2^h$
          + $Delta_1 = Delta_1 - 1 / 2^h$
          + $Delta_D_0 = Delta_D_0 union {j}$
      + if $Delta_0 gt.eq Delta_1$
        + $x[i] = "false"$
        + $D arrow.l D union Delta_D_0$
      + else
        + $x[i] = "true"$
        + $D arrow.l D union Delta_D_1$
    + *output* $x[1], dots, x[n]$
  ]
]

Cerchiamo di spiegare questo algoritmo:
- il primo ciclo for decide quale variabile $i$ devo assegnare ora;
- il secondo ciclo for scorre le clausole $j$:
  - l'insieme $D$ contiene le clausole già soddisfatte;
  - se la clausola $j in D$ o se la variabile $x_i in.not K_j$ allora possiamo andare avanti, visto che la clausola è già soddisfatta o la variabile non è presente.
  - per ogni clausola da controllare, modifico i valori $Delta_0$ e $Delta_1$ in base a quante variabili di indice $gt.eq i$ ho nella clausola corrente; questi valori $Delta$ ci dicono quanto variano i valori attesi delle clausole soddisfatte ponendo vera o falsa la variabile in esame.

Come mai proprio $1/2^h$? Supponiamo di avere $h$ variabili da assegnare per una tale clausola, allora ho $ frac(2^h - 1, 2^h) $ modi di renderla vera. Supponiamo di assegnare _VERO_ alla $i$-esima variabile, che è positiva, ma facendo ciò ho reso vera la clausola, portando a $1$ il suo valore atteso. Se invece supponiamo di assegnare _FALSO_ alla $i$-esima variabile, che è negativa, ho $h-1$ variabili ancora da controllare per renderla vera, ovvero otteniamo $ frac(2^(h-1) - 1, 2^(h-1)) . $

Se calcoliamo $Delta_1$ (_o l'altra quantità_) come differenza tra il valore dopo e il valore prima del valore atteso, otteniamo $ 1 - frac(2^h - 1, 2^h) = 1/2^h . $

Gli insiemi $Delta_D$ contano quante clausole andremo a soddisfare con la scelta fatta.

*IN SINTESI*, cosa abbiamo fatto oggi:
- siamo partiti da un algoritmo probabilistico con una buona _"mira"_ nel rendere vere le clausole;
- abbiamo deciso di fissare qualche variabile garantendo comunque la buona _"mira"_;
- abbiamo fatto vedere che possiamo trovare deterministicamente questo assegnamento.

Siamo passati dal probabilistico al non-probabilistico, mantenendo sempre dei buoni bound sul numero di clausole soddisfatte.

#align(center)[
  #block(
    fill: rgb("#9FFFFF"),
    inset: 8pt,
    radius: 4pt,

    [*Vi racconto i miei patemi interiori, sono entrato in un trip magico per cercare dei tool di visualizzazione (_cit. Boldi_)*],
  )
]

In statistica il valore atteso è praticamente inutile: una singola esecuzione di un algoritmo potrebbe essere molto sfortunata e darci un valore più piccolo del valore atteso che abbiamo calcolato teoricamente.

Il fattore di approssimazione dell'algoritmo probabilistico sarebbe $ frac(t, frac(2^k - 1, 2^k)t) = frac(2^k, 2^k -1) $ ma è appunto un algoritmo probabilistico, quindi questo bound andrebbe calcolato con le probabilità.

Tutto ciò è abbastanza sbatti, però noi abbiamo un algoritmo deterministico, ottenuto dalla re-randomizzazione.

#align(center)[
  #block(
    fill: rgb("#9FFFFF"),
    inset: 8pt,
    radius: 4pt,

    [*NOOOOO, DOVEVO REGISTRARE (_cit. Boldi_)*],
  )
]

Ora che abbiamo un algoritmo deterministico, possiamo dire che il fattore di approssimazione è quello calcolato al passo precedente.
