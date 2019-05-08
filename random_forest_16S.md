## this is a markdown file for the random forest modeling of microbial ecology data

**Ref**

https://github.com/LangilleLab/microbiome_helper/wiki/Random-Forest-Tutorial

http://userweb.eng.gla.ac.uk/umer.ijaz/projects/microbiomeSeq_Tutorial.html


**Load Packages and Read in Data**
```
library("randomForest")
library("plyr") # for the "arrange" function
library("rfUtilities") # to test model significance
library("caret") # to get leave-one-out cross-validation accuracies and also contains the nearZeroVar function 

```
