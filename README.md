# Lab 2: Monte Carlo Methods in R, Formalizing Verbal Theory

## Monte Carlo Methods

> Any method which solves a problem by generating suitable random numbers and observing that fraction of the numbers obeying some property or properties. The method is useful for obtaining numerical solutions to problems which are too complicated to solve analytically. It was named by S. Ulam, who in 1946 became the first mathematician to dignify this approach with a name, in honor of a relative having a propensity to gamble (Hoffman 1998, p. 239). Nicolas Metropolis also made important contributions to the development of such methods.
>
> - http://mathworld.wolfram.com/MonteCarloMethod.html

To complete this lab, start with the `0-tutorial.R` file. This will introduce you to a few new R techniques and methods that will be useful for Monte Carlo simulations. After you complete the tutorial, there are two challenges to solve, `1-birthday-problem.R` and `2-hot-potato-problem.R`. I recommend doing them in order, but you are under no obligation to do so.

## Formalizing Verbal Theory

I've implemented the model from Axelrod, R. (1986). An evolutionary approach to norms. *American Political Science Review*, *80*(4), 1095-1111.

You can run it in `axelrod-model.R`. The parameters at the top allow for some quick testing of variations. You can implement the regular norms game by setting the `cost.of.being.punished.for.not.punishing` and `cost.of.punishing.for.not.punishing` parameters to 0. This effectively removes all the consequences of any enforcement of meta-norms. 

In the paper, Axelrod talks about possible mechanisms that might allow the development of norms. He mentions a few broad categories: **Metanorms**, **Dominance**, **Internalization**, **Deterrence**, **Social Proof**, **Membership**, **Law**, and **Reputation**. 

Your task is to pick one of these verbal ideas and think about how to formalize it. Then, implement it by changing my model. Once you've done that and experimented with your new model, write a few sentences describing what you did and what you learned. You can add your thoughts in the `discussion.md` file.


