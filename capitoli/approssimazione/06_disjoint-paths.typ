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

= Disjoint Paths

Idea del problema: abbiamo grafo orientato con $k$ sorgenti $s_0, dots, s_(k-1)$ e altrettante destinazioni $t_0, dots, t_(k-1)$. Cerchiamo di creare il maggior numero di cammini $s_i arrow t_i$ passando per i lati al massimo una volta. In realtà noi useremo un parametro di congestione $c$ che ci permette di passare al massimo $c$ volte per un lato. Questo problema è anche detto problema dei *cammini disgiunti*.

Diamo una definizione più formale di questo problema:
- *input*:
  - grafo $G = (N, A)$ orientato;
  - lista $s_0, dots, s_(k-1) in N$ di sorgenti;
  - lista $t_0, dots, t_(k-1) in N$ di destinazioni;
  - parametro di congestione $c in NN^+$;
- *soluzione ammissibile*: insieme $I subset.eq k$ tale che i cammini $pi_i : s_i arrow t_i quad forall i in I$ non usano archi di $G$ più di $c$ volte; in altre parole, ogni arco è usato al massimo da $c$ cammini;
- *obiettivo*: $abs(I)$;
- *tipo*: $max$.

Usiamo anche una funzione di lunghezza $ l : A arrow.long RR^(>0) $ che verrà modificata nel tempo e ci permetterà di implementare il prossimo algoritmo. Con questa funzione definiamo la *lunghezza di un cammino* come la quantità $ l(pi = angle.l x_1, dots, x_i angle.r) = l(x_1,x_2) + dots + l(x_(i-1),x_i) . $

#align(center)[
  #pseudocode-list(title: [Greedy Paths])[
    - *input*:
      - grafo $G = (N,A)$ orientato
      - lista $s_0, dots, s_(k-1) in N$ di sorgenti
      - lista $t_0, dots, t_(k-1) in N$ di destinazioni
      - parametro di congestione $c in NN^+$
      - moltiplicatore $beta > 1$
    + $I arrow.l emptyset.rev$ (_coppie già collegate_)
    + $P arrow.l emptyset.rev$ (_cammini già fatti_)
    + for $a in A$:
      + $l(a) arrow.l 1$
    + forever and ever:
      + trova il cammino più corto $pi_i : s_i arrow t_i$ con $i in.not I$ (_coppia ancora non collegata_)
      + if $exists.not pi_i$:
        + break
      + $I arrow.l I union {i}$
      + $P arrow.l P union {pi_i}$
      + $forall a in pi_i$:
        + $l(a) arrow.l beta dot l(a)$
        + if $l(a) = beta^c$:
          + rimuovi $a$ dal grafo
    + *output* $I$ e $P$
  ]
]

#definition([Cammino corto])[
  In un certo istante di esecuzione, un cammino $pi$ è *corto* se e solo se $ l(pi) < beta^c . $
]

I cammini si possono solo allungare, quindi il passaggio di _"stato"_ è da _corto_ a _lungo_.

#definition([Cammino utile])[In un certo istante di esecuzione, un cammino $pi$ è *utile* se collega un coppia nuova $i in.not I$.]

L'algoritmo considera solo cammini utili e, inoltre, ogni volta il più corto. All'inizio consideriamo cammini *corti e utili*, poi cammini *lunghi e utili*, poi ci fermiamo.

Noi studieremo l'algoritmo quando finiamo i cammini corti. Sia $overline(l)$ la funzione lunghezza in quel momento e siano $overline(I)$ e $overline(P)$ le coppie già collegate con il loro percorso associato sempre in quel momento. Nella fase di output abbiamo $l_o$, $I_o$ e $P_o$.

#lemma()[
  Sia $i in I^* slash I_o$, allora $ overline(l)(pi_i^*) gt.eq beta^c . $
]

#proof()[
  Per assurdo sia $ overline(l)(pi_i^*) < beta^c . $ Questo non è possibile: nel grafo avremmo un cammino corto che potremmo selezionare, ma noi abbiamo appena esaurito i cammini corti.
]

#lemma()[
  Sia $m = abs(A)$, allora $ sum_(a in A) overline(l)(a) lt.eq beta^(c+1) abs(overline(I)) + m . $
]

#proof()[
  Dimostriamolo per induzione.

  All'inizio dell'algoritmo abbiamo $ sum_(a in A) l(a) = sum_(a in A) 1 = m lt.eq beta^(c+1) abs(overline(I)) + m . $

  Supponiamo ora che la lunghezza $l_1$ passi alla lunghezza $l_2$ scegliendo la coppia $i$-esima con il cammino $pi_i$. Supponiamo inoltre di non essere ancora arrivati a $overline(l)$.

  Possiamo dire che $ l_2 (a) = cases(l_1 (a) & "se" a in.not pi_i, beta l_1 (a) quad & "se" a in pi_i) . $

  Valutiamo la differenza $ sum_(a in A) l_2 (a) - sum_(a in A) l_1 (a) &= sum_(a in.not pi_i) (l_2 (a) - l_1 (a)) + sum_(a in pi_i) (l_2 (a) - l_1 (a)) = \ &= sum_(a in pi_i) (l_2 (a) - l_1 (a)) = sum_(a in pi_i) (beta l_1 (a) - l_1 (a)) = \ &= (beta - 1) sum_(a in pi_i) l_1 (a) = (beta - 1) l_1 (pi_i) < (beta - 1) beta^c \ &lt.eq beta^(c+1) $

  Ad ogni passo aggiungiamo un cammino, quindi la funzione lunghezza aumenta ogni volta di $beta^(c+1)$. Noi facciamo $abs(overline(I))$ aggiunte prima di arrivare in $overline(I)$, quindi aggiungiamo $beta^(c+1) abs(overline(I))$, al quale aggiungiamo il valore iniziale $m$ della lunghezza _"spostandolo a destra"_.
]

Facciamo un paio di osservazioni importanti per calcolare il $gamma$ dell'approssimazione.

Osserviamo che $ sum_(i in I^* slash I_o) overline(l)(pi_i^*) gt.eq beta^c abs(I^* slash I_o) $ per il lemma 1. Osserviamo anche che nella soluzione ottima nessun arco è usato più di $c$ volte. Quindi possiamo maggiorare il costo con il costo di tutti gli archi moltiplicati per $c$, ovvero $ sum_(i in I^* slash I_o) overline(l)(pi_i^*) lt.eq c sum_(a in A) overline(l)(a) lt.eq c (beta^(c+1) abs(overline(I)) + m) . $ L'ultima minorazione è per il lemma 2.

Grazie a queste due osservazioni possiamo trovare il $gamma$ che approssima questo algoritmo.

#theorem()[
  Greedy Path fornisce una $(2 c m^(1 / (c+1)) + 1)$-approssimazione per Disjoint Paths.
]

#proof()[
  Osserviamo che $ beta^c abs(I^*) &lt.eq beta^c abs(I^* slash I_o) + beta^c abs(I^* sect I_o) \ &lt.eq_(o 1) sum_(i in I^* slash I_o) overline(l)(pi_i^*) + beta^c abs(I_o) \ &lt.eq_(o 2) c (beta^(c+1) abs(overline(I)) + m) + beta^c abs(I_o) \ &lt.eq c (beta^(c+1) abs(I_o) + m) + beta^c abs(I_o) . $

  Dividiamo tutto per $beta^c$ e otteniamo $ abs(I^*) lt.eq c beta abs(I_o) + frac(c m, beta^c) + abs(I_o) lt.eq c beta abs(I_o) + abs(I_o) frac(c m, beta^c) + abs(I_o) = abs(I_o) (c beta + frac(c m, beta^c) + 1) . $

  Ma allora $ frac(abs(I^*), abs(I_o)) lt.eq c (beta + m beta^(-c)) + 1 . $

  Vorremmo scegliere un $beta$ che minimizzi questa funzione: la soluzione gentilmente calcolata è $ beta = m^(frac(1,c+1)) . $

  Con questo valore otteniamo $ frac(abs(I^*), abs(I_o)) lt.eq c (m^(1 / (c+1)) + m^(1 - c / (c+1))) = c (m^(1 / (c+1)) + m^(1 / (c+1))) + 1 = 2 c m^(1 / (c+1)) + 1 . qedhere $
]

Questa funzione è particolare: ha un fattore lineare moltiplicativo in $c$ che peggiora l'approssimazione, ma al tempo stesso si alza anche l'indice della radice. Infatti:
- se $c = 1$ approssimo con $2 sqrt(m) + 1$;
- se $c = 2$ approssimo con $4 root(3,m) + 1$;
- se $c = 3$ approssimo con $6 root(4,m) + 1$;
- eccetera.
