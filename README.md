
## Pelias Trentino

Scripts e Immagini Docker per l'elaborazione di opendata del Trentino da importare in [Pelias](https://github.com/pelias)

# Dati

* Civici comune di Trento
* Rete stradale e nomi di vie del comune di Trento
* Civici comune di Rovereto
* Rete stradale comune di Rovereto
* Civici OpenStreetMap
* Rete stradale e nomi di vie OpenStreetMap
* PDI OpenStreetMap

# Utilizzo

```
./setup.sh
./download.sh
./prepare.sh
```

# Directories
*/data* contiene dati importabili in Pelias
*/tmp* contiene dati temporanei scaricati e di pre-processamento

# Scripts

**setup.sh**
install tool indispensabili per download e trasformazione dati

**download.conf**
lista file remoti da scaricare

**download.sh**
scarica tutte le datasource ed estrae file compressi

**prepare.sh**
associa il nome della strada ad ogni civico con il *codice strada* prendendolo dal file csv
trasformazione e conversione dei dati scaricati in formato importabile in pelias

# Altri Scripts

**csvWkt2LatLon.js.js**
converte file csv con colonna geometria in format WKT in csv con colonne lat,lon (da centroide o simile)

**csv2polyline.js**
converte i file csv in formato .polyline importabile come road network in Pelias **.0sv**

# Utility 

* https://github.com/lcoandrade/OSMDownloader
  plugin qgis per scaricare parti di openstreetmap per debug:
* https://wiki.openstreetmap.org/wiki/Osmconvert


![Image](images/test_osm_comune.png)
