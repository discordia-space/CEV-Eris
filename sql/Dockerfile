FROM mysql:8.0

COPY migrate/* /docker-entrypoint-initdb.d/

ENV MYSQL_DATABASE=feedback MYSQL_ROOT_PASSWORD=pass
