#!/bin/bash
set -e
sudo docker build --build-arg BUILD_STEP=1 -t=offerit/offer:tests .
sudo docker run -v $WORKSPACE:/var/jenkins offerit/offer:tests cp -r /var/cobertura /var/jenkins
# make docker cleanup after itself and delete all exited containers
sudo docker rm -v $(docker ps -a -q -f status=exited) || true