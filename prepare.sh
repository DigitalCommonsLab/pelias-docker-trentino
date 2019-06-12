#!/bin/bash
#

TMP="./tmp/"
TMPDB="${TMP}tmp.sqlite"
DATA="./data/"

if [ -f $TMPDB ]; then
	rm -f $TMPDB
fi

#civici
CSV1="${TMP}trento_civici.csv"
rm -f $CSV1
ogr2ogr -f "CSV" -lco GEOMETRY=AS_XY -s_srs EPSG:3044 -t_srs EPSG:4326 $CSV1 "${TMP}TRENTO_CIVICI_SHP/civici_web.shp"

#strade geometrie
CSV_STRADE="${TMP}trento_strade_geom.csv"
rm -f $CSV_STRADE
ogr2ogr -f "CSV" -lco GEOMETRY=AS_WKT -s_srs EPSG:3044 -t_srs EPSG:4326 $CSV_STRADE "${TMP}TRENTO_STRADE_SHP/grafo_web.shp"
##linestring WKT

CSV_NOMI="${TMP}trento_strade_nomi.csv"
##quoteall
csvformat -U 1 "${TMP}TRENTO_STRADE_NOMI.csv" > $CSV_NOMI


#
#import geometries
#spatialite_tool -i -shp $INSHP -d $DB -c UTF-8 -t shp -s 4326 -g geom

#import names
#echo -e ".mode csv\n.separator ,\n.import $INCSV csv" | sqlite3 $DB

#echo $2
#TODO import nomi giusti da csv spatialite_tool -i -shp $1 -d $1.sqlite -t shape -s 4326 -g geom -c UTF-8

#echo -e ".header on\n.mode csv\nSELECT (Appellativo||' '||Prenome||' '||Denominazione) AS name, AsWKT(geom) AS geom FROM shp,csv WHERE codice = CAST('Codice via' AS INTEGER);" | spatialite $DB > $OUT

#spatialite_tool -e -d $1 -t shape -g geom -k -type LINESTRING


#generate pelias polyline
node csv2polyline.js $CSV_STRADE > "${DATA}trento_strade.0sv"
