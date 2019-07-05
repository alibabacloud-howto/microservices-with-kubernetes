FROM nginx

MAINTAINER howto-microservices

# nginx config
COPY ./nginx.conf /etc/nginx/conf.d/default.conf

# app source
COPY ./dist/ /var/www/html/
