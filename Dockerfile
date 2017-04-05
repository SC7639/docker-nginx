FROM debian:jessie

# Add nginx debian repo and install nginx
RUN apt-get update && apt-get install wget -y && wget http://nginx.org/keys/nginx_signing.key && apt-key add nginx_signing.key && apt-get remove wget -y
RUN echo "deb http://nginx.org/packages/mainline/debian/ jessie nginx" >> /etc/apt/sources.list && echo "deb-src http://nginx.org/packages/mainline/debian/ jessie nginx" >> /etc/apt/sources.list
RUN apt-get update && apt-get install nginx -y

RUN echo "\ndaemon off;" >> /etc/nginx/nginx.conf
RUN sed -e 's/.*sendfile.*on/sendfile off/' -i /etc/nginx/nginx.conf
RUN sed -e 's/.*include \/etc\/nginx\/conf.d\/\*.conf;/    include \/etc\/nginx\/conf.d\/\*.conf;\n    include \/etc\/nginx\/sites-enabled\/\*;/' -i /etc/nginx/nginx.conf
RUN sed -e 's/.*\#gzip  on;/gzip  on;/' -i /etc/nginx/nginx.conf
RUN sed -e 's/.*worker_processes  1;/worker_processes  4;/' -i /etc/nginx/nginx.conf
# RUN sed -e 's/.*\keepalive_timeout.*/    keepalive_timeout  0;/' -i /etc/nginx/nginx.conf

ADD docker.localhost.conf /etc/nginx/sites-available/docker.localhost
RUN mkdir /etc/nginx/sites-enabled && ln -s /etc/nginx/sites-available/docker.localhost /etc/nginx/sites-enabled/ # make symlink for arc to enable the site

EXPOSE 80

CMD ["/usr/sbin/nginx"]
