#!/bin/bash

TMP="./tmp/"
DATA="./data/"

echo "Download files..."
rm -fr "${TMP}*"
#rm -fr "${TMP}TRENTO_CIVICI_SHP.zip" "${TMP}TRENTO_STRADE_SHP.zip" "${TMP}ROVERETO_CIVICI_SHP.zip" "${TMP}ROVERETO_STRADE_SHP.zip" "${TMP}trento_strade_nomi.csv"

> download.log
aria2c -i download.conf -d $TMP -l download.log -x 8 --auto-file-renaming=false -c

#ls -1 $TMP

#extract compressed
unzip -d "${TMP}TRENTO_CIVICI_SHP" "${TMP}TRENTO_CIVICI_SHP.zip"
unzip -d "${TMP}TRENTO_STRADE_SHP" "${TMP}TRENTO_STRADE_SHP.zip"

mv "${TMP}TRENTO_STRADE_NOMI.csv" "${TMP}trento_strade_nomi.csv"

unzip -d "${TMP}ROVERETO_CIVICI_SHP" "${TMP}ROVERETO_CIVICI_SHP.zip"
unzip -d "${TMP}ROVERETO_STRADE_SHP" "${TMP}ROVERETO_STRADE_SHP.zip"

rm -fr "${TMP}TRENTO_CIVICI_SHP.zip" "${TMP}TRENTO_STRADE_SHP.zip" "${TMP}ROVERETO_CIVICI_SHP.zip" "${TMP}ROVERETO_STRADE_SHP.zip"
