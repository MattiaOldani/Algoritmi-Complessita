// Setup

#import "../alias.typ": *

#import "@local/typst-theorems:1.0.0": *
#show: thmrules.with(qed-symbol: $square.filled$)


// Capitolo

= Problemi di ottimizzazione

Durante questo corso non vedremo quasi mai problemi di decisione, ma ci occuperemo quasi interamente di *problemi di ottimizzazione*. Questi problemi sono un caso particolare dei problemi.

Dato $Pi$ un problema di ottimizzazione, allora questo è definito da:
- *input*: $I_Pi subset.eq 2^*$;
- *soluzioni ammissibili*: esiste una funzione $ amm(Pi) : I_Pi arrow.long 2^2^* slash {emptyset.rev} $ che mappa ogni input in un insieme di soluzioni ammissibili:
- *obiettivo*: esiste una funzione $ obj(Pi) : 2^* times 2^* arrow.long NN $ tale che $forall x in I_Pi$ e $forall y in amm(Pi)(x)$ la funzione $obj(Pi)(x,y)$ mi dà il costo di quella soluzione; questa funzione è detta *funzione obiettivo*;
- *tipo*: identificatore di $obj(Pi)$, che può essere una funzione di massimizzazione o minimizzazione, ovvero $type(Pi) in {min, max}$.

#example()[
  Vediamo *MAX CNF-SAT*, una versione alternativa di CNF-SAT. Questo problema è definito da:
  - *input*: formula logica in forma normale congiunta;
  - *soluzioni ammissibili*: data $phi$ formula CNF, in questo insieme $A$ ho tutti i possibili assegnamenti $a_i$ delle variabili di $phi$;
  - *obiettivo*: $obj(Pi)(phi, a_i in A)$ deve contare il numero di _clausole_ rese vere dall'assegnamento $a_i$;
  - *tipo*: $type(Pi) = max$.

  Sicuramente questo problema è non polinomiale: se ce l'avessimo, questo mi darebbe l'assegnamento massimo, che poi in tempo polinomiale posso buttare dentro CNF-SAT per vedere se $phi$ con tale assegnamento è soddisfacibile, ma questo non è possibile perché CNF-SAT non è risolvibile in tempo polinomiale (_o almeno, abbiamo assunto tale nozione_).
]

Ad ogni problema di ottimizzazione $Pi$ possiamo associare un problema di decisione $hat(Pi)$ con:
- *input*: $I_(hat(Pi)) = {(x,k) bar.v x in I_Pi and k in NN}$;
- *domanda*: la risposta sull'input $(x,k)$ è
  - _SI_ se e solo se $exists y in amm(Pi)(x)$ tale che:
    - $obj(Pi)(x,y) lt.eq k$ se $type(Pi) = min$;
    - $obj(Pi)(x,y) gt.eq k$ se $type(Pi) = max$;
  - _NO_ altrimenti.

Il valore $k$ fa da bound al valore minimo o massimo che vogliamo accettare.

#example()[
  Vediamo il problema $hat("MAX-CNF-SAT")$:
  - *input*: $I = {(phi, k) bar.v phi "formula CNF" and k in NN}$;
  - *domanda*: la risposta a $(phi,k)$ è _SI_ se e solo se esiste un assegnamento che rende vere almeno $k$ clausole di $phi$.
]

La classe di complessità che contiene i problemi di ottimizzazione $Pi$ risolvibili in tempo polinomiale è la classe $PO$.

#theorem()[
  Se $Pi in PO$ allora il suo problema di decisione associato $hat(Pi) in P$.
]

#corollary()[
  Se $hat(Pi) in NPC$ allora $Pi in.not PO$.
]

Noi useremo spesso problemi che hanno problemi di decisione associati $NPC$. Ci sono dei problemi in $PO$? Certo: i problemi di programmazione lineare sono tutti problemi in $PO$.

Cosa si fa se, dato un problema di ottimizzazione, vediamo che il suo associato è NPC?

Una possibile soluzione sono le *euristiche*, però non sappiamo se funzionano bene o funzionano male, perché dipendono molto dall'input.

Una soluzione migliore sono le *funzioni approssimate*: sono funzioni polinomiali che mi danno soluzioni non ottime ma molto vicine all'ottimo rispetto ad un errore che scegliamo arbitrariamente.

Dato $Pi$ problema di ottimizzazione, chiamiamo $opt(Pi)(x)$ il valore ottimo della funzione obiettivo su input $x$. Dato un algoritmo approssimato per $Pi$, ovvero un algoritmo tale che $ x in I_Pi arrow.long.squiggly A arrow.long.squiggly y in amm(Pi)(x) $ mi ritorna una soluzione ammissibile, non per forza ottima, definisco *rapporto di prestazioni* il valore $ rappr(Pi)(x) = max {frac(obj(Pi)(x,y), opt(Pi)(x)), frac(opt(Pi)(x), obj(Pi)(x,y))} . $

Si dice che $A$ è una $alpha$-approssimazione per $Pi$ se e solo se $ forall x in I_Pi bar.v rappr(Pi) lt.eq alpha . $ In poche parole, su ogni input possibile vado male al massimo quanto $alpha$.

È una definizione un po' contorta ma funziona: se la funzione obiettivo è di massimizzazione allora la prima frazione ha $ "num" lt.eq "den" , $ mentre la seconda frazione mi dà sempre un valore $gt.eq 1$, che quindi sarà il valore scelto per $rappr(Pi)$. Nel caso di funzione obiettivo di minimizzazione la situazione è capovolta.

#example()[
  Se $rappr(Pi) = 1$ allora l'algoritmo su quell'input è ottimo e mi dà la soluzione migliore. Se, ad esempio, $rappr(Pi) = 2$, allora ho ottenuto
  - un costo doppio dell'ottimo (_minimizzazione_);
  - un costo dimezzato dell'ottimo (_massimizzazione_).
]

Vorremmo sempre avere un algoritmo $1$-approssimante perché siamo all'ottimo, ma se non riusciamo ad avere ciò vorremmo almeno esserci molto vicino.

== Classi di complessità

Quali altri classi esistono in questo zoo della classi di ottimizzazione?

#v(12pt)

#figure(image("assets/04_gerarchia.svg", width: 100%))

#v(12pt)

In ordine, $PO$ è la più piccola, poi ci sono le classi $gAPX(gamma)$, con $gamma in RR^(gt.eq 1)$, che rappresentano tutte le classi che contengono i problemi con algoritmi $gamma$-approssimati. La classe che li tiene tutti è $ APX = union.big_(alpha gt.eq 1) gAPX(alpha) . $

Una classe ancora più grande è $gAPX(log(n))$: questa classe non usa una costante per definirsi, ma più l'input diventa grande più l'approssimazione diventa peggiore. La classe generale è la classe $gAPX(f(n))$, i cui algoritmi dipendono dalla funzione $f(n)$.

Il container più grande di tutti è $NPO$, che contiene anche gli $NPO$-completi, classe trasversale a tutti gli APX. La definizione di questa classe è abbastanza complicata.

Rompiamo l'ordine e vediamo infine altre due classi:
- $PTAS$ (_Polynomial Time Approximation Scheme_): classe che contiene gli algoritmi approssimabili a piacere, ma che non sono totalmente polinomiali;
- $FPTAS$ (_Fully Polynomial Time Approximation Scheme_): classe che mantiene un tempo polinomiale al ridursi dell'errore, visto che più l'errore è vicino a $1$ e più tempo ci metto.
