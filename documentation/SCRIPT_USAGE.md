# Script Usage
How to use the various scripts in this repository.

Assumes you've followed [Getting Started on README](README.md#GettingStarted).

## knoxEnvSetup.sh
Sets up (on a Linux machine) and environment which allows the contribution to Apache Knox, my fork of Knox, and this repository.

Sets up
 * the `PATH` variable to allow access to scripts in this repository
 * git clone of Apache Knox (with official Apache Knox as `upstream` and my fork as `origin`)
 * Adds environment variable for an HDP IP/name for ease-of-use.

 * See [knoxEnvSetup.sh](knoxEnvSetup.sh)

## build.sh
Small wrapper script around Maven builds.

It allows a simple bash options style of build, with the aim of reducing the amount of typing
needed for the most frequently used option.

Don't use on it's own, use with [knoxBuild.sh](knoxBuild.sh)

 * See [build.sh](build.sh)
 * `build.sh -h` for up-to-date help information

## knoxBuild.sh
Calls the [build.sh](build.sh) script with the appropriate options to allow a successful build of Knox.

 * See [knoxBuild.sh](knoxBuild.sh)

## knoxStop.sh
For execution on a Hortonworks Data Platform v2.4 Sandbox.

Stops Apache Knox and it's LDAP service.

 * See [knoxStop.sh](knoxStop.sh)

## knoxUpgrade.sh
Upgrades Apache Knox to a new version on a Hortoworks Data Platform v2.4 sandbox.

Use [knoxStop.sh](knoxStop.sh) and [knoxUpgrade.sh](knoxUpgrade.sh) in conjuntion with the [Deployment](documentation/DEPLOYMENT.md) guide.

 * See [knoxUpgrade.sh](knoxUpgrade.sh)

## knoxCheck.sh
Checks that Knox is responsive on a Hortonworks Data Platform v2.4 sandbox.

Expected to be used after [knoxUpgrade.sh](knoxUpgrade.sh).

 * See [knoxCheck.sh](knoxCheck.sh)

## Merge Upstream to Origin
Merges the upstream (official Apache Knox repository) into the origin (my fork).

 * See [mergeUpstreamToOrigin.sh](mergeUpstreamToOrigin.sh)

## Reset Origin To Upstream
Resets the status of `origin` so that it is an exact replica of `upstream`.

The main use of this is after a patch is applied to `upstream` we can set `origin`
to have the same commits as `upstream` (otherwise it always appears to be ahead).

 * See [resetOriginToUpstream.sh](resetOriginToUpstream.sh)

---
