# Kerberos in HDP 2.4
The following is based off of the [official Hortonworks Guide](http://docs.hortonworks.com/HDPDocuments/HDP2/HDP-2.4.3/bk_Security_Guide/content/_enabling_kerberos_security_in_ambari.html).

## Pre-Requisite - Get Admin Access to Ambari
I had to [set the admin password](http://hortonworks.com/hadoop-tutorial/learning-the-ropes-of-the-hortonworks-sandbox/#setup-ambari-admin-password) for Ambari first.


## Install a new [MIT KDC](http://docs.hortonworks.com/HDPDocuments/HDP2/HDP-2.4.3/bk_Security_Guide/content/_optional_install_a_new_mit_kdc.html)

 * `sudo yum install krb5-server krb5-libs krb5-workstation`
 * Modify `/etc/krb5.conf`, changing `[realms]` to reflect your FQDN - e.g.

```
[libdefaults]
  renew_lifetime = 7d
  forwardable = true
  default_realm = EXAMPLE.COM
  ticket_lifetime = 24h
  dns_lookup_realm = false
  dns_lookup_kdc = false
  #default_tgs_enctypes = aes des3-cbc-sha1 rc4 des-cbc-md5
  #default_tkt_enctypes = aes des3-cbc-sha1 rc4 des-cbc-md5

[domain_realm]

  sandbox.hortonworks.com = EXAMPLE.COM

[logging]
  default = FILE:/var/log/krb5kdc.log
  admin_server = FILE:/var/log/kadmind.log
  kdc = FILE:/var/log/krb5kdc.log

[realms]
  EXAMPLE.COM = {
    admin_server = sandbox.hortonworks.com
    kdc = sandbox.hortonworks.com
  }

```

   * Create the Kerberos Database: `sudo kdb5_util create -s`
   * When prompted for a password just leave blank and press ENTER.
   * Start the Kerberos KDC Server/Admin:

```
sudo /etc/rc.d/init.d/krb5kdc start
sudo /etc/rc.d/init.d/kadmin start
```

 * Ensure the KDC Server/Admin get started automatically on boot:
```
sudo chkconfig krb5kdc on
sudo chkconfig kadmin on
```
 * Create a KDC Admin: `sudo kadmin.local -q "addprinc admin/admin"`
   * When prompted enter password as `admin`
 * Restart KDC Server/Admin:
```
  sudo /etc/rc.d/init.d/krb5kdc restart
  sudo /etc/rc.d/init.d/kadmin restart
```

 * Initialize Tickets:
```
sudo kinit admin/admin
```
 * Restart Ambari: `sudo ambari-server restart`

## Enabling Kerberos Security
 * I had the Unlimited Strength JCE already installed on the Azure based HDP 2.4 sandbox, so I did not need to follow [Installing the JCE](http://docs.hortonworks.com/HDPDocuments/HDP2/HDP-2.4.3/bk_Security_Guide/content/_installing_the_jce.html) - but you should [check](http://derjan.io/blog/2013/03/15/nevermind-jce-unlimited-strength-use-openjdk/).
 * I just used the [DEFAULT](http://docs.hortonworks.com/HDPDocuments/HDP2/HDP-2.4.3/bk_Security_Guide/content/create_mappings_betw_principals_and_unix_usernames.html) mappings between principals and unix usernames.
 * Finally I followed the [automated Kerboros Wizard](http://docs.hortonworks.com/HDPDocuments/HDP2/HDP-2.4.3/bk_Security_Guide/content/_launching_the_kerberos_wizard_automated_setup.html)

## Verifying Kerberos has been set up

The following curl command should now fail with a HTTP 401 error because the HDFS server requires authentication:
```
curl -i "http://sandbox:50070/webhdfs/v1/tmp?op=LISTSTATUS"
```

Steps to do a curl request to HDFS with Kerberos auth:

1. Log in as yourself on the server
1. Run the command `kinit admin/admin@EXAMPLE.COM`
  * Password should be `admin` if the steps from the first section of this document were followed.
1. Run the new curl command:
  ```
  curl -i --negotiate -u : "http://sandbox:50070/webhdfs/v1/tmp?op=LISTSTATUS"
  ```
1. Authentication should now pass and the headers should include a property like:

  > Set-Cookie: hadoop.auth="u=admin&p=admin/admin@EXAMPLE.COM&t=kerberos&e=1486148110150&s=U/S7vlnp8YxdK+culkvBYcKi5sQ="; Path=/; HttpOnly

## Activating Kerberos on Knox

This step requires modifying the config files in your Knox directory.

1. `cd /usr/hdp/current/knox-server/conf` (please ensure `hdp-select` shows the right version of Knox)
1. Create ethe file `krb5.conf`:

  ```
  [logging]
   default = FILE:/var/log/krb5libs.log
   kdc = FILE:/var/log/krb5kdc.log
   admin_server = FILE:/var/log/kadmind.log

  [libdefaults]
   default_realm = EXAMPLE.COM
   dns_lookup_realm = false
   dns_lookup_kdc = false
   ticket_lifetime = 24h
   renew_lifetime = 7d
   forwardable = true

  [realms]
   EXAMPLE.COM = {
    kdc = sandbox.hortonworks.com
    admin_server = sandbox.hortonworks.com
   }

  [domain_realm]
   sandbox.hortonworks.com = EXAMPLE.COM
  ```

1. Create the file `krb5JAASLogin.conf`:

  ```
  com.sun.security.jgss.initiate {
    com.sun.security.auth.module.Krb5LoginModule required 
    renewTGT=true
    doNotPrompt=true
    useKeyTab=true
    keyTab="/etc/security/keytabs/knox.service.keytab"
    principal="knox/sandbox.hortonworks.com@EXAMPLE.COM"
    isInitiator=true
    storeKey=true
    useTicketCache=true
    client=true;
  };
  ```

1. `gateway-site.xml` will require three of the properties are updated to match the following:

  ```
  <property>
      <name>gateway.hadoop.kerberos.secured</name>
      <value>true</value>
  </property>

  <property>
      <name>java.security.krb5.conf</name>
      <value>/usr/hdp/current/knox-server/conf/krb5.conf</value>
  </property>

  <property>
      <name>java.security.auth.login.config</name>
      <value>/usr/hdp/current/knox-server/conf/krb5JAASLogin.conf</value>
  </property>
  ```

1. Restart Knox

## NOTE: Spelling
Fun fact, I mis-spelled SAN**D**BOX.HORTONWORKS.COM as SANBOX.HORTONWORKS.COM (no **D**)
and endured untold pain.

## NOTE 2: Enabling Kerberos Stalling
When Ambari was enabling Kerberos, the UI stalled for over an hour.

After I killed the UI and logged in again, I found that Kerberos was enabled, but that the services hadn't been started up.

Thus I had to manually start up the services.

HOWEVER - please ensure you check the logs first to ensure it has finished kerberizing
the environment.

---

 * John McParland (john.mcparland AT cgi.com / johmmcparland AT gmail.com)
 * Th 1st Dec 2016
