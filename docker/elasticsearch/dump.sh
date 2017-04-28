#!/bin/bash

function replicateESIndex() {
    IN_HOST=$1
    OUT_HOST=$2
    IDX_NAME=$3

    elasticdump --input=http://${IN_HOST}:80/${IDX_NAME} \
                --output=http://${OUT_HOST}:9200/${IDX_NAME} \
                --type=analyzer

    elasticdump --input=http://${IN_HOST}:80/${IDX_NAME} \
                --output=http://${OUT_HOST}:9200/${IDX_NAME} \
                --type=mapping

    elasticdump --input=http://${IN_HOST}:80/${IDX_NAME} \
                --output=http://${OUT_HOST}:9200/${IDX_NAME} \
                --type=data
}

function backupESIndex() {
    IN_HOST=$1
    IDX_NAME=$2

    if [ ! -d ${IN_HOST} ]; then
        mkdir ${IN_HOST}
    fi
    cd ${IN_HOST}

    if [ -d ${IDX_NAME} ]; then
        rm -rf ${IDX_NAME}
    fi
    mkdir ${IDX_NAME}

    # Backup index data to a file:
    elasticdump --input=http://${IN_HOST}:80/${IDX_NAME} \
                --output=${IDX_NAME}/mapping.json \
                --type=mapping

    elasticdump --input=http://${IN_HOST}:80/${IDX_NAME} \
                --output=${IDX_NAME}/data.json \
                --type=data
    cd -
}

replicateESIndex dev-ma.search.elastic-search.wdsds.net localhost movie
replicateESIndex dev-ma.search.elastic-search.wdsds.net localhost cast
replicateESIndex dev-ma.search.elastic-search.wdsds.net localhost genre
replicateESIndex dev-ma.search.elastic-search.wdsds.net localhost video

#backupESIndex dev-ma.search.elastic-search.wdsds.net movie
#backupESIndex dev-ma.search.elastic-search.wdsds.net cast
#backupESIndex dev-ma.search.elastic-search.wdsds.net genre
#backupESIndex dev-ma.search.elastic-search.wdsds.net video
