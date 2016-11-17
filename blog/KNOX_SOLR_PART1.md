# Supporting Solr In Knox - Part 1: Installation, Configuration, Ingestion and Querying
I recently picked up [KNOX-528](https://issues.apache.org/jira/browse/KNOX-528) to add Solr support to Apache Knox.

I focussed on

 * Solr as part of HDP Search (Solr Cloud, using ZooKeeper)
 * Proxying the API only

and based it a lot around what [Kevin Risden](https://github.com/risdenk/knox_solr_testing) started.

For this first part, I simply focussed on installing and configuring Solr, putting some data into it, and querying that data via Solr directly.

## Installing
To do the installation I used commands taken from

 * [Installing HDP Search](https://docs.hortonworks.com/HDPDocuments/HDP2/HDP-2.4.2/bk_hdp_search/content/ch_hdp-search-install.html)

Blow-by-blow, I executed the following on the HDP 2.4 sandbox

 * ```rpm --import http://public-repo-1.hortonworks.com/HDP-SOLR-2.3-100/repos/centos6/RPM-GPG-KEY/RPM-GPG-KEY-Jenkins```
 * ```cd /etc/yum.repos.d/```
 * ```wget http://public-repo-1.hortonworks.com/HDP-SOLR-2.3-100/repos/centos6/hdp-solr.repo```
 * ```yum install lucidworks-hdpsearch```
 * ```yum install lsof``` (needed later for solr to tell if it's listening)

## Configuring
Based around [LucidWorks HDP Search Installation Guide](https://doc.lucidworks.com/lucidworks-hdpsearch/2.3/Guide-Install.html) I did the following steps to configure Solr Cloud for the HDP 2.4 sandbox.

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

## Create a Collection
 * Create a collection with the knox integration configset.
```
bin/solr create -c KnoxIntegrationConfig \
 -d knox_integration_configs \
 -n knoxIntegrationConfigs \
 -s 2 \
 -rf 2
```

## Ingesting data
 * There's clearly better ways to do this (e.g. via HDFS, which I think is the end-goal) but for now, I've used the [post tool](https://cwiki.apache.org/confluence/display/solr/Post+Tool).
 * First I moved over some example datasets, I obtained from an earlier, aborted attempt to install solr 6.2.1 directly on the HDP machine.  Out of the exploded gzipped-tarball, it is the ```solr-6.2.1/example/exampledocs``` folder.
```
bin/post -c KnoxIntegerationConfig /home/solr/exampledocs
```

## Querying the data via the UI
 * Now you can see the data by visiting http://<< HDP 2.4 Sandbox URL >>:8983/solr/
 * Query it by selecting a "core" from the drop down menu, selecting "Query" from the menu on the LHS and hit "Execute Query".
 * You'll be able to see some data in the system!

![Solr Query Result](/blog/img/SolrQueryResult.png)

## Querying the data via the command line
Clearly going via the Solr UI isn't the right thing for what we need with Knox.  For Knox, we need to query it in a RESTful API fashion.

```
curl "http://<< external hdp 2.4 sandbox ip/name >>:8983/solr/KnoxIntegrationConfig_shard1_replica1/select?q=*%3A*&wt=json&indent=true"
```

Returned

```
{
  "responseHeader":{
    "status":0,
    "QTime":49,
    "params":{
      "indent":"true",
      "q":"*:*",
      "wt":"json"}},
  "response":{"numFound":50,"start":0,"maxScore":1.0,"docs":[
      {
        "id":"978-0641723445",
        "_src_":"{\n    \"id\" : \"978-0641723445\",\n    \"cat\" : [\"book\",\"hardcover\"],\n    \"name\" : \"The Lightning Thief\",\n    \"author\" : \"Rick Riordan\",\n    \"series_t\" : \"Percy Jackson and the Olympians\",\n    \"sequence_i\" : 1,\n    \"genre_s\" : \"fantasy\",\n    \"inStock\" : true,\n    \"price\" : 12.50,\n    \"pages_i\" : 384\n  }",
        "_version_":1551143257736478720},
      {
        "id":"GB18030TEST",
        "name":"Test with some GB18030 encoded characters",
        "features":["No accents here",
          "这是一个功能",
          "This is a feature (translated)",
          "这份文件是很有光泽",
          "This document is very shiny (translated)"],
        "price":0.0,
        "price_c":"0.0,USD",
        "inStock":true,
        "_version_":1551143258703265792},
      {
        "links":["rect",
          "http://www.apache.org"],
        "id":"/home/solr/exampledocs/sample.html",
        "title":["Welcome to Solr"],
        "content_type":["text/html; charset=ISO-8859-1"],
        "resourcename":"/home/solr/exampledocs/sample.html",
        "content":[" \n \n  \n  \n  \n  \n  \n  \n  \n  \n Welcome to Solr \n \n \n \n  Here is some text\n \n\n distinct\nwords \n\n Here is some text in a div \n\n This has a  link . \n\n  "],
        "_version_":1551143260302344192},
      {
        "id":"3007WFP",
        "name":"Dell Widescreen UltraSharp 3007WFP",
        "manu":"Dell, Inc.",
        "manu_id_s":"dell",
        "cat":["electronics and computer1"],
        "features":["30\" TFT active matrix LCD, 2560 x 1600, .25mm dot pitch, 700:1 contrast"],
        "includes":"USB cable",
        "weight":401.6,
        "price":2199.0,
        "price_c":"2199.0,USD",
        "popularity":6,
        "inStock":true,
        "store":"43.17614,-90.57341",
        "_version_":1551143260334850048},
      {
        "id":"0812521390",
        "cat":["book"],
        "name":"The Black Company",
        "price":6.99,
        "price_c":"6.99,USD",
        "inStock":false,
        "author":"Glen Cook",
        "author_s":"Glen Cook",
        "series_t":"The Chronicles of The Black Company",
        "sequence_i":1,
        "genre_s":"fantasy",
        "_version_":1551143260460679168},
      {
        "id":"0441385532",
        "cat":["book"],
        "name":"Jhereg",
        "price":7.95,
        "price_c":"7.95,USD",
        "inStock":false,
        "author":"Steven Brust",
        "author_s":"Steven Brust",
        "series_t":"Vlad Taltos",
        "sequence_i":1,
        "genre_s":"fantasy",
        "_version_":1551143260473262080},
      {
        "id":"0380014300",
        "cat":["book"],
        "name":"Nine Princes In Amber",
        "price":6.99,
        "price_c":"6.99,USD",
        "inStock":true,
        "author":"Roger Zelazny",
        "author_s":"Roger Zelazny",
        "series_t":"the Chronicles of Amber",
        "sequence_i":1,
        "genre_s":"fantasy",
        "_version_":1551143260474310656},
      {
        "id":"0805080481",
        "cat":["book"],
        "name":"The Book of Three",
        "price":5.99,
        "price_c":"5.99,USD",
        "inStock":true,
        "author":"Lloyd Alexander",
        "author_s":"Lloyd Alexander",
        "series_t":"The Chronicles of Prydain",
        "sequence_i":1,
        "genre_s":"fantasy",
        "_version_":1551143260476407808},
      {
        "id":"080508049X",
        "cat":["book"],
        "name":"The Black Cauldron",
        "price":5.99,
        "price_c":"5.99,USD",
        "inStock":true,
        "author":"Lloyd Alexander",
        "author_s":"Lloyd Alexander",
        "series_t":"The Chronicles of Prydain",
        "sequence_i":2,
        "genre_s":"fantasy",
        "_version_":1551143260485844992},
      {
        "id":"0679805273",
        "_src_":"{\"id\":\"0679805273\",\"name\":\"Oh, The Places You'll Go\",\"inStock\": true,\"author\": \"Dr. Seuss\"}",
        "_version_":1551143260633694208}]
  }}

```

This is nice, and there's a notable few points pertaining to Knox
 1. No authentication used!
    * Need to embed into Knox
 1. Queried URL made up of ```http://<<service url>>:<<service port>>/solr/<<solr collection name>>/<<query type>>?<<query params>>&wt=json&indent=true```
    * Need to get:
      * ```<< service url >>``` - the server / url for Solr (probably from Zookeeper/toplogy file)
      * ```<< service port >>``` - the port for Solr (probably from Zookeeper/topology file)
      * ```<< solr collection name >>``` - pass through from client calling Knox
      * ```<< query type >>``` - pass through from client calling Knox
      * ```<< query params >>``` - pass through from client calling Knox
      * Should probaby allow client calling Knox to specify if they want ```wt``` and ```indent``` and the appropriate values.

## Query Wrapper Script

 * See [solrQuery.sh](/solrQuery.sh) and [Script Usage](/documentation/SCRIPT_USAGE.md) on how to use a small wrapper script round querying Solr.

An example:

```./solrQuery.sh -q select -a "q=*.*" -c "KnoxIntegrationConfig"```

---

 * John McParland (john.mcparland AT cgi.com / johmmcparland AT gmail.com)
 * W 16th Nov 2016
