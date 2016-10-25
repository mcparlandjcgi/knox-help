# ODSC Knox

## Getting Started

### Apache Knox
 1. Read the [Apache Knox Contribution Process](https://cwiki.apache.org/confluence/display/KNOX/Contribution+Process)
 2. Setup a CGI-only [GitHub](https://github.com) account, and generate add an [SSH Key](https://help.github.com/articles/generating-an-ssh-key/).

### This Repository
 1. `git clone ssh://git@gitlab.cgi-odsc.com:57476/cysafa/odsc_knox.git`
 2. `chmod u+x *.sh`
 3. `./cysafa_env_setup.sh` - **NOTE: ** This will
   1. Clone [John's fork](https://github.com/mcparlandjcgi/knox) setting it as  `origin`
   2. Clone [Apache Knox Official](git@github.com:apache/knox.git) setting it as `upstream`

---

## Modifying Knox
 1. [Branch by feature/ticket](https://www.atlassian.com/git/tutorials/comparing-workflows/feature-branch-workflow)
 2. Work against `origin` (which is [John's fork](https://github.com/mcparlandjcgi/knox))
 3. As a team, we'll decide when to merge into `upstream` (which is [Apache Knox Official](git@github.com:apache/knox.git))

---

## Frequent Tasks

### Sync'ing the Fork
Based around Atlassian Blog on [Git Forks and Upstreams](http://blogs.atlassian.com/2013/07/git-upstreams-forks/).
 1. Assumes `origin` is [John's fork](https://github.com/mcparlandjcgi/knox)
 1. Assumes `upstream` is [Apache Knox Official](git@github.com:apache/knox.git)
```
git fetch upstream
git checkout master
git merge upstream/master
```

---
