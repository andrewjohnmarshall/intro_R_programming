#' 
#' 09. Visualizing information I
#' 
#' # load packages
#' 
#' Here we load the basic suite of {tidyverse} packages, along with some other useful packages.
#' 
## ------------------------------------------------------------------

library(tidyverse)
library(palmerpenguins)
library(gapminder)
library(ggpubr)
library(ggthemes)
library(patchwork)
library(viridis)
library(viridisLite)


#' 
#' # useful resources
#' 
#' R Graph Gallery: https://r-graph-gallery.com
#' Fundamentals of Data Visualization by Claus Wilke: https://clauswilke.com/dataviz/
#' Data Visualization: A Practical Introduction by Kieran Healy: https://socviz.co
#' ggplot2: Elegant Graphics for Data Analysis by Hadley Wickham, Danielle Navarro, and Thomas Lin Pedersen: https://ggplot2-book.org
#' R Graphics Cookbook by Winston Chang: https://r-graphics.org
#' 
#' # introduction
#' 
#' If you’ve only used Excel or Google sheets to make graphs, you’re probably used to starting a visualization by selecting the type of graph you want to make from a set menu (e.g., bar chart, scatter plot). This encourages us to think of different graph types as separate and unconnected. 
#' 
#' An alternative approach is to recognize the things that graphs have in common and use these commonalities as the starting point for making them. The late statistician Leland Wilkinson pioneered this approach, and in 1999 he published a book called *The Grammar of Graphics* that sought to develop a consistent way of describing all graphs. In it, Wilkinson argued that we should think of plots not as distinct type, but as following a grammar that we can use to describe any plot. 
#' 
#' Thinking about data visualization through the lens of the grammar of graphics allow us to see, for example, that graphs typically have some data that is plotted on the x axis and other data that is plotted on the y axis. This is the case no matter whether the graph is a bar chart or a line chart, for example. Consider these two figures that use identical data on life expectancy in Afghanistan. You can ignore the code for now.
#' 
## ------------------------------------------------------------------

gapminder_12_rows <- gapminder %>%
  filter(country== "Afghanistan")

bar_chart <- ggplot(
  data = gapminder_12_rows,
  mapping = aes(x = year, y = lifeExp)) +
  geom_col() +
  scale_y_continuous(limits = c(0, 45)) +
  scale_x_continuous(limits = c(1950, 2010))

line_chart <- ggplot(
  data = gapminder_12_rows,
  mapping = aes(x = year, y = lifeExp)) +
  geom_line() +
  scale_y_continuous(limits = c(0, 45)) +
  scale_x_continuous(limits = c(1950, 2010))

bar_chart + line_chart +
  plot_annotation(
    title = "Life Expectancy in Afghanistan, 1952-2007",
    caption = "Data from the Gapminder Foundation") &
  theme_minimal() +
    theme(
      axis.title = element_blank(),
      axis.text  = element_text(),
      plot.title = element_text(
        face = "bold",
        hjust = 0.5,
        size = 14),
      plot.caption = element_text(
        color = "grey40",
        size = 10))


#' 
#' While they look different, Wilkinson’s grammar of graphics allows us to see their similarities. When Wilkinson wrote his book, no data visualization tool could implement his grammar of graphics. This would change in 2010, when Hadley Wickham announced the {ggplot2} package for R in an article titled “A Layered Grammar of Graphics.” 
#' 
#' # palmer penguins
#' 
#' For this exercise we will work with a published data set that provides measurements taken on three species of penguins at the Palmer Station, a research site in Antarctica. The data were collected by Dr. Kristen Gorman and are made available in the {palmerpenguins} package, developed by Allison Horst, Alison Hill, and Kristen Gorman.
#' 
## ------------------------------------------------------------------

glimpse(penguins)


#' 
#' To simplify things for now, we'll remove the NAs from the dataset and save the it using the same name. We use `drop_na()`, a {tidyr} function that chooses only observation with no NAs.
#' 
## ------------------------------------------------------------------

penguins <- penguins %>%
   drop_na()
glimpse(penguins)


#' 
#' 
#' # ggplot basics
#' 
#' {ggplot2} relies on the idea of plots having multiple layers. Today we’ll walk through some of the most important ones. We’ll begin by selecting variables to map to aesthetic properties. Then we’ll choose a geometric object to use to represent our data. Next, we’ll change the aesthetic properties of our chart (its color scheme, for example) using a scale_ function. Finally, we’ll use a theme_ function to set the overall look-and-feel of our plot.
#' 
#' # layer 1: mapping data to aesthetic properties
#' 
#' When creating a graph with ggplot, we begin by mapping data to aesthetic properties. All this really means is that we use things like the x or y axis, color, and size (the "aesthetic" properties) to represent variables. Here we selection two linear measures from the penguins data set.
#' 
## ------------------------------------------------------------------

ggplot(penguins, aes(x = body_mass_g, y = flipper_length_mm))


#' 
#' Although this doesn't look like much, we can see that `ggplot()` has set up the plot window for us. The variables that we expect to be on the x and y axes are in the correct place.  We can also check the range of values for each variable:
#' 
## ------------------------------------------------------------------

penguins %>% 
  summarize(min_mass = min(body_mass_g),
            max_mass = max(body_mass_g),
            min_flip = min(flipper_length_mm),
            max_flip = max(flipper_length_mm))


#' 
#' which confirms that ggplot has selected reasonable ranges for the x and y axes.
#' 
#' # layer 2: selecting geoms
#' 
#' To add a visual representation of the data, we need to add the next ggplot layer: geoms (geometric objects), which are functions that provide different ways of representing data.
#' 
#' ## scatterplot
#' 
#' `geom_point()` adds a scatterplot
#' 
## ------------------------------------------------------------------

ggplot(penguins, aes(x = body_mass_g, y = flipper_length_mm)) +
  geom_point()


#' 
#' 
#' ## smooths
#' 
#' We often want to add a descriptive line to our scatterplots. We do this using `geom_smooth()`. Here we combine it with the scatter plot, so we can still see the points.
#' 
## ------------------------------------------------------------------

ggplot(penguins, aes(x = body_mass_g, y = flipper_length_mm)) +
    geom_point() +
    geom_smooth() 


#' 
#' The default is to add a 'loess' line, which is a kind of moving average that shows a smooth trend in our data. It has also added a strip showing the standard error, a measure of our certainty in the relationship depicted by the loess line. We could suppress the standard errors:
#' 
## ------------------------------------------------------------------

ggplot(penguins, aes(x = body_mass_g, y = flipper_length_mm)) +
    geom_point() +
    geom_smooth(se = FALSE) 


#' 
#' It is usually good to include them, however. The other common sort of smooth is a line that reflects the predictions of a mathematical model of our data. Here we add a simple regression line, which is based on a "liner model", or "lm", for which we have to provide an equation.
#' 
## ------------------------------------------------------------------

ggplot(penguins, aes(x = body_mass_g, y = flipper_length_mm)) +
    geom_point() +
    geom_smooth(method = "lm", formula = y ~ x) 


#' 
#' 
#' ### your turn
#' 
#' Q. Plot a scatterplot of bill_length_mm (y axis) vs. bill_depth_mm (x-axis). Add a regression line.
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
#' A. 
## ------------------------------------------------------------------

ggplot(penguins, aes(x = bill_depth_mm, y = bill_length_mm)) +
    geom_point() +
    geom_smooth(method = "lm", formula = y ~ x) 


#' 
#' 
#' ## histogram
#' 
#' Another very common data visualization is the histogram, `geom_histogram()`, which shows the distribution of a single variable:
#' 
## ------------------------------------------------------------------

ggplot(penguins, aes(x = body_mass_g)) +
    geom_histogram() 


#' 
#' We could divide this by some categorical variable, so different subsets of our data are filled with different colors:
#' 
## ------------------------------------------------------------------

ggplot(penguins, aes(x = body_mass_g, fill = sex)) +
    geom_histogram() 


#' 
#' Notice ggplot has automatically added an informative legend.
#' 
#' There are two problems here. First, the default setting is to stack the histograms. In some instances this is helpful, but when we are looking to compare groups, this is confusing. We'd rather have the histograms overlap. We can change this by setting 'position = "identity"'
#' 
## ------------------------------------------------------------------

ggplot(penguins, aes(x = body_mass_g, fill = sex)) +
    geom_histogram(position = "identity") 


#' 
#' This seems more what we want, but the colors are opaque so it is hard to compare the two distributions. This works better when the colors are semi-transparent. We can do this by setting the 'alpha':
#' 
## ------------------------------------------------------------------

ggplot(penguins, aes(x = body_mass_g, fill = sex)) +
    geom_histogram(position = "identity", alpha = 0.5) 


#' 
#' 
#' ### your turn
#' 
#' Q. Plots a histogram of body_mass_g that depicts the different species in different colors. As above, set the histograms so they overlap, and make the colors semitransparent.
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

ggplot(penguins, aes(x = body_mass_g, fill = species))+
    geom_histogram(position = "identity", alpha = 0.6) 


#' 
#' 
#' ## denisty plots
#' 
#' density plots are essentially smoothed histograms, and can make for appealing descriptive figures:
#' 
## ------------------------------------------------------------------

ggplot(penguins, aes(x = body_mass_g, fill = species)) +
  geom_density(alpha = 0.25) 


#' 
#' 
#' ## boxplot
#' 
#' box plots are also useful for showing distributions of variables
#' 
## ------------------------------------------------------------------

ggplot(penguins, aes(x = body_mass_g)) +
    geom_boxplot() 


#' 
## ------------------------------------------------------------------

ggplot(penguins, aes(y = body_mass_g, x = species)) +
    geom_boxplot() 


#' 
#' Sometimes folks like to add the data on top of the box plots:
#' 
## ------------------------------------------------------------------

ggplot(penguins, aes(x = body_mass_g, y = species)) +
    geom_boxplot() +
    geom_point()


#' 
#' ## jittering
#' 
#' in this instance, all the points are lined up, with lots of overlap. We can add a small bit of random noise to the points to pull them apart to ease viewing them. to do this, we use `geom_jitter()`
#' 
## ------------------------------------------------------------------

ggplot(penguins, aes(x = body_mass_g, y = species)) +
    geom_boxplot() +
    geom_jitter()


#' 
#' To me, that looks like too much jitter. We can change the amount of vertical jitter by setting the height, and the amount of horizontal jitter by setting the width. For example:
#' 
## ------------------------------------------------------------------

ggplot(penguins, aes(x = body_mass_g, y = species)) +
    geom_boxplot() +
    geom_jitter(height = 0.1)


#' 
#' That looks better. We could improve on that by making the points semi-transparent and changing their color:
#' 
## ------------------------------------------------------------------

ggplot(penguins, aes(x = body_mass_g, y = species)) +
    geom_boxplot() +
    geom_jitter(height = 0.1, alpha = 0.25, 
                col = "darkblue")


#' 
#' 
#' ## violin plots
#' 
#' violin plots are also commonly used to show distributions of variables
#' 
## ------------------------------------------------------------------

ggplot(penguins, aes(x = body_mass_g, y = species)) +
    geom_violin() 


#' 
#' and are often combined with box plot:
#' 
## ------------------------------------------------------------------

ggplot(penguins, aes(x = body_mass_g, y = species)) +
    geom_violin() +
    geom_boxplot()


#' 
#' yuck. Let's change the width of the box plot:
#' 
## ------------------------------------------------------------------

ggplot(penguins, aes(x = body_mass_g, y = species)) +
    geom_violin() +
    geom_boxplot(width = 0.1)


#' 
#' We could also add the jittered points:
#' 
## ------------------------------------------------------------------

ggplot(penguins, aes(x = body_mass_g, y = species)) +
    geom_violin() +
    geom_boxplot(width = 0.1) + 
    geom_jitter(height = 0.075)


#' 
#' And perhaps add some color:
#' 
## ------------------------------------------------------------------
ggplot(penguins, aes(x = body_mass_g, y = species)) +
    geom_violin(col = "darkorange") +
    geom_boxplot(width = 0.1, col = "navy", fill = "gray80") + 
    geom_jitter(height = 0.075, alpha = 0.25, col = "darkblue")



#' 
#' By now, you likely see a general pattern emerging. The same basic code can be used to produce a wide variety of plots by adding different geoms. There are many more geom types to explore.
#' 
#' # layer 3: altering aethetic properties
#' 
#' Often we would like to convey additional information on a plot (e.g., by plotting different subsets of data in different shapes or colors)
#' 
#' ## shape
#' 
#' Here we differentiate the different penguin species by the shape of the plotting character. We add 'shape = species' inside the aes call:
#' 
## ------------------------------------------------------------------

ggplot(penguins, aes(x = body_mass_g, 
                     y = flipper_length_mm, 
                     shape = species)) +
    geom_point() 


#' 
#' That worked, but it isn't that helpful. 
#' 
#' ## colors
#' 
#' Color is often a more effective way to differentiate. Let's try mapping the color aesthetic to the species:
#' 
#' 
## ------------------------------------------------------------------

ggplot(penguins, aes(x = body_mass_g, 
                     y = flipper_length_mm, 
                     col = species)) +
    geom_point() 


#' 
#' That is perhaps easier to differentiate, but the default color scheme includes red and green, which some folks find difficult to differentiate. The viridis color scheme is specifically designed to be "color blind" friendly. 
#' 
## ------------------------------------------------------------------

ggplot(penguins, aes(x = body_mass_g, 
                     y = flipper_length_mm, 
                     col = species)) +
    geom_point() +
    scale_color_viridis(discrete = TRUE)


#' 
#' We could also choose our own colors
#' 
## ------------------------------------------------------------------

ggplot(penguins, aes(x = body_mass_g, 
                     y = flipper_length_mm, 
                     col = species)) +
    geom_point() +
    scale_color_manual(values = c("darkorange","cornflowerblue","cyan4"))


#' 
## ------------------------------------------------------------------

colors()


#' 
#' 
#' We could combine color and shape to convey additional information:
#' 
## ------------------------------------------------------------------

ggplot(penguins, aes(x = body_mass_g, 
                     y = flipper_length_mm, 
                     col = species,
                     shape = sex)) +
    geom_point() +
    scale_color_manual(values = c("darkorange","cornflowerblue","cyan4"))


#' 
#' ### your turn
#' 
#' Q. Modify the code below to plot body mass (x axis) vs. bill_length_mm (y axis), with penguin species distinguished by color and island distinguished by shape. Choose three colors of your own liking. For a list of the named colors in R, type `colors()` in the console. To download a pdf showing www.stat.auckland.ac.nz/~ihaka/downloads/R-colours-a4.pdf
#' 
#' 
## ------------------------------------------------------------------

ggplot(penguins, aes(x = body_mass_g, 
                     y = flipper_length_mm, 
                     col = species,
                     shape = sex)) +
    geom_point() +
    scale_color_manual(values = c("darkorange","cornflowerblue","cyan4"))


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
#' 
#' 
#' 
#' 
#' 
#' 
#' 
#' 
#' A. 
## ------------------------------------------------------------------

ggplot(penguins, aes(x = body_mass_g, 
                     y = bill_length_mm, 
                     col = species,
                     shape = island)) +
    geom_point() +
    scale_color_manual(values = c("chocolate","seagreen","navy"))


#' 
#' 
#' ## transparency
#' 
#' As we saw above, making points semi-transparent can be quite helpful. We do this by setting the 'alpha' in `geom_point()`
#' 
## ------------------------------------------------------------------

ggplot(penguins, aes(x = body_mass_g, 
                     y = flipper_length_mm, 
                     col = species,
                     shape = sex)) +
    geom_point(alpha = 0.5) +
    scale_color_manual(values = c("darkorange","cornflowerblue","cyan4"))


#' 
#' Maybe making them less transparent would help? We can increase the alpha value:
#' 
## ------------------------------------------------------------------

ggplot(penguins, aes(x = body_mass_g, 
                     y = flipper_length_mm, 
                     col = species,
                     shape = sex)) +
    geom_point(alpha = 0.75) +
    scale_color_manual(values = c("darkorange","cornflowerblue","cyan4"))


#' 
#' 
#' ## size
#' 
#' We could also make all the points larger
#' 
## ------------------------------------------------------------------

ggplot(penguins, aes(x = body_mass_g, 
                     y = flipper_length_mm, 
                     col = species,
                     shape = sex)) +
    geom_point(alpha = 0.5, size = 3) +
    scale_color_manual(values = c("darkorange","cornflowerblue","cyan4"))


#' 
#' size can also be mapped onto aesthetic properties. Here we make the point size proportional to the bill depth
#' 
## ------------------------------------------------------------------

ggplot(penguins, aes(x = body_mass_g, 
                     y = flipper_length_mm, 
                     col = species,
                     shape = sex,
                     size = bill_depth_mm)) +
    geom_point(alpha = 0.5, size = 3) +
    scale_color_manual(values = c("darkorange","cornflowerblue","cyan4"))


#' 
#' What happened? We set size twice, and the second overrode the first.
#' 
## ------------------------------------------------------------------

ggplot(penguins, aes(x = body_mass_g, 
                     y = flipper_length_mm, 
                     col = species,
                     shape = sex,
                     size = bill_depth_mm)) +
    geom_point(alpha = 0.5) +
    scale_color_manual(values = c("darkorange","cornflowerblue","cyan4"))


#' 
#' There is probably too much information here for one plot, but you can get the sense of the flexibility here.
#' 
#' 
#' ## labels
#' 
#' We can change or add various labels to make the plot better. Here we add a title and our own x and y axis labels.
#' 
#' 
## ------------------------------------------------------------------

ggplot(penguins, aes(x = body_mass_g, 
                     y = flipper_length_mm, 
                     col = species,
                     shape = sex,
                     size = bill_depth_mm)) +
    geom_point(alpha = 0.5) +
    scale_color_manual(values = c("darkorange","cornflowerblue","cyan4")) +
    labs(title = "Relationship Between Flipper Length and Body Mass for Palmer Penguins",
       x = "Body Mass (g)", y = "Flipper Length (mm)")


#' 
#' ## coordinates
#' 
#' We can alter the axes by changing the coordinates. Here we flip the axes using `coord_flip()`:
#' 
## ------------------------------------------------------------------

ggplot(penguins, aes(x = body_mass_g, 
                     y = flipper_length_mm, 
                     col = species,
                     shape = sex,
                     size = bill_depth_mm)) +
    geom_point(alpha = 0.5) +
    coord_flip() +
    scale_color_manual(values = c("darkorange","cornflowerblue","cyan4")) +
    labs(title = "Relationship Between Flipper Length and Body Mass for Palmer Penguins",
       x = "Body Mass (g)", y = "Flipper Length (mm)")


#' 
#' Alternatively, we can change the range of data depicted by setting the axis limits using `coord_cartesian()`:
#' 
## ------------------------------------------------------------------

ggplot(penguins, aes(x = body_mass_g, 
                     y = flipper_length_mm, 
                     col = species,
                     shape = sex,
                     size = bill_depth_mm)) +
    geom_point(alpha = 0.5) +
    coord_cartesian(xlim = c(3000, 5000),
                    ylim = c(170, 200)) +
    scale_color_manual(values = c("darkorange","cornflowerblue","cyan4")) +
    labs(title = "Relationship Between Flipper Length and Body Mass for Palmer Penguins",
       x = "Body Mass (g)", y = "Flipper Length (mm)")


#' 
#' ## axis and tick marks
#' 
#' Sometimes, we want to set the axis ticks ourselves. We can do this using `scale_y_continuous()` for continuous variables (we use `scale_x_continuous()` to change the x axis)
#' 
## ------------------------------------------------------------------

ggplot(penguins, aes(x = body_mass_g, 
                     y = flipper_length_mm, 
                     col = species,
                     shape = sex,
                     size = bill_depth_mm)) +
    geom_point(alpha = 0.5) +
    scale_y_continuous(breaks = c(180, 200, 220)) +
    scale_color_manual(values = c("darkorange",
                                  "cornflowerblue",
                                  "cyan4")) +
    labs(title = "Relationship Between Flipper Length and Body Mass for Palmer Penguins",
       x = "Body Mass (g)", y = "Flipper Length (mm)")


#' 
#' We can also change the scale for discrete variables:
#' 
#' 
## ------------------------------------------------------------------

ggplot(penguins, aes(x = body_mass_g, y = species)) +
    geom_boxplot() +
    geom_jitter(height = 0.1) +
    scale_y_discrete(limits = c("Adelie", "Chinstrap"))


#' 
#' 
#' # layer 4: themes 
#' 
#' ## changing specific elements
#' 
#' You can customize ggplots in many ways. For fine scale control, you will want to tweak things like axes, tick marks, colors, legend, etc one at a time. You do this by changing aspects of the theme, using `theme()`. For example, this removed the grid lines:
#' 
## ------------------------------------------------------------------

ggplot(penguins, aes(x = body_mass_g, 
                     y = flipper_length_mm, 
                     col = species)) +
    geom_point() +
    geom_smooth(method = "lm", formula = y ~ x) +
    theme(panel.grid = element_blank())


#' 
#' This adds an axis line:
#' 
## ------------------------------------------------------------------

ggplot(penguins, aes(x = body_mass_g, 
                     y = flipper_length_mm, 
                     col = species)) +
    geom_point() +
    geom_smooth(method = "lm", formula = y ~ x) +
    theme(axis.line = element_line())


#' 
#' This changes text size, too:
#' 
## ------------------------------------------------------------------

ggplot(penguins, aes(x = body_mass_g, 
                     y = flipper_length_mm, 
                     col = species)) +
    geom_point() +
    geom_smooth(method = "lm", formula = y ~ x) +
    theme(axis.line = element_line(),
         axis.title = element_text(size = 18))


#' 
#' You can also change aspects of the legend. Here we can move the location of the legend:
#' 
## ------------------------------------------------------------------

ggplot(penguins, aes(x = body_mass_g, y = species, col = species)) +
    geom_violin() +
    geom_boxplot(width = 0.1) + 
    geom_jitter(height = 0.075) +   
    theme(legend.position = "top")


#' 
#' In this instance, it is redundant, so we can just remove it:
#' 
## ------------------------------------------------------------------

ggplot(penguins, aes(x = body_mass_g, y = species, col = species)) +
    geom_violin() +
    geom_boxplot(width = 0.1) + 
    geom_jitter(height = 0.075) +   
    theme(legend.position = "none")


#' 
#' There are lots of things you can customize about plots. See `?theme()` for more information on how you can customize individual elements of plots.
#' 
#' ## changing the whole plot
#' 
#' Alternatively, you can select a theme that will modify a bunch of non-data elements all at once. Here we replace the default theme (`theme_gray()`) with a simple black and white one.
#' 
## ------------------------------------------------------------------

ggplot(penguins, aes(x = body_mass_g, 
                     y = flipper_length_mm, 
                     col = species)) +
    geom_point() +
    geom_smooth(method = "lm", formula = y ~ x) +
    theme_bw()


#' 
#' Here is a dark one:
#' 
## ------------------------------------------------------------------

ggplot(penguins, aes(x = body_mass_g, 
                     y = flipper_length_mm, 
                     col = species)) +
    geom_point() +
    geom_smooth(method = "lm", formula = y ~ x) +
    theme_dark()


#' 
#' 
#' And a minimal one (my personal default):
#' 
## ------------------------------------------------------------------

ggplot(penguins, aes(x = body_mass_g, 
                     y = flipper_length_mm, 
                     col = species)) +
    geom_point() +
    geom_smooth(method = "lm", formula = y ~ x) +
    theme_minimal()


#' 
#' Note, here I moved the color aesthetic so it applies only to the points, not the whole plot. Now, we get a single regression line
#' 
## ------------------------------------------------------------------

ggplot(penguins, aes(x = body_mass_g, 
                     y = flipper_length_mm)) +
    geom_point(aes(col = species)) +
    geom_smooth(method = "lm", formula = y ~ x) +
    theme_minimal()


#' 
#' In this instance, I don't love that the regression line is blue, a similar color to one of our species. So, we change the line color:
#' 
## ------------------------------------------------------------------

ggplot(penguins, aes(x = body_mass_g, 
                     y = flipper_length_mm)) +
    geom_point(aes(col = species)) +
    geom_smooth(method = "lm", formula = y ~ x, 
                col = "gray") +
    theme_minimal()


#' 
#' Personally, I prefer the data on top of the line, so we can change the order of the layers:
#' 
## ------------------------------------------------------------------

ggplot(penguins, aes(x = body_mass_g, 
                     y = flipper_length_mm)) +
    geom_smooth(method = "lm", formula = y ~ x, 
                col = "gray") +
    geom_point(aes(col = species)) +
    theme_minimal()


#' 
#' ggplot2 currently includes nine themes by default (theme_x(), where x = bw, light, classic, linedraw, dark, minimal, void, test, and gray (the default))
#' 
#' Many more are included in add-on packages like {ggthemes} (<https://github.com/jrnold/ggthemes>), by Jeffrey Arnold. These include themes inspired by major magazines, websites, programs, and designers:
#' 
#' theme_base: a theme resembling the default base graphics in R. 
#' theme_calc: a theme based on LibreOffice Calc.
#' theme_economist: a theme based on the plots in the The Economist magazine.
#' theme_excel: a theme replicating the classic ugly gray charts in Excel
#' theme_few: theme from Stephen Few's "Practical Rules for Using Color in Charts".
#' theme_fivethirtyeight: a theme based on the plots at fivethirtyeight.com.
#' theme_gdocs: a theme based on Google Docs.
#' theme_hc: a theme based on Highcharts JS.
#' theme_par: a theme that uses the current values of the base graphics parameters in par.
#' theme_pander: a theme to use with the pander package.
#' theme_solarized: a theme using the solarized color palette.
#' theme_stata: themes based on Stata graph schemes.
#' theme_tufte: a minimal ink theme based on Tufte's The Visual Display of Quantitative Information.
#' theme_wsj: a theme based on the plots in the The Wall Street Journal.
#' 
#' 
## ------------------------------------------------------------------

ggplot(penguins, aes(x = body_mass_g, 
                     y = flipper_length_mm, 
                     col = species)) +
    geom_point() +
    geom_smooth(method = "lm", formula = y ~ x) +
    theme_fivethirtyeight()


#' 
## ------------------------------------------------------------------

ggplot(penguins, aes(x = body_mass_g, 
                     y = flipper_length_mm, 
                     col = species)) +
    geom_point() +
    geom_smooth(method = "lm", formula = y ~ x) +
    theme_economist()


#' 
## ------------------------------------------------------------------

ggplot(penguins, aes(x = body_mass_g, 
                     y = flipper_length_mm, 
                     col = species)) +
    geom_point() +
    geom_smooth(method = "lm", formula = y ~ x) +
    theme_excel()


#' 
#' 
## ------------------------------------------------------------------

ggplot(penguins, aes(x = body_mass_g, 
                     y = flipper_length_mm, 
                     col = species)) +
    geom_point() +
    geom_smooth(method = "lm", formula = y ~ x) +
    theme_solarized()


#' 
#' You can set themes on a plot by plot basis, or for the whole document using: `theme_set()`, e.g., theme_set(theme_economist)
#' 
#' You can also create your own themes.
#' 
#' For more on themes, see: 
#' 
#' https://ggplot2.tidyverse.org/reference/ggtheme.html
#' 
#' https://yutannihilation.github.io/allYourFigureAreBelongToUs/ggthemes
#' 
#' # faceting
#' 
#' Facets are smaller plots that display different subsets of the data. This is one of ggplot's super powers. They are particularly useful when you have discrete categories, and for exploring conditional relationships and large data. 
#' 
#' `facet_wrap()` splits the data by a single variable, here sex
#' 
## ------------------------------------------------------------------

ggplot(penguins, aes(x = body_mass_g, y = flipper_length_mm, 
                         col = species)) +
    geom_point() + 
    facet_wrap(~ sex) +
    labs(title = "Relationship Between Flipper Size and Body Mass for Palmer Penguins",
       x = "Body Mass (g)", y = "Flipper Length (mm)") +
  theme_bw()


#' 
#' Here island: 
#' 
## ------------------------------------------------------------------

ggplot(penguins, aes(x = body_mass_g, y = flipper_length_mm, 
                         col = species)) +
    geom_point() + 
    facet_wrap(~ island) +
    labs(title = "Relationship Between Flipper Size and Body Mass for Palmer Penguins",
       x = "Body Mass (g)", y = "Flipper Length (mm)") +
  theme_bw()


#' 
#' We can set the number of rows or columns using `facet_wrap()`:
#' 
## ------------------------------------------------------------------

ggplot(penguins, aes(x = body_mass_g, y = flipper_length_mm, 
                         col = species)) +
    geom_point() + 
    facet_wrap(~ island, nrow = 3) +
    labs(title = "Relationship Between Flipper Size and Body Mass for Palmer Penguins",
       x = "Body Mass (g)", y = "Flipper Length (mm)") +
    theme_bw()


#' 
#' `facet_grid()` splits the data by two variables, here sex and species
#' 
## ------------------------------------------------------------------

ggplot(penguins, aes(x = body_mass_g, y = flipper_length_mm, 
                         col = species)) +
    geom_point(size = 2, alpha = 0.5) + 
    geom_smooth(method = lm, formula = y ~ x, 
                se = FALSE, size = 1.5) +
    facet_grid(sex ~ species) +
    theme_bw() + 
    labs(title = "Flipper Length and Body Mass, by Sex & Species",
         x = "Body Mass (g)", 
         y = "Flipper Length (mm)")


#' 
#' flip rows and columns
#' 
## ------------------------------------------------------------------

ggplot(penguins, aes(x = body_mass_g, y = flipper_length_mm, 
                         col = species)) +
    geom_point(size = 2, alpha = 0.5) + 
    geom_smooth(method = lm, formula = y ~ x, 
                se = FALSE, size = 1.5) +
    facet_grid(species ~ sex) +
    theme_bw() + 
    labs(title = "Flipper Length and Body Mass, by Sex & Species",
         x = "Body Mass (g)", 
         y = "Flipper Length (mm)")


