# Kerberos in HDP 2.4
The following is based off of the [official Hortonworks Guide](http://docs.hortonworks.com/HDPDocuments/HDP2/HDP-2.4.3/bk_Security_Guide/content/_enabling_kerberos_security_in_ambari.html).

## Install a new [MIT KDC](http://docs.hortonworks.com/HDPDocuments/HDP2/HDP-2.4.3/bk_Security_Guide/content/_optional_install_a_new_mit_kdc.html)

 * `sudo yum install krb5-server krb5-libs krb5-workstation`
 * Modify `/etc/krb5.conf`, changing `[realms]` to reflect your FQDN - e.g.

```
[logging]
 default = FILE:/var/log/krb5libs.log
 kdc = FILE:/var/log/krb5kdc.log
 admin_server = FILE:/var/log/kadmind.log

[libdefaults]
 default_realm = HDP24SANDBOX.COM
 dns_lookup_realm = false
 dns_lookup_kdc = false
 ticket_lifetime = 24h
 renew_lifetime = 7d
 forwardable = true

[realms]
 HDP24SANDBOX.COM = {
  kdc = hdp24sandbox.com
  admin_server = hdp24sandbox.com
 }

[domain_realm]
 .hdp24sandbox.com = HDP24SANDBOX.COM
 hdp24sandbox.com = HDP24SANDBOX.COM
```

   * Create the Kerberos Database: `sudo kdb5_util create -s`
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
 * Add an entry to the config for your realm: `sudo vi /var/kerberos/krb5kdc/kadm5.acl`
 ```
 */admin@HDP24SANDBOX.COM     *
 ```
  * Restart KD Admin: `sudo /etc/rc.d/init.d/kadmin restart`
