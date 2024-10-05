#import "alias.typ": *


= Lezione 01 [26/09]

== Notazione

=== Insiemi numerici

Useremo i principali *insiemi numerici* come $NN, ZZ, QQ, RR$ e, ogni tanto, le loro versioni con soli elementi positivi $NN^+, ZZ^+, QQ^+, RR^+$.

=== Monoide libero

Un *magma* è una struttura algebrica $(A, dot)$ formata da un insieme e un'operazione. Se essa è:
- dotata di $dot$ *associativa* allora è detta *semigruppo*;
- dotata di un elemento $overline(e) in A$ tale che $ forall x in A quad x dot e = e dot x = x $ allora è detta *monoide*; l'elemento $overline(e)$ è chiamato *elemento neutro* e in un monoide esso è unico; alcuni monoidi importanti sono $(NN, +)$ oppure $(NN, *)$
- dotata di $dot$ *commutativa* allora si aggiunge *abeliano* alla sua definizione

Un *monoide libero* è un monoide i cui elementi sono generati da una base. Vediamo un importante monoide libero che useremo spesso durante il corso.

Partiamo da un *alfabeto* $Sigma$, ovvero un insieme finito non vuoto di lettere/simboli. Definiamo $Sigma^*$ come l'insieme di tutte le sequenze di lettere dell'alfabeto $Sigma$; queste sequenze sono dette parole/stringhe e una generica parola è $w in Sigma^*$ nella forma $w = w_0 dots w_(n-1) bar.v n gt.eq 0 and w_i in Sigma$. Usiamo $n gt.eq 0$ perché esiste anche la *parola vuota* $epsilon$. L'insieme $Sigma^*$ è numerabile.

Data una parola $w in Sigma^*$ indichiamo con $abs(w)$ il numero di simboli di $w$. La parola vuota è tale che $abs(epsilon) = 0$.

Un'operazione che possiamo definire sulle parole è la *concatenazione*: l'operazione è $ dot : Sigma^* times Sigma^* arrow.long Sigma^* $ ed è tale che, date $ x = x_0 dots x_(n-1) quad y = y_0 dots y_(m-1) bar.v x,y in Sigma^* $ posso calcolare $z = x dot y$ come $ z = x_0 dots x_(n-1) y_0 dots y_(m-1) . $

Dato il magma $(Sigma^*, dot)$, esso è:
- semigruppo perché $dot$ associativa;
- non abeliano perché $dot$ non commutativa (lo sarebbe se $Sigma = {x}$);
- dotato di neutro $e = epsilon$.

Ma allora $(Sigma^* dot)$ è un monoide. Esso è anche un monoide libero su $Sigma$.

=== Funzioni

Chiamiamo $ B^A = {f bar.v f : A arrow.long B} $ l'insieme di tutte funzioni da $A$ in $B$; usiamo questa notazione perché la cardinalità di questo insieme, se $A$ e $B$ sono finiti, ha cardinalità $abs(B)^(abs(A))$.

Spesso useremo un numero $K$ come "insieme": questo va inteso come l'insieme formato da $K$ termini, ovvero l'insieme ${0, 1, dots, k-1}$. Ad esempio, $0 = emptyset.rev$, $1 = {0}$, $2 = {0,1}$, eccetera.

Date queste due definizioni, vediamo qualche insieme particolare.

Indichiamo con $2^A$ l'insieme $ {f bar.v f : A arrow.long {0,1}} , $ ovvero l'insieme delle funzioni che classificano gli elementi di un $A$ in un dato sottoinsieme di $A$, cioè ogni funzione determina un certo sottoinsieme. Possiamo quindi dire che $ 2^A tilde.eq {X bar.v X "sottoinsieme di" A} . $ Questo insieme si chiama anche *insieme delle parti*, si indica con $cal(P)(A)$ e ha cardinalità $2^abs(A)$ se $A$ è finito.

Indichiamo con $A^2$ l'insieme $ {f bar.v f : {0,1} arrow.long A} $ l'insieme che rappresenta il *prodotto cartesiano*: infatti, $ A^2 tilde.eq A times A . $

Indichiamo con $2^*$ l'insieme delle stringhe binarie, ma allora l'insieme $2^2^*$ è la famiglia di tutti i linguaggi binari, ad esempio $emptyset.rev$, $2^*$, ${epsilon, 0, 00, 000, dots}$, eccetera.

== Algoritmi 101

In questo corso vedremo una serie di algoritmi che useremo per risolvere dei problemi, ma cos'è un problema?

Un problema $Pi$ è formato da:
- un insieme di input possibili $I_Pi subset.eq 2^*$;
- un insieme di output possibili $O_Pi subset.eq 2^*$;
- una funzione $sol(Pi) : I_Pi arrow.long 2^(O_Pi) slash {emptyset.rev}$; usiamo l'insieme delle parti come codominio perché potrei avere più risposte corrette per lo stesso problema.

Se in un problema mi viene chiesto di "decidere qualcosa", siamo davanti ad un *problema di decisione*: questi problemi sono particolari perché hanno $O_Pi = {0,1}$ e hanno *una sola risposta possibile*, vero o falso, cioè non posso avere un sottoinsieme di risposte possibili.

/**********
Se mi viene chiesto l'MCD tra due interi positivi $x,y$ come faccio a separarli? Raddoppio i bit e non ho mai $01$ o $10$, quindi li uso come separatore. Posso anche usare Elias $gamma$: scrivo il numero in binario in $l$ cifre, prima di lui scrivo $l$ in unario, cioè tanti uni quanto $l$ e uno zero.
**********/

Un algoritmo per Boldi è una *Macchina di Turing*. Sappiamo già come è fatta, ovvero:
- nastro bidirezionale infinito con input e blank:
- testina di lettura/scrittura two-way;
- controllo a stati finiti;
- programma/tabella che permette l'evoluzione della computazione.

Perché usiamo una MdT quando abbiamo a disposizione una macchina a registri (RAM, WHILE, lambda-calcolo)?

La *tesi di Church-Turing* afferma un risultato molto importante che però possiamo dare in più "salse":
- tutte le macchine create e che saranno create sono equivalenti, ovvero quello che fai con una macchina lo fai anche con l'altra;
- nessuna definizione di algoritmo può essere diversa da una macchina di Turing;
- la famiglia dei problemi di decisione che si possono risolvere è uguale per tutte le macchine;
- i linguaggi di programmazione sono Turing-completi, ovvero se ipotizziamo una memoria infinita allora è come avere una MdT.

Anche un computer quantistico è una MdT, come calcolo almeno, perché in tempo si ha la quantum supremacy.

Un *algoritmo* $A$ per $Pi$ è una MdT tale che $ x in I_Pi arrow.long.squiggly #rect[A] arrow.long.squiggly y in O_Pi $ tale che $y in sol(Pi)(x)$, ovvero quello che mi restituisce l'algoritmo è sempre la risposta corretta.

Ma tutti i problemi sono risolvibili? No, grazie Mereghetti.

Questo lo vediamo con le cardinalità:
- i problemi di decisione sono i problemi dell'insieme $2^2^*$, ovvero data una stringa binaria (il nostro input) devo dire se essa sta o meno nell'insieme; questo insieme è tale che $ abs(2^2^*) approx.eq abs(2^NN) approx.eq abs(RR) ; $
- i programmi non sono così tanti: visto che i programmi sono stringhe, e visto che $Sigma^*$ è numerabile, le stringhe su un linguaggio sono tali che $2^* tilde NN$.

Si dimostra che $NN tilde.not RR$, quindi sicuramente esistono dei problemi che non sono risolvibili.

Una volta che abbiamo ristretto il nostro studio ai solo problemi risolvibili (noi considereremo solo quelli) possiamo chiederci quanto efficientemente lo riusciamo a fare: questa branca di studio è detta *teoria della complessità*.

In questo ambito vogliamo vedere quante risorse spendiamo durante l'esecuzione dell'algoritmo o del programma.

Abbiamo in realtà due diverse teorie della complessità: algoritmica e strutturale.

La *teoria della complessità algoritmica* ci chiede di:
- stabilire se un problema $Pi$ è risolubile;
- se sì, con che costo rispetto a qualche risorsa.

Le risorse che possiamo studiare sono:
- tempo come numero di passi o tempo cronometrato;
- spazio;
- numero di CPU nel punto di carico massimo;
- somma dei tempi delle CPU;
- energia dissipata.

Noi useremo quasi sempre il *tempo*. Definiamo $ T_A : I_Pi arrow.long NN $ funzione che ci dice, per ogni input, quanto ci mette l'algoritmo $A$ a terminare su quell'input.

Questo approccio però non è molto comodo. Andiamo a raccogliere per lunghezza e definiamo $ t_A : NN arrow.long NN $ tale che $ t_A (n) = max{T_A (x) bar.v x in I_Pi and abs(x) = n} $ che va ad applicare quella che è la filosofia *worst case*. In poche parole, andiamo a raccogliere gli input con la stessa lunghezza e prendiamo, per ciascuna categoria, il numero di passi massimo che è stato rilevato. Anche questa soluzione però non è bellissima: è una soluzione del tipo "STA ANDANDO TUTTO MALEEEEE" (grande cit.).

Abbiamo altre soluzioni? Sì, ma non sono il massimo:
- la soluzione *best case* è troppo sbilanciata verso il "sta andando tutto bene";
- la soluzione *average case* è complicata perché serve una distribuzione di probabilità.

A questo punto teniamo l'approccio worst case perché rispetto agli altri due non va a rendere complicati i conti. Inoltre, prendere il massimo ci dà la certezza di non fare peggio di quel valore.

Useremo inoltre la *complessità asintotica*, ovvero per $n$ molto grandi vogliamo vedere il comportamento dei vari algoritmi, perché "con i dati piccoli sono bravi tutti".

Il simbolo per eccellenza è l'$O$-grande: se un algoritmo ha complessità $O(f(n))$ vuol dire che $f(n)$ domina il tempo $t_A$ del nostro algoritmo.
