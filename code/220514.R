a <- 10
a

b <- "test"
b

c <- c(1,2,"test",4,5)
c

d <- array(1:20, dim=c(4,5))
d

e <- matrix(1:10, nrow = 2)
e

f <- list("test", 20, "01012345678")
f
f[1]
f[3]
g <- list(name="test", age=20, phone="01012345678")
g
g[1]
g["name"]

df <- data.frame(name = c("test1", "test2"), age=c(20, 30),
                 phone=c("01012345678", "01098765432"))
df
df["name"]


mat_a <- matrix(1:10, nrow=2)
mat_b <- matrix(1:10, nrow=5)
mat_a
mat_b
mat_a %*% mat_b
mat_b %*% mat_a
mat_c <- matrix(1:12, nrow=3)
mat_c
mat_a %*% mat_c


in_a <- c(1,3,7)
in_b <- 2:6
in_a
in_b

in_a %in% in_b

"%s%" <- function(x, y){
  return(x^y)
}
20%s%3  # = 20^3

10%s%3 

"%aa%" <- function(x, y){
  return(x -y)
}

10%aa%4

p <- pi
p
ceiling(p)  #올림
trunc(p)    #버림
floor(p)    #내림
round(p)    #반올림
round(p, digits=2)  #소수점 2째 자리 이후 반올림

p1 <- 1534513
round(p1, digits=-4)

sqrt(4) #제곱근
exp(5)  #지수 함수

run_a <- runif(10)
run_a
max(run_a)
min(run_a)
mean(run_a)
sum(run_a)
run_b <- 1:10
sum(run_b)
mean(run_b)
max(run_b)
min(run_b)
sin(45)
cos(45)
tan(45)

if(a > 5){
  print("5보다 크다")
}

if(p > 5){
  print("5보다 크다")
}else{
  print("5보다 작다")
}

w_name <- c("test", "test2", "test3")
which(w_name == "test")
which(w_name == "test2")
which(w_name == "test3")
which(w_name == "test5")
which(w_name != "test")

f_x <- c(5,3,8,10)
sum_x <- 0
for (x in f_x){
  print(x)
  sum_x = sum_x + x   # 첫번째 반복시 sum_x = 0, x = 5
                      # 두번째 반복시 sum_x = 5, x = 3
                      # 세번째 반복시 sum_x = 8, x = 8
                      # 네번째 반복시 sum_x = 16, x = 10
                      # 반복문 종료 sum_x = 26
}
print(sum_x)

wh_x <- 0

while(wh_x < 9){
  wh_x = wh_x + 3
  print(wh_x)
}

br_x <- 1:20
for (n in br_x){
  if(n > 8){
    break
  }
  print(n)
}

for (n in br_x){
  if(n > 8){
    next
  }
  print(n)
}

br_x
for (n in br_x){
  if(n%%2 == 0){
    print(n)
  }
}

br_y <- 1
while(br_y <= 20){
  if(br_y%%2 == 0){
    print(br_y)
  }
  br_y = br_y + 1
}
