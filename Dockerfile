# base image
FROM pelias/baseimage
#or FROM ubuntu:bionic

# downloader apt dependencies
RUN apt-get update && apt-get install -y libc-bin rename unzip nodejs aria2 sqlite3 gdal-bin csvkit spatialite-bin

# change working dir
ENV WORKDIR /tmp
WORKDIR ${WORKDIR}

# copy package.json first to prevent npm install being rerun when only code changes
COPY ./package.json ${WORKDIR}
RUN npm install

# copy code into image
ADD . ${WORKDIR}

# run tests
#TODO RUN npm test

# run as the pelias user
USER pelias
