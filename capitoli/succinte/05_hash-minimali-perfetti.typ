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

= Hash minimali perfetti

Le funzioni hash sono funzioni molto rudimentali: partono da qualsiasi universo $U$ e ci ritornano, a prescindere da $U$, un valore nell'insieme ${0,dots,m-1}$. In poche parole sono funzioni nella forma $ h : U arrow.long m . $

Il valore $m$ indica il numero di *bucket*, ovvero il numero di contenitori che usa la funzione hash per distribuire i valori di $U$. Perché usiamo i bucket? Perché di solito $U gt.double m$ e quindi esistono sicuramente delle *collisioni*, ovvero dei valori che vengono mappati nello stesso bucket.

Imponiamo dei requisiti alle funzioni hash:
+ $h$ si calcoli in tempo costante;
+ $h$ sia _molto iniettiva_, ovvero non possiamo avere una funzione $h$ iniettiva ($U gt.double m$) ma almeno chiediamo che $h$ spalmi bene i valori di $U$ nei vari bucket, mettendone circa $U/m$ in ognuno.

Sia $X subset.eq U$ con $abs(X) = n$. Vogliamo avere una funzione hash $h$ che non generi collisioni su $X$, ovvero $ forall x,y in U quad x eq.not y arrow.long.double h(x) eq.not h(y) . $

Questa cosa è molto difficile, ecco perché chiediamo la _"molto iniettiva"_.

Costruiamo una struttura dati che utilizza una funzione hash $h$ scelta uniformemente a caso. Possiamo farlo? Sì, le funzioni hash sono finite, quindi posso farlo, ma questo in realtà è impossibile:
+ l'insieme di tutte le funzioni hash è enorme, dove lo mettiamo?
+ se scelgo a caso, potrei non avere una funzione che lavora in tempo o in spazio costante.

Una cosa che si fa spesso è associare ad ogni carattere della stringa un *peso*, e poi calcolare la somma pesata modulo la grandezza massima. Questo ci permette di avere infinite funzioni hash, modificando solamente il vettore dei pesi.

Un'altra soluzione è la *full randomness assumption*: assumiamo che $h$ sia scelta veramente a caso, e che non ci siano questi problemi.

Per permettere tutto ciò andremo a restringere la famiglia di funzioni hash ad un sottoinsieme pià maneggevole e che abbia delle buone proprietà.

Sia $ H_(U,m) subset.eq m^U $ insieme dal quale scelgo uniformemente a caso. Gli elementi di $H$ sono _belli_ perché $ forall t in m quad forall x in U quad P[h(x) = t] = 1/m . $ In poche parole, la probabilità per un elemento di $U$ di finire in un bucket è uguale per ogni bucket e questa proprietà vale per ogni elemento di $U$.

Una funzione hash $h : U arrow.long m$ è *perfetta* per l'insieme $X subset.eq U$ se e solo se $h$ è iniettiva su $X$, ovvero deve valere $abs(X) lt.eq m$.

Una funzione hash $h : U arrow.long m$ è *minimale* se $abs(X) = m$.

La probabilità di avere un hash perfetto, scegliendo a caso, è molto bassa, e questa scende ancora di più se consideriamo un hash minimale.

== Tecnica MWHC su grafi

La *tecnica MWHC* (_Majewski, Worwald, Havaś e Czech_) è stato presentato in un articolo del $1980$ con l'obiettivo di risolvere un problema legato agli *hash minimali perfetti ordinati* (_OPPMH, Ordered Preserving Perfect Minimal Hash_), ovvero hash che mappano in un ordine deciso.

Sia $U$ l'insieme universo e sia $X subset.eq U$ con $abs(X) = n$. Vogliamo una funzione che associ ad ogni $x_i in X$ un valore di $r$ bit. Fissiamo anche $m gt.eq n$. Scegliamo a caso due funzioni $ h_1,h_2 : U arrow.long m $ usando il trucchetto dei pesi.

Costruiamo un grafo. Esso ha:
- *vertici* indicizzati da ${1, dots, m}$;
- *archi* tra i vertici $i$ e $j$ se e solo se $ exists x in X bar.v {h_1(x), h_2(x)} = {i,j} . $ In poche parole, inseriamo un arco tra due vertici se otteniamo $i$ da $h_1$ e $j$ da $h_2$ a parità di input.

Cosa non vogliamo che succeda:
+ $h_1(x) = h_2(x)$, ovvero ho un *cappio*;
+ considerando $x,y$ tali che $x eq.not y$ otteniamo lo stesso arco, ovvero abbiamo un multigrafo;
+ il grafo è ciclico.

Se succede anche solo una di queste cose buttiamo via le due funzioni hash e ne scegliamo altre due (_ovvero cambiamo i pesi_). Ma le troveremo prima o poi due funzioni $h_1$ e $h_2$ che ci vanno bene?

#theorem()[
  Se $m > 2.09n$ le funzioni hash $h_1$ e $h_2$ hanno quasi sempre le proprietà desiderate e il numero di tentativi attesi è $approx 2$.
]

Vogliamo assegnare ad ogni $x in X$ un valore $f(x) in 2^r$ di $r$ bit. Etichettiamo l'arco tra due nodi con il valore $f(x)$, dove $x$ è il valore di $X$ che ha generato quell'arco.

Andiamo a scrivere $G$ come un sistema di equazioni del tipo $ (A[h_1(x)] + A[h_2(x)]) mod 2^r = f(x) quad forall x in X $ dove $A[1], dots, A[m]$ sono variabili. Se il grafo è aciclico, allora il sistema ammette una soluzione.

La soluzione di questo sistema lo andiamo a salvare in un vettore chiamato $A$.

Grazie a questo posso costruire la funzione hash richiesta: infatti, non so come ma funziona, se richiediamo $f(x)$ con $x in X$, basta calcolare la somma delle posizioni di $A$ trovate usando $h_1$ e $h_2$.

Che occupazione in spazio abbiamo?

Il valore di $m$ è scelto, quindi non lo salvo, come non salvo le funzioni $h_1$ e $h_2$. L'unica quantità da salvare è il vettore delle soluzioni $A$, formato da $m$ entry che contengono valori di $r$ bit, quindi abbiamo una occupazione di $ m r = 2.09 n r $ bit in totale.

Questa funzione hash che abbiamo creato è perfetta per quello che ci serve, ma cosa succede se calcoliamo la funzione ottenuta in un valore che non abbiamo previsto?

Vista la natura *key-less* di questo _"dizionario"_, una query con valori non previsti ci restituisce comunque un valore, che dipende dal vettore delle soluzioni, ma è completamente senza senso.

Nonostante questo piccolo svantaggio, un vantaggio di questa soluzione è che l'occupazione di memoria è veramente minima.

== Tecnica MWHC su iper-grafi

La tecnica MWHC funziona bene anche sugli iper-grafi, ovvero grafi che sono formati da iper-archi (_archi formati da più archi, Eulero perché mi fai questo_).

La scelta di $m$ per un $I$-grafo dipende sempre da $n$ e da un fattore numerico $gamma$. Per:
- $I = 1$ vale il $gamma$ precedente;
- $I = 2$ abbiamo un $gamma$ minore di $I = 1$;
- $I = 3$ abbiamo il $gamma$ migliore, ovvero $gamma = 1.23$;
- $I gt.eq 4$ il valore di $gamma$ torna a salire.

Negli iper-grafi dobbiamo modificare la nozione di aciclicità con la nozione di *peelability*.

Un iper-grafo $(V,E)$ ammette una *peeling sequence* se e solo se esiste un modo per ordinare gli archi $e_1, dots, e_n in E$ ed esiste una sequenza di vertici $x_1, dots, x_n in V$ tali che:
- $x_i in e_i$;
- $forall j < i quad x_i in.not e_j$.

I valori $x_i$ sono detti *hinge*, ovvero i perni. Per trovare una peeling sequence basta risolvere un sistema di equazioni diofantee abbastanza semplice.

Anche in questo caso, abbiamo $ gamma n r $ bit di memoria occupati da $A$, ma in questo caso possiamo fare meglio.

Non ho capito perché ma possiamo utilizzare solo $ n r + gamma n + o(n) $ bit, e nel caso $gamma = 1.23$ ci conviene se $r > 5$.
