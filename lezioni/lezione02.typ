#import "alias.typ": *

#import "theorems.typ": *
#show: thmrules.with(qed-symbol: $square.filled$)


= Lezione 02 [03/10]

== Upper e lower bound

Fissato $Pi$ un problema, qual è la complessità di $Pi$? Mi interessa la complessità del problema, non del singolo algoritmo che lo risolve: in poche parole, sto chiedendo quale sia la complessità del migliore algoritmo che lo risolve.

Questa è quella che chiamiamo *complessità strutturale*: non guardo i singoli algoritmi ma i problemi nel loro complesso.

Durante questo studio abbiamo due squadre di operai che fanno due lavori:
- *upper bound*: cerchiamo una soluzione per l'algoritmo, e cerchiamo poi di migliorarla continuamente abbassandone la complessità; in poche parole, questa squadra cerca di abbassare sempre di più la soglia indicata con $O(f(n))$ per avere una soluzione sempre migliore;
- *lower bound*: cerchiamo di dimostrare che il problema non si può risolvere in meno di $f(n)$ risorse; in matematichese, indichiamo questo "non faccio meglio" con $Omega(f(n))$ e, al contrario dell'altra squadra, questo valore cerchiamo di alzarlo il più possibile; non dobbiamo esibire un algoritmo, una prova.

Piccolo appunto: dobbiamo stare comunque attenti alle costanti dentro $O$ e $Omega$, quindi prendiamo tutte le complessità un po' con le pinze.

Quando le due complessità coincidono abbiamo chiuso la questione:
- non faccio meglio di $f(n)$,
- non faccio peggio di $f(n)$,
ma allora ci metto esattamente $f(n)$, a meno di costanti, e questa situazione si indica con $Theta(f(n))$.

È molto raro arrivare ad avere una complessità con $Theta$: l'ordinamento di array è $Theta(n log(n))$, ma è uno dei pochi casi, di solito si ha gap abbastanza grande.

Il problema sorge quando l'upper bound è esponenziale e il lower bound è polinomiale, ci troviamo in una zona grigia che potrebbe portarci ad algoritmi molto efficienti o ad algoritmi totalmente inefficienti.

I problemi interessanti sono spesso nella zona grigia, menomale molti sono solo nella "zona polinomiale", purtroppo molti sono solo nella "zona esponenziale".

== Classi di complessità [1]

Viene più comodo creare delle *classi di problemi* e studiarli tutti assieme.

Le due classi più famose sono $P$ e $NP$:
- $P$ è la classe dei problemi di decisione risolvibili in tempo polinomiale; ci chiederemo sempre se un problema $Pi$ sta in $P$, questo perché ci permetterà di scrivere degli algoritmi efficienti per tale problema;
- $NP$ è la classe dei problemi di decisione risolvibili in tempo polinomiale su macchine non deterministiche.

Cosa sono le macchine non deterministiche? Supponiamo di avere un linguaggio speciale, chiamato $N$-python, che ha l'istruzione esotica $ x = ? $ che, quando viene eseguita, sdoppia l'esecuzione del programma, assegnando $x = 0$ nella prima istanza e $x = 1$ nella seconda istanza. Queste due istanze vengono eseguite in parallelo. Questa istruzione può essere però eseguita un numero arbitrario di volte su un numero arbitrario di variabili: questo genera un *albero di computazioni*, nel quale abbiamo delle foglie che contengono uno dei tanti assegnamenti di $0$ e $1$ delle variabili "sdoppiate".

Tutte queste istanze $y_i$ che abbiamo nelle foglie le controlliamo:
- rispondiamo _SI_ se *esiste* un _SI_ tra tutte le $y_i$;
- rispondiamo _NO_ se *tutte* le $y_i$ sono _NO_.

Questa macchina è però impossibile da costruire: posso continuare a forkare il mio programma, ma prima o poi le CPU le finisco per la computazione parallela.

Molti problemi che non sappiamo se stanno in $P$ sappiamo però che sono in $NP$. Il problema più famoso è *CNF-SAT*: l'input è un'espressione logica in forma normale congiunta del tipo $ phi = (x_1 or x_2) and (x_4 or not x_5) and (x_3 or x_1) $ formata da una serie clausole unite da _AND_. Ogni clausola è combinazione di _letterali_ (normali o negati) legati da _OR_.

Data $phi$ formula in CNF, ci chiediamo se sia soddisfacibile, ovvero se esiste un assegnazione che rende $phi$ vera. Un assegnamento è una lista di valori di verità che diamo alle variabili $x_i$ per cercare di rendere vera $phi$.

Questo problema è facilmente "scrivibile" in una macchina non deterministica: per ogni variabile $x_i quad i = 1, dots, n$ eseguo l'istruzione magica $x_i = ?$ che genera così tutti i possibili assegnamenti alle variabili, che sono $2^n$, e poi controllo ogni assegnamento alla fine delle generazioni. Se almeno uno rende vera $phi$ rispondo _SI_. Il tempo è polinomiale: ho rami esponenziali ma ogni ramo deve solo controllare $n$ variabili.

Come siamo messi con CNF-SAT? Non sappiamo se sta in $P$, ma sicuramente sappiamo che sta in $NP$. Tantissimi problemi hanno questa caratteristica.

Ma esiste una relazione tra le classi $P$ e $NP$?

La relazione più ovvia è $P subset.eq NP$: se un problema lo so risolvere senza l'istruzione magica in tempo polinomiale allora creo un programma in $N$-python identico che però non usa l'istruzione magica che viene eseguito in tempo polinomiale.

Quello che non sappiamo è l'implicazione inversa, quindi se $NP subset.eq P$ e quindi se $P = NP$. Questo problema è stato definito da *Cook*, che affermava di "avere portata di mano il problema", e invece.

Abbiamo quindi due situazioni possibili:
- se $P = NP$ è una situazione rassicurante perché so che tutto quello che ho davanti è polinomiale;
- se $P eq.not NP$ è una situazione meno rassicurante perché so che esiste qualcosa di non risolvibile ma non so se il problema che ho sotto mano ha o meno questa proprietà.

Per studiare questa funzione possiamo utilizzare la *riduzione in tempo polinomiale*, una relazione tra problemi di decisione. Diciamo che $Pi_1$ è riducibile in tempo polinomiale a $Pi_2$, e si indica con $ Pi_1 lt.eq_p Pi_2 , $ se e solo se $exists f : I_Pi_1 arrow.long I_Pi_2$ tale che:
- $f$ è calcolabile in tempo polinomiale;
- $sol(Pi_1)(x) = "SI" arrow.long.double.l.r sol(Pi_2)(f(x)) = "SI"$.

Grazie a questa funzione riesco a cambiare, in tempo polinomiale, da $Pi_1$ a $Pi_2$ e, se riesco a risolvere una delle due, allora riesco a risolvere anche l'altra. Il $lt.eq$ indica che il primo problema "non è più difficile" del secondo.

#theorem()[
  Se $Pi_1 lt.eq_p Pi_2$ e $P_2 in P$ allora $P_1 in P$.
]

#theorem("Teorema di Cook")[
  Il problema CNF-SAT è in $NP$ e $ forall Pi in NP quad Pi lt.eq_p italic("CNF-SAT") . $
]

Questo teorema è un risultato enorme: afferma che CNF-SAT è un problema al quale tutti gli altri si possono ridurre in tempo polinomiale. In realtà CNF-SAT non è l'unico problema: l'insieme di problemi che hanno questa proprietà è detto insieme dei problemi $bold(NP)$*-completi*, ed è definito come $ NPC = {Pi in NP bar.v forall Pi' in NP quad Pi' lt.eq_p Pi} . $

Per dimostrare che un problema è $NP$-completo basta far vedere che CNF-SAT si riduce a quel problema, vista la proprietà transitiva della riduzione polinomiale. Se un problema è in $NPC$ lo possiamo definire come "roba probabilmente difficile".

#corollary()[
  Se $Pi in NPC$ e $Pi in P$ allora $P = NP$.
]

Questo corollario ci permette di ridurre la ricerca ai soli problemi in $NPC$.

== Problemi di ottimizzazione

Durante questo corso non vedremo quasi mai problemi di decisione, ma ci occuperemo quasi interamente di *problemi di ottimizzazione*. Questi problemi sono un caso particolare dei problemi.

Dato $Pi$ un problema di ottimizzazione, allora questo è definito da:
- *input*: $I_Pi subset.eq 2^*$;
- *soluzioni ammissibili*: esiste una funzione $ amm(Pi) : I_Pi arrow.long 2^2^* slash {emptyset.rev} $ che mappa ogni input in un insieme di soluzioni ammissibili:
- *obiettivo*: esiste una funzione $ obj(Pi) : 2^* times 2^* arrow.long NN $ tale che $forall x in I_Pi$ e $forall y in amm(Pi)(x)$ la funzione $obj(Pi)(x,y)$ mi dà il costo di quella soluzione; questa funzione è detta *funzione obiettivo*;
- *tipo*: identificatore di $obj(Pi)$, che può essere una funzione di massimizzazione o minimizzazione, ovvero $type(Pi) in {min, max}$.

Vediamo MAX-CNF-SAT, una versione alternativa di CNF-SAT. Questo problema è definito da:
- *input*: formula logiche in forma normale congiunta;
- *soluzioni ammissibili*: data $phi$ formula, in questo insieme $A$ ho tutti i possibili assegnamenti $a_i$ delle variabili di $phi$;
- *obiettivo*: $obj(Pi)(phi, a_i in A)$ deve contare il numero di _clausole_ rese vere dall'assegnamento $a_i$;
- *tipo*: $type(Pi) = max$.

Sicuramente questo problema è non polinomiale: se ce l'avessimo questo mi tirerebbe fuori l'assegnamento massimo, che poi in tempo polinomiale posso buttare dentro CNF-SAT per vedere se $phi$ con tale assegnamento è soddisfacibile, ma questo non è possibile perché CNF-SAT non è risolvibile in tempo polinomiale (_o almeno, abbiamo assunto tale nozione_).

Ad ogni problema di ottimizzazione $Pi$ possiamo associare un problema di decisione $over(Pi,tilde)$ con:
- *input*: $I_(over(Pi,tilde)) = {(x,k) bar.v x in I_Pi and k in NN}$;
- *domanda*: la risposta sull'input $(x,k)$ è
  - _SI_ se e solo se $exists y in amm(Pi)(x)$ tale che:
    - $obj(Pi)(x,y) lt.eq k$ se $type(Pi) = min$;
    - $obj(Pi)(x,y) gt.eq k$ se $type(Pi) = max$;
  - _NO_ altrimenti.

Il valore $k$ fa da bound al valore minimo o massimo che vogliamo accettare.

Vediamo il problema $over("MAX-SAT", tilde)$:
- *inputs*: $I = {(phi, k) bar.v phi "formula CNF" and k in NN}$;
- *domanda*: la risposta a $(phi,k)$ è _SI_ se e solo se esiste un assegnamento che rende vere almeno $k$ clausole di $phi$.

La classe di complessità che contiene i problemi di ottimizzazione $Pi$ risolvibili in tempo polinomiale è la classe $PO$.

#theorem()[
  Se $Pi in PO$ allora il suo problema di decisione associato $over(Pi,tilde) in P$.
]

#corollary()[
  Se $over(Pi,tilde) in NPC$ allora $Pi in.not PO$.
]

Noi useremo spesso problemi che hanno problemi di decisione associati $NPC$. Ci sono dei problemi in $PO$? Certo: i problemi di programmazione lineare sono tutti problemi in $PO$, ma noi ne vedremo almeno un altro di questa classe.

Cosa si fa se, dato un problema di decisione, vediamo che il suo associato è NPC?

Una possibile soluzione sono le *euristiche*, però non sappiamo se funzionano bene o funzionano male, perché magari dipendono molto dall'input.

Una soluzione migliore sono le *funzioni approssimate*: sono funzioni polinomiali che mi danno soluzioni non ottime ma molto vicine all'ottimo rispetto ad un errore che scegliamo arbitrariamente.

Dato $Pi$ problema di ottimizzazione, chiamiamo $opt(Pi)(x)$ il valore ottimo della funzione obiettivo su input $x$. Dato un algoritmo approssimato per $Pi$, ovvero un algoritmo tale che $ x in I_Pi arrow.long.squiggly A arrow.long.squiggly y in amm(Pi)(x) $ mi ritorna una soluzione ammissibile, non per forza ottima, definisco *rapporto di prestazioni* il valore $ rappr(Pi)(x) = max {frac(obj(Pi)(x,y), opt(Pi)(x)), frac(opt(Pi)(x), obj(Pi)(x,y))} . $

Si dice che $A$ è una $alpha$-approssimazione per $Pi$ se e solo se $ forall x in I_Pi bar.v rappr(Pi) lt.eq alpha . $ In poche parole, su ogni input possibile vado male al massimo quanto $alpha$.

È una definizione un po' esotica ma funziona: se la funzione obiettivo è di massimizzazione allora la prima frazione ha $ "num" lt.eq "den" , $ mentre la seconda frazione mi dà sempre un valore $gt.eq 1$, che quindi sarà il valore scelto per $rappr(Pi)$. Nel caso di funzione obiettivo di minimizzazione la situazione è capovolta.

Se $rappr(Pi) = 1$ allora l'algoritmo su quell'input è ottimo e mi dà la soluzione migliore. Se, ad esempio, $rappr(Pi) = 2$, allora ho ottenuto
- un costo doppio dell'ottimo (_minimizzazione_);
- un costo dimezzato dell'ottimo (_massimizzazione_).

Vorremmo sempre avere un algoritmo $1$-approssimante perché siamo all'ottimo, ma se non riusciamo ad avere ciò vorremmo almeno esserci molto vicino.

== Classi di complessità [2]

Quali altri classi esistono in questo zoo della classi di ottimizzazione?

#v(12pt)

#figure(
  image("assets/02_gerarchia.svg", width: 100%),
)

#v(12pt)

In ordine, $PO$ è la più piccola, poi ci sono le classi $gAPX(gamma)$, con $gamma in RR^(gt.eq 1)$, che rappresentano tutte le classi che contengono i problemi con algoritmi $gamma$-approssimati. La classe che li tiene tutti è $ APX = union.big_(alpha gt.eq 1) gAPX(alpha) . $

Una classe ancora più grande è $gAPX(log(n))$: questa classe non usa una costante per definirsi, ma più l'input diventa grande più l'approssimazione diventa peggiore. La classe generale è la classe $gAPX(f(n))$.

Il container più grande di tutti è $NPO$, che contiene anche gli $NPO$-completi, classe trasversale a tutti gli APX.

Rompiamo l'ordine e vediamo infine altre due classi:
- $PTAS$ (_Polynomial Time Approximation Scheme_): classe che contiene gli algoritmi approssimabili a piacere;
- $FPTAS$ (_Fully Polynomial Time Approximation Scheme_): classe che mantiene un tempo polinomiale al ridursi dell'errore, visto che più l'errore è vicino a $1$ e più tempo ci metto.
