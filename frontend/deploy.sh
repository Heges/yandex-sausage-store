#! /bin/bash
set -xe
sudo docker login -u ${CI_REGISTRY_USER} -p ${CI_REGISTRY_PASSWORD} ${CI_REGISTRY}
sudo docker network create -d bridge sausage_network || true
sudo docker rm -f sausage-backend || true
sudo docker run --rm --name sausage-frontend \
     --network=sausage_network -p 80:80 sausage-frontend:${VERSION} \
     "${CI_REGISTRY_IMAGE}"/sausage-frontend:${VERSION}
# #! /bin/bash
# set -xe

# sudo cp -rf sausage.conf /etc/nginx/conf.d/sausage.conf
# sudo rm -rf /home/student/sausage-store-front.tar.gz

# curl -u ${NEXUS_REPO_USER}:${NEXUS_REPO_PASS} -o sausage-store-front.tar.gz ${NEXUS_REPO_URL}/repository/${NEXUS_REPO_FRONTEND_NAME}/${VERSION}/sausage-store-${VERSION}.tar.gz
# sudo rm -rf /home/student/frontend
# tar -zxf ./sausage-store-front.tar.gz ||true
# sudo chown -R www-data:www-data ./frontend-build/frontend
# sudo mkdir -p /var/www-data/frontend
# sudo cp -rf ./frontend/* /var/www-data/frontend

# sudo systemctl daemon-reload
# sudo systemctl enable nginx
# sudo systemctl restart nginx

# sudo cp -rf ~/frontend-build/Dockerfile ~/frontend/Dockerfile
# cd ~/fronted

# docker build -t sausage-store-fronted-image:${VERSION} .
# docker run --restart=always -it -d -p 8080:80 --name=sausage-store-fronted sausage-store-fronted-image:1.0.1461668 -v ~/frontend-build/default.conf:/etc/nginx/conf.d/ sausage.conf
