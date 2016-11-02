# Knox Help Contributing Guide

There's two areas of Contribution

 * [To Knox](#ToKnox)
 * [To This Repository](#ToThisRepository)

---

## To Knox

### Apache Knox
 1. Read the [Apache Knox Contribution Process](https://cwiki.apache.org/confluence/display/KNOX/Contribution+Process)
 2. Setup a [GitHub](https://github.com) account, and generate add an [SSH Key](https://help.github.com/articles/generating-an-ssh-key/).

### Get the Code
 1. `git clone git@github.com:mcparlandjcgi/knox-help.git`
 2. `chmod u+x *.sh`
 3. `./knox_env_setup.sh` - **NOTE:** This will
   1. Clone [John's fork](https://github.com/mcparlandjcgi/knox) setting it as  `origin`
   2. Clone [Apache Knox Official](git@github.com:apache/knox.git) setting it as `upstream`

### Modifying Knox
 1. [Branch by feature/ticket](https://www.atlassian.com/git/tutorials/comparing-workflows/feature-branch-workflow)
 2. Work against `origin` (which is [John's fork](https://github.com/mcparlandjcgi/knox))
 3. As a team, we'll decide when to merge into `upstream` (which is [Apache Knox Official](git@github.com:apache/knox.git))

### Merging Upstream Into Origin
Based around Atlassian Blog on [Git Forks and Upstreams](http://blogs.atlassian.com/2013/07/git-upstreams-forks/).
 1. Assumes `origin` is [John's fork](https://github.com/mcparlandjcgi/knox)
 1. Assumes `upstream` is [Apache Knox Official](git@github.com:apache/knox.git)
```
git fetch upstream
git checkout master
git merge upstream/master
```

---

## To This Repository

### Get the Code/Docs
If not already, get the code/documents.
1. `git clone git@github.com:mcparlandjcgi/knox-help.git`
2. `chmod u+x *.sh`

### Modify the Code/Docs
 1. Create a new issue on GitLab.
 2. Branch [Branch by feature/ticket](https://www.atlassian.com/git/tutorials/comparing-workflows/feature-branch-workflow)
  3. Get a pull review.

---
