FROM nginx:alpine

COPY nginx.conf /etc/nginx/conf.d/default.conf
COPY cores/ /usr/share/nginx/html/cores/

RUN chmod -R 755 /usr/share/nginx/html/cores
