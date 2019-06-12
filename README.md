
## Scripts e Immagini Docker per l'elaborazione di dati da importare in [Pelias](https://github.com/pelias)

* Civici comune di Trento
* Civici OpenStreetMap
* Rete stradale e nomi di vie del comune di Trento

# Scripts

*setup.sh*
install tool indispensabili per download e trasformazione dati

*download.conf*
lista file remoti da scaricare

*download.sh*
scarica tutte le datasource ed estrae file compressi

*prepare.sh*
trasformazione e conversione dei dati scaricati in formato importabile in pelias


# Altri Scripts

*shp2csv.sh*
converte shape file scaricati dal comune in un file CSV con due colonne:
```name, geom```
geom contiene la definizione della geometria in WKT:
```LINESTRING([ [lat1,lon1],[lat2,lon2], ...])```

*csv2polyline.js*
converte il file csv di cui sopra in formato .polyline importabile come road network in Pelias **.0sv**

*join-civici-nomistrade.sh*
associa il nome della strada ad ogni civico con il *codice strada* prendendolo dal file csv



trento_civici_con_nomi_strade.csv
**lat,lon,number,alfa,zipcode,street**

# Utility 
plugin qgis per scaricare parti di openstreetmap per debug:
https://github.com/lcoandrade/OSMDownloader

![Image](images/test_osm_comune.png)
