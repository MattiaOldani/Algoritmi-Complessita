// Setup

#import "../alias.typ": *

#import "@local/typst-theorems:1.0.0": *
#show: thmrules.with(qed-symbol: $square.filled$)


// Capitolo

= Algoritmi 101

== Definizioni

In questo corso vedremo una serie di algoritmi che useremo per risolvere dei problemi, ma cos'è un problema?

Un *problema* $Pi$ è formato da:
- un insieme di input possibili $I_Pi subset.eq 2^*$;
- un insieme di output possibili $O_Pi subset.eq 2^*$;
- una funzione $ sol(Pi) : I_Pi arrow.long 2^(O_Pi) slash {emptyset.rev} . $ Usiamo l'insieme delle parti come codominio perché potrei avere più risposte corrette per lo stesso problema.

Un *algoritmo* lo possiamo identificare in una *Macchina di Turing*. Sappiamo già come è fatta, l'abbiamo vista tante volte, ovvero contiene:
- un *nastro* bidirezionale infinito con input e blank:
- una *testina* di lettura/scrittura two-way;
- un *controllo a stati finiti*;
- un *programma/tabella* che permette l'evoluzione della computazione.

Perché usiamo una MdT quando abbiamo a disposizione una macchina a registri, ad esempio una macchina RAM, WHILE o lambda-calcolo?

La *tesi di Church-Turing* afferma un risultato molto importante che possiamo dare in più _"salse"_:
- tutte le macchine create e che saranno create sono equivalenti, ovvero quello che fai con una macchina lo fai anche con l'altra;
- nessuna definizione di algoritmo può essere diversa da una macchina di Turing;
- la famiglia dei problemi di decisione che si possono risolvere è uguale per tutte le macchine;
- i linguaggi di programmazione sono Turing-completi, ovvero se ipotizziamo una memoria infinita allora è come avere una MdT.

Anche un computer quantistico è una MdT, come calcolo almeno, perché in tempo si ha la quantum supremacy.

Un *algoritmo* $A$ per $Pi$ è una MdT tale che $ x in I_Pi arrow.long.squiggly #rect[A] arrow.long.squiggly y in O_Pi $ tale che $y in sol(Pi)(x)$, ovvero quello che mi restituisce l'algoritmo è sempre la risposta corretta.

Ma tutti i problemi sono risolvibili? La risposta è no, e lo possiamo vedere con le cardinalità:
- i problemi di decisione sono i problemi dell'insieme $2^2^*$, ovvero data una stringa binaria devo dire se essa sta o meno nell'insieme delle istanze positive del problema di decisione; questo insieme è tale che $ abs(2^2^*) approx.eq abs(2^NN) approx.eq abs(RR) ; $
- i programmi non sono così tanti: visto che i programmi sono stringhe, e visto che $Sigma^*$ è numerabile, le stringhe su un linguaggio sono tali che $2^* tilde NN$.

Si dimostra che $NN tilde.not RR$, quindi sicuramente esistono dei problemi che non sono risolvibili.

== Teoria della complessità

Una volta ristretto lo studio ai solo problemi risolvibili possiamo chiederci quanto efficientemente lo riusciamo a fare: questa branca di studio è detta *teoria della complessità*.

In questo ambito vogliamo vedere quante risorse spendiamo durante l'esecuzione dell'algoritmo o del programma. Abbiamo in realtà due diverse teorie della complessità: algoritmica e strutturale.

La *teoria della complessità algoritmica* ci chiede di:
- stabilire se un problema $Pi$ è risolubile;
- se sì, con che costo rispetto a qualche risorsa.

Le risorse che possiamo studiare sono:
- tempo, come numero di passi o tempo cronometrato;
- spazio;
- numero di CPU nel punto di carico massimo;
- somma dei tempi delle CPU;
- energia dissipata.

Noi useremo quasi sempre il *tempo*. Definiamo $ T_A : I_Pi arrow.long NN $ funzione che ci dice, per ogni input, quanto ci mette l'algoritmo $A$ a terminare su quell'input.

Questo approccio però non è molto comodo. Andiamo a raccogliere per lunghezza e definiamo $ t_A : NN arrow.long NN $ la funzione $ t_A (n) = max{T_A (x) bar.v x in I_Pi and abs(x) = n} $ che va ad applicare quella che è la filosofia *worst case*. In poche parole, andiamo a raccogliere gli input con la stessa lunghezza e prendiamo, per ciascuna categoria, il numero di passi massimo che è stato rilevato. Anche questa soluzione però non è bellissima: è una soluzione del tipo _"STA ANDANDO TUTTO MALEEEEE"_.

Abbiamo altre soluzioni? Sì, ma anche loro non sono il massimo:
- la soluzione *best case* è troppo sbilanciata verso il _"sta andando tutto bene"_;
- la soluzione *average case* è complicata perché serve una distribuzione di probabilità.

A questo punto teniamo l'approccio worst case perché rispetto agli altri due non va a rendere complicati i conti. Inoltre, prendere il massimo ci dà la certezza di non fare peggio di quel valore.

La *teoria della complessità strutturale* invece, fissato $Pi$ un problema, si chiede quale sia la complessità di $Pi$. La differenza sembra minima con la complessità algoritmica, ma è abissale: mi interessa la complessità del problema, non del singolo algoritmo che lo risolve. Sto chiedendo quale sia la complessità del migliore algoritmo che lo risolve.

Per entrambe le complessità ci serviremo della *complessità asintotica*, ovvero per $n$ molto grandi vogliamo vedere il comportamento dei vari algoritmi, perché _"con i dati piccoli sono bravi tutti"_.

Il simbolo per eccellenza che useremo è l'$O$-grande: se un algoritmo ha complessità $O(f(n))$ vuol dire che $f(n)$ domina il tempo $t_A$ del nostro algoritmo in esame. Piccolo appunto: dobbiamo stare comunque attenti alle costanti dentro $O$ e $Omega$, quindi prendiamo tutte le complessità con le pinze.

Torniamo alle due teorie. Durante lo studio di queste ultime abbiamo due squadre di operai che fanno due lavori:
- *upper bound*: cerchiamo una soluzione per l'algoritmo, e cerchiamo poi di migliorarla continuamente abbassandone la complessità; in poche parole, questa squadra cerca di abbassare sempre di più la soglia indicata con $O(f(n))$ per avere una soluzione sempre migliore;
- *lower bound*: cerchiamo di dimostrare che il problema non si può risolvere in meno di $f(n)$ risorse; indichiamo questo _"non faccio meglio"_ con $Omega(f(n))$ e, al contrario dell'altra squadra, questo valore cerchiamo di alzarlo il più possibile; non dobbiamo esibire un algoritmo, bensì una prova.

Quando le due complessità coincidono abbiamo chiuso la questione:
- non faccio meglio di $f(n)$,
- non faccio peggio di $f(n)$,
ma allora ci metto esattamente $f(n)$, a meno di costanti, e questa situazione si indica con $Theta(f(n))$.

È molto raro arrivare ad avere una complessità con $Theta$: l'ordinamento di array è $Theta(n log(n))$, ma è uno dei pochi casi, di solito si ha gap abbastanza grande.

Il problema sorge quando l'upper bound è esponenziale e il lower bound è polinomiale: ci troviamo in una *zona grigia* che potrebbe portarci ad algoritmi molto efficienti o ad algoritmi totalmente inefficienti. I problemi interessanti sono spesso e volentieri nella zona grigia.
