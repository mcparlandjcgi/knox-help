# ODSC Knox

## Getting Started

### This Repository
 1. `git clone ssh://git@gitlab.cgi-odsc.com:57476/cysafa/odsc_knox.git`
 2. `chmod u+x *.sh`
 3. `./cysafa_env_setup.sh`
 4. (ToDo - Verify if needed) Modify `~/.bash_cysafa` to set the correct names of
 the HDP and Ubuntu machines you'll use.

---

### Apache Knox
 1. Read the [Apache Knox Contribution Process](https://cwiki.apache.org/confluence/display/KNOX/Contribution+Process) particularly the [GitHub Workflow](https://cwiki.apache.org/confluence/display/KNOX/Contribution+Process#ContributionProcess-GithubWorkflow).
 2. Setup a CGI-only [GitHub](https://github.com) account, and generate add an [SSH Key](https://help.github.com/articles/generating-an-ssh-key/).
 3. Clone [Apache Knox](git://git.apache.org/knox.git/): `git clone git://git.apache.org/knox.git`
 4. Add a remote for [John's fork](https://github.com/mcparlandjcgi/knox): `git remote add github https://github.com/mcparlandjcgi/knox.git`
 4. [Branch by feature/ticket](https://www.atlassian.com/git/tutorials/comparing-workflows/feature-branch-workflow)

---

## Frequent Tasks

### Sync'ing the Fork
 1. Assumes `origin` is Apache Knox main git repository.
 1. Assumes `github` is [John's fork](https://github.com/mcparlandjcgi/knox)
```
git fetch origin
git checkout github/master
git merge origin/master
git push github master
```

---
