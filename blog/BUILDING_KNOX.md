# Building Knox
When I first checkout/clone a maven project the first thing I do is

`mvn clean package install`

As, regardless of how the project is structured, one expects those goals to work.

However on my first attempt at building [my fork of Apache Knox](https://github.com/mcparlandjcgi/knox), that didn't work with as a result of the following `maven-assembly-plugin` errors.

```
$ mvn clean package install
...
[INFO] ------------------------------------------------------------------------
[INFO] Building gateway-demo-ldap-launcher 0.10.0-SNAPSHOT
[INFO] ------------------------------------------------------------------------
...
[INFO] --- maven-assembly-plugin:2.4:single (server-launcher) @ gateway-demo-ldap-launcher ---
[WARNING] Artifact: org.apache.knox:gateway-demo-ldap-launcher:jar:0.10.0-SNAPSHOT references the same file as the assembly destination file. Moving it to a temporary location for inclusion.
[INFO] Building jar: /home/mcparlandj/git/knox/gateway-demo-ldap-launcher/target/gateway-demo-ldap-launcher-0.10.0-SNAPSHOT.jar
[WARNING] Configuration options: 'appendAssemblyId' is set to false, and 'classifier' is missing.
Instead of attaching the assembly file: /home/mcparlandj/git/knox/gateway-demo-ldap-launcher/target/gateway-demo-ldap-launcher-0.10.0-SNAPSHOT.jar, it will become the file for main project artifact.
NOTE: If multiple descriptors or descriptor-formats are provided for this project, the value of this file will be non-deterministic!
[WARNING] Replacing pre-existing project main-artifact file: /home/mcparlandj/git/knox/gateway-demo-ldap-launcher/target/archive-tmp/gateway-demo-ldap-launcher-0.10.0-SNAPSHOT.jar
with assembly file: /home/mcparlandj/git/knox/gateway-demo-ldap-launcher/target/gateway-demo-ldap-launcher-0.10.0-SNAPSHOT.jar
...
[INFO] --- maven-assembly-plugin:2.4:single (server-launcher) @ gateway-demo-ldap-launcher ---
[WARNING] Artifact: org.apache.knox:gateway-demo-ldap-launcher:jar:0.10.0-SNAPSHOT references the same file as the assembly destination file. Moving it to a temporary location for inclusion.
...
[ERROR] Failed to execute goal org.apache.maven.plugins:maven-assembly-plugin:2.4:single (server-launcher) on project gateway-demo-ldap-launcher: Execution server-launcher of goal org.apache.maven.plugins:maven-assembly-plugin:2.4:single failed: MALFORMED -> [Help 1]
```

After asking on the [Knox Dev Mail list](http://mail-archives.apache.org/mod_mbox/knox-dev/) I found that the normal way of building Knox is to use the `-Prelease` or `-Ppackage` profiles
along with the `clean install` goals.  

It appears there's a clash with the Maven `package` goal and how the `maven-assembly-plugin` is configured for certain modules in Knox.

## Inspiration
This early experience of Knox served as the inspiration for the github repository and this blog.
 1. An opportunity to wrap up command sequences/long command lines into simple Scripts
 1. An opportunity to write a little about what I'd found, and help others

The earlies stages were creating
 * [build.sh](build.sh) - simple maven wrapper (to be fair, I almost always use this)
 * [knoxBuild.sh](knoxBuild.sh) - executing exact command line required for Knox build
 * [knoxEnvSetup.sh](knoxEnvSetup.sh) - setup of a simple environment on my laptop.

Hopefully it'll be of some help.

## Conclusion

Thus I'd always recommend building with

`mvn clean install`

until [KNOX-766](https://issues.apache.org/jira/browse/KNOX-766) is fixed.

---

 * John McParland (john.mcparland AT cgi.com / johmmcparland AT gmail.com)
 * W 2nd Nov 2016

---
