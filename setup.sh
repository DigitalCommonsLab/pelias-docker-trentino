#!/bin/bash
#

TMP="./tmp/"

if [ ! -d "$TMP" ]; then
	mkdir -p $TMP
fi

##base utilies from ubuntu repos
#
#apt install libc-bin rename unzip nodejs aria2 sqlite3 gdal-bin csvkit spatialite-bin

#npm install