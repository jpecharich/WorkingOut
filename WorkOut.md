Working Out and Machine Learning
========================================================

## Summary

The purpose of this project is to predict how well an individual performed a barbell lift. The data was gathered from an accelerometer placed on the belt, forearm, arm and dumbell. The predictive algorithm that I developed was a random forest constructed from **60%** of the training data with **300** trees. A more detailed description of the model is given below. In the end, the accuracy of the model was **99.45%** and it correctly predicted all **20** of the test cases from the assignment.  

## Model Description and Code

We first require the following packages to be loaded.

```r
library(caret)
```

```
## Loading required package: lattice
## Loading required package: ggplot2
```

```r
library(randomForest)
```

```
## randomForest 4.6-10
## Type rfNews() to see new features/changes/bug fixes.
```
These two packages run the prediction scheme and contain the random forest algorithm.

We now laod the training data and the test data.


```r
Training <- read.csv("~/Desktop/DataTrack/MachineLearning/Project/pml-training.csv")
Testing<- read.csv("~/Desktop/DataTrack/MachineLearning/Project/pml-testing.csv")
```

The Training and Testing sets have **160** variables, but upon looking at the Testing data I noticed that many of the variables where **NA** for all 20 cases. Since this is the case those variables should not have any bearing on our algorithm, hence those columns will be eliminated. The following code chunk finds all those columns which are entirely **NA** in the Testing data set.


```r
names<-c()

for(i in 1:length(Testing)-1){
        if(all(is.na(Testing[,i]))==FALSE){
                names<-c(names,colnames(Testing)[i])
        }
}
```

We now extract the corresponding columns from the Training data set and the attach a column for the **classe** of the exercise.

```r
Train<-Training[,names]
Train$classe<-Training$classe
```

Further inspecting the Training data set we noticed other variables which should not have any bearing on the outcome of the exercise such as the username or the time they performed the exercise. Therefore the first 7 variables will also be eliminated from the training data set.

```r
Train<-Train[,8:60]
```
After this processing we have decreased the number of variables from **160** to **53**, this data set is called **Train**.

We now partition the **Train** data set into a training set and a cross-validation set. The set will partitioned into **60** training and **40%** cross-validation.

```r
set.seed(1)
inTrain<-createDataPartition(y=Train$classe,p=0.6,list=FALSE)
training<-Train[inTrain,]
trainingCV<-Train[-inTrain,]
```

The model we have chosen to run is a random forest with **300** trees. 

```r
modFit<-randomForest(classe~.,data=training,ntree=300)
```

Notice that we used the function **randomForest()** instead of **train()** with **method='rf'**. The reason for this is that theoretically they should be the same but the **train()** function never finished even after more than **2** hours, while the **randomForest()** finishes in under 1 minute.

The cross-validation data set is now checked against the prediction using the random forest.

```r
pred<-predict(modFit,trainingCV)
trainingCV$predRight<-pred==trainingCV$classe
```

To see the accuracy of the model we print out the confusion matrix.

```r
print(confusionMatrix(trainingCV$classe,predict(modFit,trainingCV)))
```

```
## Loading required namespace: e1071
```

```
## Confusion Matrix and Statistics
## 
##           Reference
## Prediction    A    B    C    D    E
##          A 2225    4    2    0    1
##          B    5 1510    3    0    0
##          C    0    6 1360    2    0
##          D    0    0   14 1272    0
##          E    0    0    0    5 1437
## 
## Overall Statistics
##                                         
##                Accuracy : 0.995         
##                  95% CI : (0.993, 0.996)
##     No Information Rate : 0.284         
##     P-Value [Acc > NIR] : <2e-16        
##                                         
##                   Kappa : 0.993         
##  Mcnemar's Test P-Value : NA            
## 
## Statistics by Class:
## 
##                      Class: A Class: B Class: C Class: D Class: E
## Sensitivity             0.998    0.993    0.986    0.995    0.999
## Specificity             0.999    0.999    0.999    0.998    0.999
## Pos Pred Value          0.997    0.995    0.994    0.989    0.997
## Neg Pred Value          0.999    0.998    0.997    0.999    1.000
## Prevalence              0.284    0.194    0.176    0.163    0.183
## Detection Rate          0.284    0.192    0.173    0.162    0.183
## Detection Prevalence    0.284    0.193    0.174    0.164    0.184
## Balanced Accuracy       0.998    0.996    0.992    0.996    0.999
```
The accuracy of this model is therefore 

```r
confusionMatrix(trainingCV$classe,predict(modFit,trainingCV))$overall['Accuracy']
```

```
## Accuracy 
##   0.9945
```
To get the predictions of the Testing data we run the following code, which is the same as above.

```r
Test<-Testing[,names]
Test<-Test[,8:59]
predict(modFit,Test)
```

```
##  1  2  3  4  5  6  7  8  9 10 11 12 13 14 15 16 17 18 19 20 
##  B  A  B  A  A  E  D  B  A  A  B  C  B  A  E  E  A  B  B  B 
## Levels: A B C D E
```
