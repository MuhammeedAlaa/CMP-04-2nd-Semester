#In this tutorial we are going to examine a data series about monthly car sales.
require(forecast)
require(TSPred)

#Import the time series data in 'tractor-sales.csv' file. 
tsales <- read.table("Tractor-Sales.csv", header=TRUE, sep=",")
#(1) Inspect the data  
tsales
#(2) Create a time series object out of the sales data. 
data <- ts(tsales[,2], start = c(2003,1), frequency = 12)

#(3) Visualise the time series. 
par(mfrow=c(1,1))
plot(data, xlab="Years", ylab = "Tractor Sales")

#(4) 
plot(stl(data, "periodic"))

#(5)
plot(data, xlab="Years", ylab = "Tractor Sales")

#(6)
plot(diff(data), ylab="Differenced Tractor Sales")

#(7)
plot(log10(data),ylab="Log (car Sales)")


#(8)
plot(diff(log10(data)),ylab="Differenced Log (car Sales)")

#(9) Fitting an ARIMA Model 
ARIMAfit <- auto.arima(log10(data), approximation=FALSE, trace=FALSE)
# Try to pass diff(log10(data)) instead of log10(data) and see the difference
# in the output model. 

#auto.arima decide the best model
summary(ARIMAfit)

#(10) Fitting an ARIMA Model 
ARIMAfit <- auto.arima(log10(data), approximation=FALSE, trace=TRUE)
summary(ARIMAfit)

#(11) Use the ARIMA model to forecast values.
pred <- predict(ARIMAfit, n.ahead = 36)

#(12) Plot the original data
plot((data),type="l",xlim=c(2004,2018), ylim=c(1,1600), xlab = "Year",ylab = "car")

#plot the prediction and its +- 2 std dev. (expected error)
lines(10^(pred$pred),col="blue")
lines(10^(pred$pred+2*pred$se),col="orange")
lines(10^(pred$pred-2*pred$se),col="orange")

#Note that this is the reason why we passed log10(data) to the auto.arima 
#instead of diff(log10(data). 
#If we passed diff(log10(data)), then in order to forecast the future values
#in the time series, we will have to take the output of the auto.arima, 
#and do the inverse operations to the data which are undifferencing and
#the inverse of log10. 
#So, we left the job for the auto.arima function to do the differencing and undifferencing. 
#The auto.arima function will always do the necessary (differencing/detrending) first 
#to make the time series stationary, in order to be able to fit the model, and then will do the 
#inverse operation back again (undifferencing/adding the trend) before generating the 
#output of the forecast values. 
#And we were left only with the job of inverting the logarithm which is an easy task. 


#(13) library TSPred
plotarimapred(log10(data), ARIMAfit, xlim=c(2004,2018), range.percent = 0.2)

#(14) Forecast for a longer range. 
plotarimapred(log10(data), ARIMAfit, xlim=c(2004,2022), range.percent = 0.2)
