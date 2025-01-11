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

= Knapsack

Dei pirati arrivano in un grotta e trovano degli oggetti, ognuno con un valore $v_0, dots, v_(n-1)$. I pirati vorrebbero portare a casa gli oggetti con più valore, ma ogni oggetto ha un peso $w_0, dots, w_(n-1)$ e i bro hanno uno zaino con una certa capacità massima $W$. Vogliamo portare a casa il massimo valore senza rompere lo zaino. Il problema di decisione associato, ovvero chiedersi se sia possibile portare a casa più di $k$ oggetti, è un problema $NPC$.

Vediamo la definizione formale:
- *input*:
  - $n > 0$ oggetti;
  - $w_i > 0$ pesi con $i in n$;
  - $W > 0$ capacità dello zaino;
- *soluzione ammissibile*: $X subset.eq n$ tale che $sum_(i in X) w_i lt.eq W$;
- *funzione obiettivo*: $v = sum_(i in X) w_i$;
- *tipo*: $max$.

Il problema è $NPOC$ visto che il suo problema di decisione associato è $NPC$.

Useremo una tecnica chiamata *programmazione dinamica*: quest'ultima risolve un certo problema individuando $k$ parametri che andranno a formare una tabella $k$-dimensionale. Al posto di risolvere il problema noi andremo a riempire la tabella, è più facile rispetto alla risoluzione del problema originale. Abbiamo una serie di vincoli:
- le prime _"righe"_ e le prime _"colonne"_ (_facciamo finta di essere in 2d_) devono essere facili da riempire;
- dobbiamo essere in grado di riempire ogni cella partendo da celle che abbiamo già riempito precedentemente, ovvero dobbiamo avere una *strategia di riempimento*.

Ogni cella è un problema, che prende in input i parametri che indicizzano quella cella.

Questa tecnica è molto comoda quando i problemi sono di natura esponenziale. Il numero di problemi dipende dai valori dei parametri. Se i parametri sono nell'input del problema, la dimensione della tabella è esponenziale.

Prima di vedere la PD applicata a Knapsack, introduciamo il concetto di *pseudo-polinomialità*.

#example()[
  Voglio un programma che decide se un numero naturale $x$ è primo (_BTW è stato trovato finalmente un algoritmo polinomiale per questo problema_). Il programma è molto tremendamente difficile da scrivere, vediamolo in GO.

  #align(center)[
    ```go
    input(x)
    for i := 2; i < x; i++ {
      if x % i == 0 {
        return false
      }
    }
    return true
    ```
  ]

  Il ciclo `for` viene eseguito $O(x)$ volte. Quindi l'algoritmo è polinomiale? *NO*.

  Dobbiamo dire se è polinomiale anche nei bit dell'input, che sono logaritmici in $x$. Ma una cosa lineare nel logaritmo è esponenziale (????).
]

Questo algoritmo è chiamato pseudo-polinomiale, ovvero un algoritmo che è lineare nel tempo ma esponenziale nella lunghezza dell'input (????).

== PD: prima versione

#align(center)[
  #pseudocode-list(title: [Prima versione di PD (focus pesi)])[
    - *input*
      - $n > 0$ numero di oggetti
      - $v_0, dots, v_(n-1)$ valore degli oggetti
      - $w_0, dots, w_(n-1)$ peso degli oggetti
      - $W > 0$ capacità dello zaino
      - questo input ha lunghezza $O(n)$
    - *Parametri della tabella*
      - Righe: capacità dello zaino $w$, lavora sui valori $0, dots, W$
      - Colonne: quanta parte dell'input considerare $i$, lavora sui valori $0, dots, n$
        - Considero gli oggetti fino a $(i-1)$ compreso
      - In una cella inserisco il valore massimo che riesco a portare a casa
    + *Strategia di riempimento*
      + La prima riga è $0$ perché la capienza $w$ è $0$
      + La prima colonna è $0$ perché sto considerando $0$ oggetti
      - L'algoritmo riempie per righe tutte quelle successive alla prima
      + Data la cella $v[w,i]$:
        + Considero la cella $v[w,i-1]$, ovvero a parità di peso prendo i primi $i-1$ oggetti
        + Se non prendo l'oggetto $i$-esimo allora $v[w,i] = v[w,i-1]$
        + Se prendo l'oggetto $i$-esimo allora $v[w,i] = max(v[w,i-1], v_(i-1) + v[w - w_(i-1), i-1])$
          - In poche parole, vedo cosa prendevo con $w_(i-1)$ peso in meno e ci sommo il nuovo peso
        - In forma contratta: $ v[w,i] = cases(v[w,i-1] & "se" w < w_(i-1), max(v[w,i-1], v_(i-1) + v[w - w_(i-1), i-1]) quad & "altrimenti") $
    + *output*: $v[W,n]$
  ]
]

La matrice $v$ è esponenziale in $W$, visto che è un parametro di input del problema originale. Per far si che questo algoritmo funzioni, è essenziale che i pesi $w_i$ siano tutti interi e anche la capacità $W$. Se la tabella avesse valori continui allora avremmo degli algoritmi polinomiali per risolverla.

== PD: seconda versione

#align(center)[
  #pseudocode-list(title: [Seconda versione di PD (focus valori)])[
    - *input*
      - $n > 0$ numero di oggetti
      - $v_0, dots, v_(n-1)$ valore degli oggetti
      - $w_0, dots, w_(n-1)$ peso degli oggetti
      - $W > 0$ capacità dello zaino
      - questo input ha lunghezza $O(n)$
    - *Parametri della tabella*
      - Righe: massimo valore che portiamo a casa $v$, lavora sui valori $0, dots, sum_i v_i$
      - Colonne: quanta parte dell'input considerare $i$, lavora sui valori $0, dots, n$
        - Considero gli oggetti fino a $(i-1)$ compreso
      - In una cella inserisco la capacità minima dello zaino che contiene quegli elementi
        - A volte questa capacità sarà impossibile (_infinita_)
    + *Strategia di riempimento*
      + La prima riga è $0$ perché non voglio portare a casa niente
      + La prima colonna, dalla seconda riga, è $infinity$ perché voglio portare a casa qualcosa ma non ho oggetti disponibili
      - L'algoritmo riempie per righe tutte quelle successive alla prima
      + Data la cella $w[v,i]$:
        + Considero la cella $w[v,i-1]$, ovvero a parità di valore richiesto considero un oggetto in meno
        + Se non prendo l'oggetto $i$-esimo allora $w[v,i] = min(w[v,i-1], w_(i-1))$
        + Se prendo l'oggetto $i$-esimo allora $w[v,i] = min(w[v,i-1], w_(i-1) + w[v - v_(i-1), i-1])$
        - In forma contratta: $ w[v,i] = cases(min(w[v,i-1], w_(i-1)) & "se" v < v_(i-1), min(w[v,i-1], w_(i-1) + w[v - v_(i-1), i-1]) quad & "altrimenti") $
    - L'ultima colonna contiene il peso minimo degli zaini considerando tutti gli oggetti
    + Filtro le entry $w[v,n]$ tali che $w[v,n]> W$ perché non sono ammissibili
    + *output*: l'indice della riga che contiene l'ultima entry accettabile
  ]
]

Anche qui, la matrice $w$ è esponenziale ma nella somma dei valori $v$.

== FPTAS

I due algoritmi di PD visti trovano la soluzione esatta, ma vista la loro pseudo-polinomialità, essi sono esponenziali. Vediamo quindi un algoritmo polinomiale per la risoluzione, ma approssimato.

Parliamo di *Turchia*: prima degli anni $'90$ la _lira turca_ non valeva assolutamente niente. Idea geniale del governo: negli anni $'90$ viene introdotta la _lira pesante_, che valeva $10.000$ lire turche originali. In poche parole, ogni prezzo è stato diviso per $10.000$.

In cosa può esserci utile la Turchia, *oltre al trapianto di capelli*?

Dobbiamo abbattere la dimensione della tabella: possiamo esprimere i valori degli oggetti in una *moneta dei pirati pesante*, in modo che i valori diventino piccoli e che la matrice si comprima.

Abbiamo però un problema: se comprimiamo tanto i valori questi potrebbero confondersi, visto che gli indici della tabella sono *interi*. Noi diciamo chissene frega, almeno stiamo rendendo la soluzione polinomiale.

Una cosa che non abbiamo mai detto ma che è banale: gli algoritmi che utilizziamo per approssimare sono comunque ammissibili, ovvero non andiamo mai fuori dai bound del problema. In poche parole:
- accettiamo una cosa *sub-ottima*, che è peggio dell'ottimo;
- non accettiamo *mai* una soluzione *sub-ammissibile*, che va fuori dai bound.

Andiamo a comprimere la seconda tabella perché la prima rischia di rompere i vincoli di ammissibilità. Questa tecnica di compressione si chiama *scaling*. Non posso comprimere la prima tabella perché le righe mi danno l'*ammissibilità*: se comprimo potrei ottenere soluzioni che nella compressa vanno bene ma non vanno bene in quella normale.

#align(center)[
  #pseudocode-list(title: [FPTAS per Knapsack])[
    - *input*
      - problema $Pi = (v_i, w_i, W)$
      - errore $0 < epsilon lt.eq 1$ per avere una $1 + epsilon$ approssimazione di $Pi$
    + Definiamo $ theta.alt = frac(epsilon v_max, 2 n) $
    + Definiamo $ overline(Pi) = (overline(v)_i = ceil(v_i /  theta.alt) theta.alt, w_i, W) $
      - I valori degli oggetti di $overline(Pi)$ sono molto simili a quelli di $Pi$
    + Definiamo $ hat(Pi) = (over(v,tilde) = ceil(v_i / theta.alt), w_i, W) $
    + Risolviamo $hat(Pi)$ in modo esatto con la seconda versione dell'algoritmo PD
  ]
]

Osserviamo che l'*ammissibilità* è la stessa in tutti i problemi: stiamo considerando gli stessi pesi e la stessa capacità dello zaino, quindi le soluzioni ammissibili sono uguali. Le soluzioni ottime però cambiano, visto che dipendono dai valori, e questi sono diversi.

Osserviamo inoltre che $overline(X)^* = hat(X)^*$ perché i valori differiscono per una costante.

#lemma()[
  Sia $X$ una soluzione ammissibile. Allora $ (1 + epsilon) sum_(i in hat(X)^*) v_i gt.eq sum_(i in X) v_i . $
]

#proof()[
  I valori di $overline(Pi)$ sono un pelo più grandi di quelli di $Pi$, quindi $ sum_(i in X) v_i &lt.eq sum_(i in X) overline(v)_i lt.eq_("OPT") sum_(i in overline(X)^*) overline(v)_i . $

  Visto che i $overline(v)_i$ sono ottenuti con una approssimazione per eccesso, ogni $overline(v)_i$ è al massimo un $theta.alt$ in più, quindi $ sum_(i in X) v_i lt.eq sum_(i in overline(X)^*) (v_i + theta.alt) = sum_(i in overline(X)^*) v_i + abs(overline(X)^*) theta.alt lt.eq sum_(i in overline(X)^*) v_i + n theta.alt = sum_(i in overline(X)^*) v_i + n frac(epsilon v_max, 2 n) . $

  Abbiamo ottenuto quindi $ sum_(i in X) v_i lt.eq sum_(i in overline(X)^*) v_i + frac(epsilon v_max, 2) . quad (*) $

  Questa disuguaglianza è vera per ogni soluzione ammissibile. Una di queste è $X_max = {i_max}$, soluzione che contiene l'indice dell'elemento di valore massimo (_dopo aver tolto i valori che hanno peso maggiore della capacità dello zaino_).

  Ma allora $ sum_(i in X_max) v_i = v_max lt.eq sum_(i in overline(X)^*) v_i + frac(epsilon v_max, 2) lt.eq_((epsilon lt.eq 1)) sum_(i in overline(X)^*) v_i + v_max / 2 . $

  Portando a sinistra il termine $v_max / 2$ otteniamo $ v_max / 2 lt.eq sum_(i in overline(X)^*) v_i . quad (**) $

  Uniamo $(*)$ e $(**)$ e otteniamo $ sum_(i in X) v_i lt.eq sum_(i in overline(X)^*) v_i + frac(epsilon v_max, 2) lt.eq^((**)) sum_(i in overline(X)^*) v_i + epsilon (sum_(i in overline(X)^*) v_i) = (1 + epsilon) sum_(i in overline(X)^*) v_i . $

  Abbiamo prima osservato che $hat(X)^* = overline(X)^*$, ma allora $ (1 + epsilon) sum_(i in hat(X)^*) v_i gt.eq sum_(i in X) v_i . qedhere $
]

#theorem()[
  Vale inoltre $ (1 + epsilon) sum_(i in hat(X)^*) v_i gt.eq v^* . $
]

#proof()[
  Per il lemma precedente vale $ (1+epsilon) sum_(i in hat(X)^*) v_i gt.eq sum_(i in X) v_i . $ Considero $X = X^*$. Allora $ (1 + epsilon) sum_(i in hat(X)^*) v_i gt.eq sum_(i in X^*) v_i = v^* . qedhere $
]

#corollary()[
  L'algoritmo FPTAS è una $(1+epsilon)$-approssimazione per Knapsack.
]

Manca da analizzare la *complessità* di questo FPTAS: come è fatta la matrice? Quante sono le celle?

La matrice è formata da:
- *righe*: vanno da 0 a $sum_i hat(v)_i$, ma ogni indice di riga è sicuramente $lt.eq hat(v)_max$, quindi $sum_i hat(v)_i lt.eq n hat(v)_max$;
- *colonne*: $n$.

La dimensione è quindi $ "rows" dot "cols" lt.eq n^2 hat(v)_max = n^2 ceil(frac(v_max, theta.alt)) = n^2 ceil(frac(2 n v_max, epsilon v_max)) = O(n^3 / epsilon) . $

La dimensione della tabella risulta quindi polinomiale in $n$ ma anche in $epsilon$. Questa è una enorme differenza rispetto al PTAS della lezione precedente: infatti, il PTAS per $2$-LoadBalancing aveva $epsilon$ in un esponenziale.
