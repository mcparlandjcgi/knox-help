# Supporting Solr In Knox
I recently picked up [KNOX-528](https://issues.apache.org/jira/browse/KNOX-528) to add Solr support to Apache Knox.

I focussed on

 * Solr as part of HDP Search (Solr Cloud, using ZooKeeper)
 * Proxying the API only

and based it a lot around what [Kevin Risden](https://github.com/risdenk/knox_solr_testing) started.

## Installing
Commands taken from

 * [Installing HDP Search](https://docs.hortonworks.com/HDPDocuments/HDP2/HDP-2.4.2/bk_hdp_search/content/ch_hdp-search-install.html)

Execute the following on the HDP 2.4 sandbox

 * ```rpm --import http://public-repo-1.hortonworks.com/HDP-SOLR-2.3-100/repos/centos6/RPM-GPG-KEY/RPM-GPG-KEY-Jenkins```
 * ```cd /etc/yum.repos.d/```
 * ```wget http://public-repo-1.hortonworks.com/HDP-SOLR-2.3-100/repos/centos6/hdp-solr.repo```
 * ```yum install lucidworks-hdpsearch```
 * ```yum install lsof``` (needed later for solr to tell if it's listening)

## Configuring
Based around [LucidWorks HDP Search Installation Guide](https://doc.lucidworks.com/lucidworks-hdpsearch/2.3/Guide-Install.html)

 * ```cd /opt/lucidworks-hdpsearch/solr/server/solr/configsets```
 * ```cp -r ample_techproducts_configs knox_integration_configs```
 * ```cd knox_integration_configs/conf```
 * ```vi solrconfig.xml```
 * Replace the ```<directoryFactory>``` section with the following
 ```
 <directoryFactory name="DirectoryFactory" class="solr.HdfsDirectoryFactory">
      <str name="solr.hdfs.home">hdfs://sandbox.hortonworks.com:8020/user/solr</str>
      <str name="solr.hdfs.confdir">/etc/hadoop/conf</str>
      <bool name="solr.hdfs.blockcache.enabled">true</bool>
      <int name="solr.hdfs.blockcache.slab.count">1</int>
      <bool name="solr.hdfs.blockcache.direct.memory.allocation">false</bool>
      <int name="solr.hdfs.blockcache.blocksperbank">16384</int>
      <bool name="solr.hdfs.blockcache.read.enabled">true</bool>
      <bool name="solr.hdfs.nrtcachingdirectory.enable">true</bool>
      <int name="solr.hdfs.nrtcachingdirectory.maxmergesizemb">16</int>
      <int name="solr.hdfs.nrtcachingdirectory.maxcachedmb">192</int>
</directoryFactory>
```
 * Key bits:
    * ```solr.hdfs.blockcache.direct.memory.allocation``` = ```false```
      * Avoids this Error
      ```
      ERROR: Failed to create collection 'KnoxIntegrationConfig' due to: org.apache.solr.client.solrj.impl.HttpSolrClient$RemoteSolrException:Error from server at http://172.18.0.5:8983/solr: Error CREATEing SolrCore 'KnoxIntegrationConfig_shard1_replica1': Unable to create core [KnoxIntegrationConfig_shard1_replica1] Caused by: Direct buffer memory
      ```
    * ```solr.hdfs.home``` = ```hdfs://sandbox.hortonworks.com:8020/user/solr``` as that's the hostname / port for HDFS on the Hortonworks Sandbox

## Starting It Up
 * `su -l solr`
 * ```cd /opt/lucidworks-hdpsearch/solr```
 * Start it!
```
bin/solr start -c \
   -z sandbox.hortonworks.com:2181 \
   -m 1024m \
   -Dsolr.directoryFactory=HdfsDirectoryFactory \
   -Dsolr.lock.type=hdfs \
   -Dsolr.hdfs.home=hdfs://sandbox.hortonworks.com:8020/usr/solr
```
  * NOTE: ```-z``` points to Zookeeper on the sandbox.
  * NOTE: ```solr.hdfs.home``` is set to what we put in the ```directoryFactory``` earlier.
  * NOTE: ```-m``` avoids this error
  ```

  ```
## Create a Collection
 * Create a collection with the knox integration configset.
```
bin/solr create -c KnoxIntegrationConfig \
 -d knox_integration_configs \
 -n knoxIntegrationConfigs \
 -s 2 \
 -rf 2
```
