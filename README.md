# lucidworks-training-files
This is the public repo for Lucidworks Training where you will find supporting files and datasets for the training labs. 

Please navigate to the appropriate training folder to see these files. 

If you have any questions or issues regarding this Repository or any of the files included here, please send us an email: trainers@lucidworks.com  

---

### Download the whole training-files repo

If downloading to your local computer: 
1. At the [root](https://github.com/lucidworks/lucidworks-training-files) of the training-files repo, click on the button **Clone or Download** then Download ZIP. 

If downloading into a remote AWS instance while ssh'd: 
1. Same as above, but instead of clicking the **Clone or Download** do a right-click (or control-click on Mac) and just copy the link address. 
2. In the ssh session, do a `wget <paste the copied url from GitHub here>` 

---

### Downloading specific files or folders 

Github only supports downloading the whole repo from its root. 
If you want to download a specific file or folder, here are some alternatives. 

- You can use a tool like Git or SVN to checkout only a folder of file locally. (You would have to install SVN or Git). 
- You can use a browser page like [DownGit](https://minhaskamal.github.io/DownGit/#/home) to download it. See instructions below, for DownGit. 
- We are also providing Lab files as a ZIP archive at the module level. See instructions below. 

---

### DownGit Download Instructions

1 Navigate to the file or folder you want to download, and copy its URL from the browser URL bar
2 From [DownGit](https://minhaskamal.github.io/DownGit/#/home), paste the URL unto the textbox
3 You have 2 options: 
  * You can download the file directly to your computer
  *	You can create a "download link" 

**If you are ssh'd remotely into a training AWS instance, the "download link" does not work. You need to download the ZIP locally and then move it to the AWS instance via scp.** 

---

### Download a ZIP archive found in a module -- instructions 

1 Go to the module folder 
2 Confirm that there is a ZIP file there. Click on the ZIP 
3 There will be a download button there
	- To download to local computer, click on the **Download** button 
	- To download into a AWS instance, from the **Download** button, do a right-click (or control-click on Mac) and just copy the link address. Then in the ssh session, do a `wget <paste the copied url from GitHub here>` 

