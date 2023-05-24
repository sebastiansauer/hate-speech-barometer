---
title: "The hate-speech barometer template: A tutorial on design and setup"
authors: Sebastian Sauer, Alexander Piazza, Sigurd Schacht
---


# Hintergrund

- Hate-speech ist Problem für Online-Sicherheit
- [Schaden durch Hate-Speech quantifizieren?]
- Hate-Speech vergiften den Diskurs in den sozialen Medien, das ist eine Gefahr für die offene Gesellschaft.


# Theoretische Grundlagen

## State-of-the-Art der Hate-Speech-Forschung

- [Überblick geben]
- Wettrüsten zwischen Hatern und Hate-Abwehrern
- Fortschritte im Bereich Deep Learning haben die Hate-Speech-Erkennung deutlich verbessert [Papers zum Beleg anführen]
- [Einfluss von Generativen Textmodelle wie ChatGPT?]
- Verwandte Themen wie Bot-Detektion
- Falsch-Positive und Falsch-Negative Fehler in der Hate-Speech-Detektion: Beide bedeutsam


## Grundideen des ML

- Identifikation statistischer Zusammenhänge (Muster)
- Vorhersagen (Regression, Klassifikation) auf dieser Basis
- Overfitting bei flexiblen Modellen
- Abwehr von Overfitting  (neue Samples und Modell-Vereinfachung)
- Blackbox und Explainable AI


# Forschungslücke

- Es fehlt ein einfach zu handhabendes Tool, das State-of-the-Art-Methoden der Hate-Speech-Detektion verwendet.


# Nutzen, Ziel 

- Ziel dieser Arbeit ist es, so ein Tool bereitzustellen.
- Zielgruppe sind angewandte Forschende der Sozialwissenschaften mit einem mittleren Niveau an technischem Wissen.
- Im Sinne einer "Vorlage" (Template) soll dieses Tool den Forschenden die Arbeit zur Entwicklung einer entsprechenden technischen Infrastruktur abnehmen.
- Der Ablauf einer Hate-Speech-Analyse (oder zumindest eine Variante davon) lässt sich glücklicherweise recht einfach aufschreiben und damit automatisieren.
- Angewandte Forschende können sich damit auf inhaltliche Aspekte konzentrieren.
- Wir sind der Auffassung, dass somit ein Beitrag zum Fortschritt geleistet wird: Der Erfolg der Wissenschaft beruht (auch) wesentlich auf der Idee des "On the Shoulders of Giants", also des Aufbauens auf bestehenden Ideen. Im Gegensatz dazu wäre es Ressourcenverschwendung, jedes Mal das "Rad neu zu erfinden".


# Design des Hate-Speech-Barometers

- Das Hate-Speech-Barometer ist eine klassische Analyse des Maschinen-Lernens.
- Es werden verschiedene Modelle (im Train-Sample) mit Tuning berechnet und kreuzvalidiert und dann (im Test-Sample) vorhergesagt.
- Die Analysen sind in der Programmiersprache R angelegt.


# Gestaltungsprinzipien

## Reproduzierbarkeit

- Die Analyse ist skriptbasiert; der Quelltext ist vorhanden.
- Die Syntax ist quelloffen.
- Das Projekt hat eine permissive Syntax [MIT?].
- Durch die Versionierung mit Git sind Änderungen im Quellcode gut nachvollziehbar.
- Es wird ein Paketmanagement-System (renv) verwendet, so dass sichergestellt ist, dass die richtigen Versionen der R-Pakete im Projekt vorhanden sind.
- Die Daten sind offen verfügbar (Deutsche Textdaten, ähnlich im Aufbau zu Tweets).


## State-of-the-Art

- Tidymodels: Das ML-Ökosystem "Tidymodels" wurde als Rahmen für das Maschinenlernen verwendet. Tidymodels ist eine Sammlung von R-Paketen zum ML (in aktiver Entwicklung), das auf sog. "Tidy-Prinzipien" beruht, basierend auf dem "Tidyverse"-Konzept in R. Tidymodels bietet drei zentrale Nutzen: 1) Eine vereinheitlichte Syntax (API) für alle Lernalgorithmen des ML; 2) Aktuelle Methoden des ML sind implementiert ; 3) einfache Verwendung.
- Parallelisierung: Im Hate-Speech-Barometer ist die Verwendung mehrerer Kerne oder sogar Cluster problemlos möglich.
- Projektmanagement: Moderne Projektmanagement-Tools für funktionale Programmierung nach dem Vorbild von "Make" und Paketverwaltung kommen zum Einsatz.

### Beispiele für Features von Tidymodels:

- Grid Search Methoden des Tuning wie Simulated Annealing oder ANOVA Races
- Outer und Inner Loop im Kreuzvalidieren
- "Rezepte" die die Vorverarbeitung bündeln und auf das Test-Sample anwenden
- Einfache Handhabung typischer Erfordernisse des ML wie Dummysierung oder (z-)Skalierung von Daten
- Breites Angebot an vorbereiteter Schritte der Vorverarbeitung wie Box-Cox- oder Yeo-Johnson-Transformation (nützlich für schiefe metrische Variablen)
- Mehrere Methoden zur Enkodierung von nominalen (Faktor-)Variablen (wie Effektkodierung)
- Möglichkeiten, um unbekannte Faktorstufen im Test-Sample aufzufangen oder Faktorstufen zusammenzufassen
- Over- und Under-Sampling bei Klassenimbalance


### Targets

- Targets ist ein Pipeline-Tool; solche Tools koordinieren den Ablauf komplexer und/oder rechenaufwändiger Analysen.
- Targets ist ein von GNU-Make inspiertes Verfahren für Datenanalysen mit R.
- Ein zentrales Feature ist, dass bereits aktuelle Objekte der Pipeline nicht neu berechnet werden. Targets prüft, welche Objekte ("Targets") aktuell sind und aktualisiert (nur) bei Bedarf. 
- Damit wird die Analyse nicht nur schneller zu bearbeiten (kürzere Rechenzeiten), sondern auch (und das ist vielleicht wichtiger) zuverlässiger, da sichergestellt ist, dass die Objekte aktuell sind.
- Targets ist dem Paradigma des funktionalen Programmierens zugeordnet. Es passt damit gut zur R-Welt und leitet zum übersichtlichen, enkapsulierten Programmieren an.


## Einfache Bedienung

- Der Zugang ist via Github einfach zu bewerkstelligen.
- Das Paketmanagement-System "targets" erlaubt es, komplexe Pipelines übersichtlich zu gestalten.
- Alle Analysen sind schon entwickelt, aber das System im einfach weiterzuentwickeln.
- Mehrere Git-Branches erlauben Varianten des Projekts zu verwenden.
- Durch eine Textdatei zur Konfiguration ist das Projekt einfach auf eigene Spezifikationen (z.B. vorhandene Rechenpower) anzupassen.



# Beschreibung der Pipeline


- Abb. X visualisiert die Pipeline.
- Tab. X gibt einen Überblick über alle Schritte der Pipeline.

## Schritte der Pipeline

### Vorverarbeitung


### Modellierung


### Klassifikation von Tweets



## Konstanten

Die gesetzten Konstanten sind hier dargestellt (config.yml).


## Varianten der Pipeline



# Limitationen

- Dokumentation noch im Aufbau
- Noch kein Deep Learning implementiert, ist aber geplant
- Eine Vielzahl von Tools wird verwendet, was Anforderungen an das technische Knowhow der Nutzer:innen stellt.
- Nicht-interaktive Ansätze (wie funktionale Programmierung) ist schwieriger zu debuggen.
- [Alternative Projekte mit ähnlicher Zielsetzung?]










