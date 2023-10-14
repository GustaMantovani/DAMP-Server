FROM ubuntu:23.10

RUN apt update && apt install -y supervisor apache2 htop nano net-tools php libapache2-mod-php php-mysql

COPY dir.conf /etc/apache2/mods-enabled/dir.conf 
COPY php.ini /etc/php/8.1/apache2/php.ini

RUN mkdir -p /var/log/supervisor
COPY supervisord.conf /etc/supervisor/conf.d/supervisord.conf

EXPOSE 80

CMD ["supervisord", "-n"]
