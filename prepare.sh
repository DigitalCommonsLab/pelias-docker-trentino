#!/bin/bash
#
TMP="./tmp/"
TMPDB="${TMP}tmp.sqlite"
DATA="./data/"

CSV_CIV="${TMP}trento_civici.csv"
CSV_STRADE="${TMP}trento_strade.csv"
CSV_NOMI="${TMP}trento_strade_nomi.csv"

if [ -f $TMPDB ]; then
	rm -f $TMPDB
fi

#civici
rm -f $CSV_CIV
ogr2ogr -f "CSV" -lco GEOMETRY=AS_XY -s_srs EPSG:3044 -t_srs EPSG:4326 $CSV_CIV "${TMP}TRENTO_CIVICI_SHP/civici_web.shp"
##contains columns X,Y as lon,lat
##quoteall
mv $CSV_CIV "$CSV_CIV.tmp"
csvformat -U 1 "$CSV_CIV.tmp" > $CSV_CIV
rm -f "$CSV_CIV.tmp"

#strade geometrie
rm -f $CSV_STRADE
ogr2ogr -f "CSV" -lco GEOMETRY=AS_WKT -s_srs EPSG:3044 -t_srs EPSG:4326 $CSV_STRADE "${TMP}TRENTO_STRADE_SHP/grafo_web.shp"
##contains column "WKT" as a WKT LineString
#quoteall
mv $CSV_STRADE "$CSV_STRADE.tmp"
csvformat -U 1 "$CSV_STRADE.tmp" > $CSV_STRADE
rm -f "$CSV_STRADE.tmp"

#strade nomi
echo "convert to utf8..."
mv $CSV_NOMI "${TMP}TRENTO_STRADE_NOMI.win.csv"
iconv -f WINDOWS-1252 -t UTF-8//TRANSLIT "${TMP}TRENTO_STRADE_NOMI.win.csv" -o "${TMP}TRENTO_STRADE_NOMI.utf.csv"
#quoteall, tab delimited char
csvformat --tabs -U 1 "${TMP}TRENTO_STRADE_NOMI.utf.csv" > $CSV_NOMI

#import geometries
#spatialite_tool -i -shp $INSHP -d $TMPDB -c UTF-8 -t shp -s 4326 -g geom

echo -e ".mode csv\n.separator ,\n.import ${CSV_CIV} trento_civici" | sqlite3 $TMPDB
echo -e ".mode csv\n.separator ,\n.import ${CSV_STRADE} trento_strade" | sqlite3 $TMPDB
echo -e ".mode csv\n.separator ,\n.import ${CSV_NOMI} trento_strade_nomi" | sqlite3 $TMPDB

#echo $2
#TODO import nomi giusti da csv spatialite_tool -i -shp $1 -d $1.sqlite -t shape -s 4326 -g geom -c UTF-8

#echo -e ".header on\n.mode csv\nSELECT (Appellativo||' '||Prenome||' '||Denominazione) AS name, AsWKT(geom) AS geom FROM shp,csv WHERE codice = CAST('Codice via' AS INTEGER);" | spatialite $TMPDB > $OUT

#spatialite_tool -e -d $1 -t shape -g geom -k -type LINESTRING


#generate pelias polyline
#echo "generate polyline file..."
#node csv2polyline.js $CSV_STRADE > "${DATA}trento_strade_polyline.0sv"
