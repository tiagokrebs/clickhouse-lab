# Clickhouse Lab

Place to ~~brake~~ test things before send to the production cluster ¯\\_(ツ)_/¯

- standalone: 1 shard, no replicas, no zookeeper, 1 node
- sharded-replicated cluster: 2 shards, 2 replicas, zookeeper, 4 nodes

```
docker-compose up -d
```

```
$ ./cli.sh 
ClickHouse client version 21.9.3.30 (official build).
Connecting to server1:9000 as user default.
Connected to ClickHouse server version 21.9.3 revision 54449.

server1 :)
```
