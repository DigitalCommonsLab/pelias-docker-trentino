#!/bin/bash
#

TMP="./tmp/"
DATA="./data/"

if [ ! -d "$TMP" ]; then
	mkdir -p $TMP
fi

if [ ! -d "$DATA" ]; then
	mkdir -p $DATA
fi

##base utilies from ubuntu repos
#
#apt install libc-bin rename unzip nodejs aria2 sqlite3 gdal-bin csvkit spatialite-bin
echo "apt install libc-bin rename unzip nodejs aria2 sqlite3 gdal-bin csvkit spatialite-bin"
echo "npm install"