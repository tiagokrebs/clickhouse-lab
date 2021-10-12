package main

import (
	"crypto/tls"
	"crypto/x509"
	"database/sql"
	"fmt"
	"io/ioutil"
	"log"

	"github.com/ClickHouse/clickhouse-go"
)

func main() {
	caCert, err := ioutil.ReadFile("root-ca.pem")
	if err != nil {
		log.Fatal(err)
	}
	caCertPool := x509.NewCertPool()
	caCertPool.AppendCertsFromPEM(caCert)

	tlsConfig := &tls.Config{
		RootCAs: caCertPool,
	}

	connect, err := sql.Open("clickhouse", "tcp://<host>:<port>?username=<user>&password=<pass>&database=<database>&debug=true&secure=true&skip_verify=true")

	if err != nil {
		log.Fatal(err)
	}
	if err := connect.Ping(); err != nil {
		if exception, ok := err.(*clickhouse.Exception); ok {
			fmt.Printf("[%d] %s \n%s\n", exception.Code, exception.Message, exception.StackTrace)
		} else {
			fmt.Println(err)
		}
		return
	}

	err = clickhouse.RegisterTLSConfig("default_tls", tlsConfig)
	if err != nil {
		log.Fatal(err)
	}

	rows, err := connect.Query("SHOW DATABASES")
	if err != nil {
		log.Fatal(err)
	}
	defer rows.Close()

	for rows.Next() {
		var (
			name string
		)
		if err := rows.Scan(&name); err != nil {
			log.Fatal(err)
		}
		log.Printf("name: %s", name)
	}

	if err := rows.Err(); err != nil {
		log.Fatal(err)
	}
}
