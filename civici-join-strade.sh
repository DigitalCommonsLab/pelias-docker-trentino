#!/bin/bash

#use csvkit via pip
##sudo pip install csvkit

csvjoin -c "strada,Codice_via" trento_civici.csv trento_strade.csv > join.csv
csvcut -c "x,y,civico_num,cap,Appellativo,Prenome,Denominazione" join.csv > cut.csv

##quoteall
csvformat -U 1 cut.csv > format.csv

#rename column in pelias format
#https://github.com/pelias/csv-importer#overview
cat format.csv | csvsql --query "SELECT x AS lat,y AS lon,civico_num AS number,cap AS zipcode, Appellativo||' '||Prenome||' '||Denominazione AS street FROM stdin" > out.csv
