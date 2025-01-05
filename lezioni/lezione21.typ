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


= Lezione 21 [19/12]

== Alberi binari

La parola *albero* è molto *overloaded*, ovvero viene usata per esprimere tanti concetti diversi che però hanno delle differenze.

In *teoria dei grafi* un albero è _un grafo non orientato aciclico connesso_. Se cade la richiesta di connessione siamo di fronte ad una *foresta*.

Nell'*informatica classica* un albero è uguale a quello della teoria dei grafi ma, una volta scelto un nodo come radice, l'intero albero viene _"appeso per gravità"_ a questa raidce. In teoria dei grafi questi si chiamerebbero *alberi radicati*.

Possiamo distinguere gli alberi in base ad alcuni fattori:
- *numero di figli*:
  - un albero si dice *generico* se ogni nodo ha un numero arbitrario di figli;
  - un albero si dice $n$-ario se ogni nodo ha $n$ oppure $0$ nodi;
- *ordinamento*:
  - un albero si dice *ordinato* se, per ogni nodo $v$ dell'albero, i nodi nel sotto-albero sinistro sono $<$ di $v$ e i nodi del sotto-albero destro sono $>$ di $v$;
  - un albero si dice *non ordinato* se è tutto a caso.

Un albero generico di solito è anche ordinato, perché è molto più facile da salvare e rappresentare.

Un *albero binario* è un albero $2$-ario. I nodi dell'albero si chiamano *nodi* e sono di due tipi:
- i nodi che hanno figli sono detti *nodi interni*;
- i nodi che non hanno figli sono detti *foglie* o *nodi esterni*.

Se vogliamo considerare anche alberi che hanno nodi con un figlio andiamo ad aggiungere delle _foglie fittizie_ per completare l'albero.

Sia $T$ un albero. Indichiamo con:
- $E(T)$ il numero di nodi esterni dell'albero;
- $I(T)$ il numero di nodi interni dell'albero.

#theorem()[
  Per ogni albero binario $T$ vale $ E(T) = I(T) + 1. $
]

#proof()[
  Dimostriamo questo teorema per induzione strutturale.

  *Caso base*: albero binario banale $T$.

  L'albero $T$ è formato dalla sola radice. Esso ha $ E(T) = 1 bar.v I(T) = 0 , $ ma allora $1 = 0 + 1$, quindi la relazione è verificata.

  *Passo ricorsivo*: albero binario $T$ formato dalla radice $R$ e due sotto-alberi $T_1$ (_sx_) e $T_2$ (_dx_).

  Guardiamo l'albero $T$: esso è formato dai due *alberoni* $T_1$ e $T_2$, quindi $ E(T) = E(T_1) + E(T_2) bar.v I(T) = I(T_1) + I(T_2) + 1 . $

  Per ipotesi induttiva valgono $ E(T_1) = I(T_1) + 1 and E(T_2) = I(T_2) + 1 . $ Ma allora $ E(T) = E(T_1) + E(T_2) = I(T_1) + I(T_2) + 1 + 1 = I(T) + 1 . qedhere $
]

Il *numero totale di nodi* è $2n + 1$.

#theorem()[
  Ci sono $ C_n = frac(1, n+1) binom(2n,n) $ alberi binari con $n$ nodi interni.
]

Il numero $C_n$ è detto $n$-esimo *numero di Catalano*. Quanto vale $C_n$? Lo possiamo approssimare?

Usiamo l'*approssimazione di Stirling*: essa afferma che $ n! tilde sqrt(2 pi n) (frac(n,e))^x . $

Grazie a questa approssimiamo $C_n$ con $ C_n &= frac(1,n+1) binom(2n,n) = \ &= frac(1,n+1) frac((2n)!, n! (2n-n)!) = \ &= frac(1,n+1) frac((2n)!, (n!)^2) tilde \ &tilde frac(1,n+1) frac(sqrt(4 pi n) (frac(2n,e))^(2n), (sqrt(2 pi n) (n/e)^n)^2) = \ &= frac(1,n+1) frac(2 sqrt(pi n), 2 pi n) (frac(2n,e))^(2n) (e/n)^(2n) = \ &= frac(1,n+1) frac(1, sqrt(pi n)) 2^(2n) frac(n^(2n), n^(2n)) = \ &= frac(4^n, (n+1) sqrt(pi n)) approx frac(4^n, sqrt(pi n^3)) . $

Calcoliamo $Z_n$ come $ Z_n &= log_2(C_n) = log_2(4^n) - log_2(sqrt(pi n^3)) = \ &= 2n - 1/2 log_2(pi n^3) = 2n - (1/2 log_2(pi) + 3/2 log_2(n)) = 2n - O(log(n)) . $

=== Struttura succinta per alberi binari

Per ora ignoriamo i dati contenuti nei nodi, memorizziamo solo la struttura.

Numeriamo i nodi a partire dall'alto andando verso il basso, partendo da sinistra e andando verso destra. In poche parole, numera facendo una ricerca in ampiezza. I numeri partono da $0$.

Sia $n$ il numero di nodi interni. Usiamo un array binario di $2n+1$ elementi, che nella cella $i$ avrà $1$ se il nodo è interno, altrimenti conterrà $0$.

Le *operazioni* che vogliamo saper fare su questo albero sono:
- dato un nodo, voglio sapere i suoi figli;
- dato un nodo, voglio sapere se è una foglia.

Immaginiamo di avere un albero $T$ e consideriamo un sotto-albero $T'$ di $T$, scelto con la stessa radice di $T$. Dato un nodo $p$ di $T'$, voglio sapere quali sono i figli di questo nodo. Per come abbiamo numerato l'albero, basta contare i nodi alla sua destra fino al figlio sinistro (_figlio di sinistra_) e poi basta fare $+1$ (_figlio di destra_). Mi serve quindi il numero di nodi di $T'$, ma questo lo sappiamo, è due volte i nodi interni più uno, ovvero $2n' + 1$.

Quanti sono questi nodi? Noi sappiamo il numero di interni, ovvero il rank, quindi $2 rank(p) + 1$, e questo è il figlio sinistro di $p$, l'altro è uguale ma ha $+2$.

Per sapere se è una foglia basta vedere se il vettore in posizione $p$ è 0.

DA QUA

Per sapere il mio genitore, devo chiedermi chi è $p' bar.v p'$ genitore di $p$, qui mi serve la select. Sappiamo che questo $p'$ è tale che $2 rank(p') + 1 = p$ oppure $2 rank(p') + 2 = p$, quindi $ rank(p') = floor(p/2 - 1/2) . $

Applichiamo la select ad entrambi i membri e otteniamo $ p' = select(floor(p/2 - 1/2)) . $

DA QUA

Per i *dati ancillari*, ovvero i dati dei nodi, usiamo un array parallelo al vettore dei nodi che tiene i dati, ma questo approccio non è molto succinto. Se i dati sono contenuti sono nei nodi interni, uso un vettore indicizzato di lunghezza uguale ai nodi interni al quale accedo tramite rank sul vettore che già possediamo.

Quanta memoria stiamo occupando? Stiamo utilizzando:
- un array di $2n + 1$ bit;
- una struttura di rank e select che occupa $o(2n + 1) = o(n)$.

Sappiamo che $Z_n = 2n - O(log(n))$, quindi abbiamo una *struttura succinta* perché occupiamo $2n$ a meno di un $o$-piccolo.

== Codice di Elias-Fano per sequenze monotone

Nei web crawler, quando salvo il grafo del web, per ogni nodo ho una lista dei successori, che dice quali a pagine punta la pagina corrente. Vogliamo ordinare queste sequenze in maniera crescente, e useremo il *codice di Elias-Fano* per fare tutto ciò.

Data una sequenza di valori $0 lt.eq x_0 lt.eq dots lt.eq x_(n-1) < u$ vogliamo memorizzare questa lista.

Calcoliamo $ l = max{0, floor(log_2(u/n))} . $

Memorizziamo esplicitamente gli $l$ bit inferiori (_meno significativi_) $ l_0 = x_0 mod 2^l quad bar.v quad dots quad bar.v quad l_(n-1) = x_(n-1) mod 2^l $ di ogni numero. I bit superiori, che sono $ floor(x_0 / 2^l) quad bar.v quad dots quad bar.v quad floor(x_(n-1) / 2^l) $ li memorizziamo come differenze, ovvero memorizzo $ u_i = floor(x_i / 2^l) - floor(x_(i-1) / 2^l) $ assumendo che $x_(-1) = 0$.

La sequenza iniziale è non decrescente, quindi tutte queste differenze sono maggiori o uguali a $0$.

Questi valori vengono memorizzati in *unario* in un unico vettore. Scrivere in unario vuol dire tanti zeri quanto vale $u_i$ e poi un uno. Quanto occupiamo in memoria?

Per i bit inferiori ci servono $l n$ bit, ovvero $n$ valori diversi ognuno di $l$ bit. Per i bit superiori ci serve $ sum_(i=0)^(n-1) u_i + 1 &= sum_(i=0)^(n-1) floor(x_i / 2^l) - floor(x_(i-1) / 2^l) + 1 = \ &= n + sum_(i=0)^(n-1) floor(x_i / 2^l) - floor(x_(i-1) / 2^l) = \ &= "la serie è telescopica" = \ &= n + floor(x_(n-1)/2^l) - floor(x_(-1) / 2^l) = \ &= n + x_(n-1)/2^l lt.eq n + u / 2^l = n + frac(u, 2^(floor(log_2(u/n)))) lt.eq n + frac(u, 2^(log(u/n) - 1)) = n + frac(2u, u/n) = 3n . $

In totale abbiamo quindi $ D_n = l n + 3 n = (l + 3) n = (floor(log_2(u/n)) + 3) n = 2n + n ceil(log_2(u/n)) . $

Cosa ci rappresenta $select(i)_u$? Ci dice dove è l'$i$-esimo $1$, ma il vettore $u$ contiene una serie di zeri unari e poi un uno che fa da separatore. Se chiedo l'$i$-esimo uno ottengo la posizione, ma quella mi dice solo che fino a quella posizione ho $i$ uni. Quindi $ select(i) &= i + u_0 + dots + u_i = \ &= i + floor(x_0 / 2^l) + (floor(x_1 / 2^l) - floor(x_0 / 2^l)) + dots = \ &= "telescopica" = \ &= i + floor(x_(i) / 2^l) . $

Vogliamo calcolare l'information theoretical lower bound. Fissati $n$ e $u$, quante sono le sequenze $0 lt.eq x_0 lt.eq dots lt.eq x_(n-1) < u$ possibili?

Vogliamo sapere quanti insiemi di cardinalità $n$ ci sono nell'insieme ${0,dots,u-1}$. Questo è abbastanza complicato, quindi usiamo un trick. Un altro modo per vedere questa domanda è chiedersi quante soluzioni ha, in $NN^u$, l'equazione $ c_0 + c_1 + dots + c_(n-1) = n . $

Le $c_i$ sono delle variabili che ci dicono quante volte nella sequenza delle $x$ compare il numero $x_i$.

Per contare si usa la *tecnica delle stelle e delle barre* (_stars & stripes counting_).

#example()[
  La sequenza $ * * bar bar * bar bar bar bar * bar $ indica che ci sono $8$ numeri da selezionare e che viene scelto il primo numero $2$ volte e il terzo e il settimo numero $1$ volta.
]

In generale, le barre vengono usate per dividere i numeri, e le stelle vengono usate per indicare il numero di $x_i$ che sono presenti nell'insieme. Devo avere $n$ stelle, purché le metta in mezzo alle barre. Le barre sono $u-1$ e le stelle sono $n$. Quante sequenze di $n$ stelle e $u-1$ barre esistono?

Ho $u + n - 1$ caratteri nello stringone, devo scegliere dove sono le barre, quindi ho $ binom(u+n-1, u-1) = frac((u+n-1)!, (u-1)! (u+n-1-u+1)!) = frac((u+n-1)!, n! (u-1)!) $ possibili scelte. Quindi $ Z_n = log_2(binom(u+n-1, u-1)) = log_2(binom(u+n-1, n))
= log_2(frac((u+n-1)!, n! (u-1)!)) . $

Sappiamo che $ log(binom(A,B)) tilde B log(A/B) + (A-B) log(frac(A, A-B)) . $

Quindi $ Z_n &= log(binom(u+n-1, n)) tilde n log(frac(u + n - 1, n)) + (u-1) underbracket(log(frac(u+n-1, u-1)), = 0 "trascurabile se" n lt.double u) = \ &= n log((u/n)(1 + n/u - 1/u)) = \ &= n log(u/n) + n log(1 + n/u - 1/u) = \ &= "sappiamo che" x approx log(1+x) = \ &approx n log(u/n) + n(n/u - 1/u) = \ &lt.eq n log(u/n) + n^2/u . $

Ricordiamoci che $D_n = 2n + n ceil(log(u/n)) + o(n)$. Ma allora $D_n = O(Z_n)$.

Non abbiamo una struttura succinta ma almeno abbiamo lo stesso ordine di grandezza, quindi è una *struttura compatta*. Se assumiamo che $n lt.eq sqrt(u)$ allora la struttura è succinta.
