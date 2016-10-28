# Deployment

## Get a Package to the Server
 1. Build the knox repo: `knoxBuild.sh package`
 2. `export KNOX_VERSION=<<knoxversion>>`
 2. Copy tarball to HDP server:

 `scp target/${KNOX_VERSION}/knox-${KNOX_VERSION}.tar.gz ${KNOX_HDP}:/home/${USER}/knox-${KNOX_VERSION}.tar.gz`

## Upgrade Knox
You need to follow [Upgrade the Knox Gateway](https://docs.hortonworks.com/HDPDocuments/HDP2/HDP-2.4.0/bk_upgrading_hdp_manually/content/access_subtab_2_3.html)

 1. `su root`
 2. `export KNOX_VERSION=<<knoxversion>>`
 3. `mkdir -p /usr/hdp/${KNOX_VERSION}`
 4. `hdp-select set knox-server ${KNOX_VERSION}`
 5. `cp /home/${SUDO_USER}/knox-${KNOX_VERSION}.tar.gz /usr/hdp/${KNOX_VERSION}`
 6. `cd /usr/hdp/${KNOX_VERSION}`
 7. `tar xvzf knox-${KNOX_VERSION}.tar.gz`
 8. `mv knox-${KNOX_VERSION} knox`
 9. Confirm the version changed: `ls -ltra /usr/hdp/current/knox-server`

 ## If First Installation
  1. 
----
