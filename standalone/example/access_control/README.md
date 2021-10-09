# Starter Access Control Management

Simple example on how use the new SQL-driven access control method based on [Access Control and Account Management](https://clickhouse.com/docs/en/operations/access-rights/).

After start the environment open the CLI.
```
docker exec -it server1 clickhouse-client --host server1 --multiquery
```

Make sure to create the table required from `standalone/queries` folder.

And run the queries on `access_control.sql` file.  
Yes, there is an easy way to run all commands on the file, but this is not the intention here. You should read the queries and try to understand them :)