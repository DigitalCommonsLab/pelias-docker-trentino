#!/bin/bash

docker build -t pelias-importer-trentino-opendata .
docker tag pelias-importer-trentino-opendata stefcud/pelias-importer-trentino-opendata:master
#docker push stefcud/pelias-importer-trentino-opendata:master
