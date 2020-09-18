# this problem is taken from the Riddler series on fivethirtyeight.com
# if you want some additional practice writing monte carlo simulations
# the Riddler series questions can usually be solved with a monte carlo
# approach.

# A class of 30 children is playing a game where they all stand in a 
# circle along with their teacher. The teacher is holding two things:
# a coin and a potato. The game progresses like this: The teacher tosses 
# the coin. Whoever holds the potato passes it to the left if the coin 
# comes up heads and to the right if the coin comes up tails. The game 
# ends when every child except one has held the potato, and the one 
# who hasn’t is declared the winner.

# How do a child’s chances of winning change depending on where they are 
# in the circle? In other words, what is each child’s win probability? 

# Visualize the final result with a graph that shows the position relative
# to the starting location of the potato on the x-axis and the probability
# of winning on the y-axis.

# this will take some planning to think about how to formalize this problem
# I highly recommend discussing it with a classmate! the simpler you can
# make the abstraction of this problem, the easier it will be to write the
# code. either way, this is a challenging problem so give yourself 
# a high-five when you solve it.

### my solution ####

# i'll write a function to play one round of the game and return the location
# of the child who won the game. i'm going to represent locations as 1:30, where
# 1 is the child to the immediate left of the teacher and 30 is the child to the
# immediate right of the teacher.

one.round.hot.potato <- function(){
  # create an array that will be TRUE if the child has touched the potato.
  # e.g., if child 5 has touched the potato, then children[5] == TRUE
  children <- rep(F, 30)
  # start the potato at the teacher (location 0)
  potato.location <- 0
  # repeat the passing process until all but one child has touched the potato.
  while(sum(children == TRUE) < 29){
    # randomly decide whether to go left (add one) or right (subtract one)
    pass.direction <- sample(c(1, -1), 1)
    # move the potato!
    potato.location <- potato.location + pass.direction
    # check if we go around the circle (e.g., teacher passes right and location is now -1)
    # and fix this to be the child to the right of the teacher (30). also need to do this
    # if child 30 passes left to location 31.
    if(potato.location == -1){
      potato.location <- 30
    }
    if(potato.location == 31){
      potato.location <- 0
    }
    # now that the potato is in a new location, update the list of children who
    # have touched the potato
    children[potato.location] <- TRUE
  }
  # when the loop is done, there should be exactly one FALSE value in the list
  # return its location
  return(which(children==FALSE))
}

# now we simulate 10000 plays of the game
plays <- replicate(10000, one.round.hot.potato())

# we need to calculate the probability of winning at each location
probability <- sapply(1:30, function(x){
  return(sum(plays==x) / length(plays))
})

# now plot this! if your graph looks jagged, you might be zoomed in too far or have
# too few simulations. you can fix the zoom by using ylim.
plot(1:30, probability,ylim=c(0,0.2), type="o")

# yes, suprisingly (to me at least...) the answer is that all kids are equally likely to 
# win the game!