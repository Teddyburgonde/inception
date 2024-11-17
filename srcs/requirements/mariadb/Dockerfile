FROM	debian:bullseye

RUN	apt-get update && \
	apt-get upgrade -y && \	
 	apt-get install -y  mariadb-server && \
	rm -rf /var/lib/apt/lists/*

COPY	tools/mariadb.sh /mariadb.sh


RUN	chmod +x /mariadb.sh && \
    	mkdir -p /run/mysqld && \
   	chown -R mysql:mysql /var/lib/mysql

USER	mysql

ENTRYPOINT	["/mariadb.sh"]
