rm(list = ls())
n = c(2, 3, 5) 
s = c("aa", "bb", "cc") 
b = c(TRUE, FALSE, TRUE) 
df = data.frame(n, s, b)

df <- df %>% mutate2(new_n = n + 2)

df


