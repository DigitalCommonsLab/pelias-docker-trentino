# base image
#FROM pelias/baseimage
FROM ubuntu:bionic

RUN apt-get update && apt-get install -y libc-bin rename unzip nodejs npm curl aria2 sqlite3 gdal-bin csvkit spatialite-bin
RUN rm -rf /var/lib/apt/lists/*

ENV WORKDIR /code
WORKDIR ${WORKDIR}

COPY bin/* ${WORKDIR}/bin
COPY ./package.json ${WORKDIR}

RUN npm install

# run as the pelias user
#TODO create user USER pelias
