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
       aes(x = reorder(job, mean_income) , y=mean_income)
       ) + geom_col() + coord_flip()

ggplot(data = bottom10, 
       aes(x = reorder(job, -mean_income), y = mean_income)
       ) + geom_col() + coord_flip()

## 성별 직업의 빈도 체크
# 상위 직업 10개 남자, 여자 출력

# 남자의 직업 빈도수 랭킹 10
# 직장이 존재, 성별이 male인 데이터를 필터링
# job 컬럼을 기준으로 그룹화
# 빈도 수 체크 함수(n()함수를 사용)
# 빈도 수 내림차순 정렬
# 상위 10개 출력

job_male <- welfare %>% 
  filter(!is.na(job) & gender == "male") %>% 
  group_by(job) %>% 
  summarise(count = n()) %>% 
  arrange(desc(count)) %>% 
  head(10)

job_male

## 여자의 직업 빈도수 랭킹 10
job_female <- welfare %>% 
  filter(!is.na(job) & gender == "female") %>% 
  group_by(job) %>% 
  summarise(count = n()) %>% 
  arrange(desc(count)) %>% 
  head(10)

job_female

## job_male, job_female 값들을 바 그래프 출력

ggplot(data=job_male, 
       aes(x = job, y = count))+ geom_col() + coord_flip()

## 그래프의 값이 상위 10개이기 때문에 그래프의 순서를 변경
ggplot(data=job_male, 
       aes(x = reorder(job, count), y = count))+ geom_col() + coord_flip()

## female 기준으로 그래프 출력

ggplot(data=job_female, 
       aes(x = reorder(job, count), y = count)) + geom_col() + coord_flip()

## 종교의 유무에 따라 이혼율이 관계가 있을까?
## 종교를 가진 사람 데이터의 이혼율 
## 종교를 가지지 않은 사람의 데이터의 이혼율

table(welfare$religion)

# religion 컬럼의 1은 yes 2는 no
welfare$religion <- ifelse(welfare$religion == 1, 'yes', 'no')

table(welfare$religion)
qplot(welfare$religion)

# 이혼여부 파생 변수
# 0:미성년, 1:기혼, 2:사별, 3:이혼, 4:별거, 5:미혼, 6:기타
table(welfare$marriage)

welfare$group_marriage <- ifelse(welfare$marriage == 1, "marriage", 
                          ifelse(welfare$marriage == 3,"divorce", NA))
table(welfare$group_marriage)
table(is.na(welfare$group_marriage))

## 종교 컬럼을 전처리 / 이혼 여부 파생변수를 생성

## 이혼 여부의 값이 존재할 경우
## 종교 여부와 이혼 여부를 기준으로 그룹화
## 빈도 수 체크해서 컬럼에 삽입
## 빈도 수의 합을 총 빈도 수 컬럼에 삽입
## 빈도 수 / 총 빈도수 * 100 -> 이혼율 컬럼에 삽입
## 이혼율 컬럼에 값을 소수점 1자리까지 유지하고 반올림

religion_marriage <- welfare %>% 
  filter(!is.na(group_marriage)) %>% 
  group_by(religion, group_marriage) %>% 
  summarise(count = n()) %>% 
  mutate(tot_group = sum(count)) %>% 
  mutate(pct = round(count/tot_group*100, 1))

religion_marriage

## 종교 별 이혼율 어떤지 시각화
## religion_marriage 데이터에서 필요한 부분
## group_marriage 값이 divorce 부분 에서 
## 컬럼의 값은 religion, pct

divorce <- religion_marriage %>% 
  filter(group_marriage == "divorce") %>% 
  select(religion, pct)

divorce

ggplot(data = divorce, aes(x=religion, y = pct)) + geom_col()

## 연령대별 이혼율 출력
# 연령대(ageg)컬럼과 결혼여부(group_marriage) 컬럼의 값을 기준으로 그룹화
# 빈도 수(n()) count 파생변수 를 생성
# 결혼 여부 의 총 빈도수 tot_group 파생변수
# 이혼율 pct 파생변수 생성
# 시각화

ageg_marriage <- welfare %>% 
  filter(!is.na(group_marriage)) %>% 
  group_by(ageg, group_marriage) %>% 
  summarise(count = n()) %>% 
  mutate(tot_group = sum(count)) %>% 
  mutate(pct = round(count/tot_group*100, 1))

ageg_marriage

# 결혼의 상태가 이혼이고 초년생들을 제외
ageg_divorce <- ageg_marriage %>% 
  filter(ageg != "young" & group_marriage == "divorce") %>% 
  select(ageg, pct)

ageg_divorce

ggplot(data = ageg_divorce, aes(x = ageg, y = pct)) + geom_col()

## 연령대, 종교 유무, 이혼율 분석
# group_marriage에 결측치 제외
# 그룹화 ageg, religion, group_marriage
# 빈도 수
# 총 빈도 수 tot_group 생성
# pct 이혼율 생성

ageg_religion_marriage <- welfare %>% 
  filter(!is.na(group_marriage) & ageg != "young") %>% 
  group_by(ageg, religion, group_marriage) %>% 
  summarise(count = n()) %>% 
  mutate(tot_group = sum(count)) %>% 
  mutate(pct = round(count/tot_group*100, 1))

ageg_religion_marriage

# 이혼 상태인 데이터 출력

ageg_religion_divorce <- ageg_religion_marriage %>% 
  filter(group_marriage == "divorce") %>% 
  select(ageg, religion, pct)

ageg_religion_divorce

ggplot(data = ageg_religion_divorce, 
       aes(x=ageg, y=pct, fill=religion)) + geom_col()

# 바를 분리하여 그래프 표시

ggplot(data = ageg_religion_divorce, 
       aes(x=ageg, y=pct, fill=religion)) + geom_col(position="dodge")

list_region <- data.frame(code_region = c(1:7),
                          region = c("서울",
                                     "수도권(인천/경기)",
                                     "부산/경남/울산",
                                     "대구/경북",
                                     "대전/충남",
                                     "강원/충북",
                                     "광주/전남/전북/제주"))
list_region
## welfare 데이터프레임에 list_region 데이터프레임 결합 
## 공통적인 값 code_region

welfare <- left_join(welfare, list_region, id = "code_gerion")
welfare %>% 
  select(code_region, region) %>% 
  head()

## 지역별 연령대가 어떻게 구성이 되어있는지를 확인
## 그룹화 지역과 연령대
## 연령대의 빈도 수를 count컬럼 생성 삽입
## 총 빈도 수 컬럼 (tot_group) 생성 지역별 총 빈도수 삽입
## 각 연령별 지역의 비율 (count / tot_group * 100) 소수점 없애고 반올림
## 바 그래프 출력 

table(welfare$region)
table(is.na(welfare$region))

region_ageg <- welfare %>% 
  filter(!is.na(welfare$region)) %>% 
  group_by(region, ageg) %>% 
  summarise(count = n()) %>% 
  mutate(tot_group = sum(count)) %>% 
  mutate(pct = round(count/tot_group*100, 0))

region_ageg  
  
ggplot(data = region_ageg, 
       aes(x = region, y = pct, fill = ageg)
       ) + geom_col() + coord_flip()

ggplot(data = region_ageg, 
       aes(x = region, y = pct, fill = ageg)
) + geom_col(position = 'dodge') + coord_flip()
  
## 지역 코드의 순서대로 변경.
## scale_x_discrete() 옵션을 사용해서 x축을 순서 변경
## c("지역명", ..) 적어줘도 무관

order <- list_region$region
order

ggplot(data = region_ageg, 
       aes(x = region, y = pct, fill = ageg)
) + geom_col() + coord_flip() + scale_x_discrete(limits = order)

## 노년층의 비율이 높은 순으로 막대그래프 정렬

list_order_old <- region_ageg %>% 
  filter(ageg == "old") %>% 
  arrange(pct)
list_order_old

order <- list_oeder_old$region

ggplot(data = region_ageg, 
       aes(x = region, y = pct, fill = ageg)
) + geom_col() + coord_flip() + scale_x_discrete(limits = order)

## 바형 그래프 바의 순서를 변경
class(region_ageg$ageg)
levels(region_ageg$ageg)


## factor 범주형 데이터형

region_ageg$ageg <- factor(region_ageg$ageg, 
                           level = c("old", "middle", "young"))
class(region_ageg$ageg)
levels(region_ageg$ageg)
## factor 형태의 데이터에 level을 지정해주고 
## 그래프를 바형 그래프를 그리면 level의 순서대로 그래프가 그려진다. 
ggplot(data = region_ageg, 
       aes(x = region, y = pct, fill = ageg)
) + geom_col() + coord_flip() + scale_x_discrete(limits = order)

## 노년이 가장 많은 순서대로 그래프 지역이 표시
## 초년이 가장 많은 순서대로 그래프 표시

list_order_young <- region_ageg %>% 
  filter(ageg == "young") %>% 
  arrange(pct)
list_order_young

order <- list_order_young$region

ggplot(data = region_ageg, 
       aes(x = region, y = pct, fill = ageg)
) + geom_col() + coord_flip() + scale_x_discrete(limits = order)

