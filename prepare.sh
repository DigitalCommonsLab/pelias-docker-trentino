#!/bin/bash
#

TMP="./tmp/"
TMPDB="${TMP}tmp.sqlite"
DATA="./data/"

if [ -f $TMPDB ]; then
	rm -f $TMPDB
fi

#civici
CSV_CIV="${TMP}trento_civici_geom.csv"
rm -f $CSV_CIV
ogr2ogr -f "CSV" -lco GEOMETRY=AS_XY -s_srs EPSG:3044 -t_srs EPSG:4326 $CSV_CIV "${TMP}TRENTO_CIVICI_SHP/civici_web.shp"
##contains columns X,Y as lon,lat
##quoteall
mv $CSV_CIV "$CSV_CIV.tmp"
csvformat -U 1 "$CSV_CIV.tmp" > $CSV_CIV
rm -f "$CSV_CIV.tmp"

#strade geometrie
CSV_STRADE="${TMP}trento_strade_geom.csv"
rm -f $CSV_STRADE
ogr2ogr -f "CSV" -lco GEOMETRY=AS_WKT -s_srs EPSG:3044 -t_srs EPSG:4326 $CSV_STRADE "${TMP}TRENTO_STRADE_SHP/grafo_web.shp"
##contains column "WKT" as a WKT LineString
#quoteall
mv $CSV_STRADE "$CSV_STRADE.tmp"
csvformat -U 1 "$CSV_STRADE.tmp" > $CSV_STRADE
rm -f "$CSV_STRADE.tmp"


#convert to utf8
echo "convert to utf8..."
mv "${TMP}TRENTO_STRADE_NOMI.csv" "${TMP}TRENTO_STRADE_NOMI.win.csv"
iconv -f WINDOWS-1252 -t UTF-8//TRANSLIT "${TMP}TRENTO_STRADE_NOMI.win.csv" -o "${TMP}TRENTO_STRADE_NOMI.utf.csv"
#quoteall
csvformat -U 1 "${TMP}TRENTO_STRADE_NOMI.utf.csv" > "${TMP}TRENTO_STRADE_NOMI.csv"



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
echo "generate polyline file..."
node csv2polyline.js $CSV_STRADE > "${DATA}trento_strade_polyline.0sv"
