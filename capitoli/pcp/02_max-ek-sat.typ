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

= Inapprossimabilità di MAX $E_k$-SAT

Vediamo come il teorema PCP può aiutarci a dimostrare l'inapprossimabilità di alcuni problemi. Partiamo con MAX $E_k$-SAT, che avevamo introdotto parlando di algoritmi probabilistici.

#lemma()[
  Ogni $k$-CNF ($k gt.eq 3$) con $t$ clausole si può trasformare in una $3$-CNF con $(k-2)t$ clausole, preservando la soddisfacibilità.
]

Questo lemma in realtà è un se e solo se: se rendo vera una $k$-CNF allora lo stesso assegnamento rende vera la $3$-CNF (_assegnando correttamente le variabili ausiliarie_). Il contrario vale se limitiamo la soddisfacibilità alle sole variabili non ausiliarie.

Vediamo ora il teorema molto pesante che dimostreremo oggi.

#theorem()[
  Vale $ forall k gt.eq 3 quad exists epsilon > 0 $ tale che MAX $E_k$-SAT non è $(1+epsilon)$-approssimabile.
]

Questo teorema ci dice che non possiamo avvicinarci a $1$ quanto vogliamo.

#proof([(Per $k = 3$)])[
  Scegliamo un linguaggio $L in NPC$. Viste le relazioni tra classi che abbiamo visto a inizio corso, vale $L in NP$ e quindi anche $ L in pcprq(r(n) in O(log(n)), q in NN) . $

  Per assurdo, immaginiamo di avere un algoritmo di approssimazione per MAX $E_3$-SAT che approssima con tasso di approssimazione $alpha < 1 + epsilon$, con $ epsilon = frac(1, 2q 2^q) . $

  Sia $V$ il verificatore per il linguaggio $L$. Il verificatore è non adattivo, ovvero:
  - prende in input $z in 2^*$;
  - estrae una stringa di bit random $R in 2^(r(abs(z)))$;
  - sceglie delle posizioni $i_1^(z,R), dots, i_q^(z,R)$;
  - ottiene le risposte $b_1, dots, b_q$.

  Ci convinciamo del fatto che si può scrivere una $q$-CNF, che chiamiamo $Psi_(z,R)$ soddisfacibile se e solo se $V$ accetta $z$. Questa CNF dipende dalle variabili logiche $w_0, w_1, dots$ dove $w_i$ è vera se e solo se l'$i$-esimo carattere dell'oracolo è $1$.

  Per ottenere una CNF prendo la tabella dipendente dalle variabili $w_i$ e, selezionando le righe dei _NO_, creo una CNF formata dalle variabili naturali se in quella riga sono false e dalle variabili negate se in quella riga sono vere.

  #example()[
    Nell'esempio della lezione scorsa, dove viene spiegato il PCP, la CNF risultante è $ Phi = (w_3 or w_15 or w_27) and (w_3 or not w_15 or not w_27) and (not w_3 or not w_15 or not w_27) . $
  ]

  La formula $Psi_(z,R)$ è una $q$-CNF con al massimo $2^q$ clausole, ovvero il numero combinazioni di $q$ letterali. Trasformo $Psi_(z,R)$ in una $3$-CNF $phi_(z,R)$ con al massimo $q 2^q$ clausole, per il lemma precedente. Consideriamo, per semplicità, che abbia esattamente $q 2^q$.

  Definiamo la formula $ Phi_z = and.big_(R in 2^(abs(z))) phi_(z,R) . $

  Questa è un'enorme $3$-CNF con al massimo $q 2^q 2^(r(abs(z)))$ clausole. Come prima, per semplicità, consideriamo la formula con esattamente quel numero di clausole.

  Il numero di clausole è enorme, ma è comunque polinomiale:
  - $q 2^q$ è un numero, molto grande, ma che dipende solo dal numero $q$ che definisce il linguaggio;
  - $2^r(abs(z))$ è un esponenziale di un logaritmo, quindi è un polinomio.

  Do in pasto questa formula al mio algoritmo per MAX $E_3$-SAT.

  Abbiamo due casi:
  - se $z in L$ allora $exists w$ che fa accettare $V$ con probabilità $1$, e sono soddisfatte $q 2^q 2^(r(abs(z)))$ clausole;
  - se $z in.not L$ allora $forall w$ il nostro $V$ rifiuta con probabilità $gt.eq 1/2$. Vuol dire che comunque io assegno, meno della metà dei $phi_(z,R)$ che compongono $Phi_z$ risultato soddisfatti. Andiamo a quantificare il massimo numero di clausole soddisfatte. Esso è $ underbracket(frac(q 2^q 2^(r(abs(z))), 2), "metà intere") + underbracket(frac(2^(r(abs(z))),2) (q 2^q - 1), "DA CHIEDERE") = q 2^q 2^(r(abs(z))) - frac(2^r(abs(z)), 2) . $

  Il nostro algoritmo è approssimato, quindi:
  - se $z in L$ ci verrà dato un risultato $ gt.eq frac(q 2^q 2^(r(abs(z))), 1 + epsilon) ; $
  - se $z in.not L$ ci verrà dato un risultato $ lt.eq q 2^q 2^(r(abs(z))) - frac(2^(r(abs(z))),2 ) . $

  Vediamo se questi due disequazioni danno degli insiemi che non si sovrappongono.

  Siano $A = q 2^q$ e $B = 2^(r(abs(z)))$. Per assurdo sia $ A B - B/2 > frac(A B, 1 + epsilon) , $ ovvero per assurdo i due insiemi si sovrappongono. Ma allora $ A B + A B epsilon - B/2 - B/2 epsilon - A B > 0 \ epsilon (A B - B/2) - B/2 > 0 \ 1/(2A) (A B - B/2) - B/2 > 0 \ B/2 - B/(4A) - B/2 > 0 \ -B/(4A) > 0 $ che è impossibile visto che stiamo considerando solo quantità positive.

  Ma allora i due insiemi non si sovrappongono, quindi riesco a decidere se $z$ appartiene o meno a $L$ in tempo polinomiale, ma questo non è possibile perché $P eq.not NP$.
]
