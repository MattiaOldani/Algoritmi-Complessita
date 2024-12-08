// Setup

#import "../alias.typ": *

#import "@local/typst-theorems:1.0.0": *
#show: thmrules.with(qed-symbol: $square.filled$)


// Capitolo

= Problemi di decisione

Se in un problema mi viene chiesto di _"decidere qualcosa"_, siamo davanti ad un *problema di decisione*: questi sono particolari perché hanno $O_Pi = {0,1}$ e hanno *una sola risposta possibile*, vero o falso. Non posso ciò avere un sottoinsieme di risposte possibili, ma una _"risposta secca"_.

== Classi di complessità

Non possiamo studiare ogni problema singolarmente, quindi creiamo delle *classi di problemi* e andiamo a studiarli tutti assieme.

Le due classi più famose sono $P$ e $NP$:
- $P$ è la *classe dei problemi di decisione risolvibili in tempo polinomiale*; ci chiederemo sempre se un problema $Pi$ sta in $P$, questo perché ci permetterà di scrivere degli algoritmi efficienti per tale problema;
- $NP$ è la *classe dei problemi di decisione risolvibili in tempo polinomiale su macchine non deterministiche*.

Cosa sono le *macchine non deterministiche*? Supponiamo di avere un linguaggio speciale, chiamato $N$-python, dotato di una istruzione pazza $ x = ? $ che, quando viene eseguita, sdoppia l'esecuzione del programma, assegnando $x = 0$ nella prima istanza e $x = 1$ nella seconda istanza. Queste due istanze vengono eseguite in parallelo. Questa istruzione può essere però eseguita un numero arbitrario di volte su un numero arbitrario di variabili: questo genera un *albero di computazioni*, nel quale abbiamo delle foglie che contengono uno dei tanti assegnamenti di $0$ e $1$ delle variabili _"sdoppiate"_.

Tutte queste istanze $y_i$ che abbiamo nelle foglie le controlliamo:
- rispondiamo _SI_ se *esiste* un _SI_ tra tutte le $y_i$;
- rispondiamo _NO_ se *tutte* le $y_i$ sono _NO_.

Questa macchina è però impossibile da costruire: posso continuare a forkare il mio programma, ma prima o poi le CPU le finisco per la computazione parallela.

Molti problemi che non sappiamo se stanno in $P$ sappiamo però che sono in $NP$. Il problema più famoso è *CNF-SAT*: l'input è un'espressione logica in forma normale congiunta del tipo $ phi = (x_1 or x_2) and (x_4 or not x_5) and (x_3 or x_1) , $ formata da una serie clausole unite da _AND_. Ogni clausola è combinazione di _letterali_ (normali o negati) legati da _OR_. Data $phi$ formula in CNF, ci chiediamo se sia *soddisfacibile*, ovvero se esiste un assegnamento che rende $phi$ vera. Un *assegnamento* è una lista di valori di verità che diamo alle variabili $x_i$ per cercare di rendere vera $phi$.

Questo problema è facilmente _"scrivibile"_ in una macchina non deterministica: per ogni variabile $x_i bar.v i = 1, dots, n$ eseguo l'istruzione magica $x_i = ?$ che genera così tutti i possibili assegnamenti alle variabili, che sono $2^n$, e poi controllo ogni assegnamento alla fine delle generazioni. Se almeno uno rende vera $phi$ rispondo _SI_. Il tempo è polinomiale: ho rami esponenziali ma ogni ramo deve solo controllare $n$ variabili.

Come siamo messi con CNF-SAT? Non sappiamo se sta in $P$, ma sicuramente sappiamo che sta in $NP$. Tantissimi problemi hanno questa caratteristica. Ma esiste una relazione tra le classi $P$ e $NP$?

La relazione più ovvia è $P subset.eq NP$: se un problema lo so risolvere senza l'istruzione magica in tempo polinomiale allora creo un programma in $N$-python identico che però non usa l'istruzione magica che viene eseguito in tempo polinomiale.

Quello che non sappiamo è l'implicazione inversa, ovvero se $NP subset.eq P$ e quindi se $P = NP$. Questo problema è stato definito da *Cook*, che affermava di _"avere a portata di mano il problema"_, e invece...

Abbiamo quindi due situazioni possibili:
- se $P = NP$ è una situazione rassicurante perché so che tutto quello che ho davanti è polinomiale;
- se $P eq.not NP$ è una situazione meno rassicurante perché so che esiste qualcosa di non risolvibile ma non so se il problema che ho sotto mano ha o meno questa proprietà.

Per studiare questa funzione possiamo utilizzare la *riduzione in tempo polinomiale*, una relazione tra problemi di decisione. Diciamo che $Pi_1$ è *riducibile in tempo polinomiale* a $Pi_2$, e si indica con $ Pi_1 lt.eq_p Pi_2 , $ se e solo se $exists f : I_Pi_1 arrow.long I_Pi_2$ tale che:
- $f$ è calcolabile in tempo polinomiale;
- $sol(Pi_1)(x) = "SI" arrow.long.double.l.r sol(Pi_2)(f(x)) = "SI"$.

Grazie a questa funzione riesco a cambiare, in tempo polinomiale, da $Pi_1$ a $Pi_2$ e, se riesco a risolvere una delle due, allora riesco a risolvere anche l'altra. Il $lt.eq$ indica che il primo problema "non è più difficile" del secondo.

#theorem()[
  Se $Pi_1 lt.eq_p Pi_2$ e $P_2 in P$ allora $P_1 in P$.
]

#theorem([Teorema di Cook])[
  Il problema CNF-SAT è in $NP$ e $ forall Pi in NP quad Pi lt.eq_p italic("CNF-SAT") . $
]

Questo teorema è un risultato enorme: afferma che CNF-SAT è un problema al quale tutti gli altri si possono ridurre in tempo polinomiale. In realtà CNF-SAT non è l'unico problema: l'insieme di problemi che hanno questa proprietà è detto insieme dei problemi *NP-completi*, ed è definito come $ NPC = {Pi in NP bar.v forall Pi' in NP quad Pi' lt.eq_p Pi} . $

Per dimostrare che un problema è $NP$-completo basta far vedere che CNF-SAT si riduce a quel problema, vista la proprietà transitiva della riduzione polinomiale. Se un problema è in $NPC$ lo possiamo definire come _"roba probabilmente difficile"_.

#corollary()[
  Se $Pi in NPC$ e $Pi in P$ allora $P = NP$.
]

Questo corollario ci permette di ridurre la ricerca della risposta di $P = NP$ ai soli problemi in $NPC$.
