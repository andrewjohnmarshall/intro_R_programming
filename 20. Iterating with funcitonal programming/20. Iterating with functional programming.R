#' 
#' 20. Iterating with functional programming
#' 
#' # Packages
#' 
## ------------------------------------------------------------------

library(tidyverse)


#' 
#' 
#' # Introduction
#' 
#' As we explore and describe data, especially more complex data, we can come to find that some of the tools we have learned thus far are limiting or inefficient. One way to surmount these hurdles is through iteration, or repeatedly performing the same action on different objects.
#' 
#' R often does this implicitly behind the scenes, so we don't know it is happening. This is one of R's strengths, often referred to as 'vectorized' processing.
#' 
#' For example, imagine we have a vector of numbers, v, and we want to multiply every element in that vector by 3. In R, this is simple, `3 * v`, whereas in many other programming languages, we'd need to explicitly triple each element of `v` using some sort of `for` loop.
#' 
#' Here is a simple example illustrating the difference:
#' 
## ------------------------------------------------------------------

a <- 01:10
b <- 11:20

# in R, functions can work on all elements 
# without needing to loop through each element
answer <- a + b
answer

# without vectorization, we'd need to use a loop:
answer2 <- NULL
for (i in 1:10) {
  answer2[i] <- a[i] + b[i]
}
print(answer2)

# they give the same answer, but the first one is simpler & faster
identical(answer, answer2)


#' 
#' We have already used a number of {tidyverse} tools that perform the same action for multiple "things":
#' 
#' -`facet_wrap()` and `facet_grid()` that draw a plot for each subset of data
#' 
#' - `group_by()` plus `summarize()` which computes summary statistics for each subset
#' 
#' - `unnest_wider()` and `unnest_longer()` that create new rows and columns for each element of a list-column
#' 
#' Today we will learn some more general tools, often called *functional programming* tools because they are built around functions that take other functions as inputs. Typically we do this by using functions as small building blocks that can then be combined into more complex code. This reduces redundancy and can often produce simpler, more elegant code that is easier to read.
#' 
#' # Simple example
#' 
#' Let's start with a simple example that highlights the benefits of functional programming and {purrr}. We'll use the simple data set 'trees' that is built into R.
#' 
## ------------------------------------------------------------------

trees <- as_tibble(trees)
trees


#' 
#' Imagine we wanted to calculate the mean of each column. When we first start with R, we'd likely use the old copy, paste, and modify approach:
#' 
## ------------------------------------------------------------------

mean(trees$Girth)
mean(trees$Height)
mean(trees$Volume)


#' 
#' This gives us the correct answer, but it is at odds with the programming principle of not copying and pasting more than once. Copying and pasting takes time and introduces the possibility for error, and would be a nightmare if there were a lot of columns.
#' 
#' The next step we might take would be to make a loop:
#' 
## ------------------------------------------------------------------

output <- NULL

for (i in 1:length(trees)) {          
  output[i] <- mean(trees[[i]])      
}
print(output)


#' 
#' (note `trees[[i]]` specifically selects the i-th element of the list or data frame and treats it as a vector if i is a single number indicating a column.)
#' 
#' We could also try a slightly more sophisticated one.
#' 
#' Here we create a vector to receive the values, using `vector()`, which produces a vector of a given mode (type) and length.
#' 
#' We also use `seq_along()` instead of '1:length(trees)', which is generally considered better practice because a) it is more readable (i.e., it is clear we want to go along the whole length of the data frame (or tibble) 'trees') and b) it is more robust to potential issues, such as if `length(trees)` were 0.
#' 
## ------------------------------------------------------------------

# create output vector
output <- vector("double", ncol(trees))

# this would do the same:
#output <- numeric(length(trees))

# loop through columns
for (i in seq_along(trees)) {          
  output[i] <- mean(trees[[i]])      
}
print(output)


#' 
#' We could also be a step more sophisticated, and generalize this to make it a function:
#' 
## ------------------------------------------------------------------

col_mean <- function(x) {
  output <- vector("double", length(x))
  for (i in seq_along(x)) {
    output[i] <- mean(x[[i]])
  }
  print(output)
}

col_mean(trees)


#' 
#' This is preferable because we now have a generalized function, `col_mean()` that we could use in any context we like. But we are still relying on loops, which are more cumbersome to write, and slower.
#' 
#' A still more elegant and faster method would be to use functional programming, which for us entails using a powerful little function, `map()`, which is part of the {purrr} package, or {dplyr}'s `across()`. You'll explore these in more depth below, but for now the simple syntax is:
#' 
#' map(INPUT, FUNCTION, ...)
#' 
#' in this instance, because we want the output to be a number (double), we'll use `map_dbl()`:
#' 
## ------------------------------------------------------------------

map_dbl(trees, mean)


#' 
#' technically, `map_dbl()` is iterating the same task (here, 'mean') across a bunch of different elements (here, the columns in the dataframe 'trees'). It gives us the same answers as before in code that is simpler and faster, and even provides the element name ('Girth', 'Height', 'Volume') in the output.
#' 
#' Here we wanted it to return numbers, but other specifications would return things in different formats:
#' 
#' - `map()` - returns a list
#' - `map_lgl()` - returns a logical vector
#' - `map_int()` - returns an integer vector
#' - `map_dbl()` - returns a double (numeric) vector
#' - `map_chr()` - returns a character vector
#' - `map_df()` - returns a data frame (tibble)
#' 
#' Note that we are passing one function, `mean()`, to another function `map_dbl()`. This is as an example of functional programming.
#' 
#' This is not only simpler and faster, but also more flexible. If rather than means we wanted medians, we could code this simply as:
#' 
## ------------------------------------------------------------------

map_dbl(trees, median)



#' 
#' Note: In the first instance above, we could use the vectorized {base} R function `colmeans()`:
#' 
## ------------------------------------------------------------------

colMeans(trees)


#' 
#' but such a function won't always be available. For example, imagine we instead wanted the median. There's no stock function to do that for us:
#' 
## ------------------------------------------------------------------

colMedians(trees)


#' 
#' but the {purrr} function works just fine, as we saw above.
#' 
#' Now we have a general sense of the potential benefits of functional programming and iteration, we'll build up some understanding of how this works. 
#' 
#' Work through the exploration of `across()` and `map()` below. We'll be circulating to answer any questions.
#' 
#' Remember, there are lots of useful and relevant cheat sheets available on Posit cloud. For example, here is one about {purrr}:  https://rstudio.github.io/cheatsheets/html/purrr.html
#' 
#' 
#' 
#' ------------------------------------------------------------
#' 
#' # Modifying multiple columns with `across()`
#' 
#' Imagine you have a simple tibble and you want to count the number of observations and compute the median of every column.
#' 
## ------------------------------------------------------------------

df <- tibble(a = rnorm(10),
             b = rnorm(10),
             c = rnorm(10),
             d = rnorm(10))
df


#' 
#' As we saw above, we could do this by copying, pasting, and modifying rows of code:
#' 
## ------------------------------------------------------------------

df %>% 
  summarize(n = n(),
            a = median(a),
            b = median(b),
            c = median(c),
            d = median(d))


#' 
#' This breaks our principle of reducing copying and pasting, and would be impractical if we had a large number of columns. Thankfully, there is the {tidyverse} function `across()` that iterates across multiple columns:
#' 
## ------------------------------------------------------------------

df %>% 
  summarize(n = n(),
            across(a:d, median))


#' 
#' `across()` has three key arguments, the first two of which we use every time we use the function:
#' 
#' '.cols', which specifies which columns you want to iterate over, and
#' '.fns', specifies what to do with each column.
#' 
#' and third of which, '.names' which provides additional control over the names of output columns, which is particularly important when you use `across()` with `mutate()` to create new columns.
#' 
#' We'll also see two important variations, `if_any()` and `if_all()`, which work with `filter()`.
#' 
#' 
#' ## selecting columns with '.cols'
#' 
#' The first argument to `across()`, '.cols', selects the columns we want to apply our function to. There are two additional selection techniques that are particularly useful for `across()`: `everything()` and `where()`.
#' `everything()` is straightforward: it selects every (non-grouping) column:
#' 
## ------------------------------------------------------------------

df <- tibble(
  grp = sample(2, 10, replace = TRUE),
  a = rnorm(10),
  b = rnorm(10),
  c = rnorm(10),
  d = rnorm(10)
)
df

df %>%  
  group_by(grp) %>%  
  summarize(across(everything(), median))


#' 
#' Note grouping columns (`grp` here) are not included in `across()`, because they're automatically preserved by `summarize()`.
#' 
#' `where()` allows you to select columns based on their type:
#' 
#' - `where(is.numeric)` selects all numeric columns
#' - `where(is.character)` selects all string columns
#' - `where(is.Date)` selects all date columns
#' - `where(is.POSIXct)` selects all date-time columns
#' - `where(is.logical)` selects all logical columns
#' 
#' Just like other selectors, you can combine these with Boolean algebra.
#' For example, `!where(is.numeric)` selects all non-numeric columns, and `starts_with("a") & where(is.logical)` selects all logical columns whose name starts with "a".
#' 
#' ## calling a single function
#' 
#' The second argument to `across()` defines what function to perform to each of the selected columns. In simple cases, as above, this will be a single existing function.
#' 
#' It's important to note that we're passing this function to `across()`, so `across()` can call it; we're not calling it ourselves. That means the function name should never be followed by `()`. If we do, we get an error:
#' 
## ------------------------------------------------------------------

df %>%  
  group_by(grp) %>% 
  summarize(across(everything(), median()))


#' 
#' This error arises because you're calling the function with no input, e.g.:
#' 
## ------------------------------------------------------------------

median()


#' 
#' ## calling multiple functions
#' 
#' In more complex cases, we might want to supply additional arguments or perform multiple transformations. For example: let's imagine we have some 'NAs' in our data.  When we do this, `median()` gives us a suboptimal output:
#' 
## ------------------------------------------------------------------

# a function to add random NAs into our data
rnorm_na <- function(n, n_na, mean = 0, sd = 1) {
  sample(c(rnorm(n - n_na, mean = mean, sd = sd), rep(NA, n_na)))
}

#randomly create tibble with missing data:
df_miss <- tibble(
  a = rnorm_na(5, 1),
  b = rnorm_na(5, 1),
  c = rnorm_na(5, 2),
  d = rnorm(5)
)
df_miss

# then try to summarize across:

df_miss %>%  
  summarize(
    across(a:d, median),
    n = n())


#' 
#' It would be nice if we could pass along `na.rm = TRUE` to `median()` to remove these missing values. To do so, instead of calling `median()` directly, we need to create a new function that calls `median()` with the desired arguments:
#' 
## ------------------------------------------------------------------

df_miss %>%  
  summarize(
    across(a:d, function(x) median(x, na.rm = TRUE)),
    n = n()
  )


#' 
#' This works well, but is a little verbose, so R comes with a handy shortcut: for this sort of throw away function, often called an *anonymous* function because we never explicitly give it a name. In these instances, we can replace `function` with `\`, and it works the same:
#' 
## ------------------------------------------------------------------

df_miss %>%  
  summarize(
    across(a:d, \(x) median(x, na.rm = TRUE)),
    n = n()
  )


#' 
#' In essence, this code is doing this:
#' 
## ------------------------------------------------------------------

df_miss %>%  
  summarize(
    a = median(a, na.rm = TRUE),
    b = median(b, na.rm = TRUE),
    c = median(c, na.rm = TRUE),
    d = median(d, na.rm = TRUE),
    n = n()
  )


#' 
#' just more succinctly. Note, if you look at older code you might see syntax that looks like:
#' 
#' `~ .x + 1`
#' 
#' This is another way to write anonymous functions but it only works inside {tidyverse} functions and always uses the variable name `.x`. Current practice is now to use the `\` syntax, which incidentally comes from {base} R:
#' 
#' `\(x) x + 1`
#' 
#' Now, when we remove the missing values from the `median()` using our code:
#' 
## ------------------------------------------------------------------

df_miss %>%  
  summarize(
    across(a:d, \(x) median(x, na.rm = TRUE)),
    n = n()
  )


#' 
#' it would be nice to know how many NAs were removed. We can do this by supplying two functions to `across()`: one to compute the median and the other to count the missing values. We do this by supplying multiple functions using a named list to '.fns'. (Recall that `across()` has the arguments '.cols', which specifies which columns you want to iterate over, and  '.fns', specifies what to do with each column. Below we'll see the third argument, which is optional). Here we replace our single function with a list of two:
#' 
## ------------------------------------------------------------------

df_miss %>%  
  summarize(
    across(a:d, list(
      median = \(x) median(x, na.rm = TRUE),
      n_miss = \(x) sum(is.na(x))
    )),
    n = n()
  )


#' 
#' This might look a bit complicated. Look carefully at this code block and compare it to the immediately preceding one to see exactly what has changed. We've added a second function 'sum(is.na(x))' to our initial function 'median(x, na.rm = TRUE)', named each ('median' and 'n_miss') so we will be able to identify the results in the output, and wrapped them both together as a `list()`. The output shows that it has applied each function to each of the columns. So we get 9 columns in the output,  'median' and 'n_miss' for our four columns (a, b, c, d) plus the one 'n' column that counts the number of rows in the initial data set.
#' 
#' ## column names
#' 
#' The output of `across()` is named according to the specification provided in the `.names` argument. We saw above that by default the naming convention is {.fn}_{.col} (i.e., the name of the function, followed by an underscore, and  the name of the column to which that function was applied). For instance, 'median_a' or 'n_miss_b'. This code does the same, but explicitly, by specifying the third argument to `across()`, '.names'.
#' 
## ------------------------------------------------------------------

df_miss %>%  
  summarize(
    across(
      a:d,
      list(
        median = \(x) median(x, na.rm = TRUE),
        n_miss = \(x) sum(is.na(x))
      ),
      .names = "{.fn}_{.col}"
    ),
    n = n(),
  )


#' 
#' If the code `.names = "{.fn}_{.col}"` produces the same output as the default, why would be use it? Sometimes being specific can help us understand what the code is doing, but in some instances it is important because leaving it out can create unanticipated issues, such as when we use `across()` with `mutate()`. As we saw, by default, when we have a single function in `across()`, the output is given the same names as the inputs:
#' 
## ------------------------------------------------------------------

df_miss %>%  
  summarize(
    across(a:d, \(x) median(x, na.rm = TRUE)))


#' 
#' Imagine we do this using `mutate()`. Recall that we use `mutate()` to create new columns *and add them to a dataframe*, but if we use `across()` inside  `mutate()` will replace existing columns. For example, here we use `coalesce()`, which finds the `NA`s and replaces them with `0`:
#' 
## ------------------------------------------------------------------

df_miss %>% 
  mutate(
    across(a:d, \(x) coalesce(x, 0))
  )


#' 
#' But there may be cases where we'd like to create new columns and add them to our data set (in other words, have `mutate()` behave the way it usually does). To do this we override the default naming scheme, which reuses the input column names and therefore overwrites the initial columns, and instead create new columns by giving them different names inside, the `.names` argument:
#' 
## ------------------------------------------------------------------

df_miss %>% 
  mutate(
    across(a:d, \(x) coalesce(x, 0), 
           .names = "{.col}_na_zero")
  )


#' 
#' Voila! We now see the new column names listed after our initial ones. We could name these whatever we want by simply changing our specified names 
#' 
## ------------------------------------------------------------------

df_miss %>% 
  mutate(
    across(a:d, \(x) coalesce(x, 0), 
           .names = "{.col}_hi!")    # <- change here
  )


#' 
#' ## filtering
#' 
#' `across()` is a great match for `summarize()` and `mutate()` but it's more awkward to use with `filter()`, because we often want to filter based on multiple conditions with either `|` or `&`. It's clear that `across()` can help to create multiple logical columns, but the coding gets complex. So dplyr provides two variants of `across()` called `if_any()` and `if_all()`:
#' 
#' The first, `if_any()` allows use to easily ask OR (`|`) statements. For example, if we wanted to filter things if a, b, c, or d was an 'NA', rather than something like this:
#' 
## ------------------------------------------------------------------

df_miss %>% 
  filter(is.na(a) | is.na(b) | is.na(c) | is.na(d))


#' 
#' We can write:
#' 
## ------------------------------------------------------------------

df_miss %>%  filter(if_any(a:d, is.na))


#' 
#' Similarly, `if_all()` allows us to easily ask AND (`&`) statements. For example, if we wanted to filter things if a, b, c, and d contain an 'NA', instead of this:
#' 
## ------------------------------------------------------------------

df_miss %>% 
  filter(is.na(a) & is.na(b) & is.na(c) & is.na(d))


#' 
#' we can write:
#' 
## ------------------------------------------------------------------

df_miss %>% 
  filter(if_all(a:d, is.na))


#' 
#' Both produce empty tibbles, because while a, b, and c contain 'NA's, d does not so not all of them contain 'NA's and this filter only works if ALL the columns are 'NA's.
#' 
#' ## `across()` in functions
#' 
#' `across()` is particularly useful to program with because it allows you to operate on multiple columns. For example, this function uses several {lubridate} functions to expand all date columns into year, month, and day columns:
#' 
## ------------------------------------------------------------------

expand_dates <- function(df) {
  df %>% 
    mutate(
      across(where(is.Date), list(year = year, month = month, day = day))
    )
}

df_date <- tibble(
  name = c("Amy", "Bob"),
  date = ymd(c("2009-08-03", "2010-01-16"))
)

df_date

df_date %>%  
  expand_dates()


#' 
#' 
#' # functional programming with `map()`
#' 
#' In the introduction we saw a second tool that is often used for functional programming in R, `map()`. There are some things that you could do using either `map()` or `across()` as they both serve the same general function, but seem to be used in slightly different contexts. `map()` is more broadly applicable and can operate on any list or vector, while `across()` is specifically for applying functions to columns within the context of {dplyr} data wrangling. Because it is designed for use in a particular context, `across()` is more capable in that context than the more general `map()`. It is not uncommon that more specific functions are more capable in their own particular context than more broadly applicable ones. You could think of it as `across()` being narrower but deeper, whereas `map()` is broader but shallower. Here we will do a quick exploration to see some of `map()`s capabilities.
#' 
#' ## map()
#' 
#' `map()` functions carry out an operation repeatedly and store the output of that operation for you. There are a number of different map functions which do essentially the same thing but return the output in different formats. As we saw in the introduction, these include:
#' 
#' - `map()`     - returns a list
#' - `map_lgl()` - returns a logical vector
#' - `map_int()` - returns an integer vector
#' - `map_dbl()` - returns a double (numeric) vector
#' - `map_chr()` - returns a character vector
#' - `map_df()`  - returns a data frame (tibble)
#' 
#' For example, we'll use the simple dataframe we created above.
#' 
## ------------------------------------------------------------------

df <- tibble(
  grp = sample(2, 10, replace = TRUE),
  a = rnorm(10),
  b = rnorm(10),
  c = rnorm(10),
  d = rnorm(10)
)
df


#' 
#' and calculate the mean of each column:
#' 
## ------------------------------------------------------------------

map_dbl(df, mean)

# or

df %>% 
  map_dbl(mean)


#' 
#' This creates a vector of integers (doubles). If we wanted to return a dataframe, we could use `map_df()`:
#' 
## ------------------------------------------------------------------

df %>% 
  map_df(mean)


#' 
#' Note that there are two flavors of `map_df()`, one which combines the output by rows (`map_dfr()`) and one by columns (`map_dfc()`) . In the example above they produce the same output because the input, a single dataframe, returns a result that is a single vector of numbers:
#' 
## ------------------------------------------------------------------

df %>% 
  map_dfr(mean)

df %>% 
  map_dfc(mean)


#' 
#' But if our output is multiple vectors, it can be returned in two different ways. To see this we create a list of numeric vectors and make a simple function to  calculate some simple statistics (mean, median, and sum)
#' 
## ------------------------------------------------------------------

my_nums  <- list(c(10, 20, 30), c(40, 50, 60), c(70, 80, 90))
my_nums


# Define a function to calculate statistics (mean, sum, and product)
my_stats_fn <- function(x) {
  data.frame(
    mean = mean(x),
    median = median(x),
    sum = sum(x)
  )
}


#' 
#' If we map the output by rows using `map_dfr()`, each row corresponds to one of the original vectors from the list, with the statistics as columns.
#' 
## ------------------------------------------------------------------

map_dfr(my_nums, my_stats_fn)


#' 
#' If we map the output by columns using `map_dfc()`, the statistics for each vector form a separate set of columns, all combined into one wide dataframe.
#' 
## ------------------------------------------------------------------

map_dfc(my_nums, my_stats_fn)


#' 
#' Note that the output has renamed the columns so each has a unique name. 
#' 
#' Whether you use `map_dfr()` or `map_dfc()` will depend largely on what you wanted to do with the output.
#' 
#' ## map2()
#' 
#' `map()` works when we want to iterate over a single named object (above 'df' or 'my_nums').  But we might want to iterate over multiple named objects. If we want to iterate across two named objects, we use `map2()`.
#' 
#' Above we saw the generic form of `map()` is:
#' map(.x, .f, ...)
#' map(INPUT, FUNCTION_TO_APPLY, OPTIONAL_OTHER_STUFF)
#' 
#' For `map2()` the generic form is:
#' map2(.x, .y, .f, ...)
#' map2(INPUT_ONE, INPUT_TWO, FUNCTION_TO_APPLY, OPTIONAL_OTHER_STUFF)
#' 
#' To see `map2()` in action, we'll return to our initial trees data set from the start of class:
#' 
## ------------------------------------------------------------------

trees


#' 
#' Let's imagine we wanted to calculate volume ourselves from girth and height. We can create a function to do this making some simplifying assumptions about tree geometry.  
#' 
## ------------------------------------------------------------------

volume <- function(diameter, height){
  # convert diameter in inches to radius in feet
  radius_ft <- (diameter/2)/12
  # calculate volume
  output <- pi * radius_ft^2 * height
  return(output)
}


#' 
#' To use our function we need two named inputs, 'diameter' and 'height', so we need to use `map2()`. Like `map()`, we need to specify the type of output. Here it is a number, or a double, so we use `map2_dbl()`:
#' 
#' 
## ------------------------------------------------------------------

map2_dbl(trees$Girth, trees$Height, volume)


#' 
#' Note that there are all the same variations of `map2()` that exist for `map()`, so you can use `map2_lgl()`, `map_int()`, etc.
#' 
#' Both map functions work well in {tidyverse} pipes. For example, here we add the output for our volume calculation to the trees data set as well as a column 'volume_diff' that displays the difference between our volume calculation and that reported in the data set:
#' 
## ------------------------------------------------------------------

trees %>%
  mutate(volume_cylinder = map2_dbl(trees$Girth, trees$Height, volume),
         volume_diff = Volume - volume_cylinder)


#' 
#' ## pmap()
#' 
#' As we saw, `map()` allows for iteration over a single named object and `map2()` allows for iteration over two. But, there is no `map3()`, `map4()`, etc. Instead, there is a single and more general `pmap()` - parallel map - function. The `pmap()` function takes a list of arguments over which you’d like to iterate.
#' 
#' The generic usage for `pmap()` is:
#' 
#' pmap(.l, .f, ...)
#' pmap(LIST_OF_INPUT_LISTS, FUNCTION_TO_APPLY, OPTIONAL_OTHER_STUFF)
#' 
#' Note that, in contrast to `map()` and `map()`, '.l' is a list of all the input vectors, so we are no longer specifying .x or .y individually. The rest of the syntax is the same.
#' 
#' 
#' # Appendix
#' 
#' This is not essential in the context of this class, but I provide it in case you run into issues using `across()`. This comes verbatim from Wickham et al's "R for Data Science" (https://r4ds.hadley.nz). Note they use the {base} R pipe `|>`, whereas we've been using the {tidyverse}'s pipe `%>%`.
#' 
#' It's worth pointing out an interesting connection between `across()` and `pivot_longer()`. In many cases, you perform the same calculations by first pivoting the data and then performing the operations by group rather than by column. For example, take this multi-function summary:
#' 
## ------------------------------------------------------------------
df |> 
  summarize(across(a:d, list(median = median, mean = mean)))

#' 
#' We could compute the same values by pivoting longer and then summarizing:
#' 
## ------------------------------------------------------------------
long <- df |> 
  pivot_longer(a:d) |> 
  group_by(name) |> 
  summarize(
    median = median(value),
    mean = mean(value)
  )
long

#' 
#' And if you wanted the same structure as `across()` you could pivot again:
#' 
## ------------------------------------------------------------------
long |> 
  pivot_wider(
    names_from = name,
    values_from = c(median, mean),
    names_vary = "slowest",
    names_glue = "{name}_{.value}"
  )

#' 
#' This is a useful technique to know about because sometimes you'll hit a problem that's not currently possible to solve with `across()`: when you have groups of columns that you want to compute with simultaneously.
#' 
#' For example, imagine that our data frame contains both values and weights and we want to compute a weighted mean:
#' 
## ------------------------------------------------------------------
df_paired <- tibble(
  a_val = rnorm(10),
  a_wts = runif(10),
  b_val = rnorm(10),
  b_wts = runif(10),
  c_val = rnorm(10),
  c_wts = runif(10),
  d_val = rnorm(10),
  d_wts = runif(10)
)

#' 
#' There's currently no way to do this with `across()`(Maybe there will be one day, but currently we don't see how), but it's relatively straightforward with `pivot_longer()`:
#' 
## ------------------------------------------------------------------
df_long <- df_paired |> 
  pivot_longer(
    everything(), 
    names_to = c("group", ".value"), 
    names_sep = "_"
  )
df_long

df_long |> 
  group_by(group) |> 
  summarize(mean = weighted.mean(val, wts))

#' 
#' If needed, you could `pivot_wider()` this back to the original form.
#' 
#' 
