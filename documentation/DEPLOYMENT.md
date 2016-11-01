# Deployment

## Get a Package to the Server
 1. Build the knox repo: `knoxBuild.sh package`
 2. `export KNOX_VERSION=<<knoxversion>>`
 2. Copy tarball to HDP server:

 `scp target/${KNOX_VERSION}/knox-${KNOX_VERSION}.tar.gz ${KNOX_HDP}:/home/${USER}/knox-${KNOX_VERSION}.tar.gz`

 ## Sort out Ambari
  1. `ambari-admin-password-reset`
  2. Enter the password.
  3. `ambari-agent restart `

## Upgrade Knox
You need to follow [Upgrade the Knox Gateway](https://docs.hortonworks.com/HDPDocuments/HDP2/HDP-2.4.0/bk_upgrading_hdp_manually/content/access_subtab_2_3.html)

 1. `sudo su`
 2. `export KNOX_VERSION=<<knoxversion>>`
 3. `mkdir -p /usr/hdp/${KNOX_VERSION}`
 4. `hdp-select set knox-server ${KNOX_VERSION}`
 5. `cp /home/${SUDO_USER}/knox-${KNOX_VERSION}.tar.gz /usr/hdp/${KNOX_VERSION}`
 6. `cd /usr/hdp/${KNOX_VERSION}`
 7. `tar xvzf knox-${KNOX_VERSION}.tar.gz`
 8. `mv knox-${KNOX_VERSION} knox`
 9. `chmod -R 755 knox`
 10. `chown -R knox:knox knox`
 11. Confirm the version changed: `ls -ltra /usr/hdp/current/knox-server`
 12. `su -l knox`
 13. `export GATEWAY_HOME=/usr/hdp/current/knox-server`
 14. `cd $GATEWAY_HOME`

## Modify the sandbox Topology
**TODO** Verify if this is needed
 1. `vi conf/topology/sandbox.xml`
 2. Replace all URLs `%s/localhost/sandbox\\.hortonworks\\.com/g`
 3. `:wq!`

## Start LDAP and Create Master Password

 1. `bin/ldap.sh start`
 2. `bin/knoxcli.sh create-master` **REMEMBER THIS PASSWORD**

## Start Knox
 1. `bin\gateway.sh start`

## Verify Knox Started Up
 1. `curl -u guest:guest-password -X GET 'https://localhost:8443/gateway/sandbox/webhdfs/v1/?op=LISTSTATUS' | python -m json.tool`
   * Or `knoxCheck.sh`
   
```
% Total    % Received % Xferd  Average Speed   Time    Time     Time  Current
                               Dload  Upload   Total   Spent    Left  Speed
103  2575  103  2575    0     0   7131      0 --:--:-- --:--:-- --:--:-- 20934
{
  "FileStatuses": {
      "FileStatus": [
          {
              "accessTime": 0,
              "blockSize": 0,
              "childrenNum": 1,
              "fileId": 16396,
              "group": "hadoop",
              "length": 0,
              "modificationTime": 1456785157015,
              "owner": "yarn",
              "pathSuffix": "app-logs",
              "permission": "777",
              "replication": 0,
              "storagePolicy": 0,
              "type": "DIRECTORY"
          },
          {
              "accessTime": 0,
              "blockSize": 0,
              "childrenNum": 4,
              "fileId": 16392,
              "group": "hdfs",
              "length": 0,
              "modificationTime": 1456769061888,
              "owner": "hdfs",
              "pathSuffix": "apps",
              "permission": "755",
              "replication": 0,
              "storagePolicy": 0,
              "type": "DIRECTORY"
          },
          {
              "accessTime": 0,
              "blockSize": 0,
              "childrenNum": 2,
              "fileId": 16389,
              "group": "hadoop",
              "length": 0,
              "modificationTime": 1456768686744,
              "owner": "yarn",
              "pathSuffix": "ats",
              "permission": "755",
              "replication": 0,
              "storagePolicy": 0,
              "type": "DIRECTORY"
          },
          {
              "accessTime": 0,
              "blockSize": 0,
              "childrenNum": 1,
              "fileId": 17231,
              "group": "hdfs",
              "length": 0,
              "modificationTime": 1456770378196,
              "owner": "hdfs",
              "pathSuffix": "demo",
              "permission": "755",
              "replication": 0,
              "storagePolicy": 0,
              "type": "DIRECTORY"
          },
          {
              "accessTime": 0,
              "blockSize": 0,
              "childrenNum": 1,
              "fileId": 16403,
              "group": "hdfs",
              "length": 0,
              "modificationTime": 1456768694221,
              "owner": "hdfs",
              "pathSuffix": "hdp",
              "permission": "755",
              "replication": 0,
              "storagePolicy": 0,
              "type": "DIRECTORY"
          },
          {
              "accessTime": 0,
              "blockSize": 0,
              "childrenNum": 1,
              "fileId": 16399,
              "group": "hdfs",
              "length": 0,
              "modificationTime": 1456768693055,
              "owner": "mapred",
              "pathSuffix": "mapred",
              "permission": "755",
              "replication": 0,
              "storagePolicy": 0,
              "type": "DIRECTORY"
          },
          {
              "accessTime": 0,
              "blockSize": 0,
              "childrenNum": 2,
              "fileId": 16401,
              "group": "hadoop",
              "length": 0,
              "modificationTime": 1456768702875,
              "owner": "mapred",
              "pathSuffix": "mr-history",
              "permission": "777",
              "replication": 0,
              "storagePolicy": 0,
              "type": "DIRECTORY"
          },
          {
              "accessTime": 0,
              "blockSize": 0,
              "childrenNum": 1,
              "fileId": 17149,
              "group": "hdfs",
              "length": 0,
              "modificationTime": 1456769972033,
              "owner": "hdfs",
              "pathSuffix": "ranger",
              "permission": "755",
              "replication": 0,
              "storagePolicy": 0,
              "type": "DIRECTORY"
          },
          {
              "accessTime": 0,
              "blockSize": 0,
              "childrenNum": 1,
              "fileId": 16441,
              "group": "hadoop",
              "length": 0,
              "modificationTime": 1478000470936,
              "owner": "spark",
              "pathSuffix": "spark-history",
              "permission": "777",
              "replication": 0,
              "storagePolicy": 0,
              "type": "DIRECTORY"
          },
          {
              "accessTime": 0,
              "blockSize": 0,
              "childrenNum": 2,
              "fileId": 16386,
              "group": "hdfs",
              "length": 0,
              "modificationTime": 1456769396351,
              "owner": "hdfs",
              "pathSuffix": "tmp",
              "permission": "777",
              "replication": 0,
              "storagePolicy": 0,
              "type": "DIRECTORY"
          },
          {
              "accessTime": 0,
              "blockSize": 0,
              "childrenNum": 10,
              "fileId": 16387,
              "group": "hdfs",
              "length": 0,
              "modificationTime": 1456785153235,
              "owner": "hdfs",
              "pathSuffix": "user",
              "permission": "755",
              "replication": 0,
              "storagePolicy": 0,
              "type": "DIRECTORY"
          }
      ]
  }
}

```

----
