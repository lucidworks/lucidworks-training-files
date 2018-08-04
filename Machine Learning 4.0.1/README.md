# Machine Learning 4.0.1 Labs
Some of the instruction in some Labs may be problematic to copy/paste from PFDF due to differences in your laptop OS and/or PDF rendering program. 
To facilitate the Labs, below are slides where problematic text can be copied from. 
Only some PDF slides are listed here. 

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




object SignalsTimestampUpdater extends Serializable {
import spark.implicits._
import org.apache.spark.sql.functions._
import org.apache.spark.sql.DataFrame
import java.sql.Timestamp
def updateTimestamps(signalsDF: DataFrame): DataFrame = {
val now = System.currentTimeMillis()
val maxDate =
signalsDF.agg(max("timestamp_tdt")).take(1)(0).getAs[Timestamp](
0).getTime
val diff = now - maxDate
val addTime = udf((t: Timestamp, diff : Long) => new
Timestamp(t.getTime + diff))
//Remap some columns to bring the timestamps current
val newDF = signalsDF
.withColumnRenamed("timestamp_tdt", "orig_timestamp_tdt")
.withColumn("timestamp_tdt", addTime($"orig_timestamp_tdt",
lit(diff)))
newDF
}
}







---

Lab 2. 
Slide xx
---

Lab 3. 
Slide xx
---

Slide xx
---

Slide xx
---

Slide xx
---

Slide xx
---

Slide xx
---

Slide xx
---

Slide xx
---

Slide xx
---

Slide xx
---

Slide xx
---

Slide xx
---

Slide xx
---

Slide xx
