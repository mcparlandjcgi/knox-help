# Alternative GUI for Solr (proxied through Knox)
Building on the work I completed for [KNOX-528](https://issues.apache.org/jira/browse/KNOX-528) to add Solr support
to Apache Knox (see [Part 1](/blog/KNOX_SOLR_PART1.md) and [Part 2](/blog/KNOX_SOLR_PART2.md))
I required a user interface to demonstrate the concept of searching Solr via Knox.

## Acceptance Criteria
With the following acceptance critiera

 * As a sysadmin, I need all Solr queries should be proxied through Apach Knox in order to provide Authentication and Authorization HDP services, including Solr.
 * As a user I wish to perform searches on information stored in Solr and see the results in a graphical user interface.
 * As a user, I wish to perform searches on information stored in Solr without needing prior knowledge of specific cores to search.
 * This is a demonstration GUI and thus NFRs such as performance, reliability are low priority, but usability, stability are high.

I aimed to create a small, Google-like search page for Solr.  A wireframe would be;

![Knox Solr Search UI Wireframe](/blog/img/knox_solr_mockup.png)

## Design Decisions
 * Use RESTful API with HTML5 front end
   * Ended up with Spring Boot for REST end points
   * AngularJS for HTML5 front end
 * Use a single deployable WAR
   * Just for ease of deployment
 * Use embedded container
   * Ease of deployment again
 * Make specific to the example docs in the Solr setup
   * Because it was a demo, I kept the front end implementation specific to the results in the example data set.  The backend was still generic

So we got a basic Spring MVC web app architecture with HTML5 front end

![Knox Solr Search UI Design](/blog/img/knox_solr_search_ui.png)

## Implementation
The implemetation was straightforward, and can be seen [on this github repo](https://github.com/mcparlandjcgi/knox_solr_search_ui).

## Deployment
The use of an embedded container eased deployment, however there was a sticking point
with the use of a self-signed certificate for HTTPS and Spring's REST Template.

As a result it was necessary to import the certificate into the Java keystore.  
Details [on the README](https://github.com/mcparlandjcgi/knox_solr_search_ui#getting-round-ssl-problem).

## End Result

![Final UI](/blog/img/knox_solr_search_ui_deployed.png)

----

# Banana
When [HDP Search](https://docs.hortonworks.com/HDPDocuments/HDP2/HDP-2.4.2/bk_hdp_search/content/ch_hdp-search-install.html) is installed on an HDP 2.4 platform, the Banana visualization
tool for Solr is installed too.

I attempted to do a simple change to the Solr configuration to proxy it through Knox
however it was unsuccessful because
 * It needs to proxy the "/admin" end point for Solr
 * It didn't pass authentication credentials correctly

As a result, more work would be required both to the Solr service/re-write rules in
Knox and possibly to Banana to make it work.

----

 * John McParland (john DOT mcparland AT cgi DOT com / johnmmcparland AT gmail DOT com)
 * F 25 Nov 2016
