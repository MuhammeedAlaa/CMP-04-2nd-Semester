setwd("")

#install.packages("rpart.plot")
library("rpart")
library("rpart.plot")
library("ROCR")

#Read the data
play_decision <- read.table("DTdata.csv",header=TRUE,sep=",")
play_decision
summary(play_decision)

#Build the tree to "fit" the model
fit <- rpart(Play ~ Outlook + Temperature + Humidity + Wind,
             method="class", 
             data=play_decision,
             control=rpart.control(minsplit=2, maxdepth = 3),
             parms=list(split='information'))
# split='information' : means split on "information gain" 
#plot the tree
rpart.plot(fit, type = 4, extra = 1)

summary(fit)
#######################################################################################
# Q1: what is the defult value for split?                                      

# Q2: what are the meanings of these control parameters?  
#          1- "minsplit=2"
#
#          2- "maxdepth=3" 
#
#          3- "minbucket=4" 
#
# Support your answers with graphs for different values of these parameters.

#Q3: What will happen if only one of either minsplit or minbucket is specified
#    and not the other?

#Q4: What does 'type' and 'extra' parameters mean in the plot function?

#Q5: Plot the tree with propabilities instead of number of observations in each node.
######################################################################################
 
#Predict if Play is possible for condition rainy, mild humidity, high temperature and no wind
newdata <- data.frame(Outlook="overcast",Temperature="mild",Humidity="high",Wind=FALSE)
newdata
predict(fit,newdata=newdata,type=c("class"))
# type can be class, prob or vector for classification trees.

######################################################################################
#Q6: What is the predicted class for this test case?

#Q7: State the sequence of tree node checks to reach this class (label).

## ================================= END ===================================== ##