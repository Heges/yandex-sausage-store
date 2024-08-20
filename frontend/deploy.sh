#! /bin/bash
set -xe
cd /home/student/frontend-build
sudo cp -rf frontend-build/sausage.conf /etc/nginx/conf.d/sausage.conf
sudo rm -rf /home/student/frontend-build/sausage-store-front.tar.gz

curl -u ${NEXUS_REPO_USER}:${NEXUS_REPO_PASS} -o sausage-store-front.tar.gz ${NEXUS_REPO_URL}/repository/${NEXUS_REPO_FRONTEND_NAME}/${VERSION}/sausage-store-${VERSION}.tar.gz
sudo rm -rf /home/student/frontend-build/frontend
tar -zxf ./frontend-build/sausage-store-front.tar.gz ||true
sudo chown -R www-data:www-data ./frontend-build/frontend
sudo mkdir -p /var/www-data/frontend
sudo cp -rf ./frontend-build/frontend/* /var/www-data/frontend
sudo cp -rf ~/frontend-build/Dockerfile ~/frontend/frontend-build/Dockerfile

sudo systemctl daemon-reload
sudo systemctl enable nginx
sudo systemctl restart nginx

cd ~/frontend-build/fronted

docker build -t sausage-store-fronted-image:${VERSION}
docker run --restart=always -p 9999:8080 --name=sausage-store-fronted sausage-store-fronted-image:${VERSION}
