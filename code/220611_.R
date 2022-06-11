install.packages("foreign")

library(foreign)
library(dplyr)
library(ggplot2)
library(readxl)
# 한국복지패널 데이터 로드
# foreign 패키지는 read.spss()함수를 사용해서 sav파일 로드를 
# 하기 위해서 foreign 패키지 설치
raw_welfare <- read.spss(file = "Koweps_hpc10_2015_beta1.sav", 
                         to.data.frame = T)
# 원본데이터는 유지를 하고 복사본 만들어서 작업
welfare <- raw_welfare

# 데이터의 구조, 특성 확인
head(welfare)
tail(welfare)
View(welfare)
# 데이터의 사이즈
dim(welfare)
# 데이터의 구조, 변수 개수, 변수 이름,...
str(welfare)
summary(welfare)

# 데이터의 컬럼의 이름을 변경을 하는 함수는 ? -> 
# rename(dataframe명, 컬럼명 = 변경되는 컬럼이 이름, ....)
welfare <- rename(welfare, 
                  gender = h10_g3, 
                  birth = h10_g4, 
                  marriage = h10_g10, 
                  religion = h10_g11, 
                  income = p1002_8aq1, 
                  code_job = h10_eco9, 
                  code_region = h10_reg7)

## 성별에 따른 월급의 차이 어떻게 되는지? 데이터로 확인 시각화

# 성별에 이상치가 존재를 하는지?
table(welfare$gender)

# 이상치 처리 결측치
welfare$gender <- ifelse(welfare$gender == 9, NA, welfare$gender)

# 결측치의 개수를 출력
table(is.na(welfare$gender))
# 결측치의 개수는 0

# 성별 컬럼의 값들에 이름을 부여 ( 1 : male, 2: female)
welfare$gender <- ifelse(welfare$gender == 1, "male", "female")
table(welfare$gender)

# 성별 그래프로 출력
qplot(welfare$gender)

summary(welfare$income)

# 이상치 결측 처리 (0, 9999 데이터를 결측치 변경.)
welfare$income <- ifelse(welfare$income %in% c(0,9999), 
                         NA, welfare$income)
# 결측치 확인
table(is.na(welfare$income))

# 결측치의 값을 제외 ->
# 성별로 그룹화 -> 
# 월급의 평균 값을 구해서 데이터프레임 완성

gender_income <- welfare %>% 
  filter(!is.na(income)) %>%   
  # 결측치를 제거 / 월급을 받지 않는 사람들도 제외
  group_by(gender) %>% 
  summarise(mean_income = mean(income))

gender_income

#데이터프레임 완성 -> 시각화
ggplot(data = gender_income, 
       aes(x = gender, y = mean_income)) + geom_col()

### birth컬럼이 존재 태어난 년도
### 나이와 월급의 관계 시각화
### 나이컬럼이 존재 x
### 파생변수 age 생성
### age 그룹화 평균 월급이 어떻게 되는지 데이터프레임을 생성
### line 그래프로 출력

summary(welfare$birth)
qplot(welfare$birth)


# 이상치를 결측처리 (현재 년도보다 높은 생년은 존재할 수 없다)
welfare$birth <- ifelse(welfare$birth > 2022, 
                        NA, welfare$birth)

table(is.na(welfare$birth))

# age라는 파생변수 생성 (현재년도 - 출생년도 + 1)
welfare$age <- 2022 - welfare$birth + 1
summary(welfare$age)
qplot(welfare$age)

# 월급의 값이 존재하는 데이터에서 
# 나이를 통해서 그룹화 월급 평균

age_income <- welfare %>% 
  filter(!is.na(income)) %>% 
  group_by(age) %>% 
  summarise(mean_income = mean(income))

head(age_income)

ggplot(data = age_income, 
       aes(x = age, y = mean_income)) + geom_line()

## 나이 컬럼을 추가. ( 나이를 기준으로 연령대 컬럼을 추가)
## 연령대별 월급의 평균
## 연령대 나누는 기준 30살 미만 'young'
## 30살 이상 - 60살 미만 'middle',
## 60살 이상 'old' 
## ageg 파생변수를 생성
## ageg 기준으로 그룹화해서 월급 평균 시각화

# ageg 파생변수를 생성.(dplyr 패키지를 이용하여 생성) 
welfare <- welfare %>% 
  mutate(ageg = ifelse(age < 30, "young", 
                       ifelse(age < 60, "middle", "old")))
table(welfare$ageg)

ageg_income <- welfare %>% 
  filter(!is.na(income)) %>% 
  group_by(ageg) %>% 
  summarise(mean_income = mean(income))

ageg_income

#연령별 월급 데이터프레임 시각화 바그래프
ggplot(data = ageg_income, 
       aes(x = ageg, y = mean_income)) + geom_col()

# 연령별 월급의 평균 그래프에서 x축 순서를 변경
ggplot(data = ageg_income, 
       aes(x = ageg, y = mean_income)) + geom_col() 
+ scale_x_discrete(limits = c("young", "middle", "old"))

## 연령대별, 성별 월급이 어떻게 되는지 시각화

# 연령대 컬럼을 추가 성별 컬럼도 존재.
# 연령대와 성별을 그룹화 평균 월급의 값을 바형 그래프 시각화 
# 그래프의 순서는 'young', 'middle', 'old'

# 월급에 값이 존재하는 부분만 필터링 -> 그룹화
gender_income <- welfare %>% 
  filter(!is.na(income)) %>% 
  group_by(ageg, gender) %>% 
  summarise(mean_income = mean(income))

gender_income

# fill=gender 속성을 이용해서 각 그래프의 색을 다르게 하여 표시
ggplot(data=gender_income, 
       aes(x = ageg, y= mean_income, fill=gender)
       ) + geom_col() + scale_x_discrete(limits=c("young", "middle", "old"))

# 그래프 2개를 분리시켜서 보여주고 싶다면 
# position='dodge'를 이용하면 중첩이 되는 바를 분리할수 있다.
ggplot(data = gender_income, 
       aes(x=ageg, y=mean_income, fill = gender)
      ) + geom_col(position = 'dodge') + scale_x_discrete(limits=c('young', 'middle', 'old'))

## 나이별 성별 월급이 어떻게 되는지 
## 라인그래프

age_income <- welfare %>% 
  filter(!is.na(income)) %>% 
  group_by(age, gender) %>% 
  summarise(mean_income = mean(income))

head(age_income)
## 나이별 성별 평균 월급 바그래프 출력
ggplot(data=age_income, 
       aes(x = age, y = mean_income, fill=gender)
       ) + geom_col(position='dodge')
## 나이별 성별 평균 월급 라인 그래프
## 라인그래프 2개의 값을 분리 시켜주려면 
## color=컬럼명 을 이용하여 라인을 분리 할수 있다. 
ggplot(data=age_income, 
       aes(x = age, y = mean_income, color=gender)
) + geom_line()

## 직업별 평균 월급 시각화 
## job_code컬럼이 존재 -> 숫자형태의 직업 지정
## Koweps_Codebook.xlsx 파일에 code에 맞는 직업에 대한 이름이 존재
## 엑셀 파일을 로드 welfare 데이터프레임에 join
## 위에서 반복적으로 작업했던 부분을 다시 한번 실행

table(welfare$code_job)
#readxl 패키지는 엑셀 파일을 로드하기 위한 패키지
list_job <- read_excel("Koweps_Codebook.xlsx", sheet = 2, col_names = T)
head(list_job)

## 기존의 데이터프레임인 welfare에 left_join함수를 이용해서 
## list_job데이터프레임 결합. 
welfare <- left_join(welfare, list_job, id='code_job')

# 데이터가 정상적으로 결합이 되었는지 체크
welfare %>% 
  filter(!is.na(code_job)) %>% 
  select(code_job, job) %>% 
  head(10)

## 직업별로 월급의 평균을 출력
job_income <- welfare %>% 
  filter(!is.na(job) & !is.na(income)) %>% 
  group_by(job) %>% 
  summarise(mean_income = mean(income))
dim(job_income)
head(job_income)

## 직업별 평균 월급에 상위 10, 하위 10개를 출력 시각화
## 상위 10개를 출력하려면? -> 
## mean_income을 기준으로 하여 내림차순 정렬을 한 후 head(10) ->
## 상위 10개
## tail(10) 하위 10개

top10 <- job_income %>% 
  arrange(desc(mean_income)) %>% 
  head(10)
top10

bottom10 <- job_income %>% 
  arrange(desc(mean_income)) %>% 
  tail(10)
bottom10

ggplot(data = top10, 
       aes(x = job, y=mean_income)
       ) + geom_col() + coord_flip()

ggplot(data = bottom10, 
       aes(x = job, y = mean_income)
       ) + geom_col() + coord_flip()

