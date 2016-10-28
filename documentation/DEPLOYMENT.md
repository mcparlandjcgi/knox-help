# Deployment

## Get a Package to the Server
 1. Build the knox repo: `knoxBuild.sh package`
 2. Copy `target/<<version>>/knox-<<version>>.tar.gz` to the HDP sandbox server

 E.g. `scp target/0.10.0-SNAPSHOT/knox-0.10.0.tar.gz ${KNOX_HDP}:/home/mcparlandj/knox-0.10.0.tar.gz`.

## Upgrade Knox
You need to follow [Upgrade the Knox Gateway](https://docs.hortonworks.com/HDPDocuments/HDP2/HDP-2.4.0/bk_upgrading_hdp_manually/content/access_subtab_2_3.html)

 1. `su root` e.g. knox-[knox-version]
 2. `mkdir -p /usr/hdp/<<version>>` (e.g. `mkdir -p /usr/hdp/0.10.0-SNAPSHOT`)
 3. `hdp-select set knox-server <<version>>` (e.g. `hdp-select set knox-server 0.10.0-SNAPSHOT`)
 4. `cp knox-<<version>>.tar.gz /usr/hdp/<<version>>` (e.g. `cp /home/mcparlandj/knox-0.10.0-SNAPSHOT.tar.gz /usr/hdp/0.10.0-SNAPSHOT`)
 5. `cd /usr/hdp/<<version>>` (e.g. `cd /usr/hdp/0.10.0-SNAPSHOT`)
 5. `tar xvzf knox-<<version>>.tar.gz` (e.g. `tar xvzf knox-0.10.0-SNAPSHOT`)
 6. `mv knox-<<version>> knox` (e.g. `mv knox-0.10.0-SNAPSHOT knox`)
 7. Confirm the version changed: `ls -ltra /usr/hdp/current/knox-server`

[knox-version]: 0.10.0-SNAPSHOT
----
