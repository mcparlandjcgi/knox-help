# Deploying Apache Knox to Hortonworks Data Platform 2.4
Out of the box, Hortonworks Data Platform v2.4 (HDP from here on) comes with [version 0.6.0](https://docs.hortonworks.com/HDPDocuments/HDP2/HDP-2.4.0/bk_HDP_RelNotes/content/ch_relnotes_v240.html) of Apache Knox and it's not enabled.

I wanted to get up and running as quickly as I could with Knox, with the first target to simply
run Knox and get a response from a remote machine.

I managed to accomplish this, after piecing together two guides
  * [Apache Knox User Guide v0.9.1](https://knox.apache.org/books/knox-0-9-1/user-guide.html)
  * [Hortonworks Guide on Upgrading Knox in Sandbox 2.4](https://docs.hortonworks.com/HDPDocuments/HDP2/HDP-2.4.0/bk_upgrading_hdp_manually/content/access_subtab_2_3.html)

The result was my [DEPLOYMENT guide](documentation/DEPLOYMENT.md) and accompanying scripts
 * [knoxStop.sh](knoxStop.sh)
 * [knoxUpgrade.sh](knoxUpgrade.sh)
 * [knoxCheck.sh](knoxCheck.sh)

I hope those prove useful to some.

---

 * John McParland (john.mcparland AT cgi.com / johmmcparland AT gmail.com)
 * W 2nd Nov 2016
 
