#' 
#' Writing our first programs
#' 
#' # Functions
#' 
#' ## basic syntax
#' 
#' *functionname* <- function(*inputs*) {
#'                          *computations*
#'                          return(*results*)
#' }
#' 
#' *highlighted* text indicates text you can change
#' 
#' ## simple examples
#' 
#' Make a custom function to calculate the mean of a number
#' 
## ------------------------------------------------------------------

mymean <- function(a) {
     calc <- sum(a)/length(a)
     return(calc)
}

y <- c(rep(1, 9), rep(2, 15), rep(3,26), rep(4, 10))

mymean(y)
mean(y)


#' 
#' ## your turn
#' 
#' 1) write a function to return the reciprocal of a number
#' 
## ------------------------------------------------------------------


#' 
#' 
#' 2) write a function to round a number to the nearest whole number
#' 
## ------------------------------------------------------------------


#' 
#' 
#' ## why use functions?
#' 
#' "manually" calculate a standard deviation, using the standard formula:
#'  
## ------------------------------------------------------------------

sqrt(sum((x - mean(x))^2) / (length(x) - 1))


#' 
#' use the code three times by copying and changing the names of the objects
#' 
## ------------------------------------------------------------------

# randomly sample three vectors from normal distribution
set.seed(133) # pseudo randomization
x1 <- rnorm(1000, mean = 0, sd = 1.0)
x2 <- rnorm(1000, 0, 1.5)
x3 <- rnorm(1000, 0, 5.0)

# calculate standard deviation once ...
sd1 <- sqrt(sum((x1 - mean(x1))^2) / (length(x1) - 1))

# ... twice, ...
sd2 <- sqrt(sum((x2 - mean(x2))^2) / (length(x2) - 1))

# ... three times ...
sd3 <- sqrt(sum((x3 - mean(x2))^2) / (length(x3) - 1))

# ... and return the three answers
c(sd1, sd2, sd3)
# slightly nicer output
c(sd1 = sd1, sd2 = sd2, sd3 = sd3)

# compare to correct answers
c(sd1_correct = sd(x1),
  sd2_correct = sd(x2),
  sd3_correct = sd(x3))


#' 
#' Can you spot an error?
#' 
#' Note, you could compare these more easily by assigning them to objects and comparing the answers:
#' 
## ------------------------------------------------------------------

hand_calcs   <- c(sd1, sd2, sd3)
correct_vals <- c(sd(x1), sd(x2), sd(x3))

hand_calcs == correct_vals


#' 
#' create a function:
#' 
## ------------------------------------------------------------------

mysd <- function(x) {
  res <- sqrt(sum((x - mean(x))^2) / (length(x) - 1))
  return(res)
}


#' 
#' and use it
#' 
## ------------------------------------------------------------------

# calculate standard deviation using function
sd1 <- mysd(x1)
sd2 <- mysd(x2)
sd3 <- mysd(x3)

# return the three answers
c(sd1 = sd1, sd2 = sd2, sd3 = sd3)
# compare to correct answers
c(sd1_correct = sd(x1),
  sd2_correct = sd(x2),
  sd3_correct = sd(x3))

# use logic
a <- c(sd1 = sd1, sd2 = sd2, sd3 = sd3)
b <- c(sd1_correct = sd(x1),
  sd2_correct = sd(x2),
  sd3_correct = sd(x3))

a == b


#' 
#' What did we learn?
#' 
#' 
#' #########################
#' 
#' -> Back to slides   
#' 
#' #########################
#' 
#' 
#' # Conditionals
#' 
#' ## if statements
#' 
#' Basic usage: if (<condition>) { <action> }.
#' 
#' The <condition> has to be a single logical TRUE or FALSE.
#' If <condition> is evaluated to TRUE, the <action> is executed.
#' 
## ------------------------------------------------------------------

x <- 8
if (x < 10) {
  cat("x is smaller than 10") 
}


#' 
#' note:
#' `cat()` - concatenate and print
#' 
#' The condition (here: x < 10) is always within round brackets if (...), the action is everything between the curly brackets ({ ... }). If the condition is evaluated to FALSE no action is executed, e.g., when x is 12.
#' 
## ------------------------------------------------------------------

x <- 12
if (x < 10) {
  cat("x is smaller than 10") 
}


#' 
#' We could make this a function
#' 
## ------------------------------------------------------------------

myfun <- function(x) {
if (x < 10) {
  cat("x is smaller than 10") 
 } 
}

myfun(4)
myfun(19)


#' 
#' or ask the user for a number, using `readline()`, then run the function
#' 
## ------------------------------------------------------------------

x <- readline("What is the value of x? ")  
myfun(x)
x # oops

# constrain input to be a number
x <- as.numeric(readline("What is the value of x? "))
x
myfun(x)


#' 
#' ## if-else statements
#' 
#' The first extension of if-statements are if-else statements. In contrast to if-statements they have an additional else clause which is executed whenever the (if-)condition is evaluated to FALSE.
#' 
#' Basic usage: if (<condition>) { <action 1> } else { <action 2> }
#' 
#' If <condition> is evaluated to TRUE, <action 1> is executed. Else <action 2> is executed.
#' 
#' Let's take the same example as above where we check if a certain number is smaller than 10.
#' 
## ------------------------------------------------------------------

x <- 18
if (x < 10) {
    print("x is smaller than 10")
} else {
    print("x is larger than or equal to 10")
}


#' 
#' ## nested if-else statements
#' 
#' If-else statements can also be nested. Nested means that one of the actions itself contains another if-else statement. Important note: the two if-else statements are independent.
#' 
## ------------------------------------------------------------------

x <- 10
# 'Outer' if-else statement.
if (x < 10) {
    print("x is smaller than 10")
} else {
    # 'Inner' if-else statement.
    if (x > 10) {
        print("x is larger than 10")
    } else {
        print("x is exactly 10") 
    }
}



#' 
#' As before, we could make this a function, and ask for user input. 
#' 
## ------------------------------------------------------------------

# define function

myfunc <- function (x) {
if (x < 10) {
    print("x is smaller than 10")
} else {
    # 'Inner' if-else statement.
    if (x > 10) {
        print("x is larger than 10")
    } else {
        print("x is exactly 10") 
    }
  }
}

# ask for user input
x <- as.numeric(readline("What is the value of x? "))
myfunc(x)


#' 
#' ## multiple if-else statements
#' 
#' Instead of nested (independent) if-conditions we can extend the concept by adding multiple if-else conditions in one statement. The difference from nested conditions is that this is one single large statement, not several smaller independent ones.
#' 
#' Basic usage: if (<condition 1>) { <action 1> } else if (<condition 2>) { <action 2> } else { <action 3> }.
#' 
#' If <condition 1> evaluates to TRUE, <action 1> is executed.
#' Else <condition 2> is evaluated. If TRUE, <action 2> is executed.
#' Else, <action 3> is executed (if both, <condition 1> and <condition 2>, evaluate to FALSE).
#' 
#' We can achieve the same result as above (nested if-else statements) by writing the following statement.
#' 
## ------------------------------------------------------------------

x <- 10
if (x < 10) {
    print("x is smaller than 10")
} else if (x > 10) {
    print("x is larger than 10")
} else {
    print("x is exactly 10") 
}


#' 
#' this achieves the same as:
#' 
## ------------------------------------------------------------------

x <- 10
if (x < 10) {
    print("x is smaller than 10")
} else if (x > 10) {
    print("x is larger than 10")
} else if (x == 10) {
    print("x is exactly 10") 
}


#' 
#' Else or no else: This depends on the task. One advantage of else-block is that it captures all cases that are not considered by one of the conditions above. Thus, the else-block is something like the “fallback case”. In some other scenarios you only want to execute something if a strict condition is TRUE or do nothing. In such cases an else-block is not necessary.
#' 
#' 
#' ## your turn
#' 
#' Work through the following two tasks. Use the examples above to guide you. Take your time, and make sure your code does what it should and that you understand how it arrived at the answer. 
#' 
#' 
#' 1) write an if-else statement to test if the square root of a number, N,  is less than 5 and provide an appropriate output. You can assign N yourself.
#' 
## ------------------------------------------------------------------


#' 
#' 2) Now, make this into a function.
#' 
## ------------------------------------------------------------------


#' 
#' 3. Finally, modify this function to ask the user to provide N for you.
#' 
## ------------------------------------------------------------------


#' 
#' 
#' 
#' # Practice
#' 
#' Today's problem set (2026-01-20 problem set, worth 1,000 points) will give you the opportunity to work on functions and conditional statements.
#' 
#' There is also a skill booster available (2026-01-20 skill booster, 500 points), which will allow you to begin developing good coding practices in R, and allow you to practice using ChatGPT in a way that accords with course policy.
#' 
#' 
#' 
#' 
