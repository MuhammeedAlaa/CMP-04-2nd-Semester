#------------------------------------------------------------------------------#
# Requirement 1
#------------------------------------------------------------------------------#
# Clean environment and remove all variables in the global environment. 

setwd("G:/4th-grade-CMP/2nd-term/big-data/Labs/Lab 5/Association Rules")
rm(list=ls())


#------------------------------------------------------------------------------#
# Requirement 2
#------------------------------------------------------------------------------#
# Load the libraries arules and arulesViz
if(!require("arules"))
{
  install.packages("arules")
  library(arules)
}

if(!require("arulesViz"))
{

  remove.packages("arulesViz")
  install.packages("arulesViz", dependencies=T)
  
  library(arulesViz)
}

#------------------------------------------------------------------------------#
# Requirement 3
#------------------------------------------------------------------------------#
# Load the transactions in the file AssociationRules.csv using the function read.transactions.
trx = read.transactions("AssociationRules.csv", header=FALSE)

#------------------------------------------------------------------------------#
# Requirement 4
#------------------------------------------------------------------------------#
# Display the transactions in a readable format using the function inspect. Display only the first 100 transactions.
inspect(head(trx, n=100L))


#------------------------------------------------------------------------------#
# Requirement 5
#------------------------------------------------------------------------------#
# What are the most frequent two items in the dataset? What are their frequencies?
(summary(trx))
# most frequent items are (item13: 4948, item5: 3699)

#------------------------------------------------------------------------------#
# Requirement 6
#------------------------------------------------------------------------------#
itemFrequencyPlot(trx, topN=5)

#------------------------------------------------------------------------------#
# Requirement 7
#------------------------------------------------------------------------------#
# Generate the association rules from the transactions using the apriori algorithm
rules <- apriori(trx, parameter = list(supp = 0.01, conf = 0.5, target = "rules", minlen=2))

#------------------------------------------------------------------------------#
# Requirement 8
#------------------------------------------------------------------------------#
top_rules = sort(rules, descreasing=TRUE, by="support")
inspect(head(top_rules, 6))

#------------------------------------------------------------------------------#
# Requirement 9
#------------------------------------------------------------------------------#
top_rules = sort(rules, descreasing=TRUE, by="confidence")
inspect(head(top_rules, 6))

#------------------------------------------------------------------------------#
# Requirement 10
#------------------------------------------------------------------------------#
top_rules = sort(rules, descreasing=TRUE, by="lift")
inspect(head(top_rules, 6))

#------------------------------------------------------------------------------#
# Requirement 11
#------------------------------------------------------------------------------#
# Plot the generated rules with support as x-axis, confidence as y-axis and lift as shading.
plot()

#------------------------------------------------------------------------------#
# Requirement 12
#------------------------------------------------------------------------------#
     