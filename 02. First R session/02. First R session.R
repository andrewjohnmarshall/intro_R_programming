#' 
#' 
#' COMPFOR 133
#' 
#' Code 02. First R Session
#' 
#' Welcome to your first R session!
#' 
#' # Projects in Posit Cloud
#' 
#' - when you open, it creates a personal copy
#' - red file name = unsaved changes
#' - downloading projects from Posit Cloud
#' 
#' # A quick overview of R Studio and R markdown
#' 
#' ## panes 
#' 
#' Source and Console, and more
#' 
#' ## customization
#' 
#' Go to settings (Tools -> Global Options...), there you can:
#' - set the "Pane Layout" 
#' - set your own themes, appearance, font, text size, etc. under "Appearance". 
#' 
#' I normally code with font size 11 or so, which is what I used when I wrote this code. In class I will bump mine up to ~18 point to help make it more readable. This will not change any of the line numbering (as they are based on line breaks), but it will mean that the spacing of the code you use will look a little different from the one on the screen in class.
#'  
#' ## code chunks
#' 
#' In an R Markdown file, text written here (outside code chunks) is text.
#' 
#' This is a code chunk:
#' 
## ------------------------------------------------------------------


#' 
## ------------------------------------------------------------------

6 + 8


#' 
#' This is normal text.
#' 
## ------------------------------------------------------------------

# text written here (inside a code chunk) is interpreted as R code
# any thing written after a hash will not be executed
# adding a hash anywhere makes R ignore everything following it on that line (or until you hit return to make a new line)

5 +  7 # this lines adds two numbers

all lines in a code chunk not preceded by '#' are executed  #oops 


#' 
#' Code -> Insert Chunk
#' 
#' Learn the shortcut for adding code chunks!
#' 
#' ## Rmd document headings
#' 
#' 
#' Adding different levels of heading to your code, even if you don't intend to knit it to another format, can really help with organization.
#' 
#' # Basic R coding
#' 
#' simple command, send to console for R to execute
#' 
## ------------------------------------------------------------------

23 + 67
c(1, 2, 3, 7)


#' 
#' save as an object
#' 
## ------------------------------------------------------------------

x <- 23 + 67
x
y <- c(1, 2, 3, 7)
y


#' 
#' overwriting an object
#' 
## ------------------------------------------------------------------

x
x <- 6 + 7
x


#' 
#' math with objects ("vectorization")
#' 
## ------------------------------------------------------------------

y
2 * y


#' 
#' 
#' # Code formatting
#' 
#' spaces don't affect functionality (usually)
#' 
## ------------------------------------------------------------------

2/3
2 / 3
2           /              3


#' 
#' Neither do line breaks, if you select the lines together:
#' 
## ------------------------------------------------------------------

2/
  3


#' 
#' 
#' This is really helpful, as it means you can add line breaks to your code to make it easier to read, add comments, etc. Compare this code, which produces a simple scatterplot with some customization,using a built-in dataset in R called "trees". Don't worry about the details now. Just compare the readability of this:
#' 
#' 
## ------------------------------------------------------------------

plot(Volume ~ Girth,main = "Girth vs. Volume for Black Cherry Trees",xlab = "Tree Girth (in)",ylab="Tree Volume (cu ft)",las = 1,bty = "n",pch = 16,cex = Height/50,col = "blue",data = trees)


#' 
#' with a tidied version, using line breaks:
#' 
## ------------------------------------------------------------------

plot(Volume ~ Girth,
      main = "Girth vs. Volume for Black Cherry Trees",
      xlab = "Tree Girth (in)", 
      ylab = "Tree Volume (cu ft)",
      las  = 1,
      bty  = "n",
      pch  = 16,
      cex  = Height/50,
      col  = "orange",
      data = trees)


#' 
#' this also leaves room to add comments:
#' 
## ------------------------------------------------------------------

plot(Volume ~ Girth,
      main = "Girth vs. Volume for Black Cherry Trees",
      xlab = "Tree Girth (in)", 
      ylab = "Tree Volume (cu ft)",
      las  = 1,    # I'm a comment!
      bty  = "n", # Me, too.
         # the next line sets the plotting character 
      pch = 16,
      cex = Height/50,
      col = "orange",
      data = trees)


#' 
#' # Knitting
#' 
#' This is how you will submit homework.
#' 
#' 1. Knit the document to *.html
#' 2. Select box next to document in Files folder
#' 3. Export (to save to your computer)
#' 4. Upload *.html to Canvas
#' 
#' # Swirl (session 1)
#' 
#' Today we will take our first steps with R code using activities in the Swirl package. For more information, see
#' https://swirlstats.com.
#' 
#' The package should already be loaded for you, so I have "commented out" the install line. Simply run the other two lines of code to start the activity. You will have to "uncomment" (i.e., remove the hashtag) the command `swirl()` before you run it (I did this to avoid swirl-specific issues when we knit the file earlier, this is not something that will come up much after today).
#' 
## ------------------------------------------------------------------

#install.packages("swirl") # install package 
                           # (cf. installing light bulb)

library("swirl")           # load library
                           # (cf. turning light on)

#swirl()                    #start swirl


#' 
#' Enter your name, then select '2' to Proceed. It will provide you some basic information, summarized below FYI.
#' 
#' ## basic swirl commands
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
#' Next, it will give you some choices, select option 1. "R Programming: The basics of programming in R", then option 1 again "R Programming", then option "1: Basic Building Blocks". 
#' 
#' Follow the lesson. It will cover the following topics:
#'   - R as a calculator
#'   - assigning variables
#'   - creating vectors
#'   - simple vector operations
#' 
#' ## general Notes
#' 
#' - Swirl shows you how far along you are in the lesson
#' - If you input a wrong answer a couple of times,
#'       swirl will offer a hint
#' - After completing lesson, click option 2.No, then type `0` to exit.
#' 
#' 
#' # Swirl (session 2)
#' 
#' Our second activity today will be to complete the second lesson in Swirl. Start Swirl:
#' 
## ------------------------------------------------------------------

#swirl()                    #start swirl


#' 
#' Then select "1: R Programming", then option 1 again "R Programming", then "2" for the second lesson in "Workspace and Files".
#' 
#' In this lesson, you'll learn about:
#'   -working directories
#'   -file management
#'   -help files
#'   
#' 
