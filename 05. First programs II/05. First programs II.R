#' 
#' Code 05: Writing our first programs II
#' 
#' # Loops
#' 
#' ## `for()` loops
#' 
#' The simplest and most frequently used type of loop is the `for()` loop. `for()` loops in R always iterate over a sequence (a vector), where the length of the vector defines how often the action inside the loop is executed.
#' 
#' Basic usage: for (<value> in <values>) { <action> }
#' 
#' <value>: Current loop variable.
#' <values>: Set over which the variable iterates. Typically an atomic vector but can also be a list.
#' <action>: Executed for each <value> in <values>.
#' 
#' Typically this starts like this
#' 
#' `for (i in 1:n) { ... }`
#' 
#' Two examples:
#' 
## ------------------------------------------------------------------

for (i in 1:3) {
    print(i)
}


#' 
## ------------------------------------------------------------------

for (i in c("Larry", "Moe", "Curly")) {
    print(i)
}


#' 
#' We can also create the values to loop across before hand:
#' 
## ------------------------------------------------------------------

x <- 5:1 # they don't need to be increasing

for (i in x) {
    print(i)
}

x <- c(1, 6, 4) # nor consecutive

for (i in x) {
    print(i)
}


#' 
## ------------------------------------------------------------------

names <- c("Larry", "Moe", "Curly")

for (x in names) {
    print(x)
}


#' 
#' We can also save things in loops to another object:
#' 
## ------------------------------------------------------------------

b <- NULL  # create an empty vector
for (i in 1:7) {
    b <- c(b, i^2)
}
b


#' 
#' Here we do the same, but loop across values of 'n' set outside the `for()` loop:
#' 
## ------------------------------------------------------------------

n <-  c(1:5)    # values to loop across
c <- NULL       # create an empty vector

for (i in n) {
    c <- c(b, i^2)
}
c


#' 
#' This does the same, but prints the object 'c' each time a loop is completed. You can see how 'c' get one value larger with each iteration of the loop.
#' 
## ------------------------------------------------------------------

n <-  c(1:5)    # values to loop across
c <- NULL       # create an empty vector

for (i in n) {
    c <- c(c, i^2)
    print(c)
}


#' 
#' 
#' ### loops and subsetting
#' 
#' Loops are often used in combination with subsetting (`vector[]`, as we learned in swirl lesson 6). We have a named vector friends with three elements:
#' 
## ------------------------------------------------------------------

friends <- c("Jose", "Jane", "Jamelle")

for (i in 1:3) {
    print(paste("Friend", i, "is", friends[i]))
}


#' 
#' 
#' ### typical errors
#' 
#' A typical error is that the index (the sequence we loop over) is not properly constructed. Common mistakes are:
#' 
#' Wrong hard-coded range: Imagine vector friends has three elements that we want to iterate over, but our for loop goes from 1:4 instead of 1:3. This would cause problems as our vector n only has 3, not 4 elements.
#' 
#' Incomplete range: 3 instead of 1:3. 3 is not a sequence, but a vector which contains one single value 3. Thus, the loop would only loop over c(3).
#' 
#' Note: We should avoid hard-coding indices in general. Hard-coding means that we explicitly write numbers like 1:3 into the code. What if the data set or vector changes its length? Our loop may no longer work properly.
#' 
#' Better: Instead of using hard-coded sequences, we make use of `length()` to check the length of the vector and use `1:length(info)` to create the vector. In case the length of info changes, the number of iterations will change as well.
#' 
## ------------------------------------------------------------------

n = c(1:5)
b <- NULL  # create an empty vector

length(n)

for (i in 1:length(n)) {
    b <- c(b, i^2)
}


#' 
#' ### `seq_along()`
#' 
#' An even slicker way of specifying the sequence to iterate over is to use `seq_along()`. This simple function creates a vector of integers (1, 2, ... n) as long as the specified vector. 
#' 
## ------------------------------------------------------------------

letters     # list of lower case letters, built into R
LETTERS     # list of upper case letters, built into R

v <- letters[1:8]
v
seq_along(v)

k <- c(1, 4, 6, 8)
k
seq_along(k)

friends <- c("Jose", "Jane", "Jamelle")
friends
seq_along(friends)


#' 
#' You can then use this to specify the integers to iterate across in a `for()` loop.
#' 
## ------------------------------------------------------------------

for (i in seq_along(v)) {
  print(i)
}

for (i in seq_along(v)) {
  print(v[i])
}


#' 
#' 
#' ### nested `for ()` loops
#' 
#' `for()` loops can also be nested. This is a relatively common approach. Like nested conditions, nested `for()` loops are two (or more) independent for-loops nested inside one another. Here is an example:
#' 
## ------------------------------------------------------------------

a <- c(1:2)
b <- c("a", "b", "c")

for (i in 1:length(a)) {
    for (j in 1:length(b)) {
        print(paste("i =", a[i], "j =", b[j]))
    }
}


#' 
#' A second example
#' 
## ------------------------------------------------------------------

a <- c("dark", "light")
b <- c("red", "blue", "green")

for(i in 1:3) {
    for(j in 1:2) {
        print(paste(a[j], b[i]))
    }
}


#' 
#' 
#' ## `while ()` loops
#' 
#' The second type of loop is `while()`. In contrast to a `for()` loop, which runs for a fixed number of iterations, a `while ()` loop runs while (as long as) a condition is true.
#' 
#' Basic usage: while (<condition>) { <action> }.
#' 
#' <condition>: Logical condition, has to be FALSE or TRUE.
#' <action>: Executed as long as the <condition> is TRUE.
#' 
#' The following shows an example where a while-loop is useful in practice. We want to print all numbers x in  1, 2, ...∞  as long as x^2 is lower than 20, starting with x <- 0.
#' 
## ------------------------------------------------------------------

# start with 0
x <- 0
# loop until condition is FALSE
while (x^2 < 20) {
  print(x)      # print x
  x <- x + 1    # increase x by 1
}


#' 
#' Here is another example:
#' 
## ------------------------------------------------------------------

# start with 1
i <- 1
#specify action to take
action <- c("Hello World!")

# loop until condition is FALSE
while (i < 16) {
  print(action)
	i = i + 1
}


#' 
#' ### typical error
#' 
#' beware infinite loops!
#' 
## ------------------------------------------------------------------

x <- 1
while (x > 0) {
    x <- x + 1
    print(paste("Loop number ", x))
}


#' 
#' We can escape an infinite loop with "Escape" or the "STOP" button at the top right of the console.
#' 
#' One way to avoid an infinite loop would be to add an upper limit to the `while ()` loop:
#' 
## ------------------------------------------------------------------

x <- 1
while (x > 0 & x < 133) {
    x <- x + 1
    print(paste("Loop number ", x))
}


#' 
#' 
#' Note the loop started at "Loop number 2" and stopped at "Loop number 133". Why?
#' 
#' ### `break` commands
#' 
#' Another way to get out of this would be to add a `break` command, which stops a loop when some condition is triggered.
#' 
## ------------------------------------------------------------------

x <- 1
while (x > 0) {
    x <- x + 1
     if (x == 133){
        break
      }
    print(paste("Loop number ", x))
}


#' 
#' Note the loop started at "Loop number 2" and ended with "Loop number  132". Why?
#' 
#' ### `next` command
#' 
#' A second way to control loop behavior is with `next`, which skips over a  specified iteration
#' 
## ------------------------------------------------------------------

x <- 1
while (x > 0 & x < 150) {   # added "& x < 150" to  avoid infinite loop
    x <- x + 1
         if (x == 133){
            next
      }
    print(paste("Loop number ", x))
}


#' 
#' We could skip over multiple values:
#' 
## ------------------------------------------------------------------

x <- 1
while (x > 0 & x < 150) {   # added "& x < 150" to  avoid infinite loop
    x <- x + 1
         if (x == 133 | x == 89){
            next
      }
    print(paste("Loop number ", x))
}


#' 
#' We could skip over a vector of values:
#' 
## ------------------------------------------------------------------

x <- 1
while (x > 0 & x < 150) {   # added "& x < 150" to  avoid infinite loop
    x <- x + 1
         if (x %in% c(8:18, 23, 67, 133:146)){
            next
      }
    print(paste("Loop number ", x))
}


#' 
#' 
#' # *apply
#' 
#' There is one final general and very useful coding concept we’d like to introduce you to: the *apply family of functions. 
#' 
#' The *apply (e.g., sapply, lapply) family of functions is used to apply a specified function across the rows or columns of a matrix or data frame, or along other dimensions of an array. Apply functions provide a concise and efficient way to perform operations on data structures without using loops.
#' 
#' Today’s skill booster, sessions 10 & 11 in swirl, will introduce you to these concepts.
#' 
#' 
#' # Team coding challenge
#' 
#' ## hint
#' 
#' Last time we learned we could use `readline()` to solicit user input:
#' 
## ------------------------------------------------------------------

x <- readline("What is the value of x? ")  
x


#' 
#' Here here is a slightly different approach to asking for input that might be useful.
#' 
## ------------------------------------------------------------------

response <- menu(c("Yes", "No"), 
                 title= "Do you want this?")


#' 
#' We'd like you to work with others at your table to create a program that completes the task indicated in "Act like a programmer!"
#' 
#' Welcome message
#' 
#' *What table is your team sitting at?*  XX
#' *What is your team name?*  YY
#' 
#' *Greetings team XX, we're going to calculate some simple information ...*
#' 
#' *How many people are in your group?* N
#' 
#' *Would you prefer to use driving directions or straight line distances?* A / B
#' 
#' Loop
#' {
#' Team member 1: *What is your name?* N1
#' *Where is your home town?* HT1
#' *Thank you, N1.*
#' }
#' 
#' *First we'll calculate the distance between N1's hometown HT1 and N2s hometown, HT2. To do this <explicit instructions> and enter the distance (specify units).*
#' 
#' Do this across all pairs.
#' 
#' Return 
#' *The hometowns of NX and NY are the closest together, only XX (units) (distance method) apart.*
#' 
#' *The hometowns of NX and NY are the furthest apart,  XX (units) (distance method apart.*
#' 
#' *The average pairwise distance among everyone at your table is XX (units) (distance method) apart.*
#' 
#' 
#' 
#' 
#' 
#' 
#' 
