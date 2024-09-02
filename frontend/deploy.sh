#! /bin/bash
set -xe
sudo docker login -u ${CI_REGISTRY_USER} -p ${CI_REGISTRY_PASSWORD} ${CI_REGISTRY}
sudo docker rm -f sausage-frontend || true
sudo docker run -d --name sausage-frontend \
     -p 80:80 \
	 --network=sausage_network \
     "${CI_REGISTRY_IMAGE}"/sausage-frontend:${VERSION}
