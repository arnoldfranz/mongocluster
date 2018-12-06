FROM debian:stable
RUN set -x \
	&& apt-get update \
	&& apt-get install -y libcurl3 
RUN mkdir -p /tempo
COPY mongodb-org-server_4.0.4_amd64.deb /tempo 
RUN dpkg -i /tempo/mongodb-org-server_4.0.4_amd64.deb
COPY docker-entrypoint.sh /usr/local/bin/
ENTRYPOINT ["docker-entrypoint.sh"] 
