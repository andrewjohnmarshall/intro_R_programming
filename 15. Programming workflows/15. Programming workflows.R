#' 
#' 15. Improving our programming workflows
#' 
#' # Packages
#' 
## ------------------------------------------------------------------

library(here)
library(ProjectTemplate)
library(palmerpenguins)
library(ggpubr)


#' 
#' 
#' # Useful tips and tricks
#' 
#' ## Set "global parameters"
#' 
#' Let's imagine we want to make a figure with four plots. For example:
#' 
## ------------------------------------------------------------------

p1 <- penguins %>% 
  ggplot(aes(x = body_mass_g, y = flipper_length_mm)) +
  geom_point() +
  geom_smooth(method = "lm", formula = y ~ x)

p2 <- penguins %>% 
  ggplot(aes(x = body_mass_g, y = bill_length_mm)) +
  geom_point() +
  geom_smooth(method = "lm", formula = y ~ x)

p3 <- penguins %>% 
  ggplot(aes(x = body_mass_g, y = flipper_length_mm)) +
  geom_point() +
  geom_smooth()

p4 <- penguins %>% 
  ggplot(aes(x = body_mass_g, y = bill_length_mm)) +
  geom_point() +
  geom_smooth()

ggarrange(p1, p2, p3, p4,
          nrow = 2, ncol = 2,
          labels = c("A", "B", "C", "D"))


#' 
#' Now, let's imagine we want to customize the plot to use different themes, point colors, and semi-transparent points: 
#' 
## ------------------------------------------------------------------

p1 <- penguins %>% 
  ggplot(aes(x = body_mass_g, y = flipper_length_mm)) +
  geom_point(col = "darkorange", alpha = 0.5) +
  theme_bw() +
  geom_smooth(method = "lm", formula = y ~ x,
              col = "gray50")

p2 <- penguins %>% 
  ggplot(aes(x = body_mass_g, y = bill_length_mm)) +
  geom_point(col = "darkorange", alpha = 0.5) +
  theme_bw() +
  geom_smooth(method = "lm", formula = y ~ x,
              col = "gray50")

p3 <- penguins %>% 
  ggplot(aes(x = body_mass_g, y = flipper_length_mm)) +
  geom_point(col = "darkorange", alpha = 0.5) +
  theme_bw() +
  geom_smooth(method = "lm", formula = y ~ x,
              col = "gray50")

p4 <- penguins %>% 
  ggplot(aes(x = body_mass_g, y = bill_length_mm)) +
  geom_point(col = "darkorange", alpha = 0.5) +
  theme_bw() +
  geom_smooth(method = "lm", formula = y ~ x,
              col = "gray50")

ggarrange(p1, p2, p3, p4,
          nrow = 2, ncol = 2,
          labels = c("A", "B", "C", "D"))


#' 
#' But, we're not sure this is the best color or transparency. Maybe we want to color the two variables different colors. And maybe we want to add custom axis labels:
#' 
## ------------------------------------------------------------------

p1 <- penguins %>% 
  ggplot(aes(x = body_mass_g, y = flipper_length_mm)) +
  geom_point(col = "cornflowerblue", alpha = 0.6) +
  theme_bw() +
  geom_smooth(method = "lm", formula = y ~ x,
              col = "gray60") +
  labs(y = "Flipper Length (mm)", 
       x = "Body mass (g)") 

p2 <- penguins %>% 
  ggplot(aes(x = body_mass_g, y = bill_length_mm)) +
  geom_point(col = "darkgreen", alpha = 0.6) +
  theme_bw() +
  geom_smooth(method = "lm", formula = y ~ x,
              col = "gray60") +
  labs(y = "Bill Length (mm)", 
       x = "Body mass (g)") 


p3 <- penguins %>% 
  ggplot(aes(x = body_mass_g, y = flipper_length_mm)) +
  geom_point(col = "cornflowerblue", alpha = 0.6) +
  theme_bw() +
  geom_smooth(col = "gray60") +
  labs(y = "Flipper Length (mm)", 
       x = "Body mass (g)") 

p4 <- penguins %>% 
  ggplot(aes(x = body_mass_g, y = bill_length_mm)) +
  geom_point(col = "darkgreen", alpha = 0.6) +
  theme_bw() +
  geom_smooth(col = "gray60") +
  labs(y = "Bill Length (mm)", 
       x = "Body mass (g)") 

ggarrange(p1, p2, p3, p4,
          nrow = 2, ncol = 2,
          labels = c("A", "B", "C", "D"))


#' 
#' We have to change many things each time we want to make a tweak. A way to avoid this is to set "global parameters":
#' 
## ------------------------------------------------------------------

my_col1   <- "cornflowerblue"
my_col2   <- "darkgreen"
my_alpha1  <- 0.6
my_alpha2  <- 0.6
my_linecol <- "gray60"
my_theme   <- theme_minimal()

p1 <- penguins %>% 
  ggplot(aes(x = body_mass_g, y = flipper_length_mm)) +
  geom_point(col = my_col1, alpha = my_alpha1) +
  my_theme +
  geom_smooth(method = "lm", formula = y ~ x,
              col = my_linecol) +
  labs(y = "Flipper Length (mm)", 
       x = "Body mass (g)") 

p2 <- penguins %>% 
  ggplot(aes(x = body_mass_g, y = bill_length_mm)) +
  geom_point(col = my_col2, alpha = my_alpha1) +
  my_theme +
  geom_smooth(method = "lm", formula = y ~ x,
              col = my_linecol) +
  labs(y = "Bill Length (mm)", 
       x = "Body mass (g)") 

p3 <- penguins %>% 
  ggplot(aes(x = body_mass_g, y = flipper_length_mm)) +
  geom_point(col = my_col1, alpha = my_alpha1) +
  my_theme +
  geom_smooth(col = my_linecol) +
  labs(y = "Flipper Length (mm)", 
       x = "Body mass (g)") 

p4 <- penguins %>% 
  ggplot(aes(x = body_mass_g, y = bill_length_mm)) +
  geom_point(col = my_col2, alpha = my_alpha1) +
  my_theme +
  geom_smooth(col = my_linecol) +
  labs(y = "Bill Length (mm)", 
       x = "Body mass (g)") 

ggarrange(p1, p2, p3, p4,
          nrow = 2, ncol = 2,
          labels = c("A", "B", "C", "D"))


#' 
#' 
#' ### your turn
#' 
#' Q. Modify the text below to change the plots colors, transparency, and line color. Add a new global parameter to change the size of the plotted points.
#' 
## ------------------------------------------------------------------

my_col1   <- "cornflowerblue"
my_col2   <- "darkgreen"
my_alpha1  <- 0.6
my_alpha2  <- 0.6
my_linecol <- "gray60"
my_theme   <- theme_minimal()


p1 <- penguins %>% 
  ggplot(aes(x = body_mass_g, y = flipper_length_mm)) +
  geom_point(col = my_col1, alpha = my_alpha1) +
  my_theme +
  geom_smooth(method = "lm", formula = y ~ x,
              col = my_linecol) +
  labs(y = "Flipper Length (mm)", 
       x = "Body mass (g)") 

p2 <- penguins %>% 
  ggplot(aes(x = body_mass_g, y = bill_length_mm)) +
  geom_point(col = my_col2, alpha = my_alpha1) +
  my_theme +
  geom_smooth(method = "lm", formula = y ~ x,
              col = my_linecol) +
  labs(y = "Bill Length (mm)", 
       x = "Body mass (g)") 

p3 <- penguins %>% 
  ggplot(aes(x = body_mass_g, y = flipper_length_mm)) +
  geom_point(col = my_col1, alpha = my_alpha1) +
  my_theme +
  geom_smooth(col = my_linecol) +
  labs(y = "Flipper Length (mm)", 
       x = "Body mass (g)") 

p4 <- penguins %>% 
  ggplot(aes(x = body_mass_g, y = bill_length_mm)) +
  geom_point(col = my_col2, alpha = my_alpha1) +
  my_theme +
  geom_smooth(col = my_linecol) +
  labs(y = "Bill Length (mm)", 
       x = "Body mass (g)") 

ggarrange(p1, p2, p3, p4,
          nrow = 2, ncol = 2,
          labels = c("A", "B", "C", "D"))


#' 
#' 
#' ## Zoom in on one of your Rmd panes
#' 
#' Use CTRL + SHIFT + 1:4 to zoom in on any single of your RStudio panels. Hit it again to return to previous multi-panel view.
#' 
#' 
#' ## edit several lines at once
#' 
## ------------------------------------------------------------------

# press OPTION (Mac) or ALT (PC) 
# when you highlight 
# to edit several lines at once

a
b
c  
d  
e  

# delete to merge them into a single row


#' 
#' ## rename in scope
#' 
#' If you have to change a variable name in multiple places but you are afraid that “find and replace” will mess up your code, fear not. It’s possible to rename "in scope" only (e.g., only within a particular code chunk). It’s achieved by selecting the function or variable we want to change and pressing Ctrl + Shift + Alt + M.
#' 
#' It selects all occurrences in scope, you will have to just type a new name.
#' 
#' Yes, the shortcut is long, but it can be helpful. I find it to be easier to remember as an extension of the tidyverse pipe (%>%) shortcut, so Pipe + Alt.
#' 
#' Alternatively:
#' - Select a variable 
#' - Go to: Code > Rename in scope
#' - Rename 
#' 
#' Note: this is sometime buggy on Posit Cloud
#' 
## ----name----------------------------------------------------------

my_col1   <- "cornflowerblue" 
my_col2   <- "green"
my_alpha1  <- 0.6
my_alpha2  <- 0.6
my_linecol <- "gray60"
my_theme   <- theme_minimal()

p1 <- penguins2 %>% 
  ggplot(aes(x = body_mass_g, y = flipper_length_mm)) +
  geom_point(col = my_col1, alpha = my_alpha1) +
  my_theme +
  geom_smooth(method = "lm", formula = y ~ x,
              col = my_linecol) +
  labs(y = "Flipper Length (mm)", 
       x = "Body mass (g)") 

p2 <- penguins2 %>% 
  ggplot(aes(x = body_mass_g, y = bill_length_mm)) +
  geom_point(col = my_col2, alpha = my_alpha1) +
  my_theme +
  geom_smooth(method = "lm", formula = y ~ x,
              col = my_linecol) +
  labs(y = "Bill Length (mm)", 
       x = "Body mass (g)") 

p3 <- penguins2 %>% 
  ggplot(aes(x = body_mass_g, y = flipper_length_mm)) +
  geom_point(col = my_col1, alpha = my_alpha1) +
  my_theme +
  geom_smooth(col = my_linecol) +
  labs(y = "Flipper Length (mm)", 
       x = "Body mass (g)") 

p4 <- penguins2 %>% 
  ggplot(aes(x = body_mass_g, y = bill_length_mm)) +
  geom_point(col = my_col2, alpha = my_alpha1) +
  my_theme +
  geom_smooth(col = my_linecol) +
  labs(y = "Bill Length (mm)", 
       x = "Body mass (g)") 

ggarrange(p1, p2, p3, p4,
          nrow = 2, ncol = 2,
          labels = c("A", "B", "C", "D"))


#' 
#' 
#' ## specify options in your script
#' 
#' Prevent scientific notation using `options(scipen = 999)`
#' 
#' Use `options(width = 60)` to change the default width of console output
#' 
#' Use `options(max.print = 100)` to change the default number of values printed in the console
#' 
#' ## convert Rmd to R scripts
#' 
#' Open a new R script, and type
#' `knitr::purl("filename.Rmd", documentation = 2)`
#' 
#' documentation = 0: discard all text, keep only code
#' documentation = 1: (default) add chunk headers to code
#' documentation = 2: add all text chunks to code as comments
#' 
#' more info: 
#' https://www.garrickadenbuie.com/blog/convert-r-markdown-rmd-files-to-r-scripts/
#' 
#' https://bookdown.org/yihui/rmarkdown-cookbook/purl.html
#' 
#' 
#' ## explore on your own, if interested
#' 
#' ### RStudio add-ins
#' 
#' https://github.com/daattali/addinslist
#' 
#' 
#' ### Various cool tricks for Rmd documents
#' 
#' https://holtzy.github.io/Pimp-my-rmd/
#' 
#' note: The casual slang title for the website might offend, my apologies if it does. The content is innocuous and worthwhile.
#' 
#' # Programming workflows
#' 
#' As we move into the second half of the semester and begin working on some more complex programming tasks, and as you embark on your own projects, it will become more important to think about our programming workflows. Staying organized and being deliberate about how we structure our programming and analysis projects are key skills that we will be working to develop. Our use of Posit Cloud imposes some useful structure that has served us well to date. But now we will begin thinking about this more explicitly.
#' 
#' Please read and work through the material below at your own pace.
#' 
#' ## setting up R projects
#' 
#' RStudio projects are very helpful for organizing our code and any other relevant files in one location. This is how Posit Cloud is structured, so we are used to interacting with R this way - but many R users, even fairly sophisticated ones, do not make use of the functionality that projects provide in the their day-to-day R coding.
#' 
#' New projects are created by clicking on the "New project" button in Posit Cloud. This creates a file with the .Rproj extension. This file tells RStudio to identify the directory containing the .Rproj file as the working directory for that R Project.
#' 
#' A new session of RStudio is started for each project. The previous state including settings of that project will be maintained from one time to the next. The files that were open the last time the user worked on the project will automatically be opened again.
#' 
#' Background info: https://support.posit.co/hc/en-us/articles/200526207-Using-RStudio-Projects
#' 
#' 
#' ### file paths
#' 
#' A major benefit of using R projects is that it simplifies file paths. In this class, we've been using Posit Cloud so have largely avoided this complication, but in less controlled environments navigating file paths and working directories can be a hassle.
#' 
#' If we don't use R projects, we have to set a working directory manually, and the working directory for us is virtually guaranteed not to work for anyone else who wants to use our code. For example, here is the full path to a current analysis project I am working on: 
#' 
#' /Users/ajmarsha/Dropbox (Personal)/sedang diproses/*landscape connectivity
#' 
#' anyone else who wants to use the code I write would need to set a different path to get the code to run. In fact, if I want to work on the project from my home computer, I'd have to use a different path, as I have that directory structured differently.
#' 
#' So, every time I run my code from a different computer (or anyone else wants to run my code), we have to (at a minimum) set the working directory, using `setwd()`. This is a hassle, and it results from using "absolute" file paths that specify the specific path to a specific directory on a specific computer, starting at the root directory.
#' 
#' An alternative is using a "relative" path which gives a path to the destination folder based on where the user is at that moment. This is usually easier, especially when we are using R projects, because the working directory is always the folder that contains the .Rproj file (e.g., here it is called "project.Rproj". So, we can copy the entire project folder anywhere and things will work without changing any code.
#' 
#' 
#' ### controlling paths with the {here} package
#' 
#' Recently, I have seen people I respect advocating using of a package to help "minimize the pain" of working with and setting file paths within an R Project - the {here} package.
#' 
#' Once you have loaded the package using `library(here)` if you type `here()` it will set the directory to use for all future paths in this project.
#' 
## ------------------------------------------------------------------

here()


#' 
#' You may notice that the output of `here()` and `getwd()` are the same, but they are doing different things behind the scenes.
#' 
## ------------------------------------------------------------------

getwd()


#' 
#' `getwd()` shows the directory you are in currently, whereas `here()` *sets* the directory to use for all future relative paths. While in this case it also happened to be in the same directory you were in, it doesn’t have to be. The `here()` function looks to see if you have a .Rproj file and then sets your working directory to the directory that contains that file. 
#' 
#' Note: In cases where there is no .Rproj file, `here()` will look for files other than a .Rproj file and make a reasonable determination based on your project structure. You can read about those cases here: https://github.com/jennybc/here_here#the-fine-print
#' 
#' But usually, especially if you use R projects, then `here()` will work as expected.
#' 
#' Another nice feature of using `here()` is that you can use it to define any and all other paths within the project.
#' 
#' First, we'll save an object as a new RDA file, based on R's built in 'cars' data set, then save it in the 'output' folder (I created this folder myself before class). Run the code and then confirm that the new file 'CARS.rda' has appeared in the 'output' directory (a.k.a. the 'output' folder)
#' 
## ------------------------------------------------------------------

cars
SPEED <- cars$speed    
DIST  <- cars$speed    

save(SPEED, DIST, file = "output/CARS.rda")  #save file


#' 
#' Now we can get the path to this new file using `here()`
#' 
## ------------------------------------------------------------------

here("output", "CARS.rda")


#' 
#' This code tells R to start at the working directory (defined by `here()`), then look in the folder 'outputs' for the file “CARS.rda”.
#' 
#' We could use this to read in our data:
#' 
## ------------------------------------------------------------------

testdata <- load(file = here("output", "CARS.rda"))


#' 
#' The syntax is simplified when using `here()`. Each sub directory or file in the path is in quotes and simply separated by commas within the `here()` function, which makes it easier to read and use.
#' 
#' So, {here} offers some handy benefits. Personally, though, I have never felt the need to use it. For me, using R projects solves the issues without the need for a separate package. 
#' 
#' 
#' ## file names
#' 
#' Naming files well can save future you a lot of time and make collaboration with others (including your future self!) a lot easier. The best file names are: machine readable, human readable, and well ordered. If your files have these three characteristics, then it will be easy for you to search for them (machine readable), easy for you to understand what is in the files (human readable), and easy for you to glance at a whole folder and understand the organization (well ordered). Some simple rules can help us achieve these goals.
#' 
#' ### machine readable files
#' 
#' Files that are “machine readable" make it easy for your computer to search for them. Let’s see which one of the following examples are good example of machine readable files and which are not. Here are some simple rules of thumb:
#' 
#' - avoid spaces:
#'       "2024 my report.Rmd" is bad, 
#'       "2024_my_report.Rmd" is better.
#' 
#' - avoid punctuation:
#'       "andy’s_report.Rmd" is bad, 
#'       "andys_report.Rmd" is better.
#' 
#' - avoid accented characters:
#'       "01_zoë_report.Rmd" is bad,
#'       "01_zoe_report.Rmd" is better.
#' 
#' - avoid case sensitivity:   
#'       "AndyMarshallReport.Rmd" is bad, 
#'       "andy-marshall-report.Rmd" is better.
#' 
#' - use delimiters:            
#'       "executivereportumv1.Rmd" is bad,
#'       "executive_report_um_v1.Rmd" is better.
#' 
#' In short:
#' - spaces, punctuation, and periods should be avoided but underscores and dashes are recommended 
#' - use lowercase since you don’t have to later remember if the name of the file contained lowercase or uppercase letter (You may have noticed that programmers and other geeky computer types tend to have all files and folders listed using lowercase; this is one reason why. Others include ensuring cross-platform compatibility, preventing errors between case-sensitive (e.g., Linux) and case-insensitive (e.g., Windows/macOS) systems, improving readability, and preventing issues with URLs).
#' - delimiters (hyphens or underscores) makes it easier to look for files on your computer or in R and to extract information from the file names
#' 
#' ### human readable files
#' 
#' A file name is "human readable" if the name tells you something informative about the content of the file. For instance, the name "analysis.R" does not tell you what is in the file (cf. don't email someone your resume that is called "CV.docx"!)  A better name maybe would be "2024-exploratory_analysis_ungulates.Rmd". The ordering of the information is mostly up to you but make sure the ordering makes sense. For better browsing and intuitive default sorting of your files, it is usually better to use the dates and numbers in the beginning of the file name.
#' 
#' ### well ordered files
#' 
#' By using dates, you can sort your files based on chronological order. Dates should be in the ISO8601 format. In the United States we mainly use the mm-dd-yyyy format. If we use this format for naming files, files will be first sorted based on month, then day, then year. But this is counter intuitive and not very helpful. It is better to sort files based on year, then month, and then day and, therefore, the yyyy-mm-dd format. Files will sort in chronological order, and be easier for non-US folks to work with.
#' 
#' see: https://xkcd.com/1179/
#' 
#' If dates are not relevant for your file naming, put something numeric first. For instance if you’re dealing with multiple reports, you can add a report_xxx_ to the beginning of the file name so you can easily sort files by the report number.
#' 
#' In addition to making sure your files can be nicely ordered, always left-pad numbers with zeros. That is, first decide upon a max number of digits for your numbers determined by how many files you will potentially have. So if you may not have more than 1000 files you can choose three digits. If not more than a hundred you can choose two digits and so on. Once you know the number of digits, left-pad numbers with zeros to satisfy the number of digits you determined in the first step. In other words, if you’re using three digits, instead of writing 1 write 001 and instead of writing 17 write 017. This will help your files sort in the appropriate order and will work regardless of the operating system you use. This is why our lecture files are labelled 01, 02, 03, etc.
#' 
#' 
#' ## project organization
#' 
#' In addition to appropriately setting up file paths and naming files appropriately, organizing our R projects clearly can substantially improve our programming workflows. There are lots of ways we can organize projects, the important thing is that we have a logical and consistent structure. I've provided an example of a simple but well-structured project in the '15. restoring_red_apes' project, found in the class code list (the same place this project is found).
#' 
#' 
#' ## project templates
#' 
#' While there is no universally accepted "best" layout for how to do organize projects, most R projects have some aspects in common. The {ProjectTemplate} package codifies some of these defaults into a usable file hierarchy so that you can immediately start placing files in the right place.
#' 
#' This code creates a new project and populates it with useful folders:
#' 
## ------------------------------------------------------------------

create.project(project.name = "data_analysis",
               template = "minimal")


#' 
#' The `create.project()` function creates a directory called data_analysis for this project. Inside that directory are the following sub-directories (which we can view in the RStudio File browser):
#' 
#' Inside each directory is a *README* file that contains a brief description of what kinds of files should go in this directory. If you do not need all of these directories, it is okay to leave them empty for now.
#' 
#' The *data* directory is most straightforward as it holds any data files (in any variety of formats) that will be needed for the project.
#' 
#' The *munge* directory contains R code files that pre-process (e.g., tidy) the data you will eventually use an any analysis.
#' 
#' Any results from pre-processing can be stored in the *cache* directory if needed (for example, if the pre-processing takes a long time). 
#' 
#' The *config* directory can contain configuration information for your project, such as any packages that need to be loaded for your code to work. We will not go into the details of this directory for now, but suffice it to say that there are many ways to customize your project. 
#' 
#' Finally, the *src* directory contains R code for data analysis, such as fitting statistical models, computing summary statistics, or creating plots.
#' 
#' A benefit of the {ProjectTemplate} package is that it allows for a lot of customization. So if there is file/directory structure that you commonly use for your projects, then you can create a custom template that can be called every time you call `create.project()`. Custom templates can be created with the `create.template()` function. For example, you might always want to have a directory called plots for saving plots made as part of the data analysis.
#' 
#' For more information on this, see:
#' 
#' https://www.r-bloggers.com/2014/05/customising-projecttemplate-in-r/
#' http://projecttemplate.net/index.html
#' 
#' ### your turn
#' 
#' Q. Use the `create.project()` function to create a new project with a name of your choice. This time, create a full template, not a minimal one, and set the project as an rstudio project. Remember how to look for help!
#' 
#' 
#' 
#' 
#' 
#' 
#' 
#' 
#' 
#' 
#' 
#' 
#' 
#' 
#' 
#' 
#' 
#' 
#' 
#' 
#' 
#' 
#' 
#' 
#' 
#' 
#' 
#' 
#' A.
#' 
## ------------------------------------------------------------------

create.project(project.name = "big_fun",
               template = "full",
               rstudio.project = TRUE)


#' 
#' 
#' 
#' ## review: workspace management functions
#' 
#' This is largely material we have already covered but is relevant in this context so I include it here.
#' 
#' The work space (aka your working environment) represents all of the objects and functions you have either defined in the current session, or have loaded from a previous session. When you started RStudio for the first time, the working environment was empty because you hadn’t created any new objects or functions. However, as you defined new objects and functions using the assignment operator <-, these new objects were stored in your working environment.
#' 
#' display all objects in the current work space:
#' 
## ------------------------------------------------------------------

ls()


#' 
#' removes the objects DIST, SPEED from your work space
#' 
## ------------------------------------------------------------------

rm(DIST, SPEED)
ls()


#' 
#' removes all objects from your work space
#' 
## ------------------------------------------------------------------

rm(list = ls())
ls()


#' 
#' returns the names of all files in the working directory
#' 
## ------------------------------------------------------------------

list.files()


#' 
#' You could also list the files in a particular directory by naming that directory.
#' 
## ------------------------------------------------------------------

list.files("output")


#' 
#' ### your turn
#' 
#' Q. List all the files in the new project you just created.
#' 
#' 
#' 
#' 
#' 
#' 
#' 
#' 
#' 
#' 
#' 
#' 
#' 
#' 
#' 
#' 
#' 
#' 
#' 
#' 
#' 
#' 
#' 
#' 
#' 
#' 
#' 
#' 
#' 
#' 
#' 
#' 
#' 
#' 
#' A.
#' 
## ------------------------------------------------------------------

list.files("big_fun")


#' 
