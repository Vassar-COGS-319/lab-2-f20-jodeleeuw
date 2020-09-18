# for loops ####

# sometimes we want to repeat a section of code making a small change
# each time. a for loop allows us to do this without rewriting code 
# unnecessarily. here's an example:

for(i in 1:10){
  print(i)
}

# if you run the code above, the print statement executes 10 times.
# the first time it executes, i is 1. the second time i is 2. and so on.

# let's look a little more carefully at the piece of the for loop inside the
# parentheses. the first part declares the name of a variable. this can be
# whatever you want. the "in" keyword separates the name of the variable
# from the values that the variable will take. those are specified to the right.
# in the above example, we use the array of integers from 1 to 10, declared
# with the : operator.

# note that the values that the variable takes can be any kind of array/vector,
# such as the following examples.

for(word in c('four','score','and','seven','years')){
  print(word)
}

for(odd.number in c(1,3,5,7,9)){
  print(odd.number)
}

for(even.number in seq(from=2, to=20, by=2)){
  print(even.number)
}

# write a for loop that prints every integer from 1 to 100 and if the number is divisble
# by 5. for example, the first few print outs should be:
# 1 is not divisible by 5
# 2 is not divisible by 5
# 3 is not divisible by 5
# 4 is not divisible by 5
# 5 is divisible by 5
# 6 is not divisible by 5

# hint: two helpful functions will be paste() and the modulus %% operator.

for(i in 1:100){
  if(i %% 5 == 0){
    print(paste(i, "is divisible by 5"))
  }
  if(i %% 5 != 0){
    print(paste(i, "is not divisible by 5"))
  }
}

# another thing that we sometimes want to do with a for loop is to store the results
# of the loop in a data structure. the following code creates an array and puts a random
# number in each element of the array (there are faster ways to do this in R, this example
# is just for pedagogical purposes)

random.numbers <- numeric()
for(i in 1:100){
  random.numbers[i] <- rnorm(1,mean=0,sd=1)
}

# using a for loop, create a new array that is 2 items shorter than the random.numbers array
# created above. each element in this array should be the average of the three neighboring items
# in random.numbers (we are applying a simple smoothing function to the data). for example,
# the first element in the array would be the average of random.numbers[1:3], the second would
# be the average of random.numbers[2:4], and so on.

running.average <- numeric()
for(i in 2:(length(random.numbers)-1)){
  running.average[i-1] <- mean(random.numbers[(i-1):(i+1)])
}

# while loops ####

# a different kind of loop is a while loop. a while loop runs while some statement is true.
# once the statement is no longer true, it stops. for example, the following code will run
# until i < 10 is no longer true.

i <- 0
while(i < 10){
  print(i)
  i <- i + 1
}

# while loops can be useful when you don't know exactly how many times you need to 
# repeat code. for example, if your code has some element of randomness. the following
# code will run until the number 4 is randomly chosen

num_loops <- 0
while(sample(1:10, 1) != 4){
  num_loops <- num_loops + 1
}
print(num_loops)

# write a while loop that generates three random integers between 1 and 6, and stops
# when they are all the same number. count the number of loops that it takes.

numbers <- sample(1:6, 3, replace=T) # generate three random numbers
num_loops <- 0
while(numbers[1] != numbers[2] || numbers[2] != numbers[3]){
  numbers <- sample(1:6, 3, replace=T)
  num_loops <- num_loops + 1
}
print(num_loops)

# replicate ####

# R has lots of built in methods to avoid for loops. one of those methods is replicate().
# replicate() lets us run a function repeatedly and store the result of each run in an array.
# this is really useful for monte carlo simulations, where we run a function that has some
# stochastic element over and over again to calculate long-run probabilities.

# first, write a function below that simulates a roll of 2 six-sided dice. (each die has an
# equal probability of generating each integer between 1 and 6).

dice.roll <- function(){
  return(sum(sample(1:6, 2, replace=T)))
}

# we can use replicate to simulate rolling a pair of dice thousands of times and observing
# the empirical probability of these events.

roll.results <- replicate(10000, dice.roll())

# the actual probability of getting a 2 is 1/36. can you determine what proportion of the
# simulated rolls are 2? how close is it to 1/36?

sum(roll.results == 2) / length(roll.results)
1 / 36

# hist ####

# a useful function for visualizing distributions, like the simulated dice rolls, is the
# hist() function (short for histogram). here's a histogram for the roll.results generated
# above:

hist(roll.results)

# sometimes you'll want to tweak the settings of the plot, especially the number of different
# bins in the histogram. for example, here's a set of random numbers generated from a normal
# distribution with mean 0 and standard deviation 1:

normal.data <- rnorm(10000, mean=0,sd=1)
hist(normal.data)

# the above histogram does an OK job, but with 10,000 data points we can afford to use
# narrower bins and get a better picture of the data:

hist(normal.data, breaks=100)

# matrix ####

# when we create arrays with c(), we call these one-dimensional arrays. it's like
# creating a single row (or column) of data on a spreadsheet. sometimes we need to 
# store two-dimensional data. for this, R has a function called matrix()

m <- matrix(1:10, nrow=2)

# run the code above, and then click the m object in the Environment pane (top-right)
# to open the matrix object. notice that the matrix has 2 rows and 5 columns. R 
# automatically figured out that we needed 5 columns, based on the number of data
# points and the number of rows. also note that the data are added by column. the
# first column has 1, 2, instead of the first row having 1, 2, 3, 4, 5. using the help
# function (?matrix) or a google search, figure out how to generate the matrix so the 
# data are added by row. if done correctly the matrix should look like this:

# 1 2 3 4 5
# 6 7 8 9 10

m <- matrix(1:10, nrow=2, byrow=T)
m

# to extract values from the matrix, we use the same array brackets as before []. 
# but, we can specify both dimensions. for example,

row <- 1
column <- 3
m[row, column] # should be 3 for the matrix created by row, or 5 for the created matrix by column.

# one other thing you can do is extract an entire row or column, simply by not specifying a value
# for the other dimension

m[row, ] # extracts the entire row
m[, column] # extract the entire column

# create a 10x10 matrix filled with 100 random integers between 1 and 4. then extract the 2nd row
# of the matrix and calculate the sum of all the values in that row.
# hint: no loops are necessary! check out the size and replace arguments of sample (?sample). 

random.matrix <- matrix(sample(1:4, size=100, replace=T),nrow=10)
sum(random.matrix[2,])

# finally, you can also extract just a piece of a matrix.

five.by.five <- matrix(1:25, nrow=5)
three.by.three <- five.by.five[1:3, 2:4]

# the above code creates a 5x5 matrix, and then selects rows 1-3 and columns 2-4 of that matrix
# to extract a subset.

# write code to extract a 2x2 matrix, containing just the EVEN columns and rows of the
# five.by.five matrix. hint: use c() to create lists of non-consecutive integers.

five.by.five[c(2,4), c(2,4)]

# max(), min(), which(), and sample() ####

# max() and min() return the maximum and minimum value of a set of numbers.

max(1:25)
min(1:25)

# which() returns the LOCATION of specified items in an array or matrix

wheres.waldo <- c('Not Waldo', 'Not Waldo', 'Waldo', 'Not Waldo')
which(wheres.waldo == 'Waldo') 

# sample(), in addition to generating random numbers, can also be used to reorder an
# array:

in.order <- 1:100
random.order <- sample(in.order)
print(random.order)

# this works because by default sample returns a number of samples equal to the set of
# items being sampled from, and it samples without replacement (meaning each item can
# only be sampled one time).

# put together the four functions above (min(), max(), which(), and sample()) to generate
# an array containing the integers 1-50 in a random order, and find the LOCATION of the minimum
# and maximum values in the array.

array.search <- sample(1:50)
which(array.search == min(array.search))
which(array.search == max(array.search))
