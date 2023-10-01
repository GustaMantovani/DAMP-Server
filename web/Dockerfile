FROM ubuntu:latest

RUN apt update && apt install -y supervisor apache2 htop nano net-tools 

COPY dir.conf /etc/apache2/mods-enabled/dir.conf 
COPY php.ini /etc/php/8.1/apache2/php.ini

RUN mkdir -p /var/log/supervisor
COPY supervisord.conf /etc/supervisor/conf.d/supervisord.conf

EXPOSE 80

CMD ["supervisord", "-n"]
