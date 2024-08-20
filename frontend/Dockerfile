FROM node:16.20.0-alpine3.18 as builder
WORKDIR /opt
COPY . .
RUN npm install
RUN npm run build

FROM nginx:stable-alpine3.19-slim
WORKDIR /sausage-store
COPY default.conf /etc/nginx/conf.d/default.conf
COPY --from=builder /opt/dist/frontend ./frontend
EXPOSE 80
