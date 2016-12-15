#  Supporting Solr In Knox - Part 2: Support Querying Solr via Knox
I recently picked up [KNOX-528](https://issues.apache.org/jira/browse/KNOX-528) to add Solr support to Apache Knox.

I focussed on

 * Solr as part of HDP Search (Solr Cloud, using ZooKeeper)
 * Proxying the API only

and based it a lot around what [Kevin Risden](https://github.com/risdenk/knox_solr_testing) started.

For this first part, I've focussed on adding the ability to query Solr via Knox using [Kevin Minder's blog on adding a service to Knox](http://kminder.github.io/knox/2015/11/16/adding-a-service-to-knox.html).

## service.xml
```
<?xml version="1.0" encoding="UTF-8" standalone="yes"?>
<!--
   Licensed to the Apache Software Foundation (ASF) under one or more
   contributor license agreements.  See the NOTICE file distributed with
   this work for additional information regarding copyright ownership.
   The ASF licenses this file to You under the Apache License, Version 2.0
   (the "License"); you may not use this file except in compliance with
   the License.  You may obtain a copy of the License at

       http://www.apache.org/licenses/LICENSE-2.0

   Unless required by applicable law or agreed to in writing, software
   distributed under the License is distributed on an "AS IS" BASIS,
   WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
   See the License for the specific language governing permissions and
   limitations under the License.
-->
<service role="SOLRAPI" name="solr" version="5.5.0">
    <policies>
        <policy role="webappsec"/>
        <policy role="authentication" name="Anonymous"/>
        <policy role="rewrite"/>
        <policy role="authorization"/>
    </policies>
    <routes>
        <route path="/solr/**/**?**">
             <rewrite apply="SOLRAPI/solr/inbound/query" to="request.url"/>
        </route>
    </routes>
     <dispatch classname="org.apache.hadoop.gateway.dispatch.PassAllHeadersDispatch"/>
</service>

```

Key points
 * ```<route path="/solr/**/**?**">```
   * Matches incoming URLs starting with:  ```/solr```
   * Then captures the collection to search (e.g. ExampleCollection): ```/**/```
   * Then the query type (e.g. ```select```): ```**```
   * Then the query parameters separator: ```?```
   * Finally the query parameters themselves are captured: ```**```
 * ```<rewrite apply="SOLRAPI/solr/inbound/query" to="request.url"/>```
   * A re-write rule named ```SOLRAPI/solr/inbound/query``` shall be applied to the incoming request URL.
   * This rule needs to be in the corresponding ```rewrite.xml``` for this service.
 * ```<dispatch classname="org.apache.hadoop.gateway.dispatch.PassAllHeadersDispatch"/>```
   * All headers shall be passed, without processing to the re-write rule processor.

## rewrite.xml
```
<?xml version="1.0" encoding="UTF-8" standalone="yes"?>
<!--
   Licensed to the Apache Software Foundation (ASF) under one or more
   contributor license agreements.  See the NOTICE file distributed with
   this work for additional information regarding copyright ownership.
   The ASF licenses this file to You under the Apache License, Version 2.0
   (the "License"); you may not use this file except in compliance with
   the License.  You may obtain a copy of the License at

       http://www.apache.org/licenses/LICENSE-2.0

   Unless required by applicable law or agreed to in writing, software
   distributed under the License is distributed on an "AS IS" BASIS,
   WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
   See the License for the specific language governing permissions and
   limitations under the License.
-->
<rules>
  <!--Only supporting Solr queries via Knox -->
  <rule dir="IN" name="SOLRAPI/solr/inbound/query" pattern="*://*:*/**/solr/{collection=**}/{query=**}?{**}">
       <rewrite template="{$serviceUrl[SOLRAPI]}/{collection=**}/{query=**}?{**}"/>
  </rule>

</rules>
```

Key points
 * `rule dir="IN"`
   * The rule is applied to in-coming requests
 * `name="SOLRAPI/solr/inbound/query"`
   * This is the name of the rule - **NOTE** this is what was specified in ```service.xml```
 * `pattern="*://*:*/**/solr/{collection=**}/{query=**}?{**}`
   * Matches on protocol (single string) followed by colon, two-forward-slash: ```*://```
   * Then on ip/name then colon port: ```*:*```
   * Then on multiple path elements in the URL (e.g. `gateway/sandbox`): `**`
   * Then on `/solr/`
   * Next it takes multiple patch elements (e.g. ExampleCollection), and assigns them to the variable called `collection`: `{collection=**}`
   * Next it takes multiple path elements (e.g. `select`), and assigns it to the variable called `query`: `{query=**}`
   * Next it matches the question mark argument separator: `?`
   * Finally it matches all of the query arguments (zero or more): `{**}`
 * `{$serviceUrl[SOLRAPI]}/{collection=**}/{query=**}?{**}`
   * The URL of a service called `SOLRAPI` is looked up in the topology file and replaces: `{$serviceUrl[SOLRAPI]}`
   * The variable `collection`, containing multiple path elements, is put in place of: `{collection=**}`
   * The variable `query`, containing multiple patch elements is put in place of: `{query=**}`
   * A question mark is appended: `?`
   * Finally, any remaining arguments captured are written to the URL: `{**}`


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
 <role>SOLRAPI</role>
 <url>http://sandbox.hortonworks.com:8983/solr</url>
</service>
```

Then re-started Knox.

Key point
 * Role was ```SOLRAPI``` to reflect it's dealing with the API only

## Testing
 * Set the URL/IP of your HDP 2.4 sandbox host: ```export KNOX_HDP=...```
 * Execute the following

```
curl -k -v -u guest:guest-password -X GET "http://${KNOX_HDP}:8443/gateway/sandbox/solr/ExampleCollection/select?q=*.*&wt=json&indent=true"
```

Compare with

```
 curl -X GET "http://${KNOX_HDP}:8983/solr/ExampleCollection/select?q=*.*&wt=json&indent=true"
 ```

## Key Learning
I need to re-iterate the learning from
 * Kevin Minder's blog](http://kminder.github.io/knox/2015/11/16/adding-a-service-to-knox.html) article on adding a service to Apache Knox.
 * My own [run-through](/blog/KNOX_OPENWEATHER_MAP_TUTORIAL.md) of the above blog article.

In addition
 * Best to apply a rewrite rule to a route in the service definition
 * If a part of the pattern being matched in the re-write rule has meaning (e.g. the collection above), use `{variablename=**}` to capture it in the pattern and write it in the template
 * Most rewrite rule patterns may start with `*://*:*/**/<SERVICENAME>/` to capture the protocol/ip/port/gateway context/topology and of course the service your are proxying.


## Acknowledgement
I'm grateful to Sandeep More who helped me with some of the pattern matching and debugging along the way.  

 ---

  * John McParland (john.mcparland AT cgi.com / johmmcparland AT gmail.com)
  * M 21 Nov 2016
