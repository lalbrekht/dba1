FROM ubuntu:18.04

ENV POSTGRES_SOURCES='https://ftp.postgresql.org/pub/source/v11.8/postgresql-11.8.tar.gz'
ENV PGDATA=/var/data/base

RUN apt-get update \
    && apt-get install wget curl git gcc libreadline-dev zlib1g-dev build-essential -y \
    && wget $POSTGRES_SOURCES \
    && tar -xvf postgresql-11.8.tar.gz 
RUN cd postgresql-11.8 && ./configure && make && make install

RUN useradd -m -d /home/postgres -s /bin/bash postgres \
    && mkdir -p /var/data/base \
    && chown -R postgres:postgres /var/data/base

COPY entrypoint.sh /
RUN chown postgres:postgres -R /entrypoint.sh

USER postgres

ENTRYPOINT ["/bin/bash","/entrypoint.sh"]
