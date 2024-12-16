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


= Lezione 20 [13/12]

== Ancora Jacobson

La struttura di Jacobson è stata pensata negli anni $'80$.

Le strutture che consideriamo sono *statiche*: le primitive non cambiano lo stato dell'oggetto, non modificano ciò che è stato salvato. Le strutture di controllo (_tabelle_) che usiamo sono detti *indici*. Il tempo di costruzione di questi indici non lo considereremo mai.

#align(center)[
  #block(
    fill: rgb("#9FFFFF"),
    inset: 8pt,
    radius: 4pt,

    [*Eh no Gemini però. Scusate è partito ancora Gemini (_cit. Boldi_)*],
  )
]

== Struttura succinta di Clarke per Select

La *struttura di Clarke per Select* è stata ideata molto dopo rispetto alla struttura di Jacobson.

Come funziona questa struttura? È ancora una *struttura multi-livello*, che salverà le entry della select _"ogni tanto"_, ogni tot multipli.

=== Primo livello

Il *primo livello* della struttura memorizza le select dei valori multipli di $log(n) log(log(n))$. Il numero di righe di questa tabella è $ frac(n, log(n) log(log(n))) . $ Per ogni riga indico la posizione dell'$1$ richiesto, quindi al massimo $n$, che in bit è $log(n)$. La dimensione di questa tabella è quindi $ frac(n, log(n) log(log(n))) log(n) = frac(n, log(log(n))) = o(n) . $

=== Secondo livello

Stiamo salvando delle posizioni $p_i$, ognuna delle quali indica la posizione dell'$i log(n) log(log(n))$-esimo bit $1$ del vettore. Ragioniamo su $p_(i+1)$ e $p_i$. La successione è necessariamente crescente, e inoltre la differenza non può essere più bassa del multiplo, perché di mezzo ho esattamente quel valore moltiplicativo. Quindi $ p_(i+1) - p_i gt.eq log(n) log(log(n)) . $ Questa differenza ci dice quanto sono sparsi i nostri $1$ nel blocco. Se ho l'uguale allora ho solo $1$, altrimenti ne ho di meno. In poche parole, questo valore indica la *densità* degli $1$.

Il *secondo livello* dipende dalla densità $r_i = p_(i+1) - p_i$. Ho due casi da considerare:
- se $r_i gt.eq (log(n) log(log(n)))^2$ ho una densità bassa di $1$, si dice che il vettore in quello span è *sparso*. La tabella della select viene memorizzata esplicitamente. Quanto occupiamo in memoria? Gli $1$ da memorizzare sono quelli tra un pezzo e l'altro, quindi $log(n) log(log(n))$ righe. La posizione che scrivo dentro è al massimo $r_i$ (_l'indice dell'$1$ parte dall'inizio del blocco_), quindi $log(r_i)$ in bit. Come spazio totale otteniamo $ log(n)log(log(n)) log(r_i) = frac((log(n) log(log(n)))^2, log(n) log(log(n))) log(r_i) lt.eq frac(r_i log(r_i), log(n) log(log(n))) lt.eq_(r_i lt.eq n) frac(r_i, log(log(n))) ; $
- se $r_i < (log(n) log(log(n)))^2$ ho una densità alta, si dice che il vettore in quello span è *denso*, ho tantissimi $1$. In questo caso memorizzo le posizioni multiple di $log(r_i) log(log(n))$. Quanta memoria serve? Sto usando $ frac(log(n) log(log(n)), log(r_i) log(log(n))) log(r_i) = log(n) lt.eq frac(r_i, log(log(n))) $ bit di memoria.

In entrambi i casi analizzati usiamo al massimo, nel secondo livello, $ frac(r_i, log(log(n))) $ per ogni blocco, quindi $ frac(r_0, log(log(n))) + frac(r_1, log(log(n))) + dots &= frac(p_1 - p_0, log(log(n))) + frac(p_2 - p_1, log(log(n))) + dots = \ &= frac(p_n - p_0, log(log(n))) lt.eq frac(n, log(log(n))) = o(n) . $

=== Terzo livello

Nel caso denso mi mancano comunque degli $1$ da indicizzare, che sono quelli nelle posizioni non multiple. Serve un *terzo livello*. Nel secondo livello ho memorizzato le posizioni $s_i^j$ del blocco che inizia in $i$. Come prima, vediamo la differenza $t_i^j = s_i^(j+1) - s_i^j$. Ricordiamoci che siamo nel caso denso, quindi vale $r_i < (log(n) log(log(n)))^2$. Vale quindi $ t_i^j gt.eq log(r_i) log(log(n)) . $

Anche qui abbiamo due casistiche:
- se $t_i^j gt.eq log(t_i^j) log(r_i) (log(log(n)))^2$ siamo ancora nel caso *sparso*. Come prima, memorizzo tutte le tabelle esplicitamente. Che occupazione abbiamo? Il numero di righe è $log(r_i) log(log(n))$, ognuna di queste tiene una quantità che è al massimo $t_i^j$ (_contiamo sempre da inizio blocco_), quindi in bit sono $log(t_i^j)$. L'occupazione totale è quindi $ log(r_i) log(log(n)) log(t_i^j) = frac(log(t_i^j) log(r_i) (log(log(n)))^2, log(log(n))) lt.eq frac(t_i^j, log(log(n))) ; $
- se $t_i^j < log(t_i^j) log(r_i) (log(log(n)))^2$ usiamo il *four-russians trick*: per questa struttura prendiamo tutte le possibili tabelle di select. Osserviamo che $ log(t_i^j) &lt.eq_("DEF") log(r_i) lt.eq_("DEF") log(log(n) log(log(n))^2) = \ &= 2 log(log(n) log(log(n))) = 2 log(log(n)) + 2 log(log(log(n))) lt.eq 4 log(log(n)) . $ Quindi $ t_i^j &< log(t_i^j) log(r_i) (log(log(n)))^2 \ &lt.eq 4 log(log(n)) 4 log(log(n)) (log(log(n)))^2 lt.eq 16 (log(log(n)))^4 . $

Le tabelle del four-russians trick hanno $t_i^j$ righe, ognuna che contiene valori che sono al massimo $t_i^j$ (_come solito, partiamo dal blocco corrente a contare_), che in bit sono $log(t_i^j)$. Le tabelle sono $2^(t_i^j)$ quindi lo spazio occupato è $ 2^(t_i^j) t_i^j log(t_i^j) &lt.eq 2^(16 (log(log(n)))^4) 16 (log(log(n)))^4 log(16 (log(log(n)))^4) = \ &= "NON LO SO" = o(n) . $

Come prima, se sommiamo per ogni blocco $j$ abbiamo una somma *telescopica* che ci porta a $o(n)$.
