### In this module we will be using Kaggle's [Wine-Review](https://www.kaggle.com/zynicide/wine-reviews) datasets.

If you are running a local instance of Fusion, you can download a local copy of the datasets:
1. From a web-browser, login to your Kaggle account
2. Go to [Wine-Review](https://www.kaggle.com/zynicide/wine-reviews)  
3. Click on the **Download (51MB)** link to download a ZIP file containing these datasets  
4. Unzip the file. We will only be using the **winemag-data_first150k.csv** dataset for this module. 

If you are running Fusion on a remote (AWS) instance, you can upload a copy of the datasets into that instance. See next steps 
Since you are not authenticated into Kaggle while logged into the AWS instance, you need to provide your Kaggle credentials: 
1. From a web-browser, login to your Kaggle account and on the top right click on your icon and choose **My Account** 
2. Towards the middle of the page, you will see a section called **API**, click on **Create New API Token**. This will download a file called **kaggle.json** 
3. Open the **kaggle.json** file with a text editor and copy the contents of the file
4. ssh into your remote AWS instance and run the following commands
```
mkdir ~/.kaggle
vi ~/.kaggle/kaggle.json
type the letter "i" to be in **insert mode**
paste the contents of your local json file (from step 3)
to exit and save, type **[esc key] : wq!**
chmod 600 ~/.kaggle/kaggle.json```
  
5. You can now download the **winemag-data_first150k.csv** dataset for this module: 
```
kaggle datasets download -d zynicide/wine-reviews -f winemag-data_first150k.csv -p ~/
unzip winemag-data_first150k.csv.zip```