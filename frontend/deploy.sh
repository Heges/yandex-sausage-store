#! /bin/bash
set -xe
sudo echo " ${CI_REGISTRY_USER} :  ${CI_REGISTRY_PASSWORD} : ${CI_REGISTRY}"
sudo docker login -u "${CI_REGISTRY_USER}" -p "${CI_REGISTRY_PASSWORD}" "${CI_REGISTRY}"
sudo docker rm -f sausage-frontend || true
sudo docker run -d --name sausage-frontend \
	 --restart=always  \
     -p 80:80 \
	 --network=sausage_network \
     "${CI_REGISTRY_IMAGE}"/sausage-frontend:${VERSION}
