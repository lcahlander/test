xquery version "3.1";
(:~
A set of helper functions to access the application context from
within a module.

@author Loren Cahlander
@since August 2, 2021
@version 1.0.0
 :)
module namespace config="http://exist-db.org/apps/config";
declare namespace templates="http://exist-db.org/xquery/templates";

declare namespace repo="http://exist-db.org/xquery/repo";
declare namespace expath="http://expath.org/ns/pkg";
declare namespace test="http://exist-db.org/xquery/xqsuite";

(:~
    Determine the application root collection from the current module load path.
:)
declare variable $config:app-root :=
    let $rawPath := system:get-module-load-path()
    let $modulePath :=
        (: strip the xmldb: part :)
        if (starts-with($rawPath, "xmldb:exist://")) then
            if (starts-with($rawPath, "xmldb:exist://embedded-eXist-server")) then
                substring($rawPath, 36)
            else
                substring($rawPath, 15)
        else
            $rawPath
    return
        substring-before($modulePath, "/modules")
;

(:~
 :)
declare variable $config:repo-descriptor := doc(concat($config:app-root, "/repo.xml"))/repo:meta;

(:~
 :)
declare variable $config:expath-descriptor := doc(concat($config:app-root, "/expath-pkg.xml"))/expath:package;


(:~
 :)
declare variable $config:data-root := $config:app-root || "/data";



(:~
 :)
declare function config:mkcol-recursive($collection, $components) {
    if (exists($components)) then
        let $newColl := concat($collection, "/", $components[1])
        return (
            if (xmldb:collection-available($newColl))
            then ()
            else xmldb:create-collection($collection, $components[1]),
            config:mkcol-recursive($newColl, subsequence($components, 2))
        )
    else
        ()
};

(:~
Helper function to recursively create a collection hierarchy.
 :)
declare function config:mkcol($collection, $path) {
    config:mkcol-recursive($collection, tokenize($path, "/"))
};


