# model parameters

# see Axelrod paper for discussion about what all the parameters do.
# hopefully the names make it mostly clear!

temptation.to.defect <- 3
hurt.of.defection <- -1
cost.of.being.punished <- -9
cost.of.punishing <- -2
cost.of.being.punished.for.not.punishing <- -9
cost.of.punishing.for.not.punishing <- -2

population.size <- 20
chances.to.defect.per.round <- 4
number.of.generations <- 100 
mutation.probability <- 0.01

# create an initial population
# the population is represented as a matrix with each player being one row of the matrix.
# there are 6 columns in the matrix, representing the 6 genes that make up each player.
# the first three columns are the genes that encode the boldness trait, the last 3
# encode the vengefulness trait.

create.players <- function(){
  return(matrix(sample(c(0,1), population.size*6, replace=T), nrow=population.size))
}

# helper functions for boldness and vengefulness
# these take the binary-encoded genes and convert to a value between 0 and 1.

boldness <- function(genome){
  return((genome[1] + genome[2]*2 + genome[3]*4)/7)
}

vengefulness <- function(genome){
  return((genome[4] + genome[5]*2 + genome[6]*4)/7)
}

# play one round

one.round <- function(players){
  # create an empty vector to store accumulated rewards
  rewards <- rep(0,population.size)
  
  # we iterate through the game for each player
  for(p in 1:population.size){
    
    # extract the player genome
    player.genome <- players[p,]
    
    # calculate the player's boldness
    player.boldness <- boldness(player.genome)
    
    # the player gets multiple chances to play each round 
    for(i in 1:chances.to.defect.per.round){
      
      # new value of S for each chance
      probability.of.being.caught <- runif(1, min=0, max=1)
      
      # player will defect if S is less than player's boldness
      if(probability.of.being.caught < player.boldness){
        # player defects!
        # player gets defection bonus
        rewards[p] <- rewards[p] + temptation.to.defect
        # everyone else gets hurt by defection
        rewards[-p] <- rewards[-p] + hurt.of.defection
        
        # all other players now have a chance to observe the defection and punish
        for(o in (1:population.size)[-p]){
          observer.genome <- players[o,]
          observer.vengefulness <- vengefulness(observer.genome)
          if(runif(1,0,1) <= probability.of.being.caught){
            # observer catches the player!
            if(runif(1,0,1) <= observer.vengefulness){
              # observer decides to punish the player!
              # player is punished for defecting
              rewards[p] <- rewards[p] + cost.of.being.punished
              # observer assumes cost of punishing
              rewards[o] <- rewards[o] + cost.of.punishing
            } else {
              # observer decides not to punish the player!
              # check if other players see observer failing to enforce norm
              for(k in (1:population.size)[-c(p,o)]){
                k.genome <- players[k,]
                k.vengefulness <- vengefulness(k.genome)
                if(runif(1,0,1) <= probability.of.being.caught){
                  # observer's failure to punish is detected!
                  if(runif(1,0,1) <= k.vengefulness){
                    # meta-observer decides to punish observer
                    # observer gets cost
                    rewards[o] <- rewards[o] + cost.of.being.punished.for.not.punishing
                    # punisher assumes cost
                    rewards[k] <- rewards[k] + cost.of.punishing.for.not.punishing
                  }
                }
              }
            }
          }
        }
      }
    }
  }
  return(rewards)
}

next.generation <- function(players, fitness){
  # create an empty array to hold the ID of the parents of the next generation
  parents <- numeric()
  
  # selection is based on whether fitness was more than 1 SD above the mean.
  # here we convert the fitness array to z-scores using the scale() function.
  # we need an if statement to make sure that the SD of the fitness array is
  # not 0, or else the z-scores become undefined. if SD = 0, then we just 
  # use a value of 0 for all the z-scores.
  if(sd(fitness) > 0){
    z.score.fitness <- scale(fitness)
  } else {
    z.score.fitness <- rep(0,length(fitness))
  }
  
  # any player with a z-score of 1 or better gets to produce two copies in
  # the next generation. here we identify which players meet this criterion
  # and add two copies of each to the parents array.
  top.performers <- which(z.score.fitness >= 1)
  parents <- rep(top.performers, 2)
  
  # any player with a z-score between -1 and 1 gets one copy in the next
  # generation. here we identify them and add to the parents array.
  average.performers <- which(z.score.fitness >= -1 & z.score.fitness < 1)
  parents <- c(parents, average.performers)
  
  # if there are not enough members of the new generation, then we choose
  # some parents to have an extra copy at random.
  if(length(parents) < population.size){
    parents <- c(parents, sample(parents, population.size - length(parents)))
  }
  
  # if there are too many members of the new generation, then we randomly
  # select population.size parents from the total set.
  if(length(parents) > population.size){
    parents <- sample(parents, population.size)
  }
  
  # this next line allows us to generate the genomes for the next generation.
  # it uses a neat R trick, which is that we create a new matrix by picking out
  # rows from the old matrix, and the rows can be in an arbitrary order with duplicates
  next.players <- players[parents, ]
  
  # next, we randomly decide whether each individual gene will mutate.
  # we do this by generating a matrix that is the same size as the next.players matrix
  # and having a 1 at all the spots where a mutation will occur.
  mutations <- matrix(
    sample(c(0,1), population.size*6, prob = c(1-mutation.probability, mutation.probability), replace=T), 
    nrow=population.size)
  
  # a mutation involves changing the 0 to a 1 or the 1 to a 0. we can use the absolute value
  # function to do this in one step. we subtract the mutations matrix from the next.players matrix.
  # if the value was 1 it will now be 0. if it was 0 it will now be -1. using abs() fixes -1 to 1.
  next.players <- abs(next.players - mutations)
  
  return(next.players)
}

simulate.generations <- function(){
  # create arrays to store the average boldness and vengefulness of each generation
  average.boldness <- rep(0,number.of.generations)
  average.vengefulness <- rep(0,number.of.generations)
  
  # create a set of players
  players <- create.players()
  
  # loop through all the generations
  for(g in 1:number.of.generations){
    # calculate and store the average traits for the generation
    average.boldness[g] <- mean(sapply(1:population.size, function(x){boldness(players[x,])}))
    average.vengefulness[g] <- mean(sapply(1:population.size, function(x){vengefulness(players[x,])}))
    
    # run the round of the game
    fitness <- one.round(players)
    
    # replace the players with the next generation of players
    players <- next.generation(players, fitness)
  }
  return(data.frame(
    generation = 1:number.of.generations,
    boldness = average.boldness,
    vengefulness = average.vengefulness
  ))
}

result <- simulate.generations()

library(ggplot2)
library(tidyr)
plot.data <- pivot_longer(result, 2:3, names_to="trait")
ggplot(plot.data, aes(x=generation, y=value, color=trait))+
  geom_line()+
  theme_bw()

