#!/bin/bash

./cluster.sh uninstall
docker build -f hadoop/Dockerfile . -t fashi/hadoop:3.3.1
docker build -f spark/Dockerfile . -t fashi/spark:3.3.1
# docker rmi $(docker images -f 'dangling=true' -q)
./cluster.sh install
