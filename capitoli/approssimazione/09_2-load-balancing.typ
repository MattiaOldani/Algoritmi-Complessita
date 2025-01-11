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

= PTAS per 2-LoadBalancing

Ricordiamo cosa sono i $PTAS$: sono problemi che sono *approssimabili a meno di una qualunque costante*. In poche parole, dato un problema, posso scegliere una qualunque costante (_tasso di approssimazione_) tale che esiste un algoritmo che mi risolve il dato problema con il tasso di approssimazione scelto. Purtroppo, più il tasso di errore scelto è basso, più è esponenziale il tempo.

Il problema per il quale vediamo un PTAS è quello che abbiamo già visto, nel quale però viene fissato il numero di macchine a $2$. In questo caso, il carico generale sarà peggiore di Load Balancing puro, ma almeno il problema è un PTAS.

Diamo la definizione rigorosa del problema:
- *input*: insieme di task $t_0, dots, t_(n-1) > 0$;
- *soluzione ammissibile*: funzione di assegnamento delle $n$ task a $2$ macchine, ovvero $alpha : n arrow.long 2$;
- *funzione obiettivo*: $max (sum_(i bar.v alpha(i) = 0) t_i, sum_(i bar.v alpha(i) = 1) t_i)$;
- *tipo*: $min$.

Vediamo l'algoritmo magico per questo problema.

#align(center)[
  #pseudocode-list(title: [Algoritmo magico])[
    - *input*
      - insieme di task $t_0, dots, t_(n-1)$
      - macchine $M_0$ e $M_1$
      - tasso di approssimazione $epsilon > 0$ per ottenere una $(1 + epsilon)$-approssimazione
    + if $epsilon gt.eq 1$
      + Assegna tutti i task $t_i$ alla macchina $M_0$
      + Salta al punto $10$
    + Ordina i task $t_i$ in ordine decrescente
    + *FASE $1$*
      + $k arrow.l ceil(1/epsilon - 1)$
      + Si cerca esaustivamente (_tempo_ $2^k$) l'assegnamento ottimo dei primi $k$ task
    + *FASE $2$*
      + I restanti $n-k$ task sono assegnati in modo greedy
    + *output* massimo carico
  ]
]

Tutti i $PTAS$ sono così: la parte più importante del problema (_in questo caso, l'assegnamento dei task più pesanti_) la vogliamo risolvere in modo esatto, ma questo è impattante sul tempo ed è difficile. Il resto invece lo approssimo.

#theorem()[
  L'algoritmo magico è una $(1 + epsilon)$-approssimazione per $2$-LoadBalancing.
]

#proof()[
  Sia $T = sum_(i=0)^(n-1) t_i$. Vediamo due casi distinti per il valore di $epsilon$.

  Se $epsilon gt.eq 1$ ci stiamo accontentando di una $2$-approssimazione. Sappiamo infatti che $ L^* gt.eq frac(sum_(i = 0)^(n-1) t_i, 2) quad (*) $ se riusciamo a fare una divisione "perfetta". Visto che assegniamo tutto ad una macchina, allora $L = sum_(i=0)^(n-1) t_i = T$ e quindi $ frac(L,L^*) lt.eq^* frac(T, T/2) = 2 . $

  Se $epsilon in (0,1)$ alla fine della prima fase ho carichi $y_0$ e $y_1$. Dopo la seconda fase ho invece carichi $L_0$ e $L_1$. Assumiamo che $L_0 gt.eq L_1$. Ci sono anche qui due casi da analizzare.

  Il primo caso avviene quando $L_0 = y_0$: in questo caso tutti i task della seconda fase sono finiti a $M_1$. In poche parole, in ogni step della seconda fase avevo $M_1$ più scarica di $M_0$. Ma questo che abbiamo ottenuto è l'assegnamento globale ottimo: infatti, partendo da una soluzione già ottima, se avessi sbagliato qualcosa nella fase greedy avrei assegnato almeno un task a $M_0$, ma questo avrebbe peggiorato lo sbilanciamento ottenuto nella fase ottima.

  Il secondo caso è quello _"normale"_: assegno un po' di task alle due macchine ma non in modo esclusivo. Sia $t_h$ l'ultimo task assegnato a $M_0$, il più piccolo presente in $M_0$. Sappiamo che $ L_0 - t_h lt.eq_("assegnamento") L'_1 lt.eq_("altro") L_1 . $ Sommiamo $L_0$ ad entrambi i membri e dividiamo per $2$, quindi $ 2 L_0 - t_h lt.eq underbracket(L_0 + L_1, =T) arrow.long.double L_0 - t_h / 2 lt.eq T/2 arrow.long.double L_0 lt.eq T/2 + t_h / 2 . quad (**) $

  Sappiamo che $ T = t_0 + dots + t_k + t_(k+1) + dots + t_(n-1) $ e che i $t_i$ sono ordinati in senso decrescente. Ma allora, _stando molto larghi_, vale $ T = underbracket(t_0 + dots + t_k, forall i = 0\, dots\, k quad t_i gt.eq t_h) + underbracket(t_(k+1) + dots + t_(n-1), > 0) gt.eq (k+1) t_h . quad (***) $

  Valutiamo finalmente $ frac(L,L^*) =^("HP") frac(L_0,L^*) lt.eq^* frac(L_0, T/2) lt.eq^(**) frac(T/2 + t_h/2, T/2) = 1 + t_h / T lt.eq^(***) 1 + frac(t_h, (k + 1) t_h) = 1 + frac(1,k+1) . $ Ricordando che $k = ceil(1/epsilon - 1)$, infine vale $ frac(L,L^*) lt.eq 1 + frac(1, 1/epsilon - 1 + 1) = 1 + frac(1, 1/epsilon) = 1 + epsilon . qedhere $
]

Se $epsilon$ molto basso potrei richiedere nella fase $1$ di assegnare tutti i task, non eseguendo di fatto la seconda parte. Possiamo imporre ad esempio il vincolo $ceil(1/epsilon - 1) lt.eq n$ o assegnare in modo ottimo le prime $max(ceil(1/epsilon - 1), n)$ task.

#theorem()[
  L'algoritmo magico richiede tempo $O(underbracket(n log(n), "ordinamento") + underbracket(2^(min((1/epsilon),n)), "ass.es") + underbracket((n - 1/epsilon), "ass.appr"))$.
]

#proof()[
  La dimostrazione è scritta negli underbracket. Nella fase $1$ di assegnamento esatto questo lo posso fare in $2^k approx 2^(1/epsilon)$ modi. La fase $2$ ha tempo $O(n - k)$. L'ordinamento avviene con qualunque algoritmo non banale.
]
