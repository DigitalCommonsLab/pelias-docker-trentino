#!/bin/bash

TAG=$(git tag)

docker build -t pelias-importer-trentino-opendata .
docker tag pelias-importer-trentino-opendata stefcud/pelias-importer-trentino-opendata:$TAG
docker push stefcud/pelias-importer-trentino-opendata:$TAG
