-- Sharded and distributed tables
CREATE TABLE numbers
(
    numberID UInt8,
    number UInt32
    )
ENGINE = MergeTree()
ORDER BY (number, intHash32(numberID));

INSERT INTO numbers SELECT number, rand() FROM numbers(1000);