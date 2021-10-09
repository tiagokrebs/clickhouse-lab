# Starter Access Control Management on a Cluster

Simple example on how use the new SQL-driven access control on a Cluster. Based on [Access Control and Account Management](https://clickhouse.com/docs/en/operations/access-rights/).
If you don't know the previous one well, lucky you, don't even bored to search for it. This new one is much better.

After start the environment open the CLI.
```
./cli.sh
```

Make sure to create the table required from `sharded-replicated/queries` folder.

And run the commands on `access_control.sql` file.  
Yes, there is an easy way to run all commands on the file, but this is not the intention here. You should read the queries and try to understand them :)