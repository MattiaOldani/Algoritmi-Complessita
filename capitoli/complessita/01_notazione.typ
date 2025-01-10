// Setup

#import "@local/typst-theorems:1.0.0": *
#show: thmrules.with(qed-symbol: $square.filled$)


// Lezione

= Notazione

Useremo i principali *insiemi numerici* come $NN, ZZ, QQ, RR$ e, ogni tanto, le loro versioni con soli elementi positivi $NN^+, ZZ^+, QQ^+, RR^+$.

Un *magma* è una struttura algebrica $(A, plus.circle)$ formata da un insieme e un'operazione. Se essa è:
- dotata di $plus.circle$ *associativa* allora è detta *semigruppo*;
- dotata di un elemento $overline(e) in A$ tale che $ forall x in A quad x plus.circle e = e plus.circle x = x $ allora è detta *monoide*; l'elemento $overline(e)$ è chiamato *elemento neutro* e in un monoide esso è unico; alcuni monoidi importanti sono $(NN, +)$ oppure $(NN, dot)$;
- dotata di $plus.circle$ *commutativa* allora si aggiunge *abeliano* alla sua definizione.

Un *monoide libero* è un monoide i cui elementi sono generati da una base. Vediamo un importante monoide libero che useremo spesso durante il corso.

Partiamo da un *alfabeto* $Sigma$, ovvero un insieme finito non vuoto di *lettere/simboli*. Definiamo $Sigma^*$ come l'insieme di tutte le sequenze di lettere dell'alfabeto $Sigma$; queste sequenze sono dette *parole/stringhe* e una generica parola è $w in Sigma^*$ nella forma $ w = w_0 dots w_(n-1) bar.v n gt.eq 0 and w_i in Sigma . $ Usiamo $n gt.eq 0$ perché esiste anche la *parola vuota* $epsilon$. L'insieme $Sigma^*$ è *numerabile*.

Data una parola $w in Sigma^*$ indichiamo con $abs(w)$ il *numero di simboli* di $w$. La parola vuota è tale che $abs(epsilon) = 0$, ed è l'unica con questa proprietà.

Un'operazione che possiamo definire sulle parole è la *concatenazione*: l'operazione è $ dot : Sigma^* times Sigma^* arrow.long Sigma^* $ ed è tale che, date $ x = x_0 dots x_(n-1) quad y = y_0 dots y_(m-1) bar.v x,y in Sigma^*, $ posso calcolare $z = x dot y$ come $ z = x_0 dots x_(n-1) y_0 dots y_(m-1) . $

Dato il magma $(Sigma^*, dot)$, esso è:
- *semigruppo* perché $dot$ associativa;
- *non abeliano* perché $dot$ non commutativa (_lo sarebbe se_ $Sigma = {x}$);
- dotato di *neutro* $e = epsilon$.

Ma allora $(Sigma^* dot)$ è un monoide. Esso è anche un *monoide libero* su $Sigma$.

Cambiamo argomento. Chiamiamo $ B^A = {f bar.v f : A arrow.long B} $ l'insieme di tutte funzioni da $A$ in $B$; usiamo questa notazione perché la *cardinalità* di questo insieme, se $A$ e $B$ sono finiti, è esattamente $abs(B)^(abs(A))$.

Spesso useremo un numero $K$ come _"insieme"_: questo va inteso come l'insieme formato da $K$ termini, ovvero l'insieme ${0, 1, dots, k-1}$. Ad esempio, $ 0 = emptyset.rev quad bar.v quad 1 = {0} quad bar.v quad 2 = {0,1} quad bar.v quad dots $

Date queste due definizioni, vediamo qualche insieme particolare.

#example()[
  Indichiamo con $2^A$ l'insieme $ {f bar.v f : A arrow.long {0,1}} , $ ovvero l'insieme delle funzioni che classificano gli elementi di $A$ in un dato sottoinsieme di $A$, cioè ogni funzione determina un certo sottoinsieme. Possiamo quindi dire che $ 2^A tilde.eq {X bar.v X "sottoinsieme di" A} . $ Questo insieme si chiama anche *insieme delle parti*, si indica con $cal(P)(A)$ e ha cardinalità $2^abs(A)$, se $A$ è finito.
]

#example()[
  Indichiamo con $A^2$ l'insieme $ {f bar.v f : {0,1} arrow.long A} $ l'insieme che rappresenta il *prodotto cartesiano*: infatti, $ A^2 tilde.eq A times A . $
]

#example()[
  Indichiamo con $2^*$ l'insieme delle stringhe binarie, ma allora l'insieme $2^2^*$ è la famiglia di tutti i linguaggi binari, ad esempio $emptyset.rev$, $2^*$, ${epsilon, 0, 00, 000, dots}$, eccetera.
]
