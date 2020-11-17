FROM nginx:1.10
RUN apt-get clean && apt-get update && apt-get install -y wget software-properties-common apt-transport-https
RUN wget -qO - https://adoptopenjdk.jfrog.io/adoptopenjdk/api/gpg/key/public | apt-key add - && \
    add-apt-repository --yes https://adoptopenjdk.jfrog.io/adoptopenjdk/deb/
RUN apt-get clean && apt-get update && apt-get install -y spawn-fcgi fcgiwrap curl jq git adoptopenjdk-11-hotspot
RUN curl https://cli-assets.heroku.com/install-ubuntu.sh | sh
RUN sed -i 's/www-data/nginx/g' /etc/init.d/fcgiwrap
RUN chown nginx:nginx /etc/init.d/fcgiwrap
RUN mkdir /nonexistent && chown -R nginx:nginx /nonexistent
COPY ./conf/vhost.conf /etc/nginx/conf.d/default.conf
WORKDIR /var/www
# FIXME: Entrypoint is run as root
CMD /opt/bash-ci/bin/startup.sh \
    && /etc/init.d/fcgiwrap start \
    && nginx -g 'daemon off;'