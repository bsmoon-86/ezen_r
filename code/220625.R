library(ggplot2)
library(dplyr)
mpg <- as.data.frame(ggplot2::mpg)
## mpg 데이터프레임에서 특정컬럼 class, cty만 선택하여
## class 의 값이 `compact`, `suv`인 값만 출력
mpg_diff <- mpg %>% select(class, cty) %>% 
  filter(class %in% c('compact', 'suv'))

head(mpg_diff)
table(mpg_diff$class)

## t.test()를 이용하여 t검정 결과 출력
# t.test(data = data명, 컬럼명~기준컬럼(그룹화할 컬럼명), var.equal = T)
t.test(data = mpg_diff, cty~class, var.equal = T)
# 결과 값에서 p-value가 0.05보다 낮다.
# 집단간의 차이가 통계적으로 유의하다. 
# sample estimates class 기준으로 각 항목들의 평균값 출력

#t.test(data1, data2, var.equal = T)
data1 <- mpg_diff %>% filter(class == "compact") %>% 
  select(cty)
data1

data2 <- mpg_diff %>% filter(class == "suv") %>% 
  select(cty)
t.test(data1, data2, var.equal = T)

test_df <- read.csv("t_test.csv")
head(test_df)
table(test_df$group)
## 가설
## 대구와 서울의 학생들의 키의 평균이 같은가?

# 정규성 가정 확인
# shairo.test() 함수를 이용하여 정규성을 확인
# p-value가 0.05 기준으로 정규성 판단
# 대구 지역의 그룹의 정규성 확인
shapiro.test(test_df[test_df$group == "Deagu",]$height)
# p-value가 0.05보다 크기 때문에 정규성 판단 : 만족

# 서울 지역의 그룹의 정규성 확인
shapiro.test(test_df[test_df$group == "Seoul",]$height)
# p_value가 0.05보다 크기 때문에 정규성 판단 : 만족
# 서울 과 대구의 정규성은 만족.

# 등분산성 가정 확인
# 등분산성 확인을 위한 패키지 설치
install.packages('lawstat')
library(lawstat)

# levene.test()함수를 이용하여 등분산성 검정 체크
levene.test(test_df$height, test_df$group, location = 'mean')
# p-value가 0.05보다 크기 때문에 
# 두 그룹의 분산은 동일하다고 판단

# t 검정 
# 두 그룹에서 평균의 키가 같다. 
# 같지 않다. 

t.test(data = test_df, 
       height ~ group, 
       var.equal = T    #두 그룹의 분산이 동일한가?
       )
# p-value : 0.002911 
# p-value 0.05보다 작다. -> 가설은 기각
# 대구 지역의 평균 키와 서울 지역의 평균 키가 같지 않다.
# 라는 결론이 나오게 됩니다. 
# 대구 지역이 서울 지역에 비해 키가 크다고 예상.


