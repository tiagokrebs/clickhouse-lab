# Clickhouse Lab

Place to ~~brake~~ test things.

## Clusters
- **standalone**: 1 shard, no replicas, no zookeeper, 1 standalone Clickhouse node
- **sharded-replicated**: 2 shards, 2 replicas, zookeeper, 4 Clickhouse nodes


## Working with the environments
Enter one the folders and run

```
docker-compose up -d
```
To open the CLI run

```
$ ./cli.sh 
ClickHouse client version 21.9.3.30 (official build).
Connecting to server1:9000 as user default.
Connected to ClickHouse server version 21.9.3 revision 54449.

server1 :)
```
Start looking at the `queries` folder. You should need them for some examples to work.
## Examples

Some environments have an `example` folder. It should have things from simple configurations to data processing instructions for a certain test dataset.

Examples:
- [Starter Access Control Management (Standalone)](standalone/example/access_control)
- [Starter Access Control Management on a Cluster](sharded-replicated/example/access_control)
- [Stack Overflow Data Processing](standalone/example/stack_overflow)