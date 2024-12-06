FROM node:16.20.0-alpine3.18 as builder
WORKDIR /usr/src/app
COPY . .
RUN npm install
RUN npm run build

FROM nginxproxy/nginx-proxy:1.3.1-alpine
COPY --from=builder /usr/src/app/nginx.tmpl /app/nginx.tmpl
COPY --from=builder /usr/src/app/dist/frontend /usr/share/nginx/html
EXPOSE 80