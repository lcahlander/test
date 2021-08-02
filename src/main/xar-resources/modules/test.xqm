xquery version "3.1";
(:
Module Name: RestXQ APIs

Module Version: 1.0

Date: January 29, 2021

Copyright (c) 2021. EasyMetaHub, LLC

Proprietary
Extensions: eXist-db

XQuery
Specification March 2017

Module Overview:

 :)
(:~
This is the module containing the REST APIs for the downstream services to consume.

@author Loren Cahlander
@since January 29, 2021
@version 1.0
 :)
module namespace test = "http://exist-db.org/modules/ns/test-apis";
import module namespace config="http://exist-db.org/apps/config" at "config.xqm";

declare namespace rest="http://exquery.org/ns/restxq";
declare namespace output = "http://www.w3.org/2010/xslt-xquery-serialization";

(:~
test case for error.

@return
@custom:openapi-tag Test
 :)
declare
    %rest:GET
    %rest:path("/error/test")
    %rest:produces("application/xml")
    %output:media-type("application/xml")
    %output:method("xml")
function test:test-return()
{
    fn:doc($config:data-root || "/foo.xml")
};

