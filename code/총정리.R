## ---------------- dplyr 패키지 -----------------##

## 패키지 설치
install.packages("dplyr")

## 패키지 로드
library(dplyr)

## csv 파일 로드
exam <- read.csv("csv_exam.csv")

## head() 데이터프레임 상단의 6개를 출력
## head(데이터프레임명, 출력할 행의 개수)
head(exam)
head(exam, 3)

## tail() 데이터프레임의 하단에 6개를 출력
## tail(데이터프레임명, 출력할 행의 개수)
tail(exam)
tail(exam, 2)

## View() 데이터프레임을 엑셀에서 시트와 같이 보여주는 함수
## V는 대문자로 사용
View(exam)

## dim() 데이터프레임의 사이즈를 출력
## 출력은 앞의 숫자는 행의 개수 뒤의 숫자 열의 개수
dim(exam)

## str() 데이터프레임의 속성 값을 출력
str(exam)

## summary() 통계 요약 정보 출력
summary(exam)
summary(exam$math)

## 파이프 연산자 %>% 단축키 Shift+Ctrl + M

## 함수들은 다중으로 사용을 할때 연결을 시켜주는 연산자

## filter() 필터링의 기능을 가진 함수
exam %>% filter(class == 1)

## arrange() 특정 컬럼을 기준으로 오름차순 내림차순 정렬하는 함수
## 오름차순이 기본값으로 정렬
exam %>% arrange(math)

## 내림차순 정렬
# case1
exam %>% arrange(desc(math))
# case2
exam %>% arrange(-math)

## 정렬의 기준을 다중으로 사용하려면 ,를 사용해서 기준 값을 늘려준다.
exam %>% arrange(math, english)

## select() 특정 컬럼을 출력하는 함수
exam %>% select(class)
exam %>% select(class, math)

## 특정 컬럼을 제거하고 출력
exam %>% select(-class)

## 컬럼의 범위를 지정
exam %>% select(math:science)

## mutate() 새로운 컬럼을 추가하는 함수
# case1
# 컬럼을 추가하여 exam에 삽입
exam <- exam %>% mutate(total = math + english + science)
# total 컬럼을 제외하고 exam 삽입
exam <- exam %>% select(-total)
exam
# case2(base 함수)
exam$mean <- exam$total/3
exam

## group_by() 컬럼의 값들은 기준으로 데이터를 집합화
## summarise() 동시 사용
## summarise() 사용하는 함수
# mean() : 평균
# sum() : 합계
# min() : 최소값
# max() : 최대값
# median() : 중앙값
# sd() : 표준편차
# n() : 빈도(개수)
exam %>% 
  group_by(class) %>% 
  summarise(mean = mean(math),
            sum = sum(math), 
            min = min(math),
            n = n())     ## n() 함수는 컬럼을 지정하지 않는다.

## -------------------- ggplot2 패키지 -------------------##
# 데이터 시각화

## ggplot2 설치
install.packages("ggplot2")
## ggplot2 로드
library(ggplot2)

## 산점도 그래프 (geom_point())
ggplot(data = mpg, aes(x = displ, y = hwy)) + 
  geom_point() + 
  xlim(3,6) +           ## x축 범위 지정
  ylim(10,20)           ## y축 범위 지정정

## 막대 그래프 ( geom_col(), geom_bar() )

# geom_col() x축과 y축을 둘 다 지정
mpg2 <- mpg %>% 
  group_by(drv) %>% 
  summarise(mean = mean(hwy))
mpg2
ggplot(data = mpg2, aes(x = drv, y = mean)) + geom_col()

## y축의 크기에 따라 x축의 순서를 변경

# 오름차순으로 순서
ggplot(data=mpg2, aes(x = reorder(drv, mean), y = mean)) + geom_col()

# 내림차순으로 순서
ggplot(data=mpg2, aes(x = reorder(drv, -mean), y = mean)) + geom_col()

# geom_bar() 컬럼의 데이터의 빈도 수를 막대의 크기로 표현하여 출력
ggplot(data=mpg, aes(x=drv)) + geom_bar()
# table() 컬럼의 빈도수 출력
table(mpg$drv)

# geom_line() 라인 그래프 출력
ggplot(data = economics, aes(x = date, y = unemploy)) + geom_line()

# geom_boxplot() 박스 플롯  출력
ggplot(data = mpg, aes(x = drv, y = hwy)) + geom_boxplot()

## ---------- 한국복지패널 데이터를 가지고 실습 -------------##

# .sav 확장자를 가진 파일 로드하기 위해 foreign 패키지 설치
install.packages("foreign")
# 패키지 로드
library(foreign)

raw_welfare <- read.spss(file = "Koweps_hpc10_2015_beta1.sav", 
                         to.data.frame = T)
dim(raw_welfare)

# 복사본 생성
welfare <- raw_welfare

# rename() 컬럼의 이름을 변경 
# rename(데이터프레임명, 변경 후 컬럼명 = 변경 시킬 컬럼명)
welfare <- rename(welfare, 
                  gender = h10_g3, 
                  birth = h10_g4, 
                  marriage = h10_g10, 
                  income = p1002_8aq1, 
                  code_job = h10_eco9)

# 컬럼 변경 후 확인
welfare %>% 
  select(gender, birth, marriage, income, code_job) %>% 
  head(5)

# 성별에 따른 월급의 차이가 존재하는가?
# 데이터를 시각화하여 확인

# 성별이라는 컬럼에 이상치가 존재하는지 확인
# 성별은 1,2값을 제외한 수치는 이상치
# 이상치를 확인할때는 table()
table(welfare$gender)

# 1은 남성 2는 여성 9는 무응답
# 이상치를 제거하는 코드 작성
# ifelse(조건식, 조건식인 참인경우 들어갈 값, 조건식이 거짓일 경우 들어갈 값)
welfare$gender <- ifelse(welfare$gender == 9, NA, welfare$gender)

# 결측치가 존재하는지 확인
# is.na()는 결측치 값을 True, 결측치가 아니면 False
# 결측치가 존재하지 않는다.
table(is.na(welfare$gender))

# 성별이 1이면 male, 2면 female 변경 
welfare$gender <- ifelse(welfare$gender == 1, "male", "female")

table(welfare$gender)

## 성별 데이터를 그래프 출력 geom_bar 빈도를 그래프 출력
# qplot()를 이용해도 같은 결과 출력
qplot(welfare$gender)

# 월급 이상치 0, 9999 데이터를 결측치로 변환

# case1 ( 월급이 0인경우 NA로 변경, 월급이 9999인 경우 NA로 변경, 둘다 아니라면 기존 값 유지)
welfare$income <- ifelse(welfare$income == 0, NA, 
                         ifelse(welfare$income == 9999, NA, welfare$income))
# case2
welfare$income <- ifelse(welfare$income == 0 | welfare$income == 9999, NA, welfare$income)

# case3 ( %in% 연산자를 이용하여 0이나 9999가 포함되어있으면 NA로 변경 )
welfare$income <- ifelse(welfare$income %in% c(0,9999), NA, welfare$income)

# 결측치 확인
table(is.na(welfare$income))

# 성별에 따른 월급차가 존재하는지 데이터를 생성
# 결측치를 제외
# 성별 그룹화
# 월급의 평균 출력
# 데이터를 시각화

# is.na() 결측치가 True -> 앞에 !를 붙이면 부정의 의미
# !is.na() 결측치가 False : 데이터가 존재하면 True
# income과 gender 둘다 결측치를 filter 
# gender는 결측치가 0 여서 필터에서 제외
welfare %>% 
  filter(!is.na(income)) %>%     ## 월급의 결측치를 제외
  group_by(gender) %>%           ## 성별을 기준으로 그룹화
  summarise(income_mean = mean(income))   ## 그룹화된 데이터 월급의 평균 값 출력

## console에서 데이터가 출력 -> 출력만이 존재 실제 데이터가 변수에 삽입 X
## 실제 변수를 지정

gender_income <- welfare %>% 
  filter(!is.na(income)) %>%     ## 월급의 결측치를 제외
  group_by(gender) %>%           ## 성별을 기준으로 그룹화
  summarise(income_mean = mean(income))   ## 그룹화된 데이터 월급의 평균 값 출력

## 변수에 삽입 -> 출력이 나오지 않는다.

gender_income

# 시각화 막대그래프로 표시(x와 y값을 둘다 표기 geom_col()을 사용)
ggplot(data = gender_income, aes(x = gender, y = income_mean)) + geom_col()

## 나이에 따른 월급의 차이가 존재하는가?
## 생년 컬럼은 존재, 나이라는 컬럼은 존재하지 않는다.
## 파생변수 age 생성.
## age 컬럼은 현재년도 - birth = 나이

# 생년에 이상치가 혹시 존재하면 제거.( 출생년도가 현재 년도보다 높으면 이상치 )
welfare$birth <- ifelse(welfare$birth > 2022, NA, welfare$birth)

# 결측치 확인
table(is.na(welfare$birth))
# 결측치 확인 결과 결측치는 존재하지 않는다. 

# age 파생변수 생성

# case1
welfare$age <- 2022 - welfare$birth

# case2
welfare <- welfare %>% 
  mutate(age = 2022 - birth)

table(welfare$age)

# 나이의 빈도수 그래프 출력
qplot(welfare$age)

# 나이라는 컬럼을 생성
# 월급, 나이 부분의 결측치를 제거
# 나이 컬럼은 결측치 존재 X
# 월급 부분만 결측치 제거
# 나이를 기준으로 그룹화
# 월급의 평균 값
# 시각화

age_income <- welfare %>% 
  filter(!is.na(income)) %>% 
  group_by(age) %>% 
  summarise(income_mean = mean(income))
age_income

# 바 그래프로 시각화
ggplot(data = age_income, aes(x = age, y =income_mean)) + geom_col()

# 라인 그래프로 시각화
ggplot(data = age_income, aes(x = age, y = income_mean)) + geom_line()

## 나이 컬럼을 생성
## 나이 컬럼을 기준으로 연령대라는 파생변수 생성
## 연령대별 월급의 차이가 나는가?
## 연령대 30세 미만 'young' 30세 이상 60세 미만 'middle' 60세 이상 'old'
## 새로운 컬럼의 이름은 ageg

## 파생변수 생성

# case1
# 두번째 ifelse 조건식에 welfare$age < 60 지정
# middle 조건은 30세 이상 60세 미만인데 조건은 하나만 적은 이유는?
# 첫 번째 ifelse에서 30세 미만은 'young' 변경을 했기 때문에
# 두 번째 ifelse 조건식에는 30세 이상의 데이터만 가지고 비교
welfare$ageg <- ifelse(welfare$age < 30, 'young', 
                       ifelse(welfare$age < 60, 'middle', 'old'))

# case2
welfare <- welfare %>% 
  mutate(ageg = ifelse(age < 30 , 'young', 
                       ifelse(age < 60, 'middle', 'old')))
table(welfare$ageg)

# 연령대 라는 파생변수를 생성 완료
# 연령대별 평균 월급을 출력
# 월급의 결측치와 연령대 결측치를 제거
# 연령대는 나이를 기준으로 파생변수 생성 
# 나이라는 컬럼에 결측치가 존재하지 않으므로
# 연령대도 결측치는 존재하지 않는다. 
# 월급의 결측치를 제거
# 연령대를 기준으로 그룹화
# 월급의 평균 출력
# 시각화

ageg_income <- welfare %>% 
  filter(!is.na(income)) %>% 
  group_by(ageg) %>% 
  summarise(income_mean = mean(income))
ageg_income

# 바 그래프 시각화
ggplot(data = ageg_income, aes(x = ageg, y = income_mean)) + geom_col()

# x축의 순서를 변경 ( young, middle, old )
# scale_x_discrete() 옵션은 이용하여 x축의 순서를 변경
ggplot(data = ageg_income, aes(x = ageg, y = income_mean)) + geom_col() +
  scale_x_discrete(limits=c('young', 'middle', 'old'))

# 그룹화 2개
# 연령대, 성별 기준으로 그룹화 평균 월급 출력
# 시각화

ageg_gender_income <- welfare %>% 
  filter(!is.na(income)) %>% 
  group_by(ageg, gender) %>% 
  summarise(income_mean = mean(income))
ageg_gender_income

## 바 그래프로 시각화
ggplot(data = ageg_gender_income, 
       aes(x = ageg, y = income_mean, fill = gender)) +   
  ##fill = 컬럼 : 해당 컬럼의 데이터를 색으로 구분한다.
  geom_col()

## 2개의 바를 분할하여 표시
ggplot(data = ageg_gender_income, 
       aes(x = ageg, y = income_mean, fill = gender)) +   
  ##fill = 컬럼 : 해당 컬럼의 데이터를 색으로 구분한다.
  geom_col(position = 'dodge') + 
  ## position = 'dodge' 는 그래프를 분리하여 표시
  scale_x_discrete(limits = c('young', 'middle', 'old'))

## 직업 별로 월급의 차이가 존재하는가?

# welfare 데이터에서 확인하면 code_job 존재
# job이라는 컬럼은 존재 X
# job은 Koweps_Codebook.xlsx 파일에 존재

# 엑셀 파일을 로드하기 위해서 readxl 패키지 설치
install.packages("readxl")
# 패키지 로드 
library(readxl)

# 엑셀파일에서 2번째 시트에 있는 자료를 로드
list_job <- read_excel("Koweps_Codebook.xlsx", sheet = 2, col_names = T)

# welfare 데이터프레임과 list_job 데이터프레임 결합
# 조건이 code_job 컬럼의 값이 같아야 결합
# 특정 조건은 기준으로 결합을 하는 함수를 join()
# left_join() : 왼쪽 데이터프레임은 기준으로 결합 : 
# 우측 데이터프레임에 조건에 맞지 않는 값이 있으면 그 행 자체를 출력 X
# inner_join() : 양쪽 데이터프레임이 기준으로 결합 : 
# 두 데이터프레임에 조건이 맞는 값들만 결합

table(welfare$code_job)
table(list_job$code_job)

## list_job code_job의 종류가 welfare code_job보다 많다.
# welfare 기준으로 하여 결합

# 기준은 by="컬럼명"으로 지정해준다.
welfare <- left_join(welfare, list_job, by="code_job")

# 결합 확인
table(welfare$job)
welfare %>% filter(!is.na(code_job)) %>% select(code_job, job) %>% head(10)

# 직업은 존재하지만 월급이 존재하지 않는 경우 확인
welfare %>% filter(!is.na(job) & is.na(income)) %>% select(job) %>% head(10)
dim(welfare %>% filter(!is.na(job) & is.na(income)) %>% select(job))

## 직업별 평균 월급 확인
## 월급이 존재하는데 직업이 없는경우는 존재 X
## 월급의 결측치를 제거
## job을 기준으로 그룹화
## 평균 월급 출력
## 시각화

job_income <- welfare %>% 
  filter(!is.na(income)) %>% 
  group_by(job) %>% 
  summarise(income_mean = mean(income))
head(job_income, 10)

## 바 그래프 표시
ggplot(data = job_income, aes(x = job, y = income_mean)) + geom_col()

# 바 그래프 90도 회전하여 표시
ggplot(data = job_income, 
       aes(x = job, y = income_mean)) + 
  geom_col() +
  coord_flip()

## 직업 중 평균 월급이 높은 상위 10개 직업만 출력
## 평균 월급(income_mean) 내림차순으로 정렬
## 상위에 있는 10개만 출력
top10 <- job_income %>% 
  arrange(desc(income_mean)) %>% 
  head(10)
top10

## 바 그래프로 시각화
ggplot(data = top10, 
       aes(x = job, y = income_mean)) +
  geom_col() +
  coord_flip()

## 그래프 월급의 순서대로 변경
ggplot(data = top10, 
       aes(x = reorder(job, income_mean), y = income_mean)) +
  geom_col() +
  coord_flip()

## 성별 직업의 빈도 체크 
## 상위 직업 10개를 출력
## 시각화

# 남성 직업 빈도수 상위 10개
# 직업의 결측치 제거, 성별이 남성 필터 작업
# 직업을 기준으로 그룹화
# n() 함수를 이용하여 빈도수 컬럼을 생성
# 빈도 수 내림차순 정렬
# 상위 10개를 추출

job_male <- welfare %>% 
  filter(!is.na(job) & gender == "male") %>% 
  group_by(job) %>% 
  summarise(n = n()) %>% 
  arrange(desc(n)) %>% 
  head(10)

job_male

## 바그래프로 시각화 (90도 회전) 빈도수에 따라 x축 순서를 변경
ggplot(data=job_male, aes(x= reorder(job, n), y = n)) + 
  geom_col() +
  coord_flip()

## 여성 직업 빈도수 상위 10개
## 남성과 같은 작업을 반복 gender == "female"로 변경

job_female <- welfare %>% 
  filter(!is.na(job) & gender == "female") %>% 
  group_by(job) %>% 
  summarise(n = n()) %>% 
  arrange(desc(n)) %>% 
  head(10)

job_female

## 바그래프로 시각화 (90도 회전) 빈도수에 따라 x축 순서를 변경
ggplot(data=job_female, aes(x= reorder(job, n), y = n)) + 
  geom_col() +
  coord_flip()

## ----------------- 인터렉티브 그래프 --------------- ##
# plotly, dygraphs 패키지 사용

# plotly 패키지 설치
install.packages("plotly")
# 패키지 로드
library(plotly)

## plotly패키지에 있는 ggplotly() 함수를 사용하여 그래프 출력
## ggplot() 함수를 이용하여 작업한 그래프를 ggplotly 대입
a <- ggplot(data = mpg, aes(x = displ, y = cty, col=drv)) + geom_point() 
ggplotly(a)

b <- ggplot(data = diamonds, aes(x = cut, fill=clarity)) + 
  geom_bar(position='dodge')
ggplotly(b)

## dygraphs 패키지 설치
install.packages('dygraphs')
## 패키지 로드
library(dygraphs)

## dygraphs를 이용해서 시계열 그래프를 출력
## xts 데이터 타입이 필요
library(xts)
eco <- xts(economics$unemploy, order.by = economics$date)
head(eco)

## dygraph() 함수를 이용하여 xts 데이터를 대입을 하면 그래프 완성
dygraph(eco)

## 만약에 2개의 라인이 존재하는 그래프
## xts 데이터에 컬럼을 추가하여 대입

eco_a <- xts(economics$psavert, order.by = economics$date)
eco_a
eco_b <- xts(economics$unemploy/1000, order.by = economics$date)
# 컬럼을 추가하는 함수 cbind()
eco_2 <- cbind(eco_a, eco_b)
head(eco_2)

## 컬럼이 2개인 xts 데이터를 dygraph() 대입하면 라인 2개의 그래프 출력
dygraph(eco_2)

## x축의 범위를 지정할수 있는 옵션 값
dygraph(eco_2) %>% dyRangeSelector()


## -------------------- 지도 시각화 ---------------- ##

#ggiraphExtra 패키지 설치
install.packages("ggiraphExtra")
# 패키지 로드
library(ggiraphExtra)

# 인덱스의 값에 컬럼명 부여하기 위하여 tibble 패키지 로드
library(tibble)

# 미국 주 별 강력 범죄율 
str(USArrests)
View(USArrests)

# tibble 패키지에 있는 rownames_to_column 함수를 이용하여
# 인덱스 값에 컬럼명을 부여
crime <- rownames_to_column(USArrests, var = "state")

head(crime)

# map에 있는 미국 지도 데이터에는 state가 소문자로 이루어져있다.
# crime에 있는 state의 값들을 소문자로 변경
crime$state <- tolower(crime$state)

head(crime)

# 지도 정보가 담겨있는 maps 패키지 로드
library(maps)

# 미국 지도 정보 로드
states_map <- map_data("state")
head(states_map)

# 지도 시각화
ggChoropleth(data = crime,    ## 지도에 표현할 데이터 지정
             aes(fill = Murder,    ##지도를 채울 데이터의 수치 지정
                 map_id = state),  ## 지역의 기준이 되는 변수 지정
             map = states_map,      ## 맵 데이터 지정
             interactive = T        ## 인터렉티브 그래프 출력
             )

## 한국 데이터로 지도 시각화

# kormaps2014 패키지를 설치
# CRAN에 있는 정식 패키지 X
# github 패키지를 다운

# devtools 패키지 설치
install.packages("devtools")
#kormaps2014 패키지 설치
devtools::install_github("cardiomoon/kormaps2014")

# 패키지 로드
library(kormaps2014)
## korpop1 : 시도별 인구 데이터
## kormap1 : 시도별 지도 데이터

str(korpop1)
View(korpop1)

korpop1 <- rename(korpop1, 
                  pop = 총인구_명, 
                  name = 행정구역별_읍면동)

ggChoropleth(data = korpop1, 
             aes(fill = pop, 
                 map_id = code, 
                 tooltip = name),
             map = kormap1, 
             interactive = T)

## ----------------- 상관 행렬 히트맵 출력 ------------ ##
head(mtcars)

# cor() 이용하여 상관 관계 행렬 출력
cor(mtcars)
# 상관 관계 1에 가까울 수록 비례
# 음수면 반비례

car_cor <- cor(mtcars)

# round() 이용하여 소수점 3번째 자리에서 반올림
car_cor <- round(car_cor, 2)

car_cor

# 상관 행렬 히트맵 그리기 위한 corrplot 패키지 로드
library(corrplot)
# 상관 행렬 히트맵 출력
corrplot(car_cor)

# method 속성을 이용하여 히트맵을 변경이 가능
# 속성 값은 (circle, square, ellipse, number, shade, color, pie)
corrplot(car_cor, method = "number")

# 히트맵 색을 변경하기 위해 색상 목록 코드 
col <- colorRampPalette(c("#BB4444", "#EE9988", 
                          "#FFFFFF", "#77AADD", 
                          "#4477AA"))

corrplot(car_cor, 
         method = "color",
         col = col(200),     ## 색상을 200개 선정
         type = "lower",  
         ## 행렬 표시 (upper, lower, full(기본값))
         order = "alphabet", 
         ## 상관 계수의 재 정렬 (AOE : 고유벡터 각 순서, 
         ##                     FPC : 첫 번째 주요 성분 순서, 
         ##                     hclust : 계층적 군집 순서
         ##                     alphabet : 알파벳 순서)
         addCoef.col = "black", ## 상관 계수의 색 지정
         tl.col = "black",      ## 변수명의 색 지정
         tl.srt = 45,           ## 변수명 표시 각 조절
         diag = F)              ## 대각 행렬의 제외 여부


## ----------------------- openapi의 데이터 csv 저장 ----------------- ##

# XML 데이터를 수정하기 위한 패키지 설치
install.packages("XML")
# 패키지 로드
library(XML)

# 환경부 국립환경과학원 미세먼지 데이터 
# 데이터는 서비스키만 필수 항목
# api 주소를 변수 명
url <- "http://apis.data.go.kr/1480523/MetalMeasuringResultService/MetalService"

# 서비스키 (필수 항목)
servicekey <- "dtbWOdJ%2FCz5HE0DGLU%2BCRPe7pOW0NIQBUcGEqsHZaTRiYCI%2F5%2BzugwzQjcvuId7NPdg6rUiW%2Bft3fm7yqyD4pw%3D%3D"

# api 접속 주소 ( url + servicekey )
# url에서 ?는 데이터의 시작을 알리고
# 데이터는 key=value 형태로 지정
service_url <- paste0(url, 
                      "?ServiceKey=", servicekey)
service_url

# openapi에 접속하여 데이터 받아오는 부분
xmlDocument <- xmlTreeParse(service_url, 
                            useInternalNodes = TRUE, 
                            encoding = "UTF-8")

# rootnode 확인
rootnode <- xmlRoot(xmlDocument)
rootnode

## 페이지당 데이터의 개수 출력
rows <- xpathSApply(rootnode, '//numOfRows', xmlValue)
rows

## 전체 데이터의 수 출력
total_rows <- xpathSApply(rootnode, '//totalCount', xmlValue)
total_rows

# rows와 total_rows는 둘다 문자형 타입
# 둘다 실수형 타입으로 변환 
# 두 값을 나눈 값을 출력
rows <- as.numeric(rows)
total_rows <- as.numeric(total_rows)

# 두 값을 나눈 값에 올림 처리
loopcount <- ceiling(total_rows/rows)
loopcount
# 페이지당 데이터를 10개씩 받아오면 loopcount만큼 반복해서 받아야
# 전체 데이터를 다 가지고 올 수 있다. 

# 결과 값들은 담아둘 비어있는 데이터프레임을 생성
Total_data <- data.frame()

for (i in 1:2){
  ## for문이 반복 될때마다 pageNo의 값을 변경하여 url로 구성
  service_url <- paste0(url, 
                        "?ServiceKey=",servicekey,
                        "&pageNo=", i)
  ## oepnapi에 접속 하여 데이터 로드
  document <- xmlTreeParse(service_url, 
                           useInternalNodes = TRUE, 
                           encoding = "UTF-8")
  
  # rootnode 확인
  rootnode <- xmlRoot(document)
  
  # item 태그 안에 있는 값들을 호출
  node <- getNodeSet(rootnode, '//item')
  
  # node의 값을 데이터프레임으로 변경
  df_node <- xmlToDataFrame(node)
  
  # 비어있는 데이터프레임 Total_data 결합
  Total_data <- rbind(Total_data, df_node)
  
}
dim(Total_data)
View(Total_data)
# 받아온 데이터를 csv 저장 (row.names라는 속성은 인덱스의 값을 저장 할지 여부)
write.csv(Total_data, "미세먼지.csv", row.names = F)


## ----------------- t검정 ------------------- ##

# 성별 월급의 차이가 존재할까?
# 귀무가설 : 월급 차가 없다
test <- welfare %>% 
  filter(!is.na(income)) %>% 
  select(gender, income)
dim(test)

## 등분산인지 확인 lawstat 패키지 로드
library(lawstat)

## p-value 0.05보다 작기 때문에 등분산 X
## 등분산인지 확인을 한 이유는 
## t.test에서 val.equal가 T인지 F인지를 확인
levene.test(test$income, test$gender, location = 'mean')

# p-value의 값이 0.05보다 작다. 
# 그러므로 성별간의 평균 월급에 차이는 있다. 
# 추론 
t.test(data = test, 
       income ~ gender,
       var.equal = F)





