#!/bin/bash
TMP="/tmp/trentino/"

cp "${TMP}trento_strade_nomi.csv" "${TMP}TRENTO_STRADE_NOMI2.csv"

#sed -i -e 's/\xe0//g' "${TMP}TRENTO_STRADE_NOMI2.csv"
#sed -i -e 's/\u0160//g' "${TMP}TRENTO_STRADE_NOMI2.csv"

sed -i -e 's/[\d128-\d255]//g' "${TMP}TRENTO_STRADE_NOMI.csv"
sed -i -e 's/\x1a//g' "${TMP}TRENTO_STRADE_NOMI.csv"
sed -i -e 's/\u0160//g' "${TMP}TRENTO_STRADE_NOMI.csv"

iconv -f WINDOWS-1252 -t UTF-8//TRANSLIT "${TMP}TRENTO_STRADE_NOMI2.csv" -o "out.csv"

