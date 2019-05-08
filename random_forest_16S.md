## this is a markdown file for the random forest modeling of microbial ecology data

**Ref**

https://github.com/LangilleLab/microbiome_helper/wiki/Random-Forest-Tutorial

http://userweb.eng.gla.ac.uk/umer.ijaz/projects/microbiomeSeq_Tutorial.html

http://appliedpredictivemodeling.com/blog/2014/11/27/vpuig01pqbklmi72b8lcl3ij5hj2qm

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
