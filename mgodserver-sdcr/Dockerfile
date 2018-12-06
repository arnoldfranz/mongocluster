FROM debian:stable
RUN mkdir -p /data/conftemp 
COPY mongod.conf /data/conftemp
COPY docker-entrypoint.sh /usr/local/bin/
ENTRYPOINT ["docker-entrypoint.sh"]
