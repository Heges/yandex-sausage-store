FROM maven:3.9.3-eclipse-temurin-20-alpine as builder
ARG VERSION
ARG VAULT_TOKEN
ENV VAULT_TOKEN=${VAULT_TOKEN}
WORKDIR /usr/src/app
COPY ./src ./src
COPY *.xml ./
RUN wget -O YandexInternalRootCA.crt https://storage.yandexcloud.net/cloud-certs/CA.pem \
    && mvn package -Dversion.application=${VERSION} -Dmaven.test.skip=true

FROM openjdk:17-jdk-alpine
ARG VERSION
ARG VAULT_TOKEN
ENV VAULT_TOKEN=${VAULT_TOKEN}
RUN addgroup --system backend \
    && adduser -S -s /bin/false -G backend backend -D -H \
    && mkdir -p /app \
    && chown -R backend:backend /app \
    && mkdir -p /home/backend/.postgresql \
    && chown -R backend:backend /home/backend/
WORKDIR /app
COPY --from=builder /usr/src/app/YandexInternalRootCA.crt /home/backend/.postgresql/root.crt 
RUN apk add --no-cache curl \
    && chmod 644 /home/backend/.postgresql/root.crt \
    && chown backend:backend /home/backend/.postgresql/root.crt \
    && keytool -importcert -file /home/backend/.postgresql/root.crt \
    -alias yandex -cacerts -storepass changeit -noprompt

COPY --chown=backend:backend \
     --from=builder /usr/src/app/target/sausage-store-${VERSION}.jar ./sausage-store.jar
EXPOSE 8080
USER backend
ENTRYPOINT ["java", "-jar", "-Dmyserver.bindPort=8080", "/app/sausage-store.jar"]