library(caret)
library(randomForest)

Training <- read.csv("http://d396qusza40orc.cloudfront.net/predmachlearn/pml-training.csv")
Testing<- read.csv("http://d396qusza40orc.cloudfront.net/predmachlearn/pml-testing.csv")

names<-c()

for(i in 1:length(Testing)-1){
        if(all(is.na(Testing[,i]))==FALSE){
                names<-c(names,colnames(Testing)[i])
        }
}

#Extract the columns which don't contain all NA
Train<-Training[,names]
Train$classe<-Training$classe
Train<-Train[,8:60]



#Creating a partition for cross validation
set.seed(1)
inTrain<-createDataPartition(y=Train$classe,p=0.6,list=FALSE)
training<-Train[inTrain,]
trainingCV<-Train[-inTrain,]

#modFit<-train(classe~.,data=training,method='rf',prox=TRUE)
modFit<-randomForest(classe~.,data=training,ntree=300)

pred<-predict(modFit,trainingCV)
trainingCV$predRight<-pred==trainingCV$classe

#print(confusionMatrix(trainingCV$classe,predict(modFit,trainingCV)))

Test<-Testing[,names]
Test<-Test[,8:59]

predTest<-predict(modFit,Test)


#############
#part<-c()
#Acc<-c()

#for(i in 1:20){
 #       set.seed(1)
  #      inTrain<-createDataPartition(y=Train$classe,p=0.05*i,list=FALSE)
   #     training<-Train[inTrain,]
    #    trainingCV<-Train[-inTrain,]
        
       
     #   modFit<-randomForest(classe~.,data=training,ntree=300)
        
      #  pred<-predict(modFit,trainingCV)
       # trainingCV$predRight<-pred==trainingCV$classe
        #part<-c(part,0.05*i)
        #Acc<-c(Acc,confusionMatrix(trainingCV$classe,predict(modFit,trainingCV))$overall['Accuracy'])
#}

#plot(part,Acc,type='o',col='blue',lwd=2,
 #    xlab='Partition Size',
  #   ylab='Accuracy',
  #   main='Accuracy with 300 Trees',xaxt='n')
#axis(1,at=part)


