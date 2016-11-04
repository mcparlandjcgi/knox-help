# Knox Help

This project provides

 * Scripts/Shell Environment
 * Documentation
 * [My Knox Blog](/blog/ARTICLES.md)

To aid the development of Apache Knox.

---

## Getting Started

### Get the Code
 1. `git clone git@github.com:mcparlandjcgi/knox-help.git`
 2. `chmod u+x *.sh`
 3. `./knoxEnvSetup.sh` - **NOTE:** This will
   1. Clone [John's fork](https://github.com/mcparlandjcgi/knox) setting it as  `origin`
   2. Clone [Apache Knox Official](git@github.com:apache/knox.git) setting it as `upstream`
   3. Create an environment for developing Apache Knox by
      * Adding shell scripts to PATH
      * Creating KNOX_HDP environment variable for the IP/name of the Hortonworks Data Platform server.

### Read the Docs
 1. Read the [Contribution Guide](CONTRIBUTING.md)
 1. Read how to [Deploy Knox to HDP 2.4](documentation/DEPLOYMENT.md)
 1. Read on [Script Usage](documentation/SCRIPT_USAGE.md)

---

## Blog
 * [All Articles](blog/ARTICLES.md)

---
