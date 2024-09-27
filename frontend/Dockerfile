#build
FROM node:16 as builder
WORKDIR /usr/src/app
COPY . .
RUN npm install \
    && npm run build

#release
FROM nginxproxy/nginx-proxy:1.3.1-alpine
COPY --from=builder /usr/src/app/dist/frontend /usr/share/nginx/html
COPY --from=builder /usr/src/app/nginx.tmpl /app/nginx.tmpl
EXPOSE 80
