FROM	debian:bullseye

RUN	apt-get update && apt-get upgrade -y

Run	apt-get install mariadb-server -y

COPY	conf/50-server.cnf	/etc/mysql/mariadb.conf.d/50-server.cnf

COPY	conf/auto_config.sh /auto_config.sh

ENTRYPOINT ["bash", "auto_config.sh"]

EXPOSE 3306
