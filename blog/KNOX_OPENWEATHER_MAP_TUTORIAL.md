# Adding a Service
I followed [Kevin Minder's blog](http://kminder.github.io/knox/2015/11/16/adding-a-service-to-knox.html) article on adding a service to Apache Knox.

During this, I used an HDP 2.4 sandbox, and added the service to a release candidate of 0.10.0 of Apache Knox.

Kevin's blog article was straightforward and I managed to get the demo example up and running quite quickly.

You can use [this patch](/patches/TUTORIAL.patch) should you wish to copy it, but moving through, step-by-step is the best way.

Key learning from me (paraphrased from Kevin Minder)

 * ```service.xml``` ```service.role``` == ```topology``` ```<service><role>```
   * The interface
 * ```service.xml``` service ```name``` == directory beneath ```<GATEWAY_HOME>/data/services``` (by *convention*)
   * The implementation
 * ```service.xml``` ```<service><routes><route path=...```
   * This is the URL pattern that is handled
   * Don't include hosts/ports
   * Don't *usually* include params
   * In simple form, no **direct** relationship between this and rewrite routes

 * All re-write rules are combined into a single file (and namespace) at runtime
 * ```<rules><rule dir="IN"```: ```IN``` == REQUEST
 * Rule naming convention is ```role/name/<service specific>```
 * Wildcard matching
  * ```*``` in the pattern matches one segment of the URL
  * ```**``` matches 0 or more segments of the URL
  * ```{path=**}``` provides 0 or more path segments in param named ```path```
  * ```{**}``` matches 0 or more patch segments, providing them by name
 * ```<rules><rule><rewrite template="{$serviceUrl[WEATHER]/{path=**}?{**}}"```
   * ```{$serviceUrl[WATHER}]}``` looks up ```<service><url>``` for the WEATHER service in the topology

   ---

 * John McParland (john.mcparland AT cgi.com / johmmcparland AT gmail.com)
 * M 14th Nov 2016
