# 1. clean up the workspace
rm(list=ls())
#set the working dirc
#setwd("/Users/muhammadalaa/Desktop/CMP/Lab 1/Requirement_ TITANIC/")

# 2. load data 
titanicDataSet <- read.csv("titanic.csv")

# 3a. show dim 
dim(titanicDataSet)

# 3b. show structure
str(titanicDataSet)

# 3c. show first and last ten rows
head(titanicDataSet, 10)
tail(titanicDataSet, 10)

# 3d. show summary of all variables in the data frame
summary(titanicDataSet)

# 4a. Show a summary for the variable age only.
age = titanicDataSet$Age
summary(data.frame(age))

# 4b. first quartile equals 20.12 and it is the value that cuts off the first 25% of the data
#     and third quartile equals 38.00 and it is the value that cuts off the first 75% of the data

# 4c. Yes, is.na specify all variables indices that have no value but anyNA check if the whole data set has any variable with a missing value 
#     In our case the best to use is anyNA and it is faster also
is.na(age)
anyNA(age)

# 4d. character
#     (C, Q, S) no as it has also also empty space in the level correspond to NA values
typeof(titanicDataSet$Embarked)
levels(factor(titanicDataSet$Embarked))

# 4e. It needs preprocessing for the data 

# 5a. Remove the rows containing <NA> in the age variable
titanicDataSet = titanicDataSet[!is.na(titanicDataSet$Age), ]

# 5b. Remove the rows containing any unexpected value in the embarked variable
titanicDataSet = subset(titanicDataSet,  Embarked == 'C' | Embarked == 'S' | Embarked == 'Q')

# 5c. check that no NA values exist in the age variable. Also, factor the embarked variable and display its levels
anyNA(titanicDataSet) # no rows
levels(factor(titanicDataSet$Embarked)) # yes and without NA

# 5d. Remove columns Cabin and Ticket from the dataset
titanicDataSet = subset(titanicDataSet, select=-c(Cabin, Ticket))

#6a.Show the number of males and females aboard the Titanic
gendersTable = table(titanicDataSet$Gender)

#6b.Plot a pie chart showing the number of males and females aboard the Titanic.
pie(gendersTable)

#6c1. Indicate males with a blue color and females with a red color in the above plot.
pie(gendersTable, col = c("red", "blue"))

#6c2.Show the number of people who survived and didn’t survive from each gender.
gendersWithSurvivedTable = table(titanicDataSet$Gender, titanicDataSet$Survived)

#6d.Plot a pie chart showing the number of males and females who survived only.
pie(table(titanicDataSet[titanicDataSet$Survived==1,]$Gender))

#6e. the number of females survived is more than the survived males

#6f. Show the relationship between social class and survival i.e. show how many people survived and how many people didn’t survive from each class.
classWithSurvivedTable = table(titanicDataSet$Survived, titanicDataSet$Pclass)

#6g. Plot this relationship as a stacked bar plot
barplot(classWithSurvivedTable) 

#6h. Indicate survived passengers with a blue color and un-survived passengers with a red color in the above plot.
barplot(classWithSurvivedTable, col = c("red", 'blue'))

#6i. the number of survived passangers from class 1 is the largest for all classes and also the number of un survied passangers in class 3 is the largest for all classes

#6j. Plot a box and whiskers plot for the variable age (Hint: use boxplot() function) Read about the box and whiskers plot and understand it properly.
boxplot(titanicDataSet$Age) 

#6k. a box plot or boxplot is a method for graphically demonstrating the locality,
#    spread and skewness groups of numerical data through their quartiles n addition to the box on a box plot, 
#    there can be lines (which are called whiskers) extending from the box indicating variability outside the upper and lower quartiles
#    thus, the plot is also termed as the box-and-whisker plot and the box-and-whisker diagram

#6l. Plot a density distribution for the variable age.
plot(density(titanicDataSet$Age))

# 7. Remove all columns but passenger name and whether they survived or not. Export the new dataset to a file named “titanic_preprocessed.csv”
titanicDataSet = subset(titanicDataSet, select=c(Name, Survived))
write.csv(titanicDataSet,"titanic_preprocessed.csv", row.names = FALSE)





       