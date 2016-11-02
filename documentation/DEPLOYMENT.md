# Deployment

## Get a Package to the Server
As yourself on laptop.

 1. Build the knox repo: `knoxBuild.sh package`
 2. `export KNOX_VERSION=<<knoxversion>>`
 3. Copy tarball to HDP server:

 `scp target/${KNOX_VERSION}/knox-${KNOX_VERSION}.tar.gz ${KNOX_HDP}:/home/${USER}/knox-${KNOX_VERSION}.tar.gz`
 4. ssh into the server

## Stop Knox and LDAP
As `knox` on HDP-sandbox.

 * `~mcparlandj/knoxStop.sh`

## Upgrade Knox To A New Version
As `root` on HDP-sandbox.

 1. `~mcparlandj/knoxUpgrade.sh <<knoxversion>>`

## Modify the sandbox Topology
As `root` on HDP-sandbox.

  1. `vi conf/topology/sandbox.xml`
  1. Replace all URLs `:%s/localhost/sandbox\.hortonworks\.com/g`
  1. `:wq!`

## Start LDAP, Create Master Password, Start Knox
As `knox` on HDP-sandbox

 1. `cd /usr/hdp/current/knox-server`
 1. `bin/ldap.sh start`
 1. `bin/knoxcli.sh create-master` **REMEMBER THIS PASSWORD**
 1. `bin/gateway.sh start`

## Verify Knox Started Up
As yourself on laptop.

 1. `knoxCheck.sh`
 1. You should see something similar to the following output

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
