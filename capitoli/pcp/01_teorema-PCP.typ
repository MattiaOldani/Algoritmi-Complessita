// Setup

#import "../alias.typ": *

#import "@preview/diagraph:0.3.0": raw-render

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

= Teorema PCP

Iniziamo con un argomento *molto* (_enfasi sul molto_) divertente, il *teorema PCP*.

Negli anni $'70$ nasce la *teoria della complessità strutturale*: essa vuole risolvere problemi che non erano ancora stati risolti dividendoli in classi, così da usare soluzioni più astratte e generali dei singoli problemi. La domanda cruciale alla quale cercava (_e cerca ancora oggi_) risposta è la famosissima $ P = NP . $ Una domanda molto ambiziosa, alla quale ancora oggi non abbiamo una soluzione.

Inoltre, purtroppo per noi che dobbiamo studiarle, esiste uno zoo di classi di complessità, e tra queste conosciamo anche qualche relazione, ma le relazioni più importanti e interessanti non sono ancora state risolte (_vedi P e NP_).

Dal *Teorema di Cook* del $1972$ (_credo SAT problema NPC_) l'unico gioiello della teoria della complessità è il *teorema PCP* del $1998$, ideato da Arora e Safra.

Ma andiamo per ordine, prima del teorema ne vedremo di acqua passare sotto al ponte.

Torniamo nel mondo dei problemi di decisione. Una cosa molto bella che possiamo fare è trasformare il problema di decisione dato in un linguaggio $L subset.eq 2^*$. Ora, dato un input $x in 2^*$, ci chiediamo se esso appartenga o meno a $L$. Abbiamo cambiato il problema, è diventato un problema di appartenenza ad un linguaggio, ma che non cambia niente sull'esito del problema.

L'algoritmo che decide questa appartenenza è un *decisore*, che noi rappresentiamo con una MdT, l'oggetto più formale e astratto che rappresenta un algoritmo deterministico.

Le MdT hanno forme alternative però: una versione particolare è la *MdT con oracolo*.

L'input di queste macchine è sempre $x in 2^*$ e l'output è sempre una risposta _SI/NO_. Questa macchina, inoltre, può accedere ad un *oracolo* $w in 2^*$ durante la sua esecuzione, una stringa binaria. La risposta quindi dipende non solo dall'input, ma anche dall'oracolo, ovvero la MdT diventa $M(x,w)$. L'accesso all'oracolo non è _diretto_, ma la MdT usa un nastro di supporto, detto *nastro delle query*. Ogni volta che la MdT vuole un elemento della stringa dell'oracolo scrive sul nastro delle query la posizione (_in binario_) della posizione da interrogare e la macchina, andando nello *stato di query* $q_?$, estrae l'elemento richiesto.

Pensiamo all'oracolo $w$ come ad una dimostrazione: noi abbiamo in input $x$ e vogliamo verificare che $x$ abbiamo una certa proprietà usando delle informazioni aggiuntive dell'oracolo $w$.

Vista questa natura, queste macchine sono dette *verificatori*.

#example()[
  Vogliamo costruire una MdT che ci dice se $x in 2^*$ è primo. Nell'oracolo potrei andare a scrivere un divisore proprio di $x$. e la MdT deve controllare se questo oracolo ha avuto ragione oppure no. Ovviamente, questo controllo lo fa in tempo polinomiale.
]

In poche parole, la MdT verifica se l'oracolo sta dando una dimostrazione credibile oppure no.

Come vedremo nel seguente teorema, queste MdT con oracolo non sono altro che delle MdT non deterministiche: infatti, quando le MdT non deterministiche sdoppiavano il loro comportamento noi possiamo vederlo in una MdT con oracolo come la richiesta di query dall'oracolo.

#theorem()[
  Un linguaggio $L subset.eq 2^*$ sta in $NP$ se esiste una MdT con oracolo $V$ tale che:
  + $V(x,w)$ lavora in tempo polinomiale in $abs(x)$;
  + $forall x in 2^*$ vale $ exists w in 2^* bar.v V(x,w) = "SI" arrow.long.double.l.r x in L . $
]

L'oracolo fa il ruolo del *non determinismo*. Il secondo punto rappresenta _lo sbatti_ del non determinismo: comodo che per vedere l'appartenenza devo avere almeno un ramo vero, scomodo che per vedere la non appartenenza devo avere tutti i rami falsi.

Espandiamo ancora la nostra macchina: introduciamo i *verificatori probabilistici*. Essi aggiungono un ingrediente, dei *bit random*.

Come prima, abbiamo l'input $x in 2^*$ e l'oracolo $w in 2^*$ al quale la MdT ha accesso. In questa versione estesa la MdT può accedere anche ad una *sorgente di bit random*. Sulla base di queste tre variabili la MdT deve rispondere _SI/NO_.

A noi interesseranno verificatori probabilistici $V$ per un linguaggio $L$ tali che:
- $V$ lavora in tempo polinomiale in $abs(x)$;
- se
  - $x in L$ allora $exists w in 2^*$ tale che $V(x,w)$ accetta con probabilità $1$. In poche parole, qualsiasi sia la sequenza di bit random la MdT accetta $x$;
  - $x in.not L$ allora $forall w in 2^*$ abbiamo che $V(x,w)$ rifiuta con probabilità $gt.eq 1/2$. In poche parole, in almeno metà delle sequenze di bit random la MdT rifiuta $x$.

Vista la proprietà $1$, la dimensione dei bit random ai quali accediamo è polinomiale.

Abbiamo quindi due ingredienti, uno *oracolico* (_non deterministico_) e uno *randomico*.

Questi due ingredienti serviranno per definire la classe di complessità PCP e il teorema PCP. Infatti, *PCP* è l'acronimo di *Probabilistically Checkable Proof*, ovvero una dimostrazione (_oracolo_) che possiamo controllare in modo probabilistico (_random_).

Date due funzioni $r,q : NN arrow.long NN$ chiamiamo $ pcprq(r,q) $ la *classe dei linguaggi accettati da un verificatore probabilistico* che su input $x$ faccia:
- $lt.eq q(abs(x))$ query all'oracolo e
- $lt.eq r(abs(x))$ letture alla sorgente di bit random.

Vediamo qualche classe importante che possiamo definire a partire da questo _template_.

La prima classe che creiamo è $ pcprq(0,0) = P . $ Infatti, non potendo fare query e non potendo usare dei bit random, la decisione dipende solamente dall'input $x$ che abbiamo dato alla MdT.

La seconda classe che creiamo è $ pcprq(0,"poly") = NP . $ Infatti, non possiamo usare dei bit random ma abbiamo accessi polinomiali all'oracolo, che è esattamente quello che fa una MdT non deterministica. Inoltre, non avendo delle probabilità, questa macchina accetta con probabilità $1$ e rifiuta con probabilità $1$, nel senso che non esistono probabilità intermedie (_prima avevamo_ $1/2$).

#theorem([Teorema PCP])[
  Vale $ NP = pcprq(O(log(n)), O(1)) . $
]

Ho un trade-off rispetto alla definizione di $NP$ che abbiamo dato prima del teorema:
- voglio avere accesso ai bit random ($0 arrow.long.squiggly O(log(n))$);
- per far ciò devo rinunciare ad un buon numero di query ($"poly" arrow.long.squiggly O(1)$).

Vediamo come questo passaggio renda _"più potente"_ la componente randomica: passo da polinomiale a costante, ma per compensare ciò mi basta solo un fattore logaritmico. Abbiamo appena affermato la superiorità della componente randomica sulla componente non deterministica.

Quello che è sorprendente è quel $O(1)$: stiamo dicendo che, dato un linguaggio, esiste un numero (_e anche una funzione logaritmica, ma quella chissene_) perfetto per quel linguaggio e tale che ogni stringa di input viene accettata (_almeno un ramo_) o rifiutata (_ogni ramo_) entro quel numero di query.

Per verificare che è un numero va bene per un dato problema bisogna costruire un verificatore che:
- $forall x in 2^*$ allora $V$ usa al massimo quelle risorse;
- se $x in L$ allora $V$ accetta con probabilità $1$ qualsiasi sia la stringa di bit randomici;
- se $x in.not L$ allora $V$ rifiuta con probabilità $gt.eq 1/2$ qualsiasi sia l'oracolo.

Tutto bello, ma a cosa serve il teorema PCP? Noi lo useremo per fornire delle *dimostrazioni di inapprossimabilità* (_a meno di certe costanti_) usando delle riduzioni a PCP.

Facciamo un'ultima restrizione a queste macchine. Stiamo creando un verificatore $V in pcprq(r,q)$ che, su input $x in 2^*$, faccia esattamente:
- $q(abs(x))$ query;
- $r(abs(x))$ estrazioni di bit random.

Se il verificatore $V$ fa di meno query/estrazioni facciamo eseguire a $V$ delle query/estrazioni a vuoto. Questo comportamento sicuramente non modifica il comportamento del verificatore.

Immaginiamo un verificatore $ V in pcprq(r(n) in O(log(n)), q in NN) $ per $NP$. Questa macchina funziona nel seguente modo:

#align(center)[
  #raw-render(
    ```dot
    digraph {
      i -> r
      r -> s1
      s1 -> s1f
      s1 -> s1v
      s1f -> s1f2f
      s1f -> s1f2v
      s1v -> s1v2f
      s1v -> s1v2v
    }
    ```,
    labels: (
      "i": [input $x in 2^*$],
      "r": [leggo subito $R = 2^(r(abs(x)))$ caratteri random],
      "s1": [estraggo un bit $w_(i_1)^((R,x))(epsilon)$],
      "s1f": [estraggo un bit $w_(i_2)^((R,x))(0)$],
      "s1v": [estraggo un bit $w_(i_2)^((R,x))(1)$],
      "s1f2f": [$dots$],
      "s1f2v": [$dots$],
      "s1v2f": [$dots$],
      "s1v2v": [$dots$],
    ),
    edges: (
      "s1": ("s1v": $1$, "s1f": $0$),
      "s1f": ("s1f2f": $0$, "s1f2v": $1$),
      "s1v": ("s1v2f": $0$, "s1v2v": $1$),
    ),
  )
]

La quantità $w_(i_t)^((R,x))(w_(i_1), dots, w_(i_(t-1)))$ indica il bit estratto dall'oracolo sapendo $R$, $x$ e tutti i bit estratti precedentemente. Quello che si va a creare è un mega albero di computazione.

Questa proprietà si chiama *adattività*, che caratterizza un *verificatore adattivo*. Quest'ultimo è un verificatore le cui risposte dell'oracolo dipendono sì dai bit random e dall'input ma anche da quello che abbiamo ottenuto prima come estrazioni. Ma a noi non ci piace il verificatore adattivo.

L'altezza dell'albero mostrato sopra è $q$, ottenuto facendo una serie di richieste all'oracolo. Il numero totale di richieste è $ overline(q) = 2^(q-1) + 2^(q-2) + ... + 2^1 + 2^0 = sum_(i=0)^(q-1) 2^i . $

Per rimuovere l'adattività faccio subito all'oracolo tutte le richieste $overline(q)$ e, da quel momento, finisco la computazione in maniera deterministica usando le query fatte. Questa nuova versione del verificatore si chiama *verificatore non adattivo*.

#align(center)[
  #raw-render(
    ```dot
    digraph {
      i -> r
      r -> q
      q -> b
      b -> d
    }
    ```,
    labels: (
      "i": [input $x in 2^*$],
      "r": [leggo subito $R = 2^(r(abs(x)))$ caratteri random],
      "q": [scelgo un numero $q$ di query in posizioni ${i_1^(R,x), dots, i_q^(R,x)}$],
      "b": [estraggo gli elementi $b_1, dots, b_q$ dall'oracolo],
      "d": [da qui in avanti il verificatore ha un comportamento puramente deterministico],
    ),
  )
]

Sto chiedendo tutte le query subito, poi faccio partire la computazione senza interrogare di nuovo l'oracolo. Ho sicuramente un costo, ovvero un aumento del numero di query, ma questo è comunque un numero che è costante.

#set math.mat(delim: none)

#example()[
  Siano:
  - $z = 10110110$;
  - $r(abs(z)) = 2$;
  - $R = 01$;
  - $q=3$;
  - $I = {i_3, i_15, i_27}$.

  Estraggo i bit $w_3, w_15, w_27$. Ho quindi $2^3$ casi possibili: $ mat(w_3,w_15,w_27,; 0,0,0,N; 0,0,1,S; 0,1,0,S; 0,1,1,N; 1,0,0,S; 1,0,1,S; 1,1,0,S; 1,1,1,N; augment: #(hline: 1, vline: 3)) $

  Questa tabella esprime il comportamento che seguirà il verificatore dopo l'estrazione. Il comportamento espresso è un comportamento puramente deterministico.
]
