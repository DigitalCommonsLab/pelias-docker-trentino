# base image

FROM ubuntu:bionic

RUN apt-get update

ARG DEBIAN_FRONTEND=noninteractive
#https://askubuntu.com/questions/909277/avoiding-user-interaction-with-tzdata-when-installing-certbot-in-a-docker-contai

RUN apt-get install -y libc-bin tree rename unzip nodejs npm curl aria2 sqlite3 gdal-bin csvkit spatialite-bin

RUN rm -rf /var/lib/apt/lists/*

ENV WORKDIR /code
WORKDIR ${WORKDIR}

COPY ./bin ${WORKDIR}/bin
COPY ./package.json ${WORKDIR}/bin/

RUN tree
RUN npm install --prefix ${WORKDIR}/bin/



# run as the pelias user
#TODO create user USER pelias
