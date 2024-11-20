FROM maven:3.9.3-eclipse-temurin-20-alpine as builder
ARG VERSION
ARG VAULT_TOKEN
ENV VAULT_TOKEN=${VAULT_TOKEN}
WORKDIR /usr/src/app
COPY ./src ./src
COPY *.xml ./
RUN wget -O YandexInternalRootCA.crt https://storage.yandexcloud.net/cloud-certs/CA.pem \
    && mvn package -Dversion.application=${VERSION} -Dmaven.test.skip=true -e -X \
    && ls -la /usr/src/app/target

FROM bellsoft/liberica-runtime-container:jre-17-slim-musl
ARG VERSION
ARG VAULT_TOKEN
ENV VAULT_TOKEN=${VAULT_TOKEN}
RUN addgroup --system backend-report \
    && adduser -S -s /bin/false -G backend-report backend-report -D -H \
    && mkdir -p /app \
    && chown -R backend-report:backend-report /app
WORKDIR /app   
COPY --from=builder /usr/src/app/YandexInternalRootCA.crt /home/backend-report/YandexInternalRootCA.crt
RUN chmod 644 /home/backend-report/YandexInternalRootCA.crt \
    && chown backend-report:backend-report /home/backend-report/YandexInternalRootCA.crt \
    && keytool -importcert -file /home/backend-report/YandexInternalRootCA.crt \
    -alias yandex -cacerts -storepass changeit -noprompt

COPY --chown=backend-report:backend-report \
     --from=builder /usr/src/app/target/sausage-store-report-${VERSION}.jar ./sausage-store-report.jar

EXPOSE 8080
USER backend-report   
ENTRYPOINT ["java", "-jar", "-Dmyserver.bindPort=8080", "/app/sausage-store-report.jar"]
