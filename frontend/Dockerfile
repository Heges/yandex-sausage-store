FROM node:16.20.0-alpine3.18 as builder
WORKDIR /opt
COPY . .
RUN npm install
RUN npm run build

FROM nginx:stable-alpine3.19-slim

RUN  mkdir -p /sausage-store \ 
	&& chown -R www-data:www-data /sausage-store
	
WORKDIR /sausage-store
COPY default.conf /etc/nginx/conf.d/default.conf
COPY --chown www-data:www-data --from=builder /opt/dist/frontend ./frontend
EXPOSE 80
