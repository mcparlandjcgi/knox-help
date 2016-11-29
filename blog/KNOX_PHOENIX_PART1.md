# Support Apache Phoenix in Apache Knox - Part 1: Installation and Configuration
The aim here is to support Apache Phoenix APIs through Apache Knox.

Phoenix enables OLTP by alowing users to query HBase (i.e. leveraging schema-on-demand)
using SQL syntax, allowing developers to re-use their knowledge of SQL.

## Acceptance Critiera
 * As a developer, allow me to proxy Apache Phoenix APIs through Apache Knox
 * As a system admin, allow me to secure access to Apache Phoenix with Apache Knox
 providing Authorization and Authentication.

## Installation/Configuring
The following is a short step-by-step of the full instructions on [Installing Apache Phoenix in HDP 2.4](https://docs.hortonworks.com/HDPDocuments/HDP2/HDP-2.4.3/bk_installing_manually_book/content/ch_install_phoenix_chapter.html)

 1. `sudo yum install phoenix`

That's all there is to installing, but configuring HBase is a more complex part.
I choose to do this through Ambari *

 1. Login to Ambari as admin
 1. Choose Services -> HBase
 1. Expand "Advanced hbase-site"
 1. Modify (if necessary) `hbase.defaults.for.version.skip` to be `true`
 1. Modify (if necessary) `RegionServer WAL Codec` to be `org.apache.hadoop.hbase.regionserver.wal.IndexedWALEditCodec`
 1. Modify (if necessary) `hbase.region.server.rpc.scheduler.factory.class
` to be `org.apache.hadoop.hbase.ipc.PhoenixRpcSchedulerFactory`
 1. Modify (if necessary) `hbase.rpc.controllerfactory.class` to be `org.apache.hadoop.hbase.ipc.controller.ServerRpcControllerFactory`
 1. Modify (if necessary) `phoenix.functions.allowUserDefinedFunctions` to be `true`.
 1. Save the config changes.
 1. Restart HBase on each of Master, Region Server and Nodes (Ambari usually alerts you that this is needed).

*[I had to reset the admin password first](http://hortonworks.com/hadoop-tutorial/learning-the-ropes-of-the-hortonworks-sandbox/#setup-ambari-admin-password)

----
