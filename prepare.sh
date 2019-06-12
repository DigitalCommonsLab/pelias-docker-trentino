#!/bin/bash
#
TMP="./tmp/"
TMPDB="${TMP}db.sqlite"
DATA="./data/"

CSV_CIV="${TMP}trento_civici.csv"
CSV_STRADE="${TMP}trento_strade.csv"
CSV_NOMI="${TMP}trento_strade_nomi.csv"

rm -f $TMPDB "${DATA}.*"

#civici
rm -f $CSV_CIV
ogr2ogr -f "CSV" -lco GEOMETRY=AS_XY -s_srs EPSG:3044 -t_srs EPSG:4326 $CSV_CIV "${TMP}TRENTO_CIVICI_SHP/civici_web.shp"
##contains columns X,Y as lon,lat
##quoteall
mv $CSV_CIV "$CSV_CIV.tmp"
csvformat -U 1 "$CSV_CIV.tmp" > $CSV_CIV
#TODO ottimizzazione csvcut -c "X,Y,civico_alf,cap,strada,fumetto" $CSV_CIV > cut.csv
rm -fr "$CSV_CIV.tmp" "${TMP}TRENTO_CIVICI_SHP"

#strade geometrie
rm -f $CSV_STRADE
ogr2ogr -f "CSV" -lco GEOMETRY=AS_WKT -s_srs EPSG:3044 -t_srs EPSG:4326 $CSV_STRADE "${TMP}TRENTO_STRADE_SHP/grafo_web.shp"
##contains column "WKT" as a WKT LineString
#quoteall
mv $CSV_STRADE "$CSV_STRADE.tmp"
csvformat -U 1 "$CSV_STRADE.tmp" > $CSV_STRADE
rm -fr "$CSV_STRADE.tmp" "${TMP}TRENTO_STRADE_SHP"

#strade nomi
echo "convert to utf8..."
mv $CSV_NOMI "${TMP}TRENTO_STRADE_NOMI.win.csv"
iconv -f WINDOWS-1252 -t UTF-8//TRANSLIT "${TMP}TRENTO_STRADE_NOMI.win.csv" -o "${TMP}TRENTO_STRADE_NOMI.utf.csv"
#quoteall, tab delimited char
csvformat --tabs -U 1 "${TMP}TRENTO_STRADE_NOMI.utf.csv" > $CSV_NOMI
rm -f "${TMP}TRENTO_STRADE_NOMI.win.csv" "${TMP}TRENTO_STRADE_NOMI.utf.csv"

#import geometries
#spatialite_tool -i -shp $INSHP -d $TMPDB -c UTF-8 -t shp -s 4326 -g geom

echo -e ".mode csv\n.separator ,\n.import ${CSV_CIV} trento_civici" | sqlite3 $TMPDB
echo -e ".mode csv\n.separator ,\n.import ${CSV_STRADE} trento_strade" | sqlite3 $TMPDB
echo -e ".mode csv\n.separator ,\n.import ${CSV_NOMI} trento_strade_nomi" | sqlite3 $TMPDB
rm -f $CSV_CIV $CSV_STRADE $CSV_NOMI

SQL1="SELECT CAST(Y AS real) AS lat, CAST(X AS real) AS lon, civico_alf AS number, cap AS zipcode, Appellativo||' '||Prenome||' '||Denominazione AS street FROM trento_civici,trento_strade_nomi WHERE trento_civici.strada = trento_strade_nomi.'Codice via';"
echo -e ".header on\n.mode csv\n${SQL1}" | spatialite $TMPDB > $CSV_CIV
csvformat -U 1 $CSV_CIV > "${DATA}trento_civici.csv"
rm -f $CSV_CIV

SQL2="SELECT WKT AS geom, Appellativo||' '||Prenome||' '||Denominazione AS street FROM trento_strade,trento_strade_nomi WHERE trento_strade.codice = trento_strade_nomi.'Codice via';"
echo -e ".header on\n.mode csv\n${SQL2}" | spatialite $TMPDB > $CSV_STRADE
CSV_POLY="${TMP}trento_strade_polyline.csv"
csvformat -U 1 $CSV_STRADE > $CSV_POLY
node csv2polyline.js $CSV_POLY > "${DATA}trento_strade_polyline.0sv"
rm -f $CSV_POLY


#spatialite_tool -e -d $1 -t shape -g geom -k -type LINESTRING
#TODO import nomi giusti da csv spatialite_tool -i -shp $1 -d $1.sqlite -t shape -s 4326 -g geom -c UTF-8
#generate pelias polyline
#JOIN civici nomi
#csvjoin -c "strada,Codice_via" trento_civici.csv trento_strade.csv > join.csv
#csvcut -c "X,Y,civico_alf,cap,Appellativo,Prenome,Denominazione" join.csv > cut.csv
#rename columns in pelias openaddresses format
#non serve cat cut.csv | csvsql --query "SELECT X AS lon, Y AS lat, civico_alf AS number, cap AS zipcode, Appellativo||' '||Prenome||' '||Denominazione AS street FROM stdin" > out.csv
