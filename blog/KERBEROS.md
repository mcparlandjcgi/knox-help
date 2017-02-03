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
  default_realm = SANBOX.HORTONWORKS.COM
  ticket_lifetime = 24h
  dns_lookup_realm = false
  dns_lookup_kdc = false
  #default_tgs_enctypes = aes des3-cbc-sha1 rc4 des-cbc-md5
  #default_tkt_enctypes = aes des3-cbc-sha1 rc4 des-cbc-md5

[domain_realm]

  sandbox.hortonworks.com = SANBOX.HORTONWORKS.COM

   .sandbox.hortonworks.com = SANBOX.HORTONWORKS.COM


[logging]
  default = FILE:/var/log/krb5kdc.log
  admin_server = FILE:/var/log/kadmind.log
  kdc = FILE:/var/log/krb5kdc.log

[realms]
  SANBOX.HORTONWORKS.COM = {
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
 * Add an entry to the config for your realm: `sudo vi /var/kerberos/krb5kdc/kadm5.acl`
 ```
 */admin@SANBOX.HORTONWORKS.COM     *
 ```
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

## Activating Kerberos on Knox (in progress step - success yet to be verified)

https://knox.apache.org/books/knox-0-11-0/user-guide.html#Secure+Clusters

Create knox user
* `useradd -g hadoop knox`

As `root` on the server:
1. Run `kadmin.local` to initialise an interactive session
1. In the session run these commands:
  * `add_principal -randkey knox/knox@EXAMPLE.COM`
  * `ktadd -k knox.service.keytab -norandkey knox/knox@EXAMPLE.COM`
  * `exit`
1. Copy the `knox.service.keytab` to the knox host:
```
chown knox:knox knox.service.keytab
chmod 400 knox.service.keytab
cp knox.service.keytab /usr/hdp/current/knox-server/conf
```
1. Copy the `krb5.conf` template:
```
cp /usr/hdp/current/knox-server/templates/krb5.conf /usr/hdp/current/knox-server/conf
sed -i s/hello\.hortonworks\.com/sandbox\.hortonworks\.com/g /usr/hdp/current/knox-server/conf/krb5.conf
chown knox:knox /usr/hdp/current/knox-server/conf/krb5.conf
```
1. Copy the `krb5JAASLogin.conf` template:
```
cp /usr/hdp/current/knox-server/templates/krb5JAASLogin.conf /usr/hdp/current/knox-server/conf
chown knox:knox /usr/hdp/current/knox-server/conf/krb5JAASLogin.conf
```
1. Update `gateway-site.xml`:
  * Run `vi /usr/hdp/current/knox-server/conf/gateway-site.xml`
  * Edit the value of `gateway.hadoop.kerberos.secured` to `true`
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
