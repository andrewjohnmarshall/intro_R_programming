#' 
#' 16. Next level data acquisition
#' 
#' # Packages
#' 
## ------------------------------------------------------------------

library(tidyverse)
library(rvest)


#' 
#' # Acknowledgments
#' 
#' The following two sites provide helpful introductory information, some of which I presented in the introductory slides or is incorporated below:
#' 
#' https://jhudatascience.org/tidyversecourse/get-data.html
#' https://r4ds.hadley.nz/webscraping
#' 
#' 
#' # HTML basics
#' 
#' To scrape webpages, we need to first understand a little bit about HTML, the language that describes a web page's structure. HTML stands for HyperText Markup Language and looks something like this:
#' 
#' <html>
#' <head>
#'   <title>Page title</title>
#' </head>
#' <body>
#'   <h1 id='first'>A heading</h1>
#'   <p>Some text &amp; <b>some bold text.</b></p>
#'   <img src='myimg.png' width='100' height='100'>
#' </body>
#' 
#' HTML has a hierarchical structure formed by elements which consist of a start tag (e.g., <tag>, <h1>), optional attributes (id='first'), an end tag (like </tag>, </h1>), and contents (everything in between the start and end tag).
#' 
#' Since < and > are used for start and end tags, you can’t write them directly. Instead you have to use the HTML "escapes" &gt; (greater than) and &lt; (less than). And since those escapes use &, if you want a literal ampersand you have to escape it as &amp. There are a wide range of possible HTML escapes but you don’t need to worry about them too much because the package we'll be using, {rvest}, automatically handles them for you.
#' 
#' Web scraping is possible because most pages have a consistent structure.
#' 
#' ## elements
#' 
#' Every HTML page must be in an <html> element, and it must have two children: <head>, which contains document metadata like the page title, and <body>, which contains the content you see in the browser.
#' 
#' Block tags like <h1> (heading 1), <section> (section), <p> (paragraph), and <ol> (ordered list) form the overall structure of the page.
#' 
#' Inline tags like <b> (bold), <i> (italics), and <a> (link) format text inside block tags.
#' 
#' If you encounter a tag that you’ve never seen before, you can find out what it does with a little googling. Another good place to start are the MDN Web Docs which describe just about every aspect of web programming:
#' 
#' https://developer.mozilla.org/en-US/docs/Web/HTML
#' 
#' Most elements can have content in between their start and end tags. This content can either be text or more elements. For example, the following HTML contains paragraph of text, with one word in bold.
#' 
#' <p>
#'   Hi! My <b>name</b> is Mud.
#' </p>
#' 
#' The children are the elements it contains, so the <p> element above has one child, the <b> element. The <b> element has no children, but it does have contents (the text “name”).
#' 
#' If you read about HTML, you'll hear a lot about parents and children and the like. We won't need these terms much today, but in brief: HTML pages have an inherently hierarchical structure.
#' 
#' An *ancestor* refers to any element that is connected but further up the document tree - no matter how many levels higher.
#' 
#' A *descendant* refers to any element that is connected but lower down the document tree - no matter how many levels lower.
#' 
#' A *parent* is an element that is directly above and connected to an element in the document tree. 
#' 
#' A *child* is an element that is directly below and connected to an element in the document tree
#' 
#' For more, here is a nice summary (from which the above descriptions were taken):
#' 
#' http://web.simmons.edu/~grabiner/comm244/weekfour/document-tree.html
#' 
#' ## attributes
#' 
#' Tags can have named attributes which look like name1='value1' and name2='value2'. Two of the most important attributes are *id* and *class*, which are used in conjunction with CSS (more on this soon) to control the visual appearance of the page. These are often useful when scraping data off a page. 
#' 
#' Attributes are also used to record the destination of links (the href attribute of <a> elements) and the source of images (the src attribute of the <img> element).
#' 
#' 
#' # Tools
#' 
#' ## {rvest} package
#' 
#' We'll focus on {rvest}, because it is widely-used, (relatively) user-friendly, and as a {tidyverse} package, plays well with other tools we have been using. It allows us to ha"rvest” information from websites. This is less straightforward than pulling in data that are already in an easy-to-use format (e.g., from .csv, .rda files).
#' 
#' Essentially, {rvest} reads in a website's HTML code directly from its URL, then uses specific elements in the HTML code to extract the parts of the webpage you need. For a succinct introduction, see: https://rvest.tidyverse.org.
#' 
#' The {tidyverse} team advocates using {rvest} with {polite}, which is a package dedicated to promoting responsible web etiquette (which means, in a nutshell, to seek permission, take things slow, and never be pushy (don't ask twice) - advice that is worth heading IRL, too). For more on {polite}, including its charming use of www.cheese.com, see the author Dmytro Perepolkin's github site: https://dmi3kno.github.io/polite/).
#' 
#' 
#' ## other tools
#' 
#' There are (as always) many other R packages that are quite helpful if you want to delve further into web scraping. Here are a couple of useful ones you might want to look into, if this interests you:
#' 
#' {Rcrawler}  https://github.com/salimk/Rcrawler/
#' {httr2}     https://httr2.r-lib.org
#' 
#' Most R scraping tools I know of use the package {xml2} under the hood, but the "wrapper" packages are often a great way to access {xml2}'s functionality and power with a more user-friendly interface.
#' 
#' 
#' # Extracting data
#' 
#' To get started scraping, we use the URL of the page we want to scrape to read the HTML for that page into R using `read_html()`. This creates an object that we can then engage using {rvest} functions. Here are some examples:
#' 
## ------------------------------------------------------------------

html <- read_html("http://rvest.tidyverse.org/")
html

html2 <- read_html("https://github.com/andrewjohnmarshall")
html2

html3 <- read_html("https://www.nfl.com")
html3


#' 
#' {rvest} also includes a function that we can use to write HTML code directly in R. We’ll use this today to showcase some capabilities of {rvest}, but I suspect that you are not likely to use it yourself in typical scenarios, beyond code testing. For example, this creates a simple set of HTML code and saves it as an object 'my-html' in the usual way:
#' 
## ------------------------------------------------------------------

my_html <- minimal_html("
  <p>This is a paragraph</p>
  <ul>
    <li>This is a bulleted list</li>
  </ul>
")
my_html


#' 
#' Once we have the HTML in R, our next steps are to identify the information (elements) we want to extract, then use {rvest} functions to extract them.
#' 
#' 
#' ## finding elements
#' 
#' CSS is short for "cascading style sheets", and is a tool for defining the appearance of HTML documents. CSS includes a miniature language for selecting elements on a page called CSS selectors. CSS selectors define patterns for locating HTML elements, and are useful for scraping because they provide a concise way of describing which elements you want to extract. Starting out, we can get a long way with three CSS selectors:
#' 
#' - "p" selects all <p> (paragraph) elements.
#' 
#' - ".x" selects all elements of class x (e.g., ".title" selects all elements with class “title”.)
#' 
#' - "#X" selects the element with the id attribute that equals “X” (e.g., "#title" selects the element with the id attribute that equals “title”). Note that because Id attributes must be unique within a document, so this will only ever select a single element.
#' 
#' To test this out, we'll create a simple example:
#' 
## ------------------------------------------------------------------

html <- minimal_html("
  <p class='title'>MY BIG TITLE</p>
  <ul>
  <h1>This is a heading</h1>
  <ul>
  <p id='first'>This is a paragraph</p>
  <p class='important'>This is an important paragraph</p>
")
html


#' 
#' and use `html_elements()` to find all elements that match the selector. Because {rvest} is part of the {tidyverse}, we can use piping. First, we select all <p> (paragraph) elements:
#' 
## ------------------------------------------------------------------

html %>% 
  html_elements("p")


#' 
#' or select all elements with class 'title':
#' 
## ------------------------------------------------------------------

html %>% 
  html_elements(".title")


#' 
#' or elements with class 'important':
#' 
## ------------------------------------------------------------------

html %>% 
  html_elements(".important")


#' 
#' or elements with id = 'first':
#' 
## ------------------------------------------------------------------

html %>% 
  html_elements("#first")


#' 
#' Another important function is `html_element()` which always returns the same number of outputs as inputs. If you apply it to a whole document it’ll give you the first match:
#' 
## ------------------------------------------------------------------

html %>% 
  html_element("p")

# compare with:
html %>% 
  html_elements("p")


#' 
#' There’s an important difference between `html_element()` and `html_elements()` when you use a selector that doesn’t match any elements. `html_elements()` returns a vector of length 0, where `html_element()` returns a missing value. This will be important shortly.
#' 
## ------------------------------------------------------------------

html %>% 
  html_elements("b")

html %>% 
  html_element("b")


#' 
#' 
#' ## nesting selections
#' 
#' In most cases, you’ll use `html_elements()` and `html_element()` together, typically using `html_elements()` to identify elements that will become observations (rows) then using `html_element()` to find elements that will become variables (columns).
#' 
#' Here is a simple example. We have an unordered list (<ul>) where each list item (<li>) contains some information about four characters from StarWars:
#' 
## ------------------------------------------------------------------

html <- minimal_html("
  <ul>
    <li><b>C-3PO</b> is a <i>droid</i> that weighs <span class='weight'>167 kg</span></li>
    <li><b>R4-P17</b> is a <i>droid</i></li>
    <li><b>R2-D2</b> is a <i>droid</i> that weighs <span class='weight'>96 kg</span></li>
    <li><b>Yoda</b> weighs <span class='weight'>66 kg</span></li>
  </ul>
  ")
html


#' 
#' We can use `html_elements()` to make a vector where each element corresponds to a different character:
#' 
## ------------------------------------------------------------------

characters <- html %>% 
                html_elements("li")
characters


#' 
#' To extract the name of each character, we use `html_element()`, because when applied to the output of `html_elements()` it’s guaranteed to return one response per element:
#' 
## ------------------------------------------------------------------

characters %>% 
  html_element("b")


#' 
#' The distinction between `html_element()` and `html_elements()` isn’t important for name, but it is important for weight. We want to get one weight for each character, even if there’s no weight <span>. That’s what `html_element()` does:
#' 
## ------------------------------------------------------------------

characters %>% 
  html_element(".weight")


#' 
#' `html_elements()` finds all weight <span>s that are children of characters. There’s only three of these, so we lose the connection between names and weights:
#' 
## ------------------------------------------------------------------

characters %>% 
  html_elements(".weight")


#' 
#' Now that you’ve selected the elements of interest, you’ll need to extract the data, either from the text contents or some attributes.
#' 
#' ## text & attributes
#' 
#' `html_text2()` extracts the plain text contents of an HTML element:
#' 
## ------------------------------------------------------------------

characters %>% 
  html_element("b") %>% 
  html_text2()

characters %>% 
  html_element(".weight") %>%  
  html_text2()


#' 
#' `html_attr()` extracts data from attributes:
#' 
## ------------------------------------------------------------------

html <- minimal_html("
  <p><a href='https://en.wikipedia.org/wiki/Cat'>cats</a></p>
  <p><a href='https://en.wikipedia.org/wiki/Dog'>dogs</a></p>
")

html %>%  
  html_elements("p") %>%  
  html_element("a") %>% 
  html_attr("href")


#' 
#' Note that `html_attr()` always returns a string, so if you’re extracting numbers or dates, you’ll need to do some post-processing. This is very common with scraped data, as we'll see.
#' 
#' ## tables
#' 
#' If you’re lucky, your data will be already stored in an HTML table, and it’ll be a matter of just reading it from that table. It’s usually straightforward to recognize a table in your browser: it’ll have a rectangular structure of rows and columns, and you can copy and paste it directly into a spreadsheet (e.g., Google sheets, Excel).
#' 
#' HTML tables are built up from four main elements: <table>, <tr> (table row), <th> (table heading), and <td> (table data). Here’s a simple HTML table with two columns and three rows:
#' 
## ------------------------------------------------------------------

html <- minimal_html("
  <table class='mytable'>
    <tr><th>x</th>   <th>y</th></tr>
    <tr><td>1.5</td> <td>2.7</td></tr>
    <tr><td>4.9</td> <td>1.3</td></tr>
    <tr><td>7.2</td> <td>8.1</td></tr>
  </table>
  ")

html


#' 
#' The function `html_table()` handles tabular data. It returns a list containing one tibble for each table found on the page. Use `html_element()` to identify the table you want to extract:
#' 
## ------------------------------------------------------------------

html %>%  
  html_element(".mytable") %>%  
  html_table()


#' 
#' Note that x and y have automatically been converted to numbers. This automatic conversion doesn’t always work, so in more complex scenarios you may want to turn it off with 'convert = FALSE' and then do your own conversion. Here is how we'd do that with this table:
#' 
## ------------------------------------------------------------------

html %>%  
  html_element(".mytable") %>%  
  html_table(convert = FALSE) %>% 
  mutate(x = as.double(x),
         y = as.double(y))


#' 
#' 
#' # Finding the *right*! selectors
#' 
#' Assuming a site will allow you to scrape data at all, figuring out the selector that will identify the specific information you want is typically the hardest part of the problem.
#' 
#' You’ll often need to do some experimenting to find a selector that is both *specific* (i.e., it doesn’t select things you don’t care about) and *sensitive* (i.e., it does select everything you care about). Lots of trial and error is a normal part of the process!
#' 
#' There are two main tools that are available to help you with this process: SelectorGadget and your browser’s developer tools.
#' 
#' SelectorGadget is a javascript bookmarklet that automatically generates CSS selectors based on the positive and negative examples that you provide. It doesn’t always work, but when it does, it’s magic! 
#' 
#' To learn more about SelectorGadget:
#' 
#' https://rvest.tidyverse.org/articles/selectorgadget.html
#' 
#' Every modern browser comes with some toolkit for developers, but developers often recommend Chrome as web developer tools are some of the best and they’re immediately available. Right click on an element on the page and click Inspect. This will open an expandable view of the complete HTML page, centered on the element that you just clicked. You can use this to explore the page and get a sense of what selectors might work. Pay particular attention to the class and id attributes, since these are often used to form the visual structure of the page, and hence make for good tools to extract the data that you’re looking for.
#' 
#' Inside the Elements view, you can also right click on an element and choose "Copy" -> "Copy selector" to generate a selector that will uniquely identify the element of interest.
#' 
#' If either SelectorGadget or Chrome DevTools have generated a CSS selector that you don’t understand, try Selectors Explained which translates CSS selectors into plain English:
#' 
#' https://kittygiraudel.github.io/selectors-explained/
#' 
#' If you find yourself doing this a lot, you might want to learn more about CSS selectors generally. Hadley Wickham recommends these resources:
#' 
#' https://flukeout.github.io
#' https://developer.mozilla.org/en-US/docs/Web/CSS/CSS_Selectors
#' 
#' ## simple example with SelectorGadget
#' 
#' To use SelectorGadget, navigate to the webpage we’re interested in scraping. Here, we'll navigate to one of the sites provided by the "scrapthissite" website:
#' 
#' https://www.scrapethissite.com/pages/simple/
#' 
#' and toggle SelectorGadget by clicking on the SelectorGadget icon. A menu at the bottom-right of your web page should appear.
#' 
#' Now that SelectorGadget has been toggled, as you mouse over the page, colored boxes should appear. We’ll click on the the name of a country to tell SelectorGadget which component of the webpage we’re interested in.
#' 
#' An box will appear around the component of the webpage you’ve clicked. Other components of the webpage that SelectorGadget has deemed similar to what you’ve clicked will be highlighted. And, text will show up in the menu at the bottom of the page letting you know what selector you should use in {rvest} to specify the part of the webpage you want to scrape. Here it is '.country-name'
#' 
#' Sometimes SelectorGadget's first guess about which selector we want won't be what we are looking for. In this case you can double click on elements you don't want; they will turn red. 
#' 
#' Iterate until only the elements you want are selected. 
#' 
#' SelectorGadget isn’t perfect and sometimes won’t be able to find a useful css selector. Sometimes starting from a different element helps.
#' 
#' ## using {rvest}
#' 
#' Now we’re ready to use rvest’s functions. First, we’ll use `read_html()` to pull in the information we want as an HTML object and save it as 'scrape' (we don't want to repeatedly scrape the same data). Then use `html_elements()` to specify which parts of the webpage we want to extract. We use '.country-name', based on our SelectorGadget search. Finally, we use `html_text2()` to extract the plain text contents of the selected HTML elements:
#' 
## ------------------------------------------------------------------

scrape <- read_html("https://www.scrapethissite.com/pages/simple/")

scrape %>% 
  html_elements(".country-name") %>% 
  html_text2()


#' 
#' Note, the deprecated `html_nodes()` also works and you might run into it if you search for help on a web scraping task.
#' 
## ------------------------------------------------------------------

scrape %>% 
  html_nodes(".country-name") %>% 
  html_text2()


#' 
#' ### your turn
#' 
#' 
#' Q. Modify the code below to scrape the names of *capitals*. You may wish to use Selector Gadget to identify the correct element.
#' 
## ------------------------------------------------------------------

scrape %>% 
  html_nodes(".country-name") %>% 
  html_text2()


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
#' 
#' 
#' 
#' A. The correct element is `.country-capital`, which we add in the `html_elements()` call.
#' 
## ------------------------------------------------------------------

scrape %>% 
  html_elements(".country-capital") %>% 
  html_text2()


#' 
#' 
#' # Post process wrangling 
#' 
#' Another challenge of dealing with scraped data is that often we need to do a fair amount of post-scrape processing. Here is a fairly simple example of this, taking advantage of {rvest} and other {tidyverse} tools.
#' 
#' We'll scrape all the country data using the selector ".country", which I discovered using SelectorGadget.
#' 
## ------------------------------------------------------------------

d2 <- scrape %>% 
  html_elements(".country") %>% 
  html_text2() %>% 
  as_tibble() %>% 
  separate_wider_delim(cols = 1,
                       delim = ":",
                       names = c("country", "capital",
                                 "population", "area"))
d2


#' 
#' Now we need to remove all the text from each cell after after "\n". Both of these are things that {tidyverse}'s {stringr} can help with. Here's one way to do this:
#' 
## ------------------------------------------------------------------

d3 <- d2 %>% 
  mutate(across(everything(),
                ~str_remove(.x, str_c("\n", ".*"))))
d3
         

#' 
#' We're getting there. But the columns aren't all of the right type. We can fix that as above:
#' 
## ------------------------------------------------------------------

d4 <- d3 %>% 
  mutate(
    population = as.double(population),
    area       = as.double(area)
  )
d4


#' 
#' We could have also used a different delimiter in the initial data set, which would leave us with a similar type of text-based cleaning to do, in this case to strip out a bunch of text at the start of each column.
#' 
## ------------------------------------------------------------------

d5 <- scrape %>% 
  html_elements(".country") %>% 
  html_text2() %>% 
  as_tibble() %>% 
  separate_wider_delim(cols = 1,
                       delim = "\n",
                       names = c("country", "capital",
                                 "population", "area", "X"))

d5


#' 
#' # Dynamic sites
#' 
#' From time-to-time, however, you’ll hit a site where `html_elements()` and other {rvest} tools don’t return anything like what you see in the browser. In many cases, that’s because you’re trying to scrape a website that dynamically generates the content of the page with javascript. This doesn’t currently work with {rvest}, because {rvest} downloads the raw HTML and doesn’t run any javascript. The {tidyverse} team is actively working on this, using the {chromote} package that runs the Chrome browser in the background and provides additional tools to interact with the site. If this is of interest to you, stay tuned and keep an eye on https://rvest.tidyverse.org.
#' 
