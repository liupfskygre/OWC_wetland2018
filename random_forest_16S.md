## this is a markdown file for the random forest modeling of microbial ecology data

**Ref**

https://github.com/LangilleLab/microbiome_helper/wiki/Random-Forest-Tutorial

http://userweb.eng.gla.ac.uk/umer.ijaz/projects/microbiomeSeq_Tutorial.html

http://appliedpredictivemodeling.com/blog/2014/11/27/vpuig01pqbklmi72b8lcl3ij5hj2qm

**Random Forest Tutorial**

Gavin Douglas edited this page on May 23, 2017 · 6 revisions
Author: Gavin Douglas

First Created: 7 March 2017

Last Edited: 23 May 2017

**Introduction**
Requirements
Other Resources
Background
Load Packages and Read in Data
Pre-processing
Removing Rare Features
Transforming Your Data
Assessing Model Fit
Identifying Important Features
Introduction
This tutorial is intended to teach beginners the basics of running random forest (RF) models on microbial sequencing data. Users may also be interested in MetAML, which implements RF along with other machine learning techniques with a simple workflow for metagenomic data. Importantly, the below commands are not the best practices for all datasets. An important part of data analysis is determining what approaches would be best for your particular problem. However, as shall be described below, it's easy to create biased models if you select parameters based on observations you made while exploring your data.

Often when running machine learning tools you would split up your samples into a training set (often ~70%) to build your model and a test set (often ~30%) to evaluate your model. Partitioning allows an estimate of the model performance to be inferred on different data than was used to train the model. When sample sizes are large enough researchers sometimes create a third partition, the validation set, which is used to select (or tune) parameters for the model. However, often in microbial datasets sample sizes are small (e.g. often in the range of 10-50 samples), in which case alternative approaches need to be taken. Cross-validation, where different subsets of your data are systematically split into training and test sets to estimate model performance, is a family of approaches to get around this problem (a few examples are shown in this blog post). Often this actually isn't necessary for RF models given the internal measure of out-of-bag error which is calculated for each model (described below).

The below tutorial will focus on a dataset of 40 samples, where partitioning the data into training and test sets would not be helpful. Operational taxonomic unit (OTU) relative abundances are the features of this dataset. All samples have inflammation scores (IS) associated with them (ranging from 0-1). Samples with IS >= 0.5 were grouped as inflamed, while those with a value < 0.5 were put in the control group. This means that each sample has an inflammation category and a quantitative value associated with it, which will allow us to try running RF classification and regression models using the same features. Note that this example dataset was simulated for this tutorial.

Requirements
You will need the below data and R packages to run all the commands in this tutorial. I have also noted the version of each package that I was using for this tutorial. You shouldn't need to use exactly the same versions as I did, but be aware that there could be updates to these packages since this tutorial was posted.
```

**Tutorial OTU table and mapfile.**

```
R (v3.3.2)
RStudio - recommended, but not necessary (v1.0.136)
randomForest R package (v4.6-12)
rfUtilities R package (v2.0-0)
caret R package (v6.0-73)
plyr R package (v1.8.4)
Other Resources
Original RF paper: Leo Breiman. 2001. Random Forests. Machine Learning 45(1):5-32.
Paper describing the randomForest R package (includes a great description of the algorithm and helpful examples): Andy Liaw A and Matthew Wiener. 2002. Classification and Regression by randomForest. R News 2(3):18-22.
Reference for permutation test to test RF model significance: Melanie A. Murphy et al. 2010. Quantifying Bufo boreas connectivity in Yellowstone National Park with landscape genetics. Ecology 91(1): 252-261.
scikit-learn: a set of useful tools and workflows for running machine learning in Python.
MetAML: a Python package based on scikit-learn produced by the Segata Lab from Trento University for running machine learning on metagenomics datasets. They have written a tutorial and research paper for this tool.
caret: an R package that wraps many machine learning and other predictive tools. There are many online tutorials on how to use caret to run RF models, such as this short example. The coursera course Practical Machine Learning focuses on this package.
```

**Background**
```
RF models are run when researchers are interested in classifying samples into categories (called classes) of interest based upon many different variables, such as taxa, functional categories, etc (called features). RF can also be used to regress features against quantitative data (e.g. height in cm rather than splitting samples into categorical groups like short and tall).

RF models are based on decision trees, which can be used for classification of a discrete variable or regression of a continuous variable. The term Classification and Regression Tree (CART) is often used to describe these decision trees. The wikipedia article on RF describes how this method contrasts with other CART methods.

Briefly, the RF algorithm involves randomly subsetting samples from your dataset and building a decision tree based on these samples. At each node in the tree mtry (a set parameter) number of features are selected from the set of all features. The feature that provides the best split (given any preceding nodes) is chosen and then the procedure is repeated. This algorithm is run on a large number of trees, based on different sample subsets, which means that this method is less prone to overfitting than other CART methods.

Since each decision tree in the forest is only based on a subset of samples, each tree's performance can be evaluated on the left out samples. When this validation is performed on all samples and trees in a RF the resulting metric is called the out-of-bag error. The advantage of using this metric is that it removes the need for a test set to evaluate the performance of your model.

Also, the out-of-bag error can be used to calculate the variable importance of all the features in the model. Variable importance is usually calculated by re-running the RF with one feature's values scrambled across all samples. This difference in accuracy between this model with the scrambled feature and the original model is one measure of variable importance.

Sometimes RF is run to perform feature selection on a dataset. This can be useful when there are thousands of features and you'd like to reduce the number to a less complex subset. However, it's important to realize that you need to validate selected features on independent data. Click here to see a simple demonstration for why this is important.
```

**Load Packages and Read in Data**
```
library("randomForest")
library("plyr") # for the "arrange" function
library("rfUtilities") # to test model significance
library("caret") # to get leave-one-out cross-validation accuracies and also contains the nearZeroVar function 

```

Often setting your working environment simplifies working in R:
```
setwd("/Path/to/my/RF_tutorial/") 
```
