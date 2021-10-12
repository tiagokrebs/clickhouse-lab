from clickhouse_driver import Client

client = Client(host='<host>', port=<port>, user='<user>', password='<pass>', secure=True, ca_certs='root-ca.pem')

rows = client.execute('SHOW DATABASES')

for r in rows:
    print(r)