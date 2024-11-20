# Sausage Reporter

## Installation

1. Install `Java` and `maven`
2. Run `mvn package`
3. Set environment variables `PORT` and `DB`
4. Run `java -jar target/sausage-store-report-1.0.0.jar`

Example: `PORT=8080 DB=mongodb://localhost:27017/reports java -jar target/sausage-store-report-1.0.0.jar`

## Health endpoint

Application exposes `/actuator/health` endpoint according to the 12-factors app

## Testing

Run unit tests via `mvn test`

## Local testing with docker and local mongoDB

```bash
docker build -t sausage-reporter .
docker run -d --name mongo -p 27017:27017 mongo
docker run --name sausage-reporter -ti -e PORT=8080 -e DB=mongodb://host.docker.internal:27017/reports -p 8080:8080 sausage-reporter
```
