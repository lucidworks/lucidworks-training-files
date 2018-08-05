# Machine Learning 4.0.1 Labs
Some of the instruction in some Labs may be problematic to copy/paste from PDF due to differences in your laptop OS and/or PDF rendering program. 
To facilitate the Labs, below are slides where problematic text can be copied from. 
Other minor errata and clarifications on Lab pages are listed here.  
Not every Lab/Slide are listed here, only the ones that need attention. 

---

### Lab 1. Spark and Data Prep  

#### Slide 6: Machine Setup—Editing fusion.properties
Some of the dashes containing jvm values are pdf dashes which will not work in Fuaion 
Here are the corrected copy/paste values: 

```
connectors-rpc.jvmOptions = -Xmx4g -Xms4g
connectors-classic.jvmOptions = -Xmx4g -Xms4g -Dcom.lucidworks.connectors.pipelines.embedded=false
solr.jvmOptions = -Xmx8g -Xms8g
spark-worker.jvmOptions = -Xmx8g -Xms8g
```


#### Slide 13: Importing Data into Spark
```
val ecommerceFullCatalog = spark.read.parquet("/opt/fusion/training/ecommerce/")
```


#### Slide 14: Importing Data into Spark
```
val allClicks = spark.read.parquet("/opt/fusion/training/bestbuy-signals-parquet")
```


#### Slide 17: Downsampling the Catalog Data
```
val someHardGoods = ecommerceFullCatalog.filter("department IN ('ACCESSORIES', 'APPLIANCE', 'COMPUTERS')")
```


#### Slide 19: Downsampling the Clickstream Data
```
val trimmedClicks = allClicks.select("query","doc_id","fusion_query_id","filters_s","type", "count_i","timestamp_tdt","user_id","id") 
```


#### Slide 20: Downsampling the Clickstream Data
```
val hardGoodClicks = trimmedClicks.alias("TC").join(someHardGoods.withColumnRenamed("id", "doc_id"), Seq("doc_id")).select("TC.*", "name", "longDescription", "department")
```


#### Slide 22: Downsampling the Clickstream Data
```
val userClickCounts = hardGoodClicks.groupBy("user_id").count.withColumnRenamed("count", "user_count")
val itemClickCounts = hardGoodClicks.groupBy("doc_id").count.withColumnRenamed("count", "item_count")
```

#### Slide 23: Downsampling the Clickstream Data
```
val clicksWithCounts = hardGoodClicks.join(userClickCounts, Seq("user_id")).join(itemClickCounts, Seq("doc_id")) 
clicksWithCounts.select("query", "user_id","doc_id","user_count", "item_count").show 
```


#### Slide 24: Downsampling the Clickstream Data
```
val usefulClicks = clicksWithCounts.filter("user_count > 2 AND item_count > 4").drop("user_count","item_count")
```


#### Slide 27: Updating Click Dates
```
object SignalsTimestampUpdater extends Serializable {
import spark.implicits._
import org.apache.spark.sql.functions._
import org.apache.spark.sql.DataFrame
import java.sql.Timestamp

def updateTimestamps(signalsDF: DataFrame): DataFrame = {
val now = System.currentTimeMillis()
val maxDate = signalsDF.agg(max("timestamp_tdt")).take(1)(0).getAs[Timestamp](0).getTime
val diff = now - maxDate
val addTime = udf((t: Timestamp, diff : Long) => new Timestamp(t.getTime + diff))

//Remap some columns to bring the timestamps current
val newDF = signalsDF.withColumnRenamed("timestamp_tdt", "orig_timestamp_tdt").withColumn("timestamp_tdt", addTime($"orig_timestamp_tdt",lit(diff)))
newDF
}
}

```


#### Slide 28: Updating Click Dates
```
val updatedClicks = SignalsTimestampUpdater.updateTimestamps(usefulClicks)
```


#### Slide 29: Loading Data into Solr
```
someHardGoods.write.format("solr").option("collection", "Labs").option("soft_commit_secs", "10").save 
updatedClicks.write.format("solr").option("collection", "Labs_signals").option("soft_commit_secs", "10").save 
```

---

### Lab 2. Working with Signals
#### Slide 7: Exploring Labs_signals
Watch the PDF curly quotes 
The correct search argument for the query should be with Straight Quotes as: 
```
query:"cd cases"
```

---

### Lab 3. Building a Query Intent Classifier
#### Slide 16:Creating a New Pipeline
The Name is covered by the pic but it should be 
```
Labs_department_QI
```


#### Slide 24:Testing the Classifier Pipeline
The Lab instruction reads:
"In the Labs Query Workbench, execute the query ipod cover" 
**HOWEVER** the workbench uses previously loaded data from Labs Pipeline (not Labs department QI pipeline) 
You need to specifically click on the "Load" button (top right) and use Labs department QI pipeline
	
---

### Lab 4. Building a Recommender
#### No corrections

---

### Lab 5. Experiment Management
#### Slide 28:Simulating User Activity
The lab is pointing to a different GitHub location, however, it is also here: 

```
//val spark : org.apache.spark.sql.SparkSession = ???
//val sc : org.apache.spark.SparkContext = ???

import com.lucidworks.spark.fusion.FusionPipelineClient
import shaded.com.fasterxml.jackson.databind.JsonNode
//import com.fasterxml.jackson.databind.JsonNode
import java.time.format.DateTimeFormatter
import java.util.{Collections, Date}

import scala.collection.JavaConverters._
import org.apache.log4j.Logger
import java.util.UUID.randomUUID

import scala.collection.mutable.SortedSet

@transient lazy val log = Logger.getLogger("gen_exp_traffic")

 val numQueries = 500
 val queriesMap = Map("collection" -> "Labs_signals", "query" -> "*:*", "flatten_multivalued" -> "false", "fields" -> "query", "max_rows" -> s"$numQueries")
 val fusionEndpoints = "http://localhost:8765"
 val queryProfilePath = s"/api/v1/query/Labs"
 val postSignalPath = s"${queryProfilePath}/signals"
 val jsonContentType = "application/json"
 val numPartitions = 8
 val numUsers = 10000
val filters = Map("id" -> 0.4, "_version_" -> 0.3, "name" -> 0.2, "" -> 0.1)
val pctClicksPerVariant = List(0.4d, 0.2d, 0.1d)
val pctAddsPerVariant = List(0.25d, 0.15d, 0.05d)
val pctTail = 0.1d
// distribution of # of users per query
val maxUsersPerQuery = List(200,100,100,50,50,35,35,25,25,25,20,20,20,20,10,10,10,10,10,7,7,7,7,7,7,7,7,5,5,5,5,5,5,5,5,5,5,2,2,2,2,2,2,2,2,1,1,1,1,1,1)
val doClickPct = 100
val seed = 5150
val random = new java.util.Random(seed)
// keeping track of pct of matched docs
val queriesSent = sc.longAccumulator("queriesSent")
val numClicks = sc.longAccumulator("numClicks")
val numCarts = sc.longAccumulator("numCarts")
val noDocsResults = sc.longAccumulator("noDocsResults")

def sample[A](rand: java.util.Random, dist: Map[A, Double]): A = {
  val p = rand.nextDouble
  val it = dist.iterator
  var accum = 0.0
  while (it.hasNext) {
    val (item, itemProb) = it.next
    accum += itemProb
    if (accum >= p)
      return item
  }
  dist.keySet.head // shouldn't ever hit this
}

def escapeSolrQuery(q: String) : String = {
  // these need to be escaped correctly in solr queries
  val specialQueryChars = List("+","-","&&","||","!","(",")","{","}","[","]","^","\"","~","*","?",":","/")
  var query = q
  specialQueryChars.foreach(e => query = query.replace(e, "\\"+e))
  query
}

// utility method for sending a query request to a fusion pipeline endpoint
def queryFusion(fusion: FusionPipelineClient, queryParams: Map[String,String]) : Option[JsonNode] = {
  try {
    val jsonTree = fusion.queryFusion(queryProfilePath, queryParams.asJava)
    if (jsonTree != null) {
      val response = jsonTree.get("response")
      if (response != null) {
        val docs = response.get("docs")
        if (docs.isArray && docs.size > 0) {
          return Some(jsonTree)
        }
      }
    }
  } catch {
    case exc : Exception => log.info(s"Query [${queryParams.mkString("&")}] failed due to: ${exc}")
    case thr : Throwable => throw thr
  }
  return None
}

def postSignal(fusion: FusionPipelineClient, signalDoc: Map[String,_]) = {
  val timestamp = DateTimeFormatter.ISO_INSTANT.format((new Date()).toInstant)
  val withTs = signalDoc ++ Map("timestamp_tdt" -> timestamp)
  try {
    fusion.postBatchToPipeline(postSignalPath, Collections.singletonList(withTs.asJava), jsonContentType)
  } catch {
    case exc : Exception => log.info(s"POST signal [${signalDoc.mkString(", ")}] failed due to: ${exc}")
    case thr : Throwable => throw thr
  }
}

def postRequestSignal(fusion: FusionPipelineClient, userId: String, query: String, sessionId: String, filterField: String) = {
  var params = Map("domain" -> "lucidworks.com",
    "host" -> "64.71.15.234",
    "query" -> query,
    "userId" -> userId,
    "session" -> sessionId,
    "app_id" -> "scala_traffic_gen")
  if (!filterField.isEmpty) {
    params = params ++ Map("filter_field" -> s"${filterField}", "filter" -> s"${filterField}:[* TO *]")
  }
  postSignal(fusion, Map("id" -> randomUUID().toString, "type" -> "request", "params" -> params))
}


spark.read.format("solr").options(queriesMap).load.rdd.repartition(numPartitions).foreachPartition(iter => {
  val variants : SortedSet[String] = SortedSet()
  val fusion = new FusionPipelineClient(fusionEndpoints)
  iter.foreach(query => {
    val doMisspell = false // random.nextDouble <= pctTail
    val numUsersForThisQuery = maxUsersPerQuery.apply(random.nextInt(maxUsersPerQuery.size))
    List.range(0,numUsersForThisQuery).foreach(n => {
      val u = random.nextInt(numUsers)
      val userId = u.toString
      val query_s = query.getString(0)
      val sessionId = randomUUID().toString
      val filterField = sample(random, filters)

      var queryParams = Map("q" -> escapeSolrQuery(query_s),
        "userId" -> userId,
        "fl" -> "id",
        "session" -> sessionId,
        "app_id" -> "scala_traffic_gen")
      if (!filterField.isEmpty) {
        queryParams = queryParams ++ Map("fq" -> s"${filterField}:[* TO *]")
      }

      val resp = queryFusion(fusion, queryParams)
      queriesSent.add(1)

      if (doMisspell && random.nextBoolean) {
        var badQuery = query_s
        if (badQuery.contains("a")) {
          badQuery = badQuery.replaceFirst("a", "q")
        } else if (badQuery.contains("e")) {
          badQuery = badQuery.replaceFirst("e", "d")
        } else if (badQuery.contains("i")) {
          badQuery = badQuery.replaceFirst("i", "u")
        } else if (badQuery.contains("o")) {
          badQuery = badQuery.replaceFirst("o", "p")
        } else if (badQuery.contains("u")) {
          badQuery = badQuery.replaceFirst("u", "y")
        }
        // generate some tail traffic with misspelled terms
        if (badQuery != query_s) {
          //Thread.sleep(100)
          queryFusion(fusion, Map("q" -> escapeSolrQuery(badQuery),
            "userId" -> userId,
            "fl" -> "id",
            "session" -> sessionId,
            "app_id" -> "scala_traffic_gen"))
        }
      }

      var didClick = false
      if (resp.isDefined) {
        val queryResp = resp.get
        val rh = queryResp.get("responseHeader")
        val rhParams = rh.get("params")
        val variantId = if (rhParams.get("fusionExperimentVariant") != null) rhParams.get("fusionExperimentVariant").asText() else ""
        variants += variantId
        val variantIdx = variants.toSeq.indexOf(variantId)
        val pctClickIdx = if (variantIdx < pctClicksPerVariant.size) variantIdx else 0
        if (random.nextDouble <= pctClicksPerVariant.apply(pctClickIdx)) {
          didClick = true
          // send a request signal as part of this query as that's what twigkit does
          postRequestSignal(fusion, userId, query_s, sessionId, filterField)
          val fusionQueryId = rhParams.get("fusionQueryId").asText()
          val docs = queryResp.get("response").get("docs").asScala.toList

          // find which doc to click on in the results based on the num docs returned and the variant
          val clickPosRange = if (docs.size > 3 && variantIdx % 2 == 0) {
            if (random.nextBoolean) {
              1
            } else {
              math.ceil(docs.size/2).toInt
            }
          } else {
            docs.size
          }
          val docId = docs.apply(random.nextInt(clickPosRange)).get("id").asText()

          var params = Map("fusionQueryId" -> fusionQueryId, "query" -> query_s, "userId" -> userId, "docId" -> docId, "session" -> sessionId, "app_id" -> "scala_traffic_gen")
          if (!filterField.isEmpty) {
            params = params ++ Map("filter_field" -> s"${filterField}", "filter" -> s"${filterField}:[* TO *]")
          }
          println(s"Sending 'click' signal on doc $docId by user $userId for query $fusionQueryId in variant ${variantId}")
          postSignal(fusion, Map("id" -> randomUUID().toString, "type" -> "click", "params" -> params))
          numClicks.add(1)
          val pctAddIdx = if (variantIdx < pctAddsPerVariant.size) variantIdx else 0
          if (random.nextDouble <= pctAddsPerVariant.apply(pctAddIdx)) {
            println(s"Sending 'cart' signal on doc $docId by user $userId for query $fusionQueryId in variant ${variantId}")
            postSignal(fusion, Map("id" -> randomUUID().toString, "type" -> "cart", "params" -> params))
            numCarts.add(1)
          }
        }
      } else {
        noDocsResults.add(1)
      }

      if (!didClick) {
        // request signal w/o click
        postRequestSignal(fusion, userId, query_s, sessionId, filterField)
      }
    })
  })
  fusion.shutdown
})

println(s"queriesSent: ${queriesSent.value}")
println(s"numClicks: ${numClicks.value}")
println(s"numCarts: ${numCarts.value}")
println(s"noDocsResults: ${noDocsResults.value}")

```

---

### Lab 5. Experiment Management
#### Slide 29:Simulating User Activity
```
curl -X POST 'http://localhost:8983/solr/Labs_signals/update?commit=true' -d '<delete><query>app_id:("scala_traffic_gen")</query></delete>'
```

---

### Lab 6. Clustering
#### Slide 1, Step 2
There is not a clustering job already defined, so you have to **Add** a new **Document Clustering** job. 
Click on the **Advanced** switch
Use the following parameters for the Clustering job: 

Parameter | Value | Explanation
--- | --- | ---
Spark Job ID | Labs_Clustering | The ID for this Spark job. Used in the API to reference this job
Training Collection | Labs | Solr Collection containing documents to be clustered
Field to Vectorize | longDescription | Solr field containing text training data for prediction/clustering instances
Output Collection | Labs | Solr Collection to store model-labeled data to
Training data sampling fraction | 0.2 | Fraction of the training data to use


#### Slide 2, Step 3
```
tail -f /home/ubuntu/fusion/4.0.1/var/log/api/spark-driver-default.log | grep ClusteringTask:
```


#### Slide 2, Step 4
Here are the steps clarified: 

1. Go to the Labs Collection -> Query Workbench 
2. Delete the Facet for **department** if exists 
3. Add a Facet for **cluster_label**
4. Add a second Facet for **freq_terms**
5. Add a third Facet for **shortDescription**
6. On top, under **Choose Sort Field** select **dist_to_center**, Ascending order



#### Slide 3, Step 5
The line: 

Also, click on the “short_doc” facet, do you find any problem...`

should read 

Also, click on the` **“shortDescription”** `facet, do you find any problem...

---

### Lab 6. Clustering
#### Slide xx:xxxx

---

### Lab 6. Clustering
#### Slide xx:xxxx

---

### Lab 6. Clustering
#### Slide xx:xxxx

---

### Lab 6. Clustering
#### Slide xx:xxxx

---

### Lab 6. Clustering
#### Slide xx:xxxx

---

### Lab 6. Clustering
#### Slide xx:xxxx

---
