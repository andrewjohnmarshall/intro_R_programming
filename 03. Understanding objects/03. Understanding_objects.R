#' 
#' Understanding objects
#' 
#' # RStudio tips and tricks
#' 
#' ## Spell checking 
#' 
#' in an RMarkdown document, you can (and should, for submitted work) check spelling:
#'   - Edit > Check Spelling...
#'   - The spell check button to the right of the save button
#'   - The [F7] key (sometimes, depends on settings)
#'   
#' ## Keyboard shortcuts
#' 
#' Tools -> Keyboard Shortcuts Help
#' OR
#' https://support.rstudio.com/hc/en-us/articles/200711853-Keyboard-Shortcuts
#' 
#' Ones I use all the time:
#' 
#' anywhere (Mac):
#' - Cmd+Shift+O  : show outline
#' - Cmd+Shift+K  : knit
#' - Cmd+C/V/X    : save/copy/paste
#' - Cmd+Option+I : insert chunk
#' 
#' anywhere (PC):
#' - Ctrl+Shift+O  : show outline
#' - Ctrl+Shift+K  : knit
#' - Ctrl+C/V/X    : save/copy/paste
#' 
#' in code chunks (Mac):
#' - Option+-:    : insert an "<-" operator
#' - Cmd+Return   : run line / highlighted code in console
#' - Cmd+Option+C : run current chunk in console
#' - Cmd+Option+I : insert chunk
#' 
#' in code chunks (PC):
#' - Alt+-        : insert an "<-" operator
#' - Ctrl+Enter   : run line / highlighted code in console
#' - Ctrl+Alt+I   : run whole chunk in console
#' 
#' Explore and find ones that work for you... I suggest adding a few at a time, and only adding more once the initial ones are second nature.
#' 
#' ## Other tips & info
#' 
#' - select text, type a (quotation mark/parentheses/brackets to surround selection)
#' - History = a searchable list of commands that have been run
#' - "Tab" to fill functions, function arguments
#' - "Tab" between two double quotes (” “) to open 
#'     a listing of all files in the working directory
#' 
#' We will usually be using R Markdown files, filename.Rmd, which contain both code and text. You will also run into R script files, filename.R, which contain only code (any text is commented out)
#' 
#' Slightly more advanced, but also potentially useful or of interest to you is:
#' https://paulvanderlaken.com/2018/05/21/r-tips-and-tricks/#rstudio
#' 
#' # Getting help
#' 
#' ## in R
#' Option 1:`?function`
#' 
## ------------------------------------------------------------------

?mean
?seq
# R will tell you if you look for something that doesn't exist:
?gr


#' 
#' Option 2:`help()`
#' 
## ------------------------------------------------------------------

help(lm)
?help


#' 
#' Option 3: `help.search("keyword")`
#' 
## ------------------------------------------------------------------

help.search("mle")
# the "??" shortcut gives you the same thing:
??"mle"


#' 
#' ## on line
#' 
#' https://rseek.org
#' 
#' ## R Recipies
#' 
#' Left sidebar: Learn -> Recipes
#' 
#' ## R cheat sheets
#' 
#' Left sidebar: Learn -> Cheatsheets
#' 
#' # R coding nuggets: print(), return()
#' 
## ------------------------------------------------------------------

# draw ten random numbers from a normal distribution
a <- rnorm(10)  
a
print(a)
show(a)

# also works
(a <- rnorm(10))  

return(a)


#' 
#' just typing the value 'a' shows a value, it is "implicit printing". It is normally only used when working in an interactive console.
#' 
#' `print()` displays text in the console. Use it when you want to show something to a user or see it yourself. This is "explicit printing". (*"print() is for people"*) It is best to do this as opposed to "implicit printing" when working in a script of function. (Implicit printing within scripts or functions only works if you use it in the last line of the function or script)
#' 
#' `return()` stores the value so it can be used by a function when required. It does not always print the value(s) on the screen. It can only be used in a function.
#' 
#' # Basics of atomic vectors
#' 
#' Vectors are covered in detail in swirl lessons 4 and 6 (and a little in 7 & 8). Here is some simple summary info, distilled from the very helpful site https://discdown.org/rprogramming (referenced at end)
#' 
#' ## types of atomic vectors
#' 
#' Not all of these are applicable for us, yet.
#' 
#' 1	double:       	a.k.a. numeric, Floating point numbers
#' 2	integer:        including “Long” integers (12L)
#' 3	logical:	      TRUE, FALSE	Boolean
#' 4	character:	    text
#' 5	complex:       	Real + imaginary numbers (-5+11i, 3+2i)
#' 6	raw:            Raw bytes (as hexadecimal)
#' 
#' ## important vector functions
#' 
#' A few of the most important functions for creating and investigating simple vectors are:
#' 
#' 
#' c():          Combines multiple elements into 
#'                  one atomic vector.
#' length():     Returns the length (number of elements) 
#'                  of an object.
#' class():      Returns the class of an object.
#' typeof():     Returns the type of an object. 
#'                  There is a small (sometimes important)
#'                  difference between typeof() and class() 
#'                  as we will see later.
#' attributes(): Returns further metadata of arbitrary type.
#' 
#' ## checking class/type
#' 
#' `class()` and `typeof()` can be used to determine the *class* and type of an object. Both functions return a character vector which contains the name of the class/type (e.g., "numeric" or "integer").
#' 
#' Alternatively, a range of functions exist to check whether or not an object is of a specific type. These very handy functions return either a logical TRUE if the input is of this specific type, or FALSE if not. Examples are:
#' 
#' is.double()
#' is.numeric()
#' is.integer()
#' is.logical()
#' is.character()
#' is.vector()
#' … and many more.
#' 
#' # Swirl
#' 
#' Last time we did Swirl lessons 1 and 2 in class. Lessons 3 & 4 comprised your skill booster for last class. Today you should work on lessons 5 & 6 in class. Lessons 7 & 8 will be the skill booster for today's class.
#' 
#' The goal is to have you complete lessons 1-8 by next Tuesday. So if you have not yet completed 3 & 4, start with them.
#' 
#' By the end of lesson 8, you will have learned about:
#' 
#'  1: Basic Building Blocks      2: Workspace and Files     
#'  3: Sequences of Numbers       4: Vectors                 
#'  5: Missing Values             6: Subsetting Vectors      
#'  7: Matrices and Data Frames   8: Logic   
#' 
## ------------------------------------------------------------------

# install.packages("swirl") # install package 

library("swirl")           # load library
swirl()                    #start swirl


#' 
#' Enter your name, then select the appropriate numbers to proceed to your less. 
#' 
#' ## Reminder: Basic swirl commands
#' 
#' bye()        # exits and saves progress, 
#'                  should see a confirmation message
#'                  if done properly
#' skip()       # allows you to skip the current question.
#' play()       # lets you experiment with R on your own; 
#'                 swirl will ignore what you do...
#' nxt()        # regain swirl's attention 
#'                 after the play() command
#' main()       # returns you to swirl's main menu.
#' info()       # displays these options again.
#' help.start() # opens a menu of resources to help
#'                you with a particular topic
#' 
#' ## General Notes
#' 
#' - Swirl shows you how far along you are in the lesson
#' - If you input a wrong answer a couple of times,
#'       swirl will offer a hint
#' - After completing lesson, click option 2.No, then type `0` to exit.
#' 
#' # Additional information on R objects
#' 
#' If you would like to learn a bit more background regarding R objects, particularly vectors, matrices, lists. and dataframes, I recommend the following excellent online resource:
#' 
#' https://discdown.org/rprogramming/vectors.html
#' https://discdown.org/rprogramming/matrices.html
#' https://discdown.org/rprogramming/lists.html
#' https://discdown.org/rprogramming/dataframes.html
