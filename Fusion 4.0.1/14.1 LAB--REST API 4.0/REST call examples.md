## Examples of REST calls

These REST calls work while ssh'd into a remote (AWS) host or if running a local instance of fusion. In either case the hostname is **localhost.**
If you are executing these call from a local shell but connecting to a remote AWS host, you will have to substitute **localhost** here for the instructor-provided IP of your assigned AWS instance.


### Collections
**cURL**

`curl -u admin:Lucidworks1 -X PUT -H 'Content-type: application/json' -d '{"solrParams":{"replicationFactor":1,"numShards":1}}' http://localhost:8764/api/collections/Wines`

`curl -u admin:Lucidworks1 -X GET http://localhost:8764/api/collections/Wines`

`curl -u admin:Lucidworks1 -X DELETE http://localhost:8764/api/collections/Wines` (deletes only collection in fusion only) 

`curl -u admin:Lucidworks1 -X DELETE http://localhost:8764/api/collections/Wines?solr=True&purge=True&pipelines=True` (deletes all solr collections and associated pipelines) 

**Poweshell**

`.\irm.ps1 -Method PUT -Uri "http://localhost:8764/api/collections/Wines" -Body '{"solrParams":{"replicationFactor":1,"numShards":1}}'`

`.\irm.ps1 -Method GET -Uri "http://localhost:8764/api/collections/Wines" `

`.\irm.ps1 -Method DELETE -Uri "http://localhost:8764/api/collections/Wines"` #deletes only collection in fusion, not solr

`.\irm.ps1 -Method DELETE -Uri "http://localhost:8764/api/collections/Wines?solr=True&purge=True&pipelines=True"` #deletes all solr collections and associated pipelines


### Datasources
**cURL**

`curl -u admin:Lucidworks1 -X POST -H 'Content-type: application/json' -d @JSON/wines-datasource.json http://localhost:8764/api/connectors/datasources`

`curl -u admin:Lucidworks1 -X GET http://localhost:8764/api/connectors/datasources/wines-datasource`

`curl -u admin:Lucidworks1 -X DELETE http://localhost:8764/api/connectors/datasources/wines-datasource`

**Poweshell**

`.\irm.ps1 -Method POST -Uri "http://localhost:8764/api/connectors/datasources" -Infile "JSON/wines-datasource.json"`

`.\irm.ps1 -Method GET -Uri "http://localhost:8764/api/connectors/datasources/wines-datasource"`

`.\irm.ps1 -Method DELETE -Uri "http://localhost:8764/api/connectors/datasources/wines-datasource"`


### Blobs
**cURL**

`curl -u admin:Lucidworks1 -X PUT --data-binary @datasets/winemag-data_first150k.csv -H 'Content-type: text/plain' http://localhost:8764/api/blobs/winemag-data_first150k.csv?resourceType=File`

`curl -u admin:Lucidworks1 -X GET http://localhost:8764/api/blobs/winemag-data_first150k.csv` (just returns the contents of the file)

`curl -u admin:Lucidworks1 -X DELETE http://localhost:8764/api/blobs/winemag-data_first150k.csv`

**Poweshell**

`.\irm.ps1 -Method PUT -Uri "http://localhost:8764/api/blobs/winemag-data_first150k.csv?resourceType=File" -Infile "datasets/winemag-data_first150k.csv" `

`.\irm.ps1 -Method GET -Uri "http://localhost:8764/api/blobs/winemag-data_first150k.csv"` (just returns the contents of the file)

`.\irm.ps1 -Method DELETE -Uri "http://localhost:8764/api/blobs/winemag-data_first150k.csv" `


### Parsers
**cURL**

`curl -u admin:Lucidworks1 -X POST -H 'Content-type: application/json' -d @JSON/wines-parser.json http://localhost:8764/api/parsers`

`curl -u admin:Lucidworks1 -X GET http://localhost:8764/api/parsers/wines-parser`

`curl -u admin:Lucidworks1 -X DELETE http://localhost:8764/api/parsers/wines-parser`

**Poweshell**

`.\irm.ps1 -Method POST -Uri "http://localhost:8764/api/parsers" -Infile "JSON/wines-parser.json"`

`.\irm.ps1 -Method GET -Uri "http://localhost:8764/api/parsers/wines-parser"`

`.\irm.ps1 -Method DELETE -Uri "http://localhost:8764/api/parsers/wines-parser"`


### Index Datasource Job
**cURL**

`curl -u admin:Lucidworks1 -X POST -H "Content-Type: application/json" http://localhost:8764/api/jobs/datasource:wines-datasource/actions -d '{"action": "start"}'`

`curl -u admin:Lucidworks1 -X GET http://localhost:8764/api/jobs/datasource:wines-datasource`

**Poweshell**

`.\irm.ps1 -Method POST -Uri "http://localhost:8764/api/jobs/datasource:wines-datasource/actions" -Body '{"action": "start"}'`

`.\irm.ps1 -Method GET -Uri "http://localhost:8764/api/jobs/datasource:wines-datasource"`


### Query via REST 
**cURL**

`curl -u admin:Lucidworks1 "http://localhost:8764/api/query-pipelines/Wines/collections/Wines/select?echoParams=all&wt=json&json.nl=arrarr&sort&start=0&q=*:*&debug=true&rows=10"`

**Poweshell**

`.\irm.ps1 -Method GET -Uri "http://localhost:8764/api/query-pipelines/Wines/collections/Wines/select?echoParams=all&wt=json&json.nl=arrarr&sort&start=0&q=*:*&debug=true&rows=10"`


### Apps
**cURL**

`curl -u admin:Lucidworks1 -X POST -H "Content-Type: application/json" -d @JSON/Wines-app.json http://localhost:8764/api/apps`

`curl -u admin:Lucidworks1 -X GET http://localhost:8764/api/apps/General`

`curl -u admin:Lucidworks1 -X DELETE http://localhost:8764/api/apps/General`

**Poweshell**

`.\irm.ps1 -Method POST -Uri "http://localhost:8764/api/apps" -Infile "JSON/Wines-app.json"`

`.\irm.ps1 -Method GET -Uri "http://localhost:8764/api/apps/General"` 

`.\irm.ps1 -Method DELETE -Uri "http://localhost:8764/api/apps/General"`


### Object Links
**cURL**

`curl -u admin:Lucidworks1 -X PUT -H 'Content-type: application/json' -d  '{"subject" : "collection:Wines","object" : "app:General","linkType" : "inContextOf"}'  http://localhost:8764/api/links`

`curl -u admin:Lucidworks1 -X GET http://localhost:8764/api/links?subject=collection:Wines`

**Poweshell**

`.\irm.ps1 -Method PUT -Uri "http://localhost:8764/api/links?subject=collection:Wines" -Body '{"subject" : "collection:Wines","object" : "app:General","linkType" : "inContextOf"}'`

`.\irm.ps1 -Method GET -Uri "http://localhost:8764/api/links?subject=collection:Wines"`


### Tasks: Define 
**cURL**

`curl -u admin:Lucidworks1 -X POST -H 'Content-type: application/json' -d @JSON/new-cleanup-task.json http://localhost:8764/api/tasks`

`curl -u admin:Lucidworks1 -X GET http://localhost:8764/api/tasks/delete-system-logs-gt-1-day`

`curl -u admin:Lucidworks1 -X DELETE http://localhost:8764/api/tasks/delete-system-logs-gt-1-day`

**Poweshell**

`.\irm.ps1 -Method POST -Uri "http://localhost:8764/api/tasks" -Infile "JSON/new-cleanup-task.json"`

`.\irm.ps1 -Method GET -Uri "http://localhost:8764/api/tasks/delete-system-logs-gt-1-day"`

`.\irm.ps1 -Method DELETE -Uri "http://localhost:8764/api/tasks/delete-system-logs-gt-1-day"`


### Tasks: Start 
**cURL**

`curl -u admin:Lucidworks1 -X POST -H "Content-Type: application/json" http://localhost:8764/api/jobs/task:delete-system-logs-gt-1-day/actions -d '{"action": "start"}'`

`curl -u admin:Lucidworks1 -X GET http://localhost:8764/api/jobs/task:delete-system-logs-gt-1-day`

**Poweshell**

`.\irm.ps1 -Method POST -Uri "http://localhost:8764/api/jobs/task:delete-system-logs-gt-1-day/actions" -Body '{"action": "start"}'`

`.\irm.ps1 -Method GET -Uri "http://localhost:8764/api/jobs/task:delete-system-logs-gt-1-day"`


### Query Profiles 
**cURL**

`curl -u admin:Lucidworks1 -X POST -H 'Content-type: application/json' -d @JSON/main-2-wines-pipeline.json http://localhost:8764/api/query-profiles`

`curl -u admin:Lucidworks1 -X GET http://localhost:8764/api/query-profiles/main`

`curl -u admin:Lucidworks1 -X PUT -H 'Content-type: application/json' -d @JSON/main-2-general-pipeline.json http://localhost:8764/api/query-profiles/main`

**Poweshell**

`.\irm.ps1 -Method POST -Uri "http://localhost:8764/api/query-profiles" -Infile "JSON/main-2-wines-pipeline.json"`

`.\irm.ps1 -Method GET -Uri "http://localhost:8764/api/query-profiles/main"`

`.\irm.ps1 -Method PUT -Uri "http://localhost:8764/api/query-profiles/main" -Infile "JSON/main-2-general-pipeline.json"`