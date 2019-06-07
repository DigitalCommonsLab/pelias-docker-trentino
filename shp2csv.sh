#!/bin/bash

#SOURCE SHP
CIVICI_SHP="http://webapps.comune.trento.it/cartografia/gis/dbexport?db=base&sc=toponomastica&ly=civici_web&fr=shp"
#
#
#ogrinfo  $1
DB=tmp.sqlite
OUT=out.csv
INCSV=strade_comune_trento.csv
INSHP=shapes_4326/grafo_web	

if [ ! -f $OUT ]; then

	rm -f $DB

	#import geometries
	spatialite_tool -i -shp $INSHP -d $DB -c UTF-8 -t shp -s 4326 -g geom

	#import names
	echo -e ".mode csv\n.separator ,\n.import $INCSV csv" | sqlite3 $DB

	#echo $2
	#TODO import nomi giusti da csv spatialite_tool -i -shp $1 -d $1.sqlite -t shape -s 4326 -g geom -c UTF-8

	echo -e ".header on\n.mode csv\nSELECT (Appellativo||' '||Prenome||' '||Denominazione) AS name, AsWKT(geom) AS geom FROM shp,csv WHERE codice = CAST('Codice via' AS INTEGER);" | spatialite $DB > $OUT

	#spatialite_tool -e -d $1 -t shape -g geom -k -type LINESTRING

fi
