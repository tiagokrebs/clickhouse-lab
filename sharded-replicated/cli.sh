#!/bin/bash
docker exec -it server1 clickhouse-client --host server1 --multiquery
exit 0