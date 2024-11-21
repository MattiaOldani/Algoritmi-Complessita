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


= Lezione 13 [21/11]

Oggi si implementa e basta.

Non posso comprimere la prima tabella perché le righe mi danno l'*ammissibilità*: se comprimo potrei ottenere soluzioni che nella compressa vanno bene ma non vanno bene in quella normale.

Per le soluzioni esatte, visto che uso sempre la colonna prima, posso tenere in memoria solo questa e costruire mano a mano quella corrente. Non mi cambia il tempo ma lo spazio.
