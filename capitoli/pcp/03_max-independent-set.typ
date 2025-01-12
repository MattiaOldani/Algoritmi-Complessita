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

= Inapprossimabilità di MAX Independent Set

Non abbiamo visto il problema *MAX Independent Set* durante il corso, quindi vediamo rapidamente la sua definizione formale:
- *input*: grafo $G = (V,E)$ non orientato;
- *soluzione ammissibile*: un *insieme indipendente*, ovvero una *anti-cricca*, un sottoinsieme $X subset.eq V$ tale che $ binom(X,2) sect E = emptyset.rev ; $
- *funzione obiettivo*: $abs(X)$;
- *tipo*: $max$.

Ovviamente, questo è un problema $NPOC$.

#theorem()[
  Per ogni $epsilon > 0$ MAX Independent Set non è $(2 - epsilon)$-approssimabile.
]

Non riusciamo quindi ad approssimare MAX Independent Set meglio di $2$.

#proof()[
  Sia $L$ un linguaggio $NPC$ a nostra scelta, ovvero $ L in pcprq(r(n) in O(log(n)), q in NN) . $

  Fissato $z in 2^*$, il nostro verificatore:
  - genera una sequenza di bit random $R in 2^(r(abs(z)))$;
  - genera delle posizioni $i_1^(z,R), dots, i_q^(z,R)$;
  - fa le query all'oracolo all'oracolo, ottenendo $b_1, dots, b_q$.

  Tutti questi dati formano una $z$-*configurazione*: essa è una coppia $ (R, {i_1^(z,R):b_1, dots, i_q^(z,R):b_q}) . $ Il numero di queste configurazioni dipende dal numero di scelte di $R$ e, fissata una di queste, anche dal numero di scelte dell'oracolo.

  Costruiamo $G_z$ un grafo non orientato, dove:
  - i vertici sono le $z$-configurazioni *accettanti*, ovvero le configurazioni che mi portano ad accettare $z$ nel linguaggio $L$;
  - i lati tra due vertici $v$ e $v'$ esistono se e solo se:
    - $R = R'$ oppure
    - $exists k,k' in {1,dots,q}$ tali che $i_k^(z,R) = i_(k')^(z,R') and b_k eq.not b_(k')$. In poche parole, esiste una posizione in comune che ha avuto due risposte diverse dall'oracolo. Questo lato in particolare evidenzia una *relazione di inconsistenza*.

  Il grafo ha un numero di vertici *polinomiale*: i bit random sono $2^(r(abs(z)))$ ma la funzione $r(abs(z))$ è logaritmica quindi ho un fattore polinomiale in $abs(z)$. Il numero di possibili risposte è $2^q$ che però è un numero. Quindi il numero di vertici è polinomiale.

  Supponiamo per assurdo di avere un algoritmo approssimato per MAX Independent Set con grado di approssimazione $alpha < 2 + epsilon$.

  Abbiamo due casi:
  - se $z in L$ il MAX Independent Set ha dimensione $ gt.eq 2^(r(abs(z))) $ per il @primo-lemma-mis, ma noi abbiamo in mano un algoritmo $(2-epsilon)$-approssimante, quindi quello che ci viene restituito è un valore $ gt.eq frac(2^(r(abs(z))), 2 - epsilon) ; $
  - se $z in.not L$ il MAX Independent Set ha dimensione $ lt.eq 2^(r(abs(z)) - 1) $ per il @secondo-lemma-mis.

  Questi insiemi sono disgiunti: infatti, $ 2^(r(abs(z)) - 1) = frac(2^(abs(z)), 2) < frac(2^(abs(z)), 2 - epsilon) $ quindi sto decidendo in tempo polinomiale l'appartenenza di una stringa in un linguaggio $NPC$, ma questo è impossibile se $P eq.not NP$, quindi non esistono algoritmi $alpha$-approssimanti per MAX Independent Set.
]

Vediamo la dimostrazione dei due lemmi che abbiamo usato nella dimostrazione.

#lemma()[
  Se $z in L$ allora $G_z$ ha un Independent Set di dimensione $gt.eq 2^r(abs(z))$.
]<primo-lemma-mis>

#proof()[
  Se $z in L$ allora $exists overline(w)$ che fa accettare con probabilità $1$. Prendiamo tutte le configurazioni accettanti $(R, {i_1^(z,R):b_1, dots, i_q^(z,R):b_q})$ consistenti con $overline(w)$. Noi abbiamo definito la relazione di inconsistenza, quindi devo scegliere l'unico nodo che ha le risposte uguali ai bit di $overline(w)$. Visto che abbiamo $2^(r(abs(z)))$ possibili $R$, l'insieme di tutti questi vertici ha cardinalità $gt.eq 2^(r(abs(z)))$. Inoltre, tutti questi elementi sono non collegati da archi, visto che sono consistenti, quindi è anche un Independent Set.
]

#lemma()[
  Se $z in.not L$ ogni Independent Set di $G_z$ ha cardinalità $lt.eq 2^(r(abs(z)) - 1)$.
]<secondo-lemma-mis>

#proof()[
  Per assurdo, supponiamo che $S$ sia un Independent Set di $G_z$ con cardinalità $> 2^(r(abs(z)) - 1)$.

  $S$ contiene tutti nodi che hanno $R$ diversi tra loro e, considerando le risposte dell'oracolo, a parità di indice ho sicuramente la stessa risposta, altrimenti avremmo un arco tra i due vertici e quindi non sarebbe un Independent Set.

  A fronte di $S$ si può costruire un $overline(w)$ compatibile con tutti i vertici di $S$. Stiamo quindi accettando con probabilità $ > 2^(r(abs(z)) - 1) = frac(2^(r(abs(z))), 2) $ ovvero stiamo accettando con più della metà delle possibili stringhe random. Noi però non stiamo accettando $z$, quindi almeno metà delle configurazioni non devono accettare per definizione, quindi questo è un assurdo.
]
