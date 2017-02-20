FROM debian:wheezy

RUN apt-get update  -y
RUN apt-get install -y nginx

RUN echo "\ndaemon off;" >> /etc/nginx/nginx.conf
RUN sed -e 's/.*sendfile on/sendfile off/' -i /etc/nginx/nginx.conf

ADD docker.localhost.conf /etc/nginx/sites-enabled/docker.localhost
RUN ln -s /etc/nginx/sites-enabled/docker.localhost /etc/nginx/sites-available # make symlink for arc to enable the site

EXPOSE 80

CMD ["/usr/sbin/nginx"]
