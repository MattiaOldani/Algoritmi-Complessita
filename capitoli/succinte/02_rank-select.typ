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

= Rank e Select

Vogliamo implementare l'ADT che definisce il comportamento *Rank e Select*.

Dato un array $b in 2^n$ di $n$ bit, abbiamo due operazioni:
- la primitiva *rank* conta il numero di $1$ prima di una data posizione, ovvero $ rank(b,p) = abs({i bar.v i < p and b_i = 1}) ; $
- la primitiva *select* dice in che posizione è presente il $k$-esimo $1$ (_a partire da $0$_), ovvero $ select(b,k) = max{p bar.v rank(b,p) lt.eq k} . $

Valgono due *proprietà*: $ rank(b,select(b,i)) = i \ select(b,rank(b,i)) gt.eq i and select(b,rank(b,i)) = i arrow.long.double.l.r b_i = 1 $

Le strutture che considereremo sono dette *statiche*: una volta costruito l'oggetto, esso non viene più modificato dalle primitive, quindi è buona cosa costruire in maniera intelligente queste strutture.

Le strutture di controllo (_tabelle_) che usiamo sono dette *indici*. Il tempo di costruzione di questi indici non lo considereremo mai.

Vediamo due implementazioni naive di questa ADT:
- se non costruisco niente lo spazio utilizzato dalla struttura è $0$ ma il tempo è lineare perché ogni volta devo calcolarmi i valori di rank e select scorrendo l'array;
- se costruisco le tabelle di rank e select per intero occupiamo $2 n log_2(n)$ bit di spazio ma abbiamo tempo di accesso $O(1)$ per avere le risposte.

Per salvare un array di $n$ bit ci servono $ gt.eq log_2(D_n) = log_2(2^n) = n "bit". $

== Struttura di Jacobson per Rank

La struttura di Jacobson è stata pensata negli anni $'80$ ed è una *struttura multi-livello*.

Dato l'array $b$ lo divido in *super-blocchi* di lunghezza $(log(n))^2$. Ogni super-blocco poi lo dividiamo in *blocchi* di lunghezza $1/2 log(n)$.

Ogni super-blocco $S_i$ memorizza quanti $1$ sono contenuti dall'inizio del vettore fino a $S_i$ (_escluso_). Invece, ogni blocco $B_(i j)$ memorizza quanti $1$ ci sono dall'inizio del super blocco $S_i$ fino a se stesso (_escluso_). Vediamo l'occupazione in memoria di queste strutture.

La *tabella dei super-blocchi* ha $frac(n, (log(n))^2)$ righe e contiene dei valori che sono al massimo lunghi $n$, che in bit sono $log(n)$. La grandezza di questa tabella è quindi $ frac(n, (log(n))^2) log(n) = frac(n, log(n)) = o(n) . $

La *tabella dei blocchi* ha $frac(n, 1/2 log(n))$ righe e contiene dei valori che sono al massimo lunghi $(log(n))^2$, che in bit sono $log(log(n)^2)$. La grandezza di questa tabella è quindi $ frac(n, 1/2 log(n)) log(log(n)^2) = frac(4 n log(log(n)), log(n)) = o(n) . $

Manca una cosa: cosa succede se ci viene chiesta una posizione interna al blocco?

Usiamo il *four-russians trick*, il _trucco dei quattro russi_.

Per ogni possibile configurazione dei blocchi, che sono $2^(1/2 log(n))$, memorizziamo la tabella di rank di quella configurazione. Abbiamo quindi $1/2 log(n)$ righe, che contengono valore massimo $1/2 log(n)$, che in bit sono $log(1/2 log(n))$. L'occupazione totale di tutte queste strutture è $ 2^(1/2 log(n)) 1/2 log(n) log(1/2 log(n)) = sqrt(n) log(sqrt(n)) log(log(sqrt(n))) = o(n) . $

La struttura di Jacobson è quindi *succinta*.

== Struttura di Clarke per Select

La *struttura di Clarke per Select* è stata ideata molto dopo rispetto alla struttura di Jacobson.

Come funziona questa struttura? È ancora una *struttura multi-livello*, che salverà le entry della select _"ogni tanto"_, ogni tot multipli.

=== Primo livello

Il *primo livello* della struttura memorizza le select dei valori multipli di $log(n) log(log(n))$. Il numero di righe di questa tabella è $ frac(n, log(n) log(log(n))) . $ Per ogni riga indico la posizione dell'$1$ richiesto, quindi al massimo $n$, che in bit è $log(n)$. La dimensione di questa tabella è quindi $ frac(n, log(n) log(log(n))) log(n) = frac(n, log(log(n))) = o(n) . $

=== Secondo livello

Stiamo salvando delle posizioni $p_i$, ognuna delle quali indica la posizione dell'$[i log(n) log(log(n))]$-esimo bit $1$ del vettore. Ragioniamo su $p_(i+1)$ e $p_i$. La successione è necessariamente crescente, e inoltre la differenza non può essere più bassa del multiplo, perché di mezzo ho esattamente quel valore moltiplicativo. Quindi $ p_(i+1) - p_i gt.eq log(n) log(log(n)) . $ Questa differenza ci dice quanto sono sparsi i nostri $1$ nel blocco. Se ho l'uguale allora ho solo $1$, altrimenti ne ho di meno. In poche parole, questo valore indica la *densità* degli $1$.

Il *secondo livello* dipende dalla densità $r_i = p_(i+1) - p_i$. Ho due casi da considerare:
- se $r_i gt.eq (log(n) log(log(n)))^2$ ho una densità bassa di $1$, si dice che il vettore in quello span è *sparso*. La tabella della select viene memorizzata esplicitamente. Quanto occupiamo in memoria? Gli $1$ da memorizzare sono quelli tra un pezzo e l'altro, quindi $log(n) log(log(n))$ righe. La posizione che scrivo dentro è al massimo $r_i$ (_l'indice dell'$1$ parte dall'inizio del blocco_), quindi $log(r_i)$ in bit. Come spazio totale otteniamo $ log(n)log(log(n)) log(r_i) = frac((log(n) log(log(n)))^2, log(n) log(log(n))) log(r_i) lt.eq frac(r_i log(r_i), log(n) log(log(n))) lt.eq_(r_i lt.eq n) frac(r_i, log(log(n))) ; $
- se $r_i < (log(n) log(log(n)))^2$ ho una densità alta, si dice che il vettore in quello span è *denso*, ho tantissimi $1$. In questo caso memorizzo le posizioni multiple di $log(r_i) log(log(n))$. Quanta memoria serve? Sto usando $ frac(log(n) log(log(n)), log(r_i) log(log(n))) log(r_i) = log(n) lt.eq frac(r_i, log(log(n))) $ bit di memoria.

In entrambi i casi analizzati usiamo al massimo, nel secondo livello, un numero di bit uguale a $ frac(r_i, log(log(n))) $ per ogni blocco, quindi $ frac(r_0, log(log(n))) + frac(r_1, log(log(n))) + dots &= frac(p_1 - p_0, log(log(n))) + frac(p_2 - p_1, log(log(n))) + dots = \ &= frac(p_n - p_0, log(log(n))) lt.eq frac(n, log(log(n))) = o(n) . $

=== Terzo livello

Nel caso denso mi mancano comunque degli $1$ da indicizzare, che sono quelli nelle posizioni non multiple. Serve un *terzo livello*. Nel secondo livello ho memorizzato le posizioni $s_i^j$ del blocco che inizia in $i$. Come prima, vediamo la differenza $t_i^j = s_i^(j+1) - s_i^j$. Ricordiamoci che siamo nel caso denso, quindi vale $r_i < (log(n) log(log(n)))^2$. Vale inoltre $ t_i^j gt.eq log(r_i) log(log(n)) . $

Anche qui abbiamo due casistiche:
- se $t_i^j gt.eq log(t_i^j) log(r_i) (log(log(n)))^2$ siamo ancora nel caso *sparso*. Come prima, memorizzo tutte le tabelle esplicitamente. Che occupazione abbiamo? Il numero di righe è $log(r_i) log(log(n))$, ognuna di queste tiene una quantità che è al massimo $t_i^j$ (_contiamo sempre da inizio blocco_), quindi in bit sono $log(t_i^j)$. L'occupazione totale è quindi $ log(r_i) log(log(n)) log(t_i^j) = frac(log(t_i^j) log(r_i) (log(log(n)))^2, log(log(n))) lt.eq frac(t_i^j, log(log(n))) ; $
- se $t_i^j < log(t_i^j) log(r_i) (log(log(n)))^2$ usiamo il *four-russians trick*: per questa struttura prendiamo tutte le possibili tabelle di select. Osserviamo che $ log(t_i^j) &lt.eq_("DEF") log(r_i) lt.eq_("DEF") log((log(n) log(log(n)))^2) = \ &= 2 log(log(n) log(log(n))) = 2 log(log(n)) + 2 log(log(log(n))) lt.eq 4 log(log(n)) . $ Quindi $ t_i^j &< log(t_i^j) log(r_i) (log(log(n)))^2 \ &lt.eq 4 log(log(n)) 4 log(log(n)) (log(log(n)))^2 lt.eq 16 (log(log(n)))^4 . $

Le tabelle del four-russians trick hanno $t_i^j$ righe, ognuna che contiene valori che sono al massimo $t_i^j$ (_come solito, partiamo dal blocco corrente a contare_), che in bit sono $log(t_i^j)$. Le tabelle sono $2^(t_i^j)$ quindi lo spazio occupato è $ 2^(t_i^j) t_i^j log(t_i^j) lt.eq 2^(16 (log(log(n)))^4) 16 (log(log(n)))^4 log(16 (log(log(n)))^4) = o(n) . $

Come prima, se sommiamo per ogni blocco $j$ abbiamo una somma *telescopica* che ci porta a $o(n)$.
