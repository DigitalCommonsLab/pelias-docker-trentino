#!/bin/bash

#ogrinfo  $1
DB=tmp.sqlite
OUT=out.csv

rm -f $DB

#import geometries
spatialite_tool -i -shp $1 -d $DB -c UTF-8 -t shp -s 4326 -g geom

#import names
echo -e ".mode csv\n.separator ,\n.import $2 csv" | sqlite3 $DB

#echo $2
#TODO import nomi giusti da csv spatialite_tool -i -shp $1 -d $1.sqlite -t shape -s 4326 -g geom -c UTF-8

echo "SELECT (Appellativo||' '||Prenome||' '||Denominazione) AS name, AsText(geom) AS geom FROM shp,csv WHERE codice = CAST('Codice via' AS INTEGER); " | spatialite -csv $DB

#spatialite_tool -e -d $1 -t shape -g geom -k -type LINESTRING