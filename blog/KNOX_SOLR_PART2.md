#  Supporting Solr In Knox - Part 2: Support Querying Solr via Knox
I recently picked up [KNOX-528](https://issues.apache.org/jira/browse/KNOX-528) to add Solr support to Apache Knox.

I focussed on

 * Solr as part of HDP Search (Solr Cloud, using ZooKeeper)
 * Proxying the API only

and based it a lot around what [Kevin Risden](https://github.com/risdenk/knox_solr_testing) started.

For this first part, I've focussed on adding the ability to query Solr via Knox using [Kevin Minder's blog on adding a service to Knox](http://kminder.github.io/knox/2015/11/16/adding-a-service-to-knox.html).

## service.xml


This was copied to

## rewrite.xml

## Deploying the above
After scp'ing the files to my HDP 2.4 sandbox, I

  * ```sudo su```
  * ```su -l knox```
  * ```cd /usr/hdp/current/knox-server/```
  * ```mkdir -p data/services/solr/5.5.0```
  * ```cp service.xml rewrite.xml data/services/solr/5.5.0```

## topology
On my HDP 2.4 sandbox, I added the following section to ```/usr/hdp/current/knox-server/conf/topologies/sandbox.xml```

```
<service>
 <role>SOLR</role>
 <url>http://sandbox.hortonworks.com:8983/solr</url>
</service>
```

Then re-started Knox.

## Testing
 * Set the URL/IP of your HDP 2.4 sandbox host: ```export KNOX_HDP=...```
 * Execute the following

```
curl -k -v -u guest:guest-password -X GET "http://${KNOX_HDP}:8443/gateway/sandbox/solr/KnoxIntegrationConfig/select?q=*.*&wt=json&indent=true"
```

Compare with

```
 curl -X GET "http://${KNOX_HDP}:8983/solr/KnoxIntegrationConfig/select?q=*.*&wt=json&indent=true"
 ```
