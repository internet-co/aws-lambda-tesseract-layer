#!/bin/bash -x

set -e

rm -rf layer
docker build -t tess/ocr_layer .
CONTAINER=$(docker run -d tess/ocr_layer false)
docker cp $CONTAINER:/root/tesseract-standalone layer
docker rm $CONTAINER