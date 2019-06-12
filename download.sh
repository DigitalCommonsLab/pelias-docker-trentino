#!/bin/bash

TMP="./tmp/"
DATA="./data/"

echo "Download files..."
rm -fr $TMP/*
> download.log
aria2c -i download.conf -d $TMP -l download.log -x 8 --auto-file-renaming=false -c

ls -1 $TMP

#extract compressed
unzip -d "${TMP}TRENTO_CIVICI_SHP" "${TMP}TRENTO_CIVICI_SHP.zip"
unzip -d "${TMP}TRENTO_STRADE_SHP" "${TMP}TRENTO_STRADE_SHP.zip"

#convert to utf8
mv "${TMP}TRENTO_STRADE_NOMI.csv" "${TMP}TRENTO_STRADE_NOMI.win.csv"
iconv -f WINDOWS-1252 -t UTF-8//TRANSLIT "${TMP}TRENTO_STRADE_NOMI.win.csv" -o "${TMP}TRENTO_STRADE_NOMI.csv"

mv "${TMP}TRENTO_STRADE_NOMI.utf.csv" "${TMP}TRENTO_STRADE_NOMI.csv"