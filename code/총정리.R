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



