



func_1 <- function(){
  print("Hello R")
}

func_1()

sum <- function(x, y){
  c <- x-y
  return(c)
}

sum(5,3)

sum_2 <- function(x, y=5){
  return(x+y)
}

sum_2(5, 3)

func_2 <- function(x, ...){
  print(x)
  summary(...)
}

v <- 1:10
func_2("Summary of v :", v)

# 1부터 20까지 홀수만 출력하는 함수를 하나 만들어봅시다. 
# 인자 값으로 1, 20 넣어서 홀수가 출력이 되도록 함수 생성 

func_3 <- function(x, y){
  while(x >= y){
    if(x %%2 == 1){ # 홀수인 경우
      print(x)
    }
    x = x - 1
  }
}

func_3(20, 1)


func_4 <- function(x, y){
  c <- x:y
  for(n in c){
    if(n %% 2 == 0){  #홀수인 경우
      print(n)
    }
  }
}
func_4(1, 20)
func_4(50, 60)


install.packages("ggplot2")
library(ggplot2)

x <- c("a", "a", "b", "c")
qplot(x)

mpg


qplot(data = mpg, x = hwy)

qplot(data = mpg, x = drv, y = hwy, geom="boxplot", 
      colour = drv)

?qplot


name <- c("A", "B", "C", "D", "E")
grade <- c(1,3,2,1,2,2)
student <- data.frame(name, grade)
student

n <- c("A", "B", "C", "D", "E")
grade <- c(1,3,2,1,2)
student_ <- data.frame(name = n, grade)
student_

midturm <- c(80,70,90,60,80)
final <- c(70,90,80,80,80)
scores <- cbind(midturm, final)
scores

gender <- c("M", "F", "F", "F", "M")
students <- data.frame(student, gender, scores)
students

total_score <- midturm + final
total_score
students_2 <- cbind(students, total_score)
students
print(students_2)

new_student <- data.frame(name="F", 
                          grade = 2, 
                          gender="M",
                          midturm=90,
                          final=80)
new_student
rbind(students, new_student)

students
students$name
students[["grade"]]
students[[3]]

## 함수를 생성.
## 매개변수는 2개, 하나는 dataframe, 컬럼의 이름
## 컬럼의 이름이 인자 값이 존재하지 않을 경우는 
## 1번째 컬럼의 데이터를 출력


func_5 <- function(data, c=1){
  result <- data[[c]]
  return(result)
}

func_5(students)

students$name
students[["grade"]]
students[[3]]

students$name[4]

students[1,3:5]
students[2:4,3:5]
students[c(1,3),c("grade", "gender")]

students$midturm >= 80
students[students$midturm >= 80,c("grade", "gender")]

order(students$grade)
students[order(students$grade),]

order(students$final, decreasing = TRUE)
students[order(students$final , decreasing = TRUE),]

students
students[order(students$grade, -students$midturm),]

x <- c(7,9,NA,5,2)
x[x>6]
subset(x, x>6)

y <- 1:5
z <- -1:-5
df_1 <- data.frame(x,y,z)
df_1

df_1[df_1$x>6,]
subset(df_1, df_1$x>6, 2:3)

##함수 생성
##매개변수 3개 생성
##x,y,z x가 '합'면 y+z
##'차'면 y-z
##'곱'이면 y*z
##결과값을 출력을 하는 함수를 생성


func_6 <- function(x, y, z){
  if(x=="합"){
    result = y+z
  }else if(x=="차"){
    result = y-z
  }else if(x =="곱"){
    result = y*z
  }else{
    result = "Error"
    print("x 값이 잘못되었습니다.")
  }
  return(result)
}

func_6("합", 5,6)
func_6("차", 5,6)
func_6("곱", 5,6)
func_6("나누기", 5,6)

students


##함수 생성
##매개변수 2개 생성(x,y)
##x가 "c"면 y값을 students 행 추가(y값 벡터 데이터 타입)
##x가 "r"이면 y값을 students 열 추가(y값 데이터프레임 타입)
##결과값을 출력하는 함수를 생성




func_7 <- function(x, y){
  if(x == "c"){
    result = cbind(students, y)
  }else if(x=="r"){
    result = rbind(students, y)
  }else{
    result = "x 값이 잘못되었습니다."
  }
  return(result)
}
##벡터 데이터타입
hw <- c(1,2,3,4,5)  
##데이터프레임 타입
df_add <- data.frame(name = "F", grade=4, gender="M",
                     midturm = 50, final=80)  


func_7("c", c(1,2,3,4,5))
func_7("r", df_add)













if(조건식1){
  조건식1이 참인경우 실행
}else if(조건식2){
  조건식2이 참인경우 실행
}else if(조건식3){
  조건식3이 참인경우 실행
}else{
  모든 조건식이 거짓인 경우 실행
}

