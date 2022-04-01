# Let us get the appropriate libraries loaded for NB Classifier. 
#install.packages("e1071")
library("e1071")

# 1. First of all, start by cleaning the workspace and setting the working directory.
rm(list=ls())
setwd("/Users/muhammadalaa/Desktop/CMP/CMP-04-2nd-Semester/BigData/Lab3/")

# 2. Divide the data into two data frames
sample <- read.table("nbtrain.csv", header=TRUE, sep=",")
# age gender educ income

# 3. Divide the data into two data frames
traindata <- as.data.frame(sample[1:9000,])
testdata <- as.data.frame(sample[9001:nrow(sample),])
# we split the data to training on the training set to learn features and then test on the test set to see if we are generalizing well.


# 4. Train a Naïve Bayes Classifier model with income as the target variable and all other variables as independent variables. Smooth the model with Laplace smoothing coefficient = 0.01
model <- naiveBayes(income~.,traindata)
# Laplace smoothing is a smoothing technique that handles the problem of zero probability in Naïve Bayes. Using Laplace smoothing

# 5. display model
model

# 6. predict with test data
results <- predict (model, testdata)

# 7. Display a confusion matrix for the predict values of the test data versus the actual values
table(results, testdata$income)
# class 10=50K is over-represented in the taring test and class 2,3 have few samples in the training set (Imbalanced Data problem)
# aprior probability is large for class 1.

# 8 Display the accuracy of the model.
print(paste0("Acc = %", sum(results == testdata$income)/nrow(testdata) * 100))
# for imbalanced data accuracy is not enough to judge the model 
#so we need to apply more evaluation criteria like(f1-score, precision, recall) to judge the model

# 9. Display the overall 10-50K, 50-80K, GT 80K mis-classification rates.

print(paste0("misclassification rates (10-50K) = % ", sum(results != testdata$income & testdata$income == '10-50K') / sum(testdata$income == '10-50K') * 100))
print(paste0("misclassification rates (50-80K) = % ", sum(results != testdata$income & testdata$income == '50-80K') / sum(testdata$income == '50-80K') * 100))
print(paste0("misclassification rates (GT 80K) = % ", sum(results != testdata$income & testdata$income == 'GT 80K') / sum(testdata$income == 'GT 80K') * 100))

