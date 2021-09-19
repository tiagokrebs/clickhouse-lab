-- Sharded and distributed tables
CREATE TABLE numbers ON CLUSTER 'shardedreplicated'
(
    numberID UInt8,
    number UInt32
    )
ENGINE = ReplicatedMergeTree('/clickhouse/tables/{shard}/numbers','{replica}')
ORDER BY (number, intHash32(numberID))

CREATE TABLE numbers_dist ON CLUSTER 'shardedreplicated' AS numbers 
ENGINE = Distributed(shardedreplicated, default, numbers, intHash64(numberID))

-- One of methods that can be used is insert on the distributed table and let Clickhouse do the fan-out and replication
INSERT INTO numbers_dist SELECT number, rand() FROM numbers(1000)

-- It is also possible to insert on the local tables, Clickhouse will handle only the replication in this case
INSERT INTO numbers SELECT number, rand() FROM numbers(1000)