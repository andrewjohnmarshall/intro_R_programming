#' 
#' 17. Wrangling more complex data
#' 
#' 
#' # Packages
#' 
## ------------------------------------------------------------------

library(tidyverse)
library(repurrrsive)
library(jsonlite)


#' 
#' # Hierarchical data
#' 
#' An important skill to learn as we expand our abilities to use R to work with data is data *rectangling*, which means converting data that are fundamentally hierarchical into a rectangular data frame made up of rows and columns. This is important because hierarchical data are very common, especially when working with data that come from the web.
#' 
#' ## lists
#' 
#' Our first step is to learn about lists, the data structure that makes hierarchical data possible. So far we've worked with data frames that contain simple vectors like integers, numbers, characters, date-times, and factors. These vectors are simple because they're homogeneous: every element is of the same data type. If we want to store elements of different types in the same vector, we need a *list*, which we create with `list()`:
#' 
## ------------------------------------------------------------------

x1 <- list(1:4, "a", TRUE)
x1
str(x1)


#' 
#' `str()` displays each child of the list on its own line. It's often convenient to name the components, or children, of a list, which you can do in the same way as naming the columns of a tibble:
#' 
## ------------------------------------------------------------------

x2 <- list(a = 1:2, b = 1:3, c = 1:4)
x2
str(x2)


#' 
#' Note that lists are still considered vectors in R. But they are different than most vectors we have seen so far. Most vectors we've seen so far are are *atomic* vectors, with their contents restricted to a single data type. In contrast, a list is a *heterogeneous* or *recursive* vector, which means it contains data of different types.
#' 
#' 
#' ### hierarchy
#' 
#' Lists can contain any type of object, including other lists (this is what *recursive* means). This makes them suitable for representing hierarchical (tree-like) structures:
#' 
## ------------------------------------------------------------------

x3 <- list(list(1, 2), list(3, 4))
str(x3)


#' 
#' This is notably different to `c()`, which generates a flat vector:
#' 
## ------------------------------------------------------------------

x4 <- c(c(1, 2), c(3, 4))
x4

str(x4)
str(x3)


#' 
#' As lists get more complex, `str()` becomes even more useful, as it lets us see the nested hierarchy at a glance:
#' 
## ------------------------------------------------------------------

x5 <- list(1, list(2, list(3, list(4, list(5)))))
str(x5)


#' 
#' but as lists get larger and more complex, `str()` can become cumbersome. Luckily, we can take advantage of the `View()` call to interactively explore a complex list.
#' 
## ------------------------------------------------------------------

View(x5)


#' 
#' In the view pane that is produced we can click on the rightward facing triangle to expand that component of the list and reveal its children. Note the bottom-left corner: if you click an element of the list, RStudio will give you the subsetting code needed to access it, which you can send directly to the console by clicking the icon on the far right side of the relevant line.
#' 
#' 
#' ### list-columns
#' 
#' Lists can also live inside tibbles, where they are called 'list-columns'. List-columns are useful because they allow us to place objects in a tibble that wouldn't usually belong in one. For example, list-columns are used a lot in the {tidymodels} package (https://www.tidymodels.org), because they allow us to store things like model outputs in a data frame. Here's a simple example of a list-column:
#' 
## ------------------------------------------------------------------

df <- tibble(
  x = 1:2, 
  y = c("a", "b"),
  z = list(list(1, 2), list(3, 4, 5))
)
df


#' 
#' list-columns respond in the same way as any other column in the {tidyverse}:
#' 
## ------------------------------------------------------------------

df %>%  
  filter(x == 1)


#' 
#' but computing with list-columns is harder, but that's because computing with lists is harder in general (it generally involves iteration, repeatedly performing the same action on different objects) but for now we'll focus on unnesting list-columns out into regular variables so we can use our existing tools on them.
#' 
#' The default print method just displays a rough summary of the contents.
#' The list column could be arbitrarily complex, so there's no good way to print it. If you want to see it, you'll need to pull out just the one list-column and examine it using `str()` or `View()`:
#' 
## ------------------------------------------------------------------

df %>% 
  pull(z) %>% 
  str()

df %>%  
  pull(z) %>%  
  View()


#' 
#' Note, above we use the tidyverse function `pull()`, which extracts information from a dataframe (similar to the `$` syntax, so `df %>% pull(z)` is the same as `df$z`). `pull()` is similar to `select()`, but `pull()` creates a vector, whereas `select()` creates a  dataframe:
#' 
## ------------------------------------------------------------------

df %>% 
  pull(z) %>% 
  class()

df %>% 
  select(z) %>% 
  class()


#' 
#' Remember, a list is a kind of vector, but it is not an *atomic* vector.
#' 
#' ## unnesting
#' 
#' Now that we know the basics of lists and list-columns, we'll explore how you can turn them back into regular rows and columns. List-columns tend to come in two basic forms- named and unnamed- that tend to unnest in different ways, as we'll see below.
#' 
#' ### named chilren: `unnest_wider()`
#' 
#' When the children are *named*, they tend to have the same names in every row. For example, in `df1`, every element of list-column `y` has two elements named `a` and `b`. 
#' 
## ------------------------------------------------------------------

df1 <- tribble(
  ~x, ~y,
  1, list(a = 11, b = 12),
  2, list(a = 21, b = 22),
  3, list(a = 31, b = 32),
)

str(df1)

df1 %>% 
  View()


#' 
#' Named list-columns naturally unnest into columns: each named element becomes a new named column. We do this using `unnest_wider()`:
#' 
## ------------------------------------------------------------------

df1 %>%  
  unnest_wider(y)


#' 
#' By default, the names of the new columns come directly from the names of the list elements, but you can use the `names_sep` argument to request that they combine the column name and the element name. This is useful for disambiguating repeated names.
#' 
## ------------------------------------------------------------------

df1 %>% 
  unnest_wider(y, names_sep = "_")


#' 
#' ### unnamed chilren: `unnest_longer()`
#' 
#' When the children are *unnamed*, the number of elements tends to vary from row-to-row. For example, in `df2`, the elements of list-column `y` are unnamed and vary in length from one to three. 
#' 
## ------------------------------------------------------------------

df2 <- tribble(
  ~x, ~y,
  1, list(11, 12, 13),
  2, list(21),
  3, list(31, 32),
)

str(df2)

df2 %>% 
  View()


#' 
#' Unnamed list-columns naturally unnest into rows: we get one row for each child. For this we use `unnest_longer()`:
#' 
## ------------------------------------------------------------------

df2 %>% 
  unnest_longer(y)


#' 
#' Note how `x` is duplicated for each element inside of `y`: we get one row of output for each element inside the list-column. But what happens if one of the elements is empty, as in the following example?
#' 
## ------------------------------------------------------------------

df3 <- tribble(
  ~x, ~y,
  "a", list(1, 2),
  "b", list(3),
  "c", list()
)

df3

df3 %>% 
  unnest_longer(y)


#' 
#' We get zero rows in the output, so the row effectively disappears.
#' If you want to preserve that row, adding 'NA' in y, set 'keep_empty = TRUE':
#' 
## ------------------------------------------------------------------

df3 %>% 
  unnest_longer(y, keep_empty = TRUE)


#' 
#' Often this can be a good idea, as it can alert you to missing data that should be there.
#' 
#' 
#' ### other functions
#' 
#' {tidyr} has additional functions that you might come across:
#' 
#' - `unnest_auto()` automatically picks between `unnest_longer()` and `unnest_wider()` based on the structure of the list-column. It's useful for rapid exploration, but ultimately it's suboptimal because it doesn't force you to understand how your data is structured, and makes your code harder to understand.
#' 
#' - `unnest()` expands both rows and columns. It's useful when you have a list-column that contains a 2d structure like a data frame.
#' 
#' 
#' # JSON
#' 
#' ## converting JSON using {jsonlite}
#' 
#' The package {jsonlite} is a convenient way to convert JSON into R data structures. The most commonly-used functions are `read_json()` and `parse_json()`. Normally, we'd use `read_json()` to read a JSON file that we had downloaded from the web using an API. `parse_json()` extracts information from JSON format. Here are three simple examples. We start by creating three simple datasets in JSON format:
#' 
## ------------------------------------------------------------------

# a number
json1 <- '1'                

# an array
json2 <- '[1, 2, 3]'

# an object
json3 <- '{"x": [1, 2, 3]}'


#' 
#' We can parse each of these using `parse_json()`:
#' 
## ------------------------------------------------------------------

parse_json('1')
parse_json(json1)
parse_json('[1, 2, 3]')
parse_json(json2)
parse_json('{"x": [1, 2, 3]}')
parse_json(json3)


#' 
#' and look at their structure:
#' 
## ------------------------------------------------------------------

str(parse_json('1'))
str(parse_json('[1, 2, 3]'))
str(parse_json('{"x": [1, 2, 3]}'))


#' 
#' R has converted the number 'json1' to an integer, the array 'json2' to an unnamed list, and object 'json3' to a named list.
#' 
#' 
#' ## starting the rectangling process
#' 
#' In most cases, JSON files contain a single top-level array, because they're designed to provide data about multiple "things", e.g., multiple pages, or multiple records, or multiple results. Here we create a JSON object, called 'json'
#' 
## ------------------------------------------------------------------

json <- '[
  {"name": "John", "age": 34},
  {"name": "Susan", "age": 27}
]'
json


#' 
#' We can use `parse_json()` to extract the information:
#' 
## ------------------------------------------------------------------

parse_json(json)


#' 
#' but this is not so easy to work with. So, we convert it to a tibble called json so each element becomes a row, and save the object as a dataframe.
#' 
## ------------------------------------------------------------------

df <- tibble(json = parse_json(json))
df


#' 
#' We can use `View()` to examine the results:
#' 
## ------------------------------------------------------------------

View(df)


#' 
#' This has named children, suggesting to us that `unnest_wider()` will convert these named children to columns:
#' 
## ------------------------------------------------------------------

df %>% 
  unnest_wider(json)


#' 
#' Note we could have done this in a single pipe:
#' 
## ------------------------------------------------------------------

json %>% 
  parse_json() %>% 
  tibble() %>% 
  unnest_wider(1)


#' 
#' 
#' # Examples: explore on your own
#' 
#' In the simple examples we used above a single level of unnesting was sufficient to extract the data we wanted. In real-world situations JSON data typically contains multiple levels of nesting that require multiple calls to `unnest_longer()` and/or `unnest_wider()`. Below you will see this in action by working through two real rectangling challenges using datasets from the {repurrrsive} package.
#' 
#' ## 1. very wide data
#' 
#' We'll start with `gh_repos`, which is a list that contains data about a collection of GitHub repositories retrieved using the GitHub API. It's a very deeply nested list. Before continuing, explore the data a little to get a sense of its structure. Start by using `str()`, which will show you that it isn't very helpful with data that are this nested (it will likely also take a few second to render). Then, try `View()`, where you can explore by digging into the hierarchical structure of the list.
#' 
## ------------------------------------------------------------------

str(gh_repos)
View(gh_repos)


#' 
#' 'gh_repos' is a list, but our tools work with list-columns, so we'll begin by putting it into a tibble that we call 'json' and then save the object as 'repos'.
#' 
## ------------------------------------------------------------------

repos <- tibble(json = gh_repos)
repos


#' 
#' This tibble contains 6 rows, one row for each child of `gh_repos`. Each row contains a unnamed list with either 26 or 30 rows. Since these are unnamed, we'll start with `unnest_longer()` to put each child in its own row:
#' 
## ------------------------------------------------------------------

repos %>% 
  unnest_longer(json)


#' 
#' At first glance, it might seem like we haven't improved the situation: while we have more rows (176 instead of 6) each element of `json` is still a list.
#' 
#' However, there's an important difference: now each element is a *named* list so we can use `unnest_wider()` to put each element into its own column:
#' 
## ------------------------------------------------------------------

repos %>%  
  unnest_longer(json) %>% 
  unnest_wider(json) 


#' 
#' This has worked but the result is a little overwhelming: there are so many columns that tibble doesn't even print all of them. We can see them all with `names()`:
#' 
## ------------------------------------------------------------------

repos %>%  
  unnest_longer(json) %>%  
  unnest_wider(json) %>%  
  names()


#' 
#' Let's pull out a few that look interesting:
#' 
## ------------------------------------------------------------------

repos %>%  
  unnest_longer(json) %>%  
  unnest_wider(json) %>%  
  select(id, full_name, owner, description)


#' 
#' You can use this to work back to understand how `gh_repos` was structured: each child was a GitHub user containing a list of up to 30 GitHub repositories that they created.
#' 
#' `owner` is another list-column, and since it contains a named list, we can use `unnest_wider()` to get at the values:
#' 
## ------------------------------------------------------------------

repos %>%  
  unnest_longer(json) %>%  
  unnest_wider(json) %>%  
  select(id, full_name, owner, description) %>% 
  unnest_wider(owner)


#' 
#' We get an error because the 'owner' list column also contains an `id` column and we can't have two columns with the same name in the same data frame.
#' The error message suggests we try `names_sep` to resolve the problem:
#' 
## ------------------------------------------------------------------

repos %>%  
  unnest_longer(json) %>%  
  unnest_wider(json) %>%  
  select(id, full_name, owner, description) %>% 
  unnest_wider(owner, names_sep = "_")


#' 
#' This gives another wide dataset, but you can get the sense that `owner` appears to contain a lot of additional data about the person who "owns" the repository.
#' 
#' ## 2. relational data
#' 
#' Nested data are sometimes used to represent data that we'd usually spread across multiple data frames. To explore this, we'll use the 'got_chars' which contains data in JSON format about characters that appear in the Game of Thrones books and TV series. You will explore these data further in the problem set for today. Like 'gh_repos' in the previous example, it's a list, so we start by turning it into a list-column of a tibble:
#' 
## ------------------------------------------------------------------

chars <- tibble(json = got_chars)
chars


#' 
#' The `json` column contains named elements, so we'll start by widening it:
#' 
## ------------------------------------------------------------------

chars %>%  
  unnest_wider(json)


#' 
#' And selecting a few columns to make it easier to read:
#' 
## ------------------------------------------------------------------

characters <- chars %>%  
  unnest_wider(json) %>%  
  select(id, name, gender, culture, born, died, alive)
characters


#' 
#' We can also select columns based on the types. Here we select list-columns:
#' 
## ------------------------------------------------------------------

chars %>%  
  unnest_wider(json) %>%  
  select(id, where(is.list))


#' 
#' Let's explore the `titles` column. It's an unnamed list-column, so we'll unnest it into rows:
#' 
## ------------------------------------------------------------------

chars %>% 
  unnest_wider(json) %>% 
  select(id, titles) %>%  
  unnest_longer(titles)


#' 
#' You might expect to see this data in its own table because it would be easy to join to the characters data as needed. Let's do that, which requires little cleaning: filtering out the rows containing empty strings (more precisely, filtering and keeping the rows where title is not equal to "", an empty cell) and renaming `titles` to `title` since each row now only contains a single title.
#' 
## ------------------------------------------------------------------

titles <- chars %>%  
  unnest_wider(json) %>%  
  select(id, titles) %>% 
  unnest_longer(titles) %>%  
  filter(titles != "") %>% 
  rename(title = titles)
titles


#' 
#' You could imagine creating a table like this for each of the list-columns, then using joins to combine them with the character data as you need it.
#' 
#' For additional worked examples using these two data sets and others, see https://tidyr.tidyverse.org/articles/rectangle.html#github-users.
#' 
