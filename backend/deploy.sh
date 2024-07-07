#! /bin/bash
set -xe

sudo cp -rf backend.service /etc/systemd/system/backend.service
sudo rm -rf /home/jarservice/sausage-store.jar
curl -u ${NEXUS_REPO_USER}:${NEXUS_REPO_PASS} -o sausage-store.jar ${NEXUS_REPO_URL}/repository/${NEXUS_REPO_BACKEND_NAME}/com/yandex/practicum/devops/sausage-store/${VERSION}/sausage-store-${VERSION}.jar
sudo cp -rf ./sausage-store.jar /var/jarservice/sausage-store.jar

sudo systemctl daemon-reload
sudo systemctl enable backend.service
sudo systemctl restart backend.service
