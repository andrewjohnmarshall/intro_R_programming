
# simple custom function to center and standardize data, 
# but instead of dividing by 1 sd, as scale() does, 
# this divides by two, per suggestions of Gelman et al. 2021

scale2 <- function(x){
     (x - mean(x))/(2 * sd(x))
}

scale2.na <- function(x){
     (x - mean(x, na.rm = TRUE))/(2 * sd(x, na.rm = TRUE))
}