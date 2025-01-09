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

= Alberi binari

== Introduzione

La parola *albero* è molto _overloaded_, ovvero viene usata per esprimere tanti concetti diversi che però hanno delle differenze.

In *teoria dei grafi*, un albero è _un grafo non orientato aciclico connesso_. Se cade la richiesta di connessione siamo di fronte ad una *foresta*.

Nell'*informatica classica*, un albero è uguale a quello della teoria dei grafi ma, una volta scelto un nodo come radice, l'intero albero viene _"appeso per gravità"_ a questa radice. In teoria dei grafi questi si chiamerebbero *alberi radicati*.

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

  Guardiamo l'albero $T$: esso è formato dai due *alberoni* $T_1$ e $T_2$, quindi $ E(T) = E(T_1) + E(T_2) quad bar.v quad  I(T) = I(T_1) + I(T_2) + R = I(T_1) + I(T_2) + 1 . $

  Per ipotesi induttiva valgono $ E(T_1) = I(T_1) + 1 and E(T_2) = I(T_2) + 1 . $ Ma allora $ E(T) = E(T_1) + E(T_2) = I(T_1) + I(T_2) + 1 + 1 = I(T) + 1 . qedhere $
]

Il *numero totale di nodi* è $2n + 1$.

#theorem()[
  Ci sono $ C_n = frac(1, n+1) binom(2n,n) $ alberi binari con $n$ nodi interni.
]

Il numero $C_n$ è detto $n$-esimo *numero di Catalano*. Quanto vale $C_n$? Lo possiamo approssimare?

Usiamo l'*approssimazione di Stirling*: essa afferma che $ n! tilde sqrt(2 pi n) (frac(n,e))^n . $

Grazie a questa approssimiamo $C_n$ con $ C_n &= frac(1,n+1) binom(2n,n) = \ &= frac(1,n+1) frac((2n)!, n! (2n-n)!) = \ &= frac(1,n+1) frac((2n)!, (n!)^2) tilde \ &tilde frac(1,n+1) frac(sqrt(4 pi n) (frac(2n,e))^(2n), (sqrt(2 pi n) (n/e)^n)^2) = \ &= frac(1,n+1) frac(2 sqrt(pi n), 2 pi n) (frac(2n,e))^(2n) (e/n)^(2n) = \ &= frac(1,n+1) frac(1, sqrt(pi n)) 2^(2n) frac(n^(2n), n^(2n)) = \ &= frac(4^n, (n+1) sqrt(pi n)) approx frac(4^n, sqrt(pi n^3)) . $

Calcoliamo $Z_n$ come $ Z_n &= log_2(C_n) = log_2(4^n) - log_2(sqrt(pi n^3)) = \ &= 2n - 1/2 log_2(pi n^3) = 2n - (1/2 log_2(pi) + 3/2 log_2(n)) = 2n - O(log(n)) . $

== Struttura succinta per alberi binari

Per ora ignoriamo i dati contenuti nei nodi, memorizziamo solo la struttura.

Numeriamo i nodi a partire dall'alto andando verso il basso, partendo da sinistra e andando verso destra. In poche parole, numera facendo una ricerca in ampiezza. I numeri partono da $0$.

Sia $n$ il numero di nodi interni. Usiamo un array binario di $2n+1$ elementi, che nella cella $i$ avrà $1$ se il nodo è interno, altrimenti conterrà $0$.

Le *operazioni* che vogliamo saper fare su questo albero sono:
- dato un nodo, voglio sapere i suoi figli;
- dato un nodo, voglio sapere se è una foglia.

Immaginiamo di avere un albero $T$ e consideriamo un sotto-albero $T'$ di $T$, scelto con la stessa radice di $T$. Dato un nodo $p$ di $T'$, voglio sapere quali sono i figli di questo nodo. Per come abbiamo numerato l'albero, basta contare i nodi alla sua destra fino al figlio sinistro (_figlio di sinistra_) e poi basta fare $+1$ (_figlio di destra_). Mi serve quindi il numero di nodi di $T'$, ma questo lo sappiamo, è due volte i nodi interni più uno, ovvero $2n' + 1$.

Quanti sono questi nodi? Noi sappiamo il numero di interni, ovvero il rank, quindi $2 rank(p) + 1$, e questo è il figlio sinistro di $p$, l'altro è uguale ma ha $+2$.

Per sapere se è una foglia basta vedere se il vettore in posizione $p$ è 0.

Per sapere il mio genitore, devo chiedermi chi è $p' bar.v p'$ genitore di $p$, qui mi serve la select. Sappiamo che questo $p'$ è tale che $2 rank(p') + 1 = p$ oppure $2 rank(p') + 2 = p$, quindi $ rank(p') = floor(p/2 - 1/2) . $

Applichiamo la select ad entrambi i membri e otteniamo $ p' = select(floor(p/2 - 1/2)) . $

Per i *dati ancillari*, ovvero i dati dei nodi, usiamo un array parallelo al vettore dei nodi che tiene i dati, ma questo approccio non è molto succinto. Se i dati sono contenuti sono nei nodi interni, uso un vettore indicizzato di lunghezza uguale ai nodi interni al quale accedo tramite rank sul vettore che già possediamo.

Quanta memoria stiamo occupando? Stiamo utilizzando:
- un array di $2n + 1$ bit;
- una struttura di rank e select che occupa $o(2n + 1) = o(n)$.

Sappiamo che $Z_n = 2n - O(log(n))$, quindi abbiamo una *struttura succinta* perché occupiamo $2n$ a meno di un $o$-piccolo.
