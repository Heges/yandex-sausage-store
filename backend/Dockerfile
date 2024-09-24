FROM maven:3.9.3-eclipse-temurin-20-alpine as builder
ARG VERSION=${VERSION}
WORKDIR /usr/src/app
COPY ./src ./src
COPY *.xml ./
RUN wget -O YandexInternalRootCA.crt https://storage.yandexcloud.net/cloud-certs/CA.pem \
    && mvn package -Dversion.application=${VERSION} -Dmaven.test.skip=true

# шаг релиза
FROM ubuntu:20.04
RUN apt-get update
RUN apt-get install -y curl

FROM bellsoft/liberica-runtime-container:jre-17-slim-musl
ARG VERSION=${VERSION}
RUN  addgroup --system backend \
    && adduser -S -s /bin/false -G backend backend -D -H \
	&& mkdir -p /app \ 
	&& chown -R backend:backend /app
	
WORKDIR /app
COPY --from=builder /usr/src/app/YandexInternalRootCA.crt .

# Создание каталога для сертификата и копирование его туда

RUN mkdir -p /home/backend/.postgresql \
    && chmod 755 /home/backend/.postgresql 

COPY --from=builder /usr/src/app/YandexInternalRootCA.crt /home/backend/.postgresql/root.crt 
RUN chmod 644 /home/backend/.postgresql/root.crt \
    && chown -R backend:backend /home/backend/

RUN keytool -importcert -file YandexInternalRootCA.crt \
    -alias yandex -cacerts -storepass changeit -noprompt \
    && rm -rf YandexInternalRootCA.crt

COPY --chown=backend:backend \
     --from=builder /usr/src/app/target/sausage-store-${VERSION}.jar ./sausage-store.jar
EXPOSE 8080
USER backend
ENTRYPOINT ["java", "-jar", "-Dmyserver.bindPort=8080", "/app/sausage-store.jar"]
# CMD ["tail", "-f", "/dev/null"]
