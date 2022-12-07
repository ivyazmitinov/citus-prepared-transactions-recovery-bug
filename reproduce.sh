#!/usr/bin/env bash

docker-compose down &&\
docker-compose up -d &&\
sleep 5 &&\
psql -P pager=off -h localhost -U postgres -f configure.sql &&\
docker-compose restart && sleep 5 &&\
psql -P pager=off -h localhost -U postgres -f create_transactions_to_abort.sql &&\
docker-compose restart && sleep 5 &&\
psql -P pager=off -h localhost -U postgres -f trigger_recovery.sql
