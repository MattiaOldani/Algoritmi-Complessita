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


= Lezione 19 [12/12]

== Inapprossimabilità di MAX Independent Set

Non abbiamo visto questo problema durante il corso, quindi vediamo rapidamente la sua definizione formale:
- *input*: grafo $G = (V,E)$ non orientato;
- *soluzione ammissibile*: un *insieme indipendente*, ovvero una *anti-cricca*, un sottoinsieme $X subset.eq V$ tale che $ binom(X,2) sect E = emptyset.rev ; $
- *funzione obiettivo*: $abs(X)$
- *tipo*: $max$

Stiamo cercando un insieme di vertici di grandezza massima che contiene vertici non collegati tra loro. Ovviamente, questo è un problema $NPOC$.

#theorem()[
  Per ogni $epsilon > 0$ MAX Independent Set non è $(2 - epsilon)$-approssimabile.
]

Non riusciamo quindi ad approssimare MAX Independent Set meglio di $2$.

#proof()[
  Sia $L$ un linguaggio $NPC$ a nostra scelta, ovvero $ L in pcprq(r(n) in O(log(n)), q in NN) . $

  #align(center)[
    #block(
      fill: rgb("#9FFFFF"),
      inset: 8pt,
      radius: 4pt,

      [*Gemini voleva dire la sua (_cit. Boldi_)*],
    )
  ]

  Fissato $z in 2^*$, il nostro verificatore:
  - genera una sequenza di bit random $R in 2^(r(abs(z)))$;
  - genera delle posizioni $i_1^(Z,r), dots, i_q^(Z,r)$;
  - fa le query all'oracolo all'oracolo, ottenendo $b_1, dots, b_q$.

  Tutti questi dati formano una $z$-*configurazione*: essa è una coppia $ (R, {i_1^(z,R):b_1, dots, i_q^(z,R):b_q}) . $ Il numero di queste configurazioni dipende dal numero di scelte di $R$ e, fissata una di queste, anche dal numero di scelte dell'oracolo.

  Costruiamo $G_z$ un grafo non orientato:
  - i vertici sono le $z$-configurazioni *accettanti*, ovvero le configurazioni che mi portano ad accettare $z$ nel linguaggio $L$;
  - i lati tra due vertici $v$ e $v'$ esistono se e solo se:
    - $R = R'$ oppure
    - $exists k,k' in {1,dots,q}$ tali che $i_k^(z,R) = i_(k')^(z,R') and b_k eq.not b_(k')$. In poche parole, esiste una posizione in comune che ha avuto due risposte diverse dall'oracolo. Questo lato in particolare evidenzia una *relazione di inconsistenza*.

  Il grafo ha un numero di vertici *polinomiale*: i bit random sono $2^(r(abs(z)))$ ma la funzione $r(abs(z))$ è logaritmica quindi ho un fattore polinomiale in $abs(z)$. Il numero di possibili risposte è $2^q$ che però è un numero. Quindi il numero di vertici è polinomiale.

  Supponiamo per assurdo di avere un algoritmo approssimato per MAX Independent Set con grado di approssimazione $alpha < 2 + epsilon$.

  Abbiamo due casi:
  - se $z in L$ il MAX Independent Set ha dimensione $ gt.eq 2^(r(abs(z))) $ per il @primo-lemma, ma noi abbiamo in mano un algoritmo $(2-epsilon)$-approssimante, quindi quello che ci viene restituito è un valore $ gt.eq frac(2^(r(abs(z))), 2 - epsilon) ; $
  - se $z in.not L$ il MAX Independent Set ha dimensione $ lt.eq 2^(r(abs(z)) - 1) $ per il @secondo-lemma.

  Questi insiemi sono disgiunti: infatti, $ 2^(r(abs(z)) - 1) = frac(2^(abs(z)), 2) < frac(2^(abs(z)), 2 - epsilon) $ quindi sto decidendo in tempo polinomiale l'appartenenza di una stringa in un linguaggio $NPC$, ma questo è impossibile se $P eq.not NP$, quindi non esistono algoritmi $alpha$-approssimanti per MAX Independent Set.
]

Vediamo la dimostrazione dei due lemmi che abbiamo usato nella dimostrazione.

#lemma()[
  Se $z in L$ allora $G_z$ ha un Independent Set di dimensione $gt.eq 2^r(abs(z))$.
]<primo-lemma>

#proof()[
  Se $z in L$ allora $exists overline(w)$ che fa accettare con probabilità $1$. Prendiamo tutte le configurazioni accettanti $(R, {i_1^(z,R):b_1, dots, i_q^(z,R):b_q})$ consistenti con $overline(w)$. Noi abbiamo definito la relazione di inconsistenza, quindi devo scegliere l'unico nodo che ha le risposte uguali ai bit di $overline(w)$. Visto che abbiamo $2^(r(abs(z)))$ possibili $R$, l'insieme di tutti questi vertici ha cardinalità $gt.eq 2^(r(abs(z)))$. Inoltre, tutti questi elementi sono non collegati da archi, visto che sono consistenti, quindi è anche un Independent Set.
]

#lemma()[
  Se $z in.not L$ ogni Independent Set di $G_z$ ha cardinalità $lt.eq 2^(r(abs(z)) - 1)$.
]<secondo-lemma>

#proof()[
  Per assurdo supponiamo che $S$ sia un Independent Set di $G_z$ con cardinalità $> 2^(r(abs(z)) - 1)$.

  $S$ contiene tutti nodi che hanno $R$ diversi tra loro e, considerando le risposte dell'oracolo, a parità di indice ho sicuramente la stessa risposta, altrimenti avremmo un arco tra i due vertici e quindi non sarebbe un Independent Set.

  A fronte di $S$ si può costruire un $overline(w)$ compatibile con tutti i vertici di $S$. Stiamo quindi accettando con probabilità $ > 2^(r(abs(z)) - 1) = frac(2^(r(abs(z))), 2) $ ovvero stiamo accettando con più della metà delle possibili stringhe random. Noi però non stiamo accettando $z$, quindi almeno metà delle configurazioni non devono accettare, per definizione, quindi questo è un assurdo.
]

== Strutture succinte

Le *strutture succinte* sono oggetti estremamente piccoli, talmente piccoli che andremo a contare i bit di queste strutture per ridurli il più possibile. Come vedremo però, ci sarà un limite a tutto ciò.

Una *struttura dati* è un *Abstract Data Type* (_ADT_): esso rappresenta un insieme di primitive che devono essere implementate. In base a come implementiamo i metodi, avremo una certa occupazione in spazio e un certo dispendio temporale. Le implementazioni, ovviamente, non differiscono per funzioni, ma differiscono per complessità in spazio e tempo.

Le strutture succinte sono SD che occupano poco spazio. Per il tempo andremo nella soluzione _"a babbo"_, ovvero _"basta che vadano"_.

In poche parole vogliamo tutto: SD piccola ma molto veloce. Di solito, questo trade-off è difficile da avere nella realtà.

#theorem([Information-theoretical lower bound])[
  Data una struttura dati con:
  - taglia $n$;
  - $V_n$ valori possibili ${v_1, dots, v_(V_n)}$;
  - ${x_1, dots, x_(V_n)}$ bit utilizzati.

  Il *teorema di Shannon* afferma che $ frac(x_1 + dots + x_(V_n), V_n) gt.eq log_2(V_n) . $
]

Quel fattore $log_2(V_n)$ si chiama *information-theoretical lower bound*, e ci dà una dimensione media minima in bit che serve per codificare una struttura dati di $V_n$ valori di taglia $n$.

Chiamiamo $Z_n$ questo bound sul numero di bit. Sia $D_n$ il numero di bit utilizzati per rappresentare una struttura. Allora la struttura è:
- *implicita* se $D_n = Z_n + O(1)$;
- *succinta* se $D_n = Z_n + o(Z_n)$;
- *compatta* se $D_n = O(Z_n)$.

== Struttura succinta per Rank e Select

Vogliamo implementare l'ADT che definisce il comportamento *Rank e Select*.

Dato un array $b in 2^n$ di $n$ bit, abbiamo due operazioni:
- la primitiva *rank* conta il numero di $1$ prima di una data posizione, ovvero $ rank(p) = abs({i bar.v i < p and b_i = 1}) ; $
- la primitiva *select* dice in che posizione è presente il $k$-esimo $1$ (_a partire da $0$_), ovvero $ select(k) = max{p bar.v rank(p) lt.eq k} . $

Valgono due *proprietà*: $ rank(select(i)) = i \ select(rank(i)) gt.eq i and select(rank(i)) = i arrow.long.double.l.r b_i = 1 $

Quella che abbiamo è una *struttura statica*, ovvero dato $b$ la struttura viene costruita e, una volta fatto ciò, essa non viene più modificata.

Vediamo due implementazioni naive di questa ADT:
- se non costruisco niente lo spazio utilizzato dalla struttura è $0$ ma il tempo è lineare perché ogni volta devo calcolarmi i valori di rank e select scorrendo l'array;
- se costruisco le tabelle di rank e select per intero occupiamo $2 n log_2(n)$ bit di spazio ma abbiamo tempo di accesso $O(1)$ per avere le risposte.

Per salvare un array di $n$ bit ci servono $ gt.eq log_2(D_n) = log_2(2^n) = n $ bit. Abbiamo $2^n$ perché sono bit e abbiamo $n$ posizioni.

=== Struttura di Jacobson per Rank

La struttura di Jacobson per rank è una *struttura multi-livello*.

Dato l'array $b$ lo divido in *super-blocchi* di lunghezza $(log(n))^2$. Ogni super-blocco poi lo dividiamo in *blocchi* di lunghezza $1/2 log(n)$.

Ogni super-blocco $S_i$ memorizza quanti $1$ sono contenuti in esso. Invece, ogni blocco $B_(i j)$ memorizza quanti $1$ ci sono dall'inizio del super blocco $S_i$ fino a se stesso (_escluso_).

Vediamo l'occupazione in memoria di queste strutture.

La *tabella dei super-blocchi* ha $frac(n, (log(n))^2)$ righe e contiene dei valori che sono al massimo lunghi (secondo me sono $(log(n)^2)$, e invece sono) $n$, che in bit sono $log(n)$. La grandezza di questa tabella è quindi $ frac(n, (log(n))^2) log(n) = frac(n, log(n)) = o(n) . $

La *tabella dei blocchi* ha $frac(n, 1/2 log(n))$ righe e contiene dei valori che sono al massimo lunghi $(log(n))^2$, che in bit sono $log(log(n)^2)$. La grandezza di questa tabella è quindi $ frac(n, 1/2 log(n)) log(log(n)^2) = frac(4 n log(log(n)), log(n)) = o(n) . $

Manca una cosa: cosa succede se ci viene chiesta una posizione interna al blocco?

Usiamo il *four-russians trick*, il _trucco dei quattro russi_.

Per ogni possibile configurazione dei blocchi, che sono $2^(1/2 log(n))$, memorizziamo la tabella di rank di quella configurazione. Abbiamo quindi $1/2 log(n)$ righe, che contengono valore massimo $1/2 log(n)$, che in bit sono $log(1/2 log(n))$. L'occupazione totale di tutte queste strutture è $ 2^(1/2 log(n)) 1/2 log(n) log(1/2 log(n)) = sqrt(n) log(sqrt(n)) log(log(sqrt(n))) = o(n) . $

La struttura di Jacobson è quindi *succinta*.
