# Patching
... the main upstream git repository.

This assumes your `origin` is a fork of `upstream` (the main Apache Knox).

On your branch (`git checkout origin KNOX-nnn`) do

```
git reset --soft origin/master
git format-patch upstream/master --stdout > KNOX-nnn.patch
```
