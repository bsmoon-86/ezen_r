library(dplyr)
library(ggplot2)
library(jsonlite)

args <- commandArgs(TRUE)
a <- as.character(args[1])
file_path <- paste0("./public/csv/",a,".csv")
b <- as.numeric(args[2])
c <- as.numeric(args[3])

test <- function(path, subject, score){
  df <- read.csv(path)
  df <- df %>% 
    filter(df[,subject] > score)
  return(df)
}

result <- test(file_path, b, c)
print(toJSON(result))
