# Stack Overflow Data Processing

This example is complementary to my personal blog post [Clickhouse Tutorial]().

Just because we love it so much we're using the [StackSample: 10% of Stack Overflow Q&A](https://www.kaggle.com/stackoverflow/stacksample) dataset in this example.

## Get the data
These are relatively large datasets (~4, GB uncompressed) so it and can take a wile to download. Go ahead and download the dataset [here](https://www.kaggle.com/stackoverflow/stacksample).  

```
mkdir data
mv ~/Downloads/archive.zip data/
unzip data/archive.zip -d data/
```
If you want to know more about the Stack Exchange data look at [data.stackexchange.com](https://data.stackexchange.com/) and [archive.org/details/stackexchange](https://archive.org/details/stackexchange).


## Start the environment
Start using docker-compose and the file `docker-compose.yaml` from the `standalone` cluster folder.

```
cd ../../
docker-compose up -d
```

## Create the tables
To open the CLI run.
```
docker exec -it server1 clickhouse-client --host server1 --multiquery
```

Then create the database and the tables.
```
CREATE DATABASE IF NOT EXISTS tutorial;

CREATE TABLE tutorial.tags
(
    Id UInt32,
    Tag String
)
ENGINE = MergeTree()
ORDER BY (Id, Tag);

CREATE TABLE tutorial.answers
(
    Id UInt32,
    OwnerUserId String,
    CreationDate DateTime,
    ParentId String,
    Score Int32,
    Body String
)
ENGINE = MergeTree()
PARTITION BY toYYYYMM(CreationDate)
ORDER BY (ParentId, CreationDate);

CREATE TABLE tutorial.questions
(
    Id UInt32,
    OwnerUserId String,
    CreationDate DateTime,
    ClosedDate Nullable(DateTime),
    Score Int32,
    Title String,
    Body String
)
ENGINE = MergeTree()
PARTITION BY toYYYYMM(CreationDate)
ORDER BY (OwnerUserId, CreationDate);
```

Exit from the client
```
server1 :) exit
Bye.
```

## Insert the data
Execute a bash session on the server.
```
docker exec -it server1 bash
```

Then import the CSV files from the Stack Overflow example.
```
# Simple import
cat /example/stack_overflow/data/Tags.csv \
    | /usr/bin/clickhouse --client \
    --query="INSERT INTO tutorial.tags FORMAT CSVWithNames"

# Import specific columns
cat example/stack_overflow/data/Answers.csv \
    | /usr/bin/clickhouse --client \
    --query="INSERT INTO tutorial.answers SELECT Id UInt32, OwnerUserId, toDateTime(parseDateTimeBestEffort(CreationDate)) AS CreationDate, ParentId, Score, Body FROM input('Id UInt32, OwnerUserId String, CreationDate String, ParentId String, Score Int32, Body String') FORMAT CSVWithNames"

# Import ignoring errors
cat example/stack_overflow/data/Questions.csv \
    | sed "s/'/ /g" | /usr/bin/clickhouse \
    --client --query="INSERT INTO tutorial.questions SELECT Id UInt32, OwnerUserId, toDateTime(parseDateTimeBestEffort(CreationDate)) AS CreationDate, toDateTime(parseDateTimeBestEffort(replaceOne(ClosedDate, 'NA', null))) AS ClosedDate, Score, Title, Body FROM input('Id UInt32, OwnerUserId String, CreationDate String, ClosedDate String, Score Int32, Title String, Body String') FORMAT CSVWithNames" \
    --input_format_allow_errors_ratio=0.5
```

Exit from the bash session
```
root@server1:/# exit
exit
```

## Do some queries
Open the CLI again.

Tables from MergeTree-family do merges of data parts in the background to optimize data storage when needed. We can force to OPTIMIZE the tables now instead to leave to the engine decided when is the best moment to do this.
```
server1 :) OPTIMIZE TABLE tutorial.tags FINAL;
server1 :) OPTIMIZE TABLE tutorial.answers FINAL;
server1 :) OPTIMIZE TABLE tutorial.questions FINAL;
```

Take a peak on the Tags.
```
server1 :) SELECT * FROM tutorial.tags LIMIT 5;

SELECT *
FROM tutorial.tags
LIMIT 5

Query id: 90752735-6cce-4220-92ce-ff61d6d4eb6c

┌─Id─┬─Tag───────────────────┐
│ 80 │ actionscript-3        │
│ 80 │ air                   │
│ 80 │ flex                  │
│ 90 │ branch                │
│ 90 │ branching-and-merging │
└────┴───────────────────────┘

5 rows in set. Elapsed: 0.004 sec. 

```

Get the lower and higher score from the answers.
```
server1 :) SELECT min(Score) AS min, max(Score) AS max FROM answers;

SELECT
    min(Score) AS min,
    max(Score) AS max
FROM answers

Query id: 7c8f3422-8ed9-4090-ac18-9085f8cbc7b1

┌─min─┬──max─┐
│ -42 │ 5718 │
└─────┴──────┘

1 rows in set. Elapsed: 0.010 sec. Processed 2.01 million rows, 8.06 MB (192.16 million rows/s., 768.64 MB/s.)
```

Get how many times the string `python` is in the questions on each year.
```
server1 :) SELECT toYear(CreationDate) AS year, count() FROM questions WHERE Body ilike('%python%') GROUP BY year ORDER BY year;

SELECT
    toYear(CreationDate) AS year,
    count()
FROM questions
WHERE Body ILIKE '%python%'
GROUP BY year
ORDER BY year ASC

Query id: 3aa8083a-cd49-40ae-8149-1d8ec42bccfb

┌─year─┬─count()─┐
│ 2008 │     388 │
│ 2009 │    2180 │
│ 2010 │    4036 │
│ 2011 │    6284 │
│ 2012 │    9158 │
│ 2013 │   12914 │
│ 2014 │   14666 │
│ 2015 │   17538 │
│ 2016 │    9058 │
└──────┴─────────┘

9 rows in set. Elapsed: 0.868 sec. Processed 2.31 million rows, 3.25 GB (2.67 million rows/s., 3.75 GB/s.)
```
