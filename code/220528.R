exam <- read.csv("csv_exam.csv")
exam
head(exam)
head(exam, 3)
tail(exam)
tail(exam, 4)
View(exam)
dim(exam)
str(exam)
summary(exam)

install.packages('dplyr')
library(dplyr)

df_raw <- data.frame(var1 = c(1,2,1), var2 = c(2,3,2))
df_raw

df_new <- rename(df_raw, v2 = var2)
df_new

df_raw$sum <- df_raw$var1 + df_raw$var2
df_raw

df_raw$mean <- (df_raw$var1 + df_raw$var2)/2
df_raw

df_raw$total <- ifelse(df_raw$sum >= 4, "pass", "fail")
df_raw

df_raw$total2 <- ifelse(df_raw$sum >= 4, "pass", 
                        ifelse(df_raw$sum >= 3, "hold", "fail")
                        )
df_raw

mpg

mpg <- as.data.frame(ggplot2::mpg)
mpg
head(mpg)
View(mpg)

## mpg 데이터프레임에서 total이라는 파생변수를 생성
## total이라는 파생변수는 cty 와 hwy의 평균 값을 지정.

mpg$total <- (mpg$cty + mpg$hwy)/2
head(mpg)
View(mpg)

## mpg 데이터프레임에서 평균 연비를 기준으로 test 파생변수를
## 생성. 
## total 30이상이면 A 20~30 B 그 외는 C 라는 파생변수를 생성.

mpg$test <- ifelse(mpg$total >= 30, "A", 
                   ifelse(mpg$total >= 20, "B", "C"))
head(mpg)

table(mpg$test)

qplot(mpg$test)
hist(mpg$total)

midwest <- as.data.frame(ggplot2::midwest)
head(midwest)
View(midwest)

## midwest 데이터프레임에 poptotal컬럼이름을 total 변경
## popasian 컬럼이름을 asian 변경
## total, asian 이용해서 전체 인구 대비 아시아 인구 백분율 
## 파생변수(ratio) 생성
## ratio 히스토그램 출력 
## ratio의 평균값을 기준으로 평균을 초과하면 large, 이하면 small
## 파생변수(group) 생성
## group 컬럼의 해당하는 지역이 분포의 갯수 출력
## 막대그래프로 출력

midwest <- rename(midwest, total = poptotal)
midwest <- rename(midwest, asian = popasian)
head(midwest)

midwest$ratio <- midwest$asian/midwest$total*100
head(midwest)
hist(midwest$ratio)

mean(midwest$ratio)
ratio_mean <- mean(midwest$ratio)

midwest$group <- ifelse(midwest$ratio > 0.4872462, 
                        "large", "small")
midwest$group <- ifelse(midwest$ratio > ratio_mean, 
                        "large", "small")
head(midwest)

table(midwest$group)
qplot(midwest$group)

exam <- read.csv("csv_exam.csv")
exam

exam %>% filter(class == 1)
exam %>% filter(class != 2)

exam %>% filter(math > 50)

exam %>% filter(class == 1 & math > 50)
exam %>% filter(math >= 90 | english >= 90)

## exam 데이터프레임에서 class가 1,3,5 인 경우를 출력
exam %>% filter(class == 1 | class == 3 | class == 5)
exam %>% filter(class %in% c(1,3,5))

exam_class1 <- exam %>% filter(class == 1)
exam_class1

exam %>% select(id, class)
exam %>% select(-class)

exam %>% 
  filter(math > 50) %>% 
  select(id, class) %>% 
  head(4)

exam %>% arrange(math) %>% head
exam %>% arrange(math, english) %>% head
exam %>% arrange(desc(class)) %>%  head
exam %>% arrange(desc(class), math)

exam %>% mutate(total = math + english + science, 
                mean = (math+english+science)/3 )

exam %>% summarise(mean_math = mean(math))

View(exam)

exam %>% group_by(class) %>% summarise(mean_math = mean(math))

## mean() -> 평균
## sd() -> 표준편차
## sum() -> 합계
## median() -> 중앙값
## min() -> 최소값
## max() -> 최대값
## n() -> 빈도(갯수)

exam %>% group_by(class) %>% summarise(
  mean_math = mean(math),
  sum_math = sum(math),
  max_math = max(math),
  n_math = n())

## mpg 데이터프레임 -> group_by -> 기준 컬럼이 manufacfurer, drv
## cty 평균 출력
head(mpg)
mpg %>% 
  group_by(manufacturer, drv) %>% 
  summarise(mean_cty = mean(cty),
            count = n())

## mpg 데이터프레임 
## 회사(manufacturer)별로 그룹화 
## class컬럼의 값이 suv 자동차의 total컬럼의 평균을 출력하고 
## 내림차순으로 정렬 후
## 1~5위까지 출력을 해봅시다

mpg %>% 
  group_by(manufacturer) %>%  ## 제조사별 그룹
  filter(class == "suv") %>%  ## suv만 필터링
  summarise(mean_total = mean(total)) %>%   ##total 컬럼의 평균
  arrange(desc(mean_total)) %>%   ##mean_total을 기준으로 내림차순
  head(5) ##상위 5개만 출력

df_1 <- data.frame(id = 1:5, score = c(60,70,80,90,100))
df_2 <- data.frame(id = 1:5, weight = c(80,70,75,65,60))
df_3 <- data.frame(id = 1:3, class= c(1,1,2))
df_4 <- data.frame(id = c(5,4,3,2,1), age=c(10,14,12,10,20))
df_1
df_2
df_4
## inner_join은 by인자의 컬럼의 값이 같은 경우에만
## 열을 추가하여 데이터프레임을 완성 
## 컬럼의 값이 다른경우는 출력하지 않는다. 
total_df1 <- inner_join(df_1, df_2, by='id')
total_df1
total_df2 <- inner_join(df_1, df_4, by='id')
total_df2
total_df3 <- inner_join(df_1, df_3, by='id')
total_df3

total_df4 <- left_join(df_1, df_2, by='id')
total_df4
total_df5 <- left_join(df_1, df_3, by='id')
total_df5

total_df6 <- right_join(df_1, df_2, by='id')
total_df6
total_df7 <- right_join(df_1, df_3, by='id')
total_df7

total_df8 <- full_join(df_1, df_2, by='id')
total_df8
total_df9<- full_join(df_1, df_3, by='id')
total_df9

df_4 <- data.frame(id = 1:5, x = 1:5)
df_5 <- data.frame(id = 6:10, y = 6:10)
total_df10 <- full_join(df_4, df_5, by='id')
total_df10

exam
df_6 <- data.frame(class = 1:5, 
                   teacher = c("kim", "lee", "park", "choi", "jung"))
df_6

total_exam <- left_join(exam, df_6, by='class')
total_exam

df_a <- data.frame(id = 1:5, score = c(60,50,80,44,80))
df_b <- data.frame(id = 6:10, weight = c(60,80,70,50,70))
df_a
df_b
rbind(df_a, df_b)
total_df11 <- bind_rows(df_a, df_b)
total_df11

df_c <- data.frame(id = 11:15, score = c(100,70,50,80,70))
df_c
rbind(df_a, df_c)
bind_rows(df_a, df_c)


head(mpg)


## mpg 데이터프레임에 연료 종류(fl)컬럼이 존재
## 연료의 가격이 나타나는 컬럼이 존재X
fuel <- data.frame(fl = c("c", "d", "e", "p", "r"),
                   price_fl = c(2.35, 2.38, 2.11, 2.76, 2.22))
##mpg 데이터에 price_fl 컬럼을 추가를 하는데 기준은 fl의 값을 
## 기준으로 하여 컬럼을 추가
## 데이터가 추가가 제대로 되었는지 확인하기 위해서
## model, fl, price_fl 변수를 추출하여
## 앞부분 5개만 출력

mpg_add_fuel <- left_join(mpg, fuel, by='fl')

mpg_add_fuel %>% select(model, fl, price_fl) %>% head(5)

## ggplot2 패키지에서 제공하는 midwest 라는 데이터를 
## 데이터프레임의 형태로 변경
## popadults 컬럼이 해당 지역의 성인 인구수
## poptotal은 전체 인구수
## "전체 인구 대비 미성년자의 인구 백분율"을 
## ratio_child 라는 파생변수를 생성
## 미성년 인구 백분율이 가장 높은 상위 5개 지역을 출력
## 미성년의 비율이 40% 이상이면 large 
## 30%이상 40% 미만이면 middle
## 30%미만이면 small
## grade 파생변수도 생성
## 각 grade별 빈도수 출력, 막대그래프로 표시

midwest3 <- as.data.frame(ggplot2::midwest)
head(midwest3)
## 미성년의 인구 백분율 -> 
## (전체인구수 - 성인인구수)/전체인구수 * 100
## 100 - (성인인구수/전체인수*100)
midwest3 <- midwest3 %>% 
  mutate(ratio_child = (poptotal - popadults)/poptotal * 100)
midwest3 %>% 
  arrange(desc(ratio_child)) %>% 
  select(county, ratio_child) %>% 
  head(5)
midwest3 <- midwest3 %>% 
  mutate(grade = ifelse(ratio_child >= 40, "large", 
                        ifelse(ratio_child >= 30, "middle", "small"
                               )))
midwest3 %>% 
  select(county, ratio_child, grade) %>% 
  head(5)
table(midwest3$grade)
qplot(midwest3$grade)

## transaction_1, transaction_2 2개의 파일의 로드 
## 행추가 함수를 이용하여 결합
## transaction_detail_1, transaction_detail2 파일도 로드
## 행 추가 함수를 이용하여 결합
## transaction, transaction_detail의 데이터프레임을 구조를 확인
## left_join이용하여 결합
## quantity와 price 두개의 값을 곱하여 
## 새로운 파생변수(total_price) 생성
## item_id기준으로 그룹화 진행
## quantity 합을 출력

transaction1 = read.csv("transaction_1.csv")
transaction2 = read.csv("transaction_2.csv")
transaction_detail_1 = read.csv("transaction_detail_1.csv")
transaction_detail_2 = read.csv("transaction_detail_2.csv")

total_tr <- bind_rows(transaction1, transaction2)
total_td <- bind_rows(transaction_detail_1, transaction_detail_2)
head(total_tr)
head(total_td)

total <- left_join(total_tr, total_td, by="transaction_id")
head(total)

total <- total %>% 
  mutate(total_price = quantity * price)
head(total)

total %>% 
  group_by(item_id) %>% 
  summarise(sum_q = sum(quantity))
