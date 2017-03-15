# Verifying Avatica/Phoenix Integration with Knox

The purpose of this document is to verify the integration of Avatica with Knox.

Useful links:
* [JIRA ticket for this change](https://issues.apache.org/jira/browse/KNOX-817)
* [Commit in apache/knox on GitHub](https://github.com/apache/knox/commit/785ea084a617df7ad637a7afed9740bd569c07ae)
* [JIRA ticket for creating documentation for Phoenix support](https://issues.apache.org/jira/browse/KNOX-844)
* [Simple Java app created by John McParland to use a JDBC to connection to Phoenix](https://github.com/mcparlandjcgi/phoenix-knox-jdbc)

## Add the HDP SSL certificate to cacerts

In order for Java to successfully connect with JDBC over an SSL connection the `cacerts` need to be updated with the HDP SSL certificate.

1. Visit https://xxx.cloudapp.azure.com:8443/ on Firefox. Confirm the security exception and get to the 404 error page. Then click the padlock in the url to find your way to "More Inforation", "View Certificate", "Details" and then "Export". Save the vertificate as `localhost.crt.
1. Copy the certificate to the server
  * `scp -P 2222 ~/Downloads/localhost.crt root@localhost:/root`
1. As `root` user
```
keytool -importcert -keystore /etc/pki/java/cacerts -storepass changeit -alias localhost -file ~/localhost.crt
```
1. Verify it worked
```
keytool -list -keystore /etc/pki/java/cacerts -alias localhost
```
  * Should output something like:
```
localhost, Jan 25, 2017, trustedCertEntry,
Certificate fingerprint (SHA1): B6:F1:53:11:D0:BA:4D:52:B7:76:73:D7:58:13:EA:56:D8:05:CE:44
```

## Using mcparlandjcgi/phoenix-knox-jdbc

1. As yourself on the server:
```
git clone https://github.com/mcparlandjcgi/phoenix-knox-jdbc.git
```
1. Modify `phoenix-knox-jdbc/run_phoenixjdbc.sh` and change the `JARFILE` property to `/home/<username>/phoenixjdbc-1.0-SNAPSHOT.jar`
  * Ensure you change the `<username>` to your own.
1. It will be easiest to build this locally (for development on the repo) then push the compiled jar to the server. Clone the repo on your own machine and build it with `mvn package`. Then it can be uploaded to the server:
```
scp -p 2222 target/phoenixjdbc-1.0-SNAPSHOT.jar root@localhost:/root
```
1. As `root` on the server you can modify the config file for the app:
  * `vi /usr/phoenixjdbc/config.properties`
  * Here you can modify the JDBC URL used for the connection.
1. To run the app:
```
/root/phoenix-knox-jdbc/run_phoenixjdbc.sh
```

Possible JDBC URLs:

* Most basic form straight into Phoenix
```
jdbc:phoenix:sandbox.hortonworks.com:/hbase-unsecure
```
* Using PQS:
```
jdbc:avatica:remote:url=http://sandbox.hortonworks.com:8765;serialization=PROTOBUF
jdbc:phoenix:thin:url=http://sandbox.hortonworks.com:8765;serialization=PROTOBUF
```
* Using Knox (localhost is required because Java can't validate sandbox.hortonworks.com):
```
jdbc:avatica:remote:url=https://localhost:8443/gateway/sandbox/avatica/;avatica_user=guest;avatica_password=guest-password;authentication=BASIC
```
