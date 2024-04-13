FROM mysql:latest

COPY migrate/* /docker-entrypoint-initdb.d/

ENV MYSQL_DATABASE=feedback MYSQL_ROOT_PASSWORD=pass
