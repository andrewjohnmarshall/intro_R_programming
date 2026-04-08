#' 
#' Class 13. Building shiny apps II
#' 
#' # Packages
#' 
## ------------------------------------------------------------------

library(tidyverse)
library(shiny)
library(bslib)
library(maps)
library(mapproj)


#' 
#' 
#' # Framing
#' 
#' Recently we began the process of learning to build Shiny apps. We learned the basics of working with {shiny}, the general structure of apps, how to build a simple user interface, and how to add control widgets.
#' 
#' Today we will pick up where we left off, taking the next steps in learning to build Shiny apps: displaying reactive output and incorporating R scripts and data.
#' 
#' As with last time, this exercise draws heavily from Posit's Welcome to Shiny website (https://shiny.posit.co/r/getstarted/shiny-basics/lesson4/index.html). Like last time, I have updated it for clarity, to standardize syntax, and to fix errors and inconsistencies. I'll remind you of some useful resources: 
#' 
#' You can download a handy {shiny} cheat sheet here: https://shiny.posit.co/r/articles/start/cheatsheet/
#' 
#' There are many useful relevant articles here:
#' https://shiny.posit.co/r/articles/
#' 
#' And Hadley Wickham's book Mastering Shiny is available here:
#' https://mastering-shiny.org/
#' 
#' 
#' 
#' # Displaying reactive output
#' 
#' This section will teach you how to build reactive output into displays in your Shiny app. Reactive output automatically responds when your user toggles a widget.
#' 
#' By the end of this exercise, you’ll know how to make a simple Shiny app with two reactive lines of text. Each line will display the values of a widget based on your user’s input.
#' 
#' This new Shiny app will need its own new directory. Create a folder in your working directory named "census-app". This is where we’ll save the "app.R" file that you make in this exercise.
#' 
#' You can create reactive output with a two step process.
#' 
#' 1. Add an R object to your user interface ('ui').
#' 
#' 2. Tell Shiny how to build this object in the 'server' function. The object will be reactive (i.e., it will respond to user input) if the code that builds it calls a widget value.
#' 
#' ## add an R object to the UI
#' 
#' {shiny} provides a family of functions that turn R objects into output for your user interface. Each function creates a specific type of output, named in intuitive ways:
#' 
#' Output function	       Creates
#' `dataTableOutput()`   	DataTable
#' `htmlOutput()`        	raw HTML
#' `imageOutput()`       	image
#' `plotOutput()`          plot
#' `tableOutput()`	        table
#' `textOutput()`        	text
#' `uiOutput()`          	raw HTML
#' `verbatimTextOutput()` 	text
#' 
#' You can add output to the user interface in the same way that you added HTML elements and widgets to the "app.R" script inside your Shiny app directory in our first Shiny session.
#' 
#' For example, the 'ui' object below uses `textOutput()` to add a reactive line of text to the main panel of the Shiny app pictured in "censusviz-01.png", located in the working directory.
#' 
## ------------------------------------------------------------------

ui <- page_sidebar(
  title = "censusVis",
  sidebar = sidebar(
    helpText(
      "Create demographic maps with information from the 2010 US Census."
    ),
    selectInput(
      "var",
      label = "Choose a variable to display",
      choices = 
        c("Percent White",
          "Percent Black",
          "Percent Hispanic",
          "Percent Asian"),
      selected = "Percent White"
    ),
    sliderInput(
      "range",
      label = "Range of interest:",
      min = 0, 
      max = 100, 
      value = c(0, 100)
    )
  ),
  textOutput("selected_var")     # adds reactive line of text
                                 # ("You have chosen a range...")
)


#' 
#' Notice that `textOutput()` takes an argument, the character string "selected_var". Each of the `*Output()` functions require a single argument: a character string that Shiny will use as the name of your reactive element. Your users will not see this name, but you will use it later.
#' 
#' ## provide R code to build the object
#' 
#' Placing a function in 'ui' tells {shiny} where to display your object. Next, you need to tell {shiny} how to build the object.
#' 
#' We do this by providing the R code that builds the object in the 'server' function.
#' 
#' The 'server' function plays a special role in the Shiny process; it builds a list-like object named 'output' that contains all of the code needed to update the R objects in your app. Each R object needs to have its own entry in the list.
#' 
#' You can create an entry by defining a new element for 'output' within the 'server' function, as in the example below. The element name should match the name of the reactive element that you created in the 'ui'.
#' 
#' In the 'server' function below, 'output$selected_var' matches `textOutput("selected_var")` in your 'ui'.
#' 
## ------------------------------------------------------------------

server <- function(input, output) {

  output$selected_var <- renderText({   # matches the 'selected_var' in ui
    "You have selected this"
  })

}


#' 
#' Note: Unlike the functions we built earlier in the semester, you do not need to explicitly state in the 'server' function that R should return 'output' in its last line of code. R will automatically update 'output'. This is one of the nice features of {shiny}'s reactive programming.
#' 
#' Each entry to 'output' should contain the output of one of Shiny’s `render*()` functions. These functions capture an R expression and do some light pre-processing on the expression. Use the `render*()` function that corresponds to the type of reactive object you are making.
#' 
#' render function	     creates
#' `renderDataTable()`	 DataTable
#' `renderImage()`	     images (saved as a link to a source file)
#' `renderPlot()`	     plots
#' `renderPrint()`    	 any printed output
#' `renderTable()`	     data frame, matrix, other table like structures
#' `renderText()`	     character strings
#' `renderUI()`    	   a Shiny tag object or HTML
#' 
#' Each `render*()` function takes a single argument: an R expression surrounded by curly braces, '{}'. The expression can be one simple line of text, or it can involve many lines of code- for example, if it were a more complicated function.
#' 
#' Think of this R expression as a set of instructions that you give Shiny to store for later. Shiny will run the instructions when you first launch your app, and then Shiny will re-run the instructions every time it needs to update your object.
#' 
#' For this to work, your expression should return the object you have in mind (a piece of text, a plot, a data frame, etc.). You will get an error if the expression does not return an object, or if it returns the wrong type of object.
#' 
#' ## use widget values
#' 
#' If you run the app with the 'server' function above, it will display “You have selected this” in the main panel. However, the text will not be reactive. It will not change even if you manipulate the widgets of your app.
#' 
#' You can make the text reactive by asking Shiny to call a widget value when it builds the text. Let’s look at how to do this.
#' 
#' Take a look at the first line of code in the 'server' function:
#' 
## ------------------------------------------------------------------

server <- function(input, output) {

  output$selected_var <- renderText({
    paste("You have selected", input$var)
  })

}


#' 
#' 
#' Notice that the 'server' function mentions two arguments, 'input' and 'output'. You already saw that 'output' is a list-like object that stores instructions for building the R objects in your app.
#' 
#' 'input' is a second list-like object. It stores the current values of all of the widgets in your app (things your app's user can change). These values will be saved under the names that you gave the widgets in your 'ui.'
#' 
#' So for example, our app has two widgets, one named "var" and one named "range". The values of "var" and "range" will be saved in 'input' as 'input$var' and 'input$range'. Since the slider widget has two values (a min and a max), 'input$range' will contain a vector of length two.
#' 
#' Shiny will automatically make an object reactive if the object uses an input value. For example, the server function below creates a reactive line of text by calling the value of the select box widget to build the text.
#' 
## ------------------------------------------------------------------

server <- function(input, output) {

  output$selected_var <- renderText({
    paste("You have selected", input$var)
  })

}


#' 
#' Shiny tracks which outputs depend on which widgets. When a user changes a widget, Shiny will rebuild all of the outputs that depend on the widget, using the new value of the widget as it goes. As a result, the rebuilt objects will be completely up-to-date- in other words, they will reflect dynamically different inputs from the user of your app.
#' 
#' This is how you create reactivity with Shiny, by connecting the values of 'input' to the objects in 'output'. Shiny takes care of all of the other details.
#' 
#' ## launch your app and see the reactive output
#' 
#' The description above may be hard to grasp in the abstract. Now, we'll explore this more concretely.
#' 
#' Open a new R script, saving it as "app.R" inside the "census-app" directory you created above. Paste the following text in to the script file:
#' 
## ------------------------------------------------------------------

library(shiny)
library(bslib)

# Define UI ----
ui <- page_sidebar(
  title = "censusVis",
  sidebar = sidebar(
    helpText(
      "Create demographic maps with information from the 2010 US Census."
    ),
    selectInput(
      "var",
      label = "Choose a variable to display",
      choices = 
        c("Percent White",
          "Percent Black",
          "Percent Hispanic",
          "Percent Asian"),
      selected = "Percent White"
    ),
    sliderInput(
      "range",
      label = "Range of interest:",
      min = 0, 
      max = 100, 
      value = c(0, 100)
    )
  ),
  textOutput("selected_var")
)

# Define server logic ----
server <- function(input, output) {
  
  output$selected_var <- renderText({
    paste("You have selected", input$var)
  })
  
}

# Run the app ----
shinyApp(ui = ui, server = server)


#' 
#' Then launch your Shiny app:
#' 
## ------------------------------------------------------------------

runApp("census-app", display.mode = "showcase")


#' 
#' Your app should look like the output shown in "censusviz-showcase.png", and the statement "You have selected Percent ..." should update instantly as you change the select box widget (e.g., Percent Hispanic, Percent Black).
#' 
#' When Shiny rebuilds an output, it highlights the code it is running. This temporary highlighting can help you see how Shiny generates reactive output. For example, when you select different choices in the drop down menu, watch the server portion of the script. Note: this might not be visible to you if the code is down below the app. If this happens, click the "show with app" button in the top right of the lower panel. This will place the R code next to, rather than below, the app.
#' 
#' ## your turn
#' 
#' Add a second line of reactive text to the main panel of your Shiny app. This line should display “You have chosen a range that goes from *something* to *something*”, and each *something* should show the current minimum (min) or maximum (max) value of the slider widget. An example of how this should look is showing in "censusviz-02.png".
#' 
#' Don’t forget to update both your 'ui' object and your 'server' function. Take some time and try this on your own. Use the {shiny} cheatsheet. If you are stuck, scroll down for a hint.
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
#' 
#' Hint: Add the second line of text in the same way that you added the first one. Use `textOutput()` in 'ui' to place the second line of text in the main panel. Use `renderText()` in 'server' to tell Shiny how to build the text. You’ll need to use the same name to refer to the text in both scripts (e.g., "min_max").
#' 
#' Your text should use both the slider’s min value (saved as input$range[1]) and its max value (saved as input$range[2]).
#' 
#' Remember that your text will be reactive as long as you connect 'input' values to 'output' objects. Shiny creates reactivity automatically when it recognizes these connections.
#' 
#' 
#' 
#' Still having issues? A sample solution is provided in "Model_answer_1.R in this class's project working directory.
#' 
#' ## recap
#' 
#' In this section, you created your first reactive Shiny app. This entailed a few new tricks:
#' 
#' - using an `*Output()` function in the 'ui' to place reactive objects in your Shiny app,
#' - using a `render*()` function in the server to tell Shiny how to build your objects,
#' - surrounding R expressions by curly braces, {}, in each `render*()` function,
#' - saving your `render*()` expressions in the 'output' list, with one entry for each reactive object in your app, and
#' - creating reactivity by including an input value in a `render*()` expression.
#' 
#' If you follow these rules, {shiny} will automatically make your objects reactive.
#' 
#' Our second exercise will make a more sophisticated reactive app that incorporates R scripts and external data.
#' 
#' 
#' # Use R scripts and data
#' 
#' This section will show you how to load data, R Scripts, and packages to use in your Shiny apps. Along the way, you will build a sophisticated app that visualizes US Census data. A sneak peek of the app can be seen in "censusvis-four-views.png".
#' 
#' "counties.rds" is a data set of demographic data for each county in the United States, collected with the {UScensus2010} R package. The file is available in the working directory. In order to use these data in your app, create a new folder named "data" in your "census-app" directory and move or copy "counties.rds" into the "data" folder.
#' 
#' The data set in "counties.rds" contains
#' 
#' - the name of each county in the United States
#' - the total population of the county
#' - the percent of residents in the county who are White, Black, Hispanic, or Asian
#' 
#' This code loads and examines the data in the usual (non-shiny) way:
#' 
## ------------------------------------------------------------------

counties <- readRDS("census-app/data/counties.rds")
head(counties)
glimpse(counties)


#' 
#' You may recognize the names of the first counties in Alabama (e.g., Autauga) from our mapping exercises last time.
#' 
#' 
#' "helpers.R" is an R script that can help you make choropleth maps, like the ones pictured in "censusvis-four-views.png". Recall that a choropleth map is a map that uses color to display spatial variation in a variable. In our case, "helpers.R" will create `percent_map()`, a function designed to map the data in "counties.rds". Move or copy "helpers.R" to the "census-app" directory.
#' 
#' We can pull in the code included in 'helpers.R' using the `source()` command, which acts much like the `library()` command we use to load packages into our R session. We'll talk more about this useful function in a few classes' time.
#' 
#' The `percent_map()` function in 'helpers.R' takes five arguments:
#' 
#' Argument    	Input
#' var	          a column vector from the "counties.rds" data set
#' color	        any character string you see in the output of `colors()`
#' legend.title	a character string to use as the title
#'                   of the plot’s legend
#' max	          a parameter for controlling shade range
#'                   (defaults to 100)
#' min	          a parameter for controlling shade range
#'                    (defaults to 0)
#' 
#' You can use `percent_map()` in the console to plot the counties data as a choropleth map, like this.
#' 
## ------------------------------------------------------------------

source("census-app/helpers.R")
counties <- readRDS("census-app/data/counties.rds")
percent_map(counties$white, "darkgreen", "% White")


#' 
#' `percent_map()` plots the counties data as a choropleth map, with the percent of white residents in the counties indicated using the darkgreen color.
#' 
#' Take a look at the above code. To use `percent_map()`, we first pulled in the code in "helpers.R" with the `source()` function, and then loaded "counties.rds" with the `readRDS()` function.
#' 
#' You will need to ask Shiny to call the same functions before it uses `percent_map()` in your app, but how you write these functions will change. Both `source()` and `readRDS()` require a file path, and file paths do not behave the same way in a Shiny app as they do in other contexts we have seen thus far.
#' 
#' When Shiny runs the commands in 'server' inside your "app.R" file, it will treat all file paths as if they begin in the same directory as "app.R". In other words, the directory that you save "app.R" in will become the working directory of your Shiny app.
#' 
#' Since you saved "helpers.R" in the same directory as "app.R" ("census-app"), you can ask Shiny to load it with:
#' 
## ------------------------------------------------------------------

source("helpers.R")


#' 
#' Since you saved "counties.rds" in a sub-directory (named "data") of the directory that "app.R" is in, you can load it with:
#' 
## ------------------------------------------------------------------

counties <- readRDS("data/counties.rds")


#' 
#' Note, this will work within the 'app.R' script that your shiny app will run, but if you ran it within today's class's .Rmd file (this file), you will get an error. This is because the class code for today has a different working directory than your 'app.R' script. This code should work in this class's*.Rmd file:
#' 
## ------------------------------------------------------------------

counties <- readRDS("census-app/data/counties.rds")


#' 
#' Inside your app script (inside 'app.R') you can load the {maps} and {mapproj} packages in the normal way with:
#' 
## ------------------------------------------------------------------

library(maps)
library(mapproj)


#' 
#' which does not require a file path.
#' 
#' ## execution
#' 
#' {shiny} will execute all of these commands if you place them in your "app.R" script. However, where you place them will determine how many times they are run (or re-run), which will in turn affect the performance of your app, since {shiny} will run some sections your "app.R" script more often than others.
#' 
#' {shiny} will run the whole script the first time you call `runApp()`. This causes {shiny} to execute the 'server' function. Thus, when an app is launched, the code pictured in "run-once.png" is run.
#' 
#' {shiny} saves the 'server' function until a new user visits your app. Each time a new user visits your app, Shiny runs the 'server' function again, one time. The function helps Shiny build a distinct set of reactive objects for each user. See "run-once-per-user.png".
#' 
#' As users interact with the widgets and change their values, Shiny will re-run the R expressions assigned to each reactive object that depend on a widget whose value was changed. See "run-many-times.png". If your user is very active, these expressions may be re-run many, many times a second.
#' 
#' To recap:
#' 
#' The `shinyApp()` function is run once, when you launch your app
#' The 'server' function is run once each time a user visits your app
#' The R expressions inside `render*()` functions are run many times. Shiny runs them once each time a user changes the value of a widget.
#' 
#' How can you use this information?
#' 
#' It is best to pull in scripts (using `source()`), load libraries (using `library()`), and read data sets (using `readRDS()`) at the beginning of "app.R" before (and outside) the 'server' function. Shiny will only run this code once, which is all you need to set your server up to run the R expressions contained in 'server'.
#' 
#' Then, you can define user specific objects inside 'server' function, but outside of any `render*()` calls. These would be objects that you think each user will need for their own personal copy of your app (e.g., an object that records the user’s session information). This code will be run once per user.
#' 
#' Only place code that Shiny must rerun to build an object inside of a `render*()` function. Shiny will rerun all of the code in a `render*()` chunk each time a user changes a widget mentioned in the chunk. This can be quite often, depending on the user, the use case, and your application.
#' 
#' You should generally avoid placing code inside a `render*()`  function that does not need to be there. Doing so will slow down the entire app.
#' 
#' ## your turn
#' 
#' Open your "app.R" script and replace the code with the following:
#' 
## ------------------------------------------------------------------

# User interface ----
ui <- page_sidebar(
  title = "censusVis",

  sidebar = sidebar(
    helpText(
      "Create demographic maps with information from the 2010 US Census."
    ),
    selectInput(
      "var",
      label = "Choose a variable to display",
      choices =
        c(
          "Percent White",
          "Percent Black",
          "Percent Hispanic",
          "Percent Asian"
        ),
      selected = "Percent White"
    ),
    sliderInput(
      "range",
      label = "Range of interest:",
      min = 0, 
      max = 100, 
      value = c(0, 100)
    )
  ),

  card(plotOutput("map"))
)

# Server logic ----
server <- function(input, output) {
  output$map <- renderPlot({
    percent_map( # some arguments )
  })
}

# Run app ----
shinyApp(ui, server)


#' 
#' The add the following code to an efficient location inside your script in "app.R":
#' 
## ------------------------------------------------------------------

source("helpers.R")
counties <- readRDS("data/counties.rds")
library(maps)
library(mapproj)


#' 
#' Think about where best to place these code, given the information provided in the previous section.
#' 
#' Note: This is the first of two steps that will complete your app. Choose the best place to insert the code above, but do not try to run the app. Your app will return an error until you replace "# some arguments" with real code below, in "your turn" around line 533 . (Note that because this is not running code, you'll also likely see red "error" x's next to the line numbers. This is to be expected, and is in part due to the "#" inside `percent_map()` which comments out a parenthesis.)
#' 
#' If you are stuck, you can look at the solution in "Model_answer_2.R" 
#' 
#' Since your app only needs to load "helpers.R" and "counties.rds" once, they should go outside of the 'ui' and 'server' functions. This is also a good place to load the {maps} library (which `percent_map()` uses).
#' 
#' You may wonder, “Won’t each user need their own copy of counties and percent_map?” (which would imply that the code should go inside of the server function). No, each user will not.
#' 
#' Keep in mind that your user’s computer won’t run any of the R code in your Shiny app. In fact, their computer won’t even see the R code. The computer that you use as a server will run all of the R code necessary for all of your users. It will send the results over to your users as HTML elements.
#' 
#' Your server can rely on a single global copy of "counties.rds" and `percent_map()` to do all of the R execution necessary for all of the users. You only need to build a separate object for each user if the objects will have different values for each of your users.
#' 
#' ## finishing the app
#' 
#' The census visualization app has one reactive object, a plot named "map". The plot is built with the `percent_map()` function, which takes five arguments.
#' 
#' - The first three arguments, var, color, and legend.title, depend on the value of the select box widget.
#' -The last two arguments, max and min, should be the max and min values of the slider bar widget.
#' 
#' The 'server' function below shows one way to craft reactive arguments for `percent_map()`. R’s `switch()` function can transform the output of a select box widget to whatever you like. However, the script is incomplete. It does not provide values for color, legend.title, max, or min. Note: the script will not run as is. You will need to finish the script before you run it, which is you last task for today.
#' 
## ------------------------------------------------------------------

server <- function(input, output) {
  output$map <- renderPlot({
    data <- switch(input$var,
                   "Percent White" = counties$white,
                   "Percent Black" = counties$black,
                   "Percent Hispanic" = counties$hispanic,
                   "Percent Asian" = counties$asian)

    percent_map(var = data, color = ?, legend.title = ?, max = ?, min = ?)
  })
}


#' 
#' ## your turn
#' 
#' Complete the code to build a working census visualization app.
#' 
#' When you’re ready to deploy your app, save your "app.R" file and run `runApp("census-app")`. If everything works, your app should look like the one in "censusviz-final.png"
#' 
#' You’ll need to decide
#' 
#' - how to create the argument values for percent_map, and
#' - where to put the code that creates these arguments.
#' 
#' Remember, you’ll want the argument values to switch whenever a user changes the associated widget. When you are finished, or if you get stuck, see "Model_answer_3.R".
#' 
## ------------------------------------------------------------------

runApp("census-app")


#' 
#' ## recap
#' 
#' You can create more complicated Shiny apps by loading R Scripts, packages, and data sets.
#' 
#' Keep in mind:
#' 
#' The directory that "app.R" appears in will become the working directory of the Shiny app
#' 
#' {shiny} will run code placed at the start of "app.R", before the 'server' function only once (when you first run the app).
#' 
#' {shiny} will run code placed inside 'server' function multiple times, which can slow down the app.
#' 
#' You also learned that `switch()` is a useful companion to multiple choice Shiny widgets. Use `switch()` to change the values of a widget into R expressions.
#' 
#' 
#' 
#' 
