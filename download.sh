#!/bin/bash

TMP="./tmp/"

#SOURCE SHP
${TMP}TRENTO_CIVICI.shp.zip
${TMP}TRENTO_STRADE_GEOM.shp.zip
${TMP}TRENTO_STRADE_NOMI.csv

OUT=out.csv
INCSV=trento_strade.csv
INSHP=shapes_4326/grafo_web	

#ogrinfo  $1
#iconv -f WINDOWS-1252 -t UTF-8//TRANSLIT strade.csv -o strade.utf.csv
