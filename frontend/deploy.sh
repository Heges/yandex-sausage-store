#! /bin/bash
set -xe

sudo cp -rf sausage.conf /etc/nginx/conf.d/sausage.conf
sudo rm -rf /home/student/sausage-store-front.tar.gz
cd /home/student
curl -u ${NEXUS_REPO_USER}:${NEXUS_REPO_PASS} -o sausage-store-front.tar.gz ${NEXUS_REPO_URL}/repository/${NEXUS_REPO_FRONTEND_NAME}/${VERSION}/sausage-store-${VERSION}.tar.gz
sudo rm -rf /home/student/frontend
tar -zxf ./sausage-store-front.tar.gz ||true
sudo chown -R www-data:www-data ./frontend
sudo mkdir -p /var/www-data/frontend
sudo cp -rf ./frontend/* /var/www-data/frontend

sudo systemctl daemon-reload
sudo systemctl enable nginx
sudo systemctl restart nginx