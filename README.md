
![Image](images/test_osm_comune.png)

il file:
*trento_civici_con_nomi_strade.csv*
**lat,lon,number,alfa,zipcode,street**

# Uso

```
npm install
```

# Scripts

*shp2csv.sh*
converte shape file scaricati dal comune in un file CSV con due colonne:
```name, geom```

*join-civici-nomistrade.sh*
associa il nome della strada ad ogni civico con il *codice strada* prendendolo dal file csv

geom contiene la definizione della geometria in WKT:
```LINESTRING([ [lat1,lon1],[lat2,lon2], ...])```
