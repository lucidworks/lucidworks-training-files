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
val allClicks = spark.read.parquet("/opt/fusion/training/bestbuysignals-parquet")
```




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
