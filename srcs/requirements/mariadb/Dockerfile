FROM	debian:bullseye

RUN	apt-get update && \
	apt-get upgrade -y && \	
 	apt-get install -y  mariadb-server && \
	rm -rf /var/lib/apt/lists/*

COPY	conf/50-server.cnf	/etc/mysql/mariadb.conf.d/

COPY	mariadb.sh /mariadb.sh

RUN	chown -R mysql:mysql /var/lib/mysql

RUN	mkdir /run/mysqld && chmod +x /mariadb.sh

CMD	["/mariadb.sh"]
