#Logit
rm(list=ls())

# Please Answer all the questions
# ===============================
# Logistic Regression, also known as Logit, 
# is typically used in models where the dependent 
# variables have a binary outcome (True/False, which is coded with 1/0).  
# You model the log odds of the outcome 
# as a linear combination of predictor variables).

# [Terminology]:
# 0- logit = logistic regression
# 1- output variable = outcome = response variable = dependent variable
# 2- input variables (features) = predictor variables = explanatory variables = drivers = independent variables
# 3- residual: the true value - the predicted value
# 4- fit = train the model
# 5- odds of an event: the likelihood of that event to happen. (anologous to probability but not the same)
# 6- odds ratio = p/(1-p) --> the prob. to occur / the prob to not occur
#                             for example: p = 0.2, 1-p = 0.8 --> odds ratio is 1 to 4
# 7- log odds ratio: log(odds ratio) = log(p/(1-p)) = y = sum_over_i(coeff_i * feature_i), i = 0 to n
# 8- the prob. p from log odds ratio p = 1 / (1 + e^-y) --> sigmoid function


# [Data Description]: 
# the marketing campaign team wants to send 
# special offers to those respondents with the highest probability of purchase.
# the response variable is purchase or no purchase 
# given customer income and age and product price
Mydata <- read.csv("survey.csv",header=TRUE,sep=",")


# [1] Explore data
table(Mydata$MYDEPV) # the outcome variable
                     # purchase or no purchase
with(Mydata, table(Price,MYDEPV))
summary(Mydata$Age)
cor.mat <- cor(Mydata[,-1]) # the input variables
cor.mat # Note: The general rule is not to include variables in your model that are
        # too highly correlated with other predictors.
        # corr 0: independent, corr 1: highly correlated, corr -1: highly correlated in inverse direction

#(Q1) Write the variable pairs that are not correlated at all to each other.

#(Q2) Are there any highly correlated variables in this dataset?

# [2] Test a model with 3 variables Price, Income and Age
mylogit <- glm(MYDEPV ~ Income + Age + as.factor(Price),
           data =Mydata, family=binomial(link="logit"),
           na.action=na.pass) # as.factor(Price) : to deal with price as categorical feature
summary(mylogit) 
                 # Additional information:
                 # ==================
                 # Read this: http://www.theanalysisfactor.com/r-glm-model-fit/
                 # Deviance: Deviance is a measure of the "badness" of fit (trained model) of a generalized linear model
                 #      the smaller the better
                 # Null Deviance shows how well the response variable is predicted by a model that includes only the intercept
                 # Residual Deviance: after including the weighted predictors to the intercept
                 # The quantity: 1 - (Residual deviance/Null deviance) 
                 #      is  called "pseudo-R-squared"; you use it to evaluate "goodness" of fit
                 # AIC: provides a method for assessing the quality of your model through comparison of related models.
                 #      it's useful for comparing models, but isn't interpretable on its own.
                 #      the smaller the better
                 # Fisher Scoring: This doesn't really tell you a lot of what you need to know, 
                 #      other than the fact that the model did indeed converge, and had no trouble doing it.
                 # ===== End of additional information =======

    # Notice how the price in coefficient section is divided into 2 entries:
    # as.factor(Price)20, as.factor(Price)30

#(Q3): How many categories are there for the Price variable? 
#(Q4): Why is it divided into two entries only in the model?

	# Review the "Estimate" column. For every one unit change in Income (while other variables are constants), 
	# the log odd ratio of Purchase (not the probability) increases by 0.12876 (the coefficients)
                 
# [3] ROC Curve
if(!require("ROCR"))
{
  install.packages("ROCR")
  library(ROCR)
}
#### NOTE: For this part, you need to search and read about the ROC curve.  
pred = predict(mylogit, type="response") # this returns the probability scores on the training data
predObj = prediction(pred, Mydata$MYDEPV) # prediction object needed by ROCR

rocObj = performance(predObj, measure="tpr", x.measure="fpr")  # creates ROC curve obj
aucObj = performance(predObj, measure="auc")  # auc object

auc = aucObj@y.values[[1]]
auc   # the auc score: tells you how well the model predicts.
#(Q5.1) Write the value of this expression (just the number)

#(Q5.2) What is the maximum value of AUC (ideal case)?

# plot the roc curve
plot(rocObj, main = paste("Area under the curve:", auc))

#(Q6) What does each point in the ROC graph represent? 
#In other words, what is the value that changes and drives TPR and FPR to change too 
#from one point to another in the graph?
  
# [4] Predictions
#Prediction - 1
Price <- c(10,20,30)
Age <- c(mean(Mydata$Age))
Income <- c(mean(Mydata$Income))
newdata1 <- data.frame(Income,Age,Price) # Note: The predict function requires the variables to be named exactly as in the fitted model.  
newdata1
newdata1$PurchaseP <- predict (mylogit,newdata=newdata1,type="response")
newdata1  
#(Q7) How is the predicted probability affected by changing only price holding all other variables constant?

#Prediction - 2 
newdata2 <- data.frame(Age=seq(min(Mydata$Age),max(Mydata$Age),2),
                       Income=mean(Mydata$Income),Price=30)
newdata2
newdata2$PurchaseP <- predict(mylogit,newdata=newdata2,type="response")
newdata2
cbind(newdata2$Age,newdata2$PurchaseP)
plot(newdata2$Age,newdata2$PurchaseP)
#(Q8) How is the predicted probability affected by changing only age holding all other variables constant?

#Prediction - 3
newdata3 <- data.frame(Income= seq(20,90,10),Age=mean(Mydata$Age),Price=30)
newdata3$PurchaseP<-predict(mylogit,newdata=newdata3,type="response")
cbind(newdata3$Income,newdata3$PurchaseP)
plot(newdata3$Income,newdata3$PurchaseP)
#(Q9) How is the predicted probability affected by changing only income holding all other variables constant?

#Prediction 4
newdata4 <- data.frame (Age= round(runif(10,min(Mydata$Age),max(Mydata$Age))), 
                        Income= round(runif(10,min(Mydata$Income),max(Mydata$Income))),
                        Price = round((runif(10,10,30)/10))*10)
newdata4$Prob <- predict(mylogit,newdata=newdata4,type="response")
newdata4
