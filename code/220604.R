c1 <- c(1,2,NA, NA, 5)
c2 <- c(1,2,3,4,5)
c3 <- c(NA, 2,3,4,5)
df = data.frame(c1, c2, c3)
df
is.na(df)
table(is.na(df))
is.na(df$c1)
table(is.na(df$c1))

df %>% filter(!is.na(c1))
df %>% filter(!is.na(c3))

mean(df$c1)
sum(df$c1)
mean(df$c2)
mean(df$c3)

#na.rm 속성은 NA값의 제외하고 연산을 실행
mean(df$c1, na.rm=T)

# na.rm 속성이 존재하지 않으면 다음과 같이 
# NA의 값을 필터링을 한 뒤 mean() 함수를 사용
df_c1 <- df %>% filter(!is.na(c1))
mean(df_c1$c1)

df %>% summarise(mean_c1 = mean(c1, na.rm = T))

exam <- read.csv("csv_exam.csv")
exam
exam[c(3, 8, 15), 'math'] <- NA
exam

# class별 수학 점수의 평균을 구하시오.

exam %>% group_by(class) %>% 
  summarise(math_mean = mean(math, na.rm=T),
            math_sum = sum(math, na.rm=T))

# exam데이터의 math의 결측치의 값을 math 전체의 평균 값으로 대체
mean(exam$math, na.rm = T)

# is.na()조건식이 참이면 55을 대입, 거짓이면 기존의 값을 대입
exam$math <- ifelse(is.na(exam$math), 55, exam$math)
exam


exam$math <- ifelse(is.na(exam$math), 
                    mean(exam$math, na.rm = T), 
                    exam$math)
exam

mpg
library(ggplot2)
mpg
mpg <- as.data.frame(ggplot2::mpg)
mpg[c(65, 124, 131, 153, 212), "hwy"] <- NA

# drv별로 hwy의 평균을 구하려고 하는데 
# hwy의 결측치의 값이 존재하는지 확인.
# drv와 hwy의 결측치의 개수가 몇개인지 확인.
# filter를 이용해서 hwy의 결측치를 제거하고 
# drv별 hwy의 평균값을 구하고 어떠한 값이 높은지 확인.

is.na(mpg$drv)
table(is.na(mpg$drv))
table(is.na(mpg$hwy))
## filter 함수를 변수에 지정해서 하는 방법
mpg_1 <- mpg %>% filter(!is.na(mpg$hwy))
table(is.na(mpg_1$hwy))

mpg_1 %>% group_by(drv) %>% 
  summarise(mean_hwy = mean(hwy)) %>% 
  arrange(desc(mean_hwy))
## 모든 함수를 파이프라인 연산자로 연결하여 출력
mpg %>% filter(!is.na(mpg$hwy)) %>% 
  group_by(drv) %>% 
  summarise(mean_hwy = mean(hwy)) %>% 
  arrange(desc(mean_hwy))
## na.rm을 이용하여 결측치를 제외하고 연산을 사용한 방법
mpg %>% group_by(drv) %>% 
  summarise(mean_hwy = mean(hwy, na.rm=T)) %>% 
  arrange(desc(mean_hwy))

outlier <- data.frame(gender = c(1,2,3,1,2),
                      score = c(80, 100, 90, 110, 70))
outlier

## gender가 1,2는 정상 3은 이상치
table(outlier$gender)
## score에서 100이하는 정상 100이상 이상치
table(outlier$score)
# gender가 3인 경우 NA 대체
outlier$gender <- ifelse(outlier$gender == 3, NA, outlier$gender)
outlier
#score가 100보다 크면 NA 대체
outlier$score <- ifelse(outlier$score > 100, NA, outlier$score)
outlier

#결측치의 값을 제외하고 성별 점수의 평균을 구하는 방법
outlier %>% filter(!is.na(gender) & !is.na(score)) %>% 
  group_by(gender) %>% 
  summarise(mean_score = mean(score))

mpg <- as.data.frame(ggplot2::mpg)
boxplot(mpg$hwy)
boxplot(mpg$hwy)$stats
## boxplot 데이터를 가지고 극단치 부분을 NA로 대체
mpg$hwy <- ifelse(mpg$hwy < 12 | mpg$hwy >37, NA, mpg$hwy)
table(is.na(mpg$hwy))
## drv별로 hwy의 평균 값을 출력
mpg %>% group_by(drv) %>% 
  summarise(mean_hwy = mean(hwy, na.rm=T)) %>% 
  arrange(desc(mean_hwy))

# drv 컬럼의 4, f, r 값들이 정상 k는 이상치
mpg <- as.data.frame(ggplot2::mpg)
mpg[c(10, 14, 58, 93), "drv"] <- "k"
mpg[c(29, 43, 129, 203), "cty"] <- c(3,4, 39,42)

# drv컬럼에 이상치가 존재하는지 확인.
# 이상치가 존재하면 이상치를 NA로 대체
# (k인경우 NA) (drv가 4, f, r이 아닌경우) 
# boxplot을 이용하여 cty의 극단치의 범위를 확인.
# 극단치의 범위에 있는 데이터의 값을 NA로 대체
# 이상치를 제외했을때 drv별 cty의 평균값과 
# 이상치를 제거하지 않은 경우의 drv별 cty의 평균값을 체크

table(mpg$drv)

mpg$drv <- ifelse(mpg$drv == "k", NA, mpg$drv)
table(mpg$drv)

#%in% c() 값을 포함하면 True 포함하지 않으면 False
mpg$drv <- ifelse(mpg$drv %in% c("4", "f", "r"), mpg$drv , NA)
table(mpg$drv)

boxplot(mpg$cty)
boxplot(mpg$cty)$stats

mpg$cty <- ifelse(mpg$cty <9 | mpg$cty > 26, NA, mpg$cty)
boxplot(mpg$cty)
## 이상치를 제거한 뒤 평균을 출력
mpg %>% filter(!is.na(drv) & !is.na(cty)) %>% 
  group_by(drv) %>% 
  summarise(mean_cty = mean(cty))
## 이상치를 제거하지 않은 상태에서의 평균을 출력
mpg <- as.data.frame(ggplot2::mpg)
mpg[c(10, 14, 58, 93), "drv"] <- "k"
mpg[c(29, 43, 129, 203), "cty"] <- c(3,4, 39,42)
mpg %>% group_by(drv) %>% 
  summarise(mean_cty = mean(cty))

exam <- read.csv("csv_exam.csv")
exam[c(3, 8, 15), 'math'] <- NA
exam

# math 컬럼의 NA 값에 전체 수학 평균의 값을 대체를 해봤었는데
# class별 math의 평균 값들로 NA의 값을 대체.
# 힌트1. 방법이 2가지 
# 1. 클래스 별로 데이터프레임 나눠서 (변수 5개에 클래스별로 필터링하여 저장) 
# 변수 5개의 NA 값을 대체를 한 뒤 
# 데이터프레임 5개를 합치는 방법
# 2. 클래스의 중복값을 없애고 리스트의 형태로 만들어서
# for문을 이용해서 반복 작업을 만드는 과정
# 1번 방법 2번 방법으로 코드를 작성을 해보시면 되겠습니다. 

exam_list <- (exam %>% group_by(class) %>% slice(1))$class
exam_list
# 2번 방법을 사용할때 사용할 리스트 값  = exam_list

# 변수를 각 class별로 만들어서 평균 값을 넣어주는 방법
exam_1 <- exam %>% filter(class == 1)
exam_1
exam_2 <- exam %>% filter(class == 2)
exam_3 <- exam %>% filter(class == 3)
exam_4 <- exam %>% filter(class == 4)
exam_5 <- exam %>% filter(class == 5)

mean(exam_1$math, na.rm=T)
exam_1$math <- ifelse(is.na(exam_1$math), 
                      mean(exam_1$math, na.rm=T), exam_1$math)
exam_1
exam_2$math <- ifelse(is.na(exam_2$math), 
                      mean(exam_2$math, na.rm=T), exam_2$math)
exam_3$math <- ifelse(is.na(exam_3$math), 
                      mean(exam_3$math, na.rm=T), exam_3$math)
exam_4$math <- ifelse(is.na(exam_4$math), 
                      mean(exam_4$math, na.rm=T), exam_4$math)
exam_5$math <- ifelse(is.na(exam_5$math), 
                      mean(exam_5$math, na.rm=T), exam_5$math)
exam_ <- bind_rows(exam_1, exam_2, exam_3, exam_4, exam_5)
exam_

#for문을 이용한 방법
exam_list <- (exam %>% group_by(class) %>% slice(1))$class
exam_list


# i가 1인경우에는 is.na(exam[exam$class == 1, ]$math)
for(i in exam_list){
  exam[exam$class==i,]$math <- ifelse(is.na(exam[exam$class == i,]$math), 
                                      mean(exam[exam$class == i,]$math, na.rm=T),
                                      exam[exam$class == i,]$math)
}
exam

mean(exam[exam$class == 1,]$math, na.rm=T)


mpg <- ggplot2::mpg
mpg
# xlim -> x축의 범위 설정
# ylim -> y축의 범위 설정
ggplot(data = mpg, aes(x = displ, y = hwy)) +
  geom_point() + 
  xlim(3, 6) +
  ylim(20, 30)

mpg2 <- mpg %>% group_by(drv) %>% summarise(mean_hwy = mean(hwy))
mpg2
# drv별 평균 hwy의 값을 막대그래프로 표현
ggplot(data = mpg2, aes(x=drv, y=mean_hwy)) + geom_col()
# 순서를 오름차순으로 변경
ggplot(data=mpg2, aes(x = reorder(drv, mean_hwy), y = mean_hwy)) + geom_col()
# 순서를 내림차순으로 변경
ggplot(data=mpg2, aes(x = reorder(drv, -mean_hwy), y = mean_hwy)) + geom_col()

ggplot(data=mpg, aes(x = drv)) + geom_bar()

# geom_col()그래프 geom_bar()그래프의 차이는?
# geom_col() -> x축의 값과 y축의 값을 전부 지정
# geom_bar() -> x축만 지정. -> x축을 지정을 해서 개수를 그래프에 출력을 하는 방식

ggplot(data=mpg, aes(x = hwy)) + geom_bar()

View(economics)

ggplot(data = economics, 
       aes(x = date, 
           y = unemploy)
       )+ geom_line()

View(Orange)

ggplot(data = Orange, 
       aes(x = age, 
           y = circumference, group=Tree)
       ) + geom_line()

ggplot(data=mpg, 
       aes(x=drv, 
           y = hwy)
       ) + geom_boxplot()

# mpg 데이터프레임에서 cty와 hwy 간에 산점도 그래프를 출력 ( x축 cty y축 hwy)

ggplot(data = ggplot2::mpg, aes(x = cty, y = hwy)) + geom_point()


# midwest 데이터프레임에서 x축 전체인구(poptotal), y축 아시아인 인구(popasian)으로 된 
# 산점도 그래프를 출력 
# (전체 인구는 50만명 이하, 아시아인 인구는 만명 이하인 지역만 표시)
ggplot(data = ggplot2::midwest, aes(x = poptotal, y=popasian)) + 
  geom_point() + 
  xlim(0, 500000) + 
  ylim(0, 10000)

# mpg 데이터프레임에서 종류(class)가 suv 차량중에 도시연비(cty)가 
# 가장 좋은 5군데의 제조사(manufacturer)를
# 막대 그래프로 출력. 
# class 컬럼에서 suv만 출력, 제조사별로 그룹, 평균 도시연비를 구해서 
# 상위 5개만 막대 그래프로 출력

class_cty <- ggplot2::mpg %>% filter(class == "suv") %>% 
  group_by(manufacturer) %>% 
  summarise(mean_cty = mean(cty)) %>% 
  arrange(desc(mean_cty)) %>% 
  head(5)

class_cty

ggplot(data = class_cty, 
       aes(x = reorder(manufacturer, -mean_cty), 
           y = mean_cty)
       ) + geom_col()
# 차량의 종류(class)중에 어떤 차량이 제일 잘 팔리는지 확인하는 방법
# class 별 빈도를 그래프로 출력

ggplot(data = ggplot2::mpg, 
       aes(x = class)
       ) + geom_bar()

# economics 데이터에서 시계열 그래프 y축의 값이 개인 저축률(psavert)값으로
# 그래프를 출력
ggplot(data = ggplot2::economics, aes(x = date, y = psavert)) + geom_line()


# mpg 데이터프레임에서 class가 'compact', 'subcompact', 'suv'인 자동차의 cty
# 박스플롯을 출력
# 힌트 . filter를 이용해서 class가 3가지인 경우로 새로운 데이터프레임을 생성

table(mpg$class)
class_mpg <- ggplot2::mpg %>% 
  filter(ggplot2::mpg$class %in% c("compact", "subcompact", "suv"))

table(class_mpg$class)
ggplot(data = class_mpg, aes(x = class, y = cty)) + geom_boxplot()


