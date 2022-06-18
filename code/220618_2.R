install.packages("ggiraphExtra")
library(ggiraphExtra)
library(ggplot2)

# 미국 주별 강력 범죄율 정보
head(USArrests)
str(USArrests)

library(tibble)
# tibble 패키지 안에 rownames_to_column() 함수를 이용해서 
# 행의 이름을 state 변경
crime <- rownames_to_column(USArrests, var = "state")

# USArrests 데이터 안에 있는 state 컬럼의 값을 소문자로 다 통일
crime$state <- tolower(crime$state)

str(crime)
View(crime)

# 미국의 주 별 위,경도 데이터가 들어있는 maps 패키지.
install.packages("maps")

states_map <- map_data("state")
str(states_map)
View(states_map)

ggChoropleth(data = crime, #지도에 표현이 될 데이터의 값
             aes(fill = Murder, #색깔로 표현이 될 변수
                 map_id = state # 지역 지군 변수
                 ),
             map = states_map,   #지도 데이터
             interactive = T
             )

# 한국 시도별 인구가 어떻게 되는지 지도 시각화

install.packages("devtools")
devtools::install_github("cardiomoon/kormaps2014")
library(kormaps2014)

# korpop1 : 2014년도 기준 인구 데이터(시도별)
# korpop2 : 2014년도 기준 인구 데이터(시군구별)
# korpop3 : 2014년도 기준 인구 데이터(읍면동별)
# kormap1 : 2014년도 한국 행정 지도(시도별)
# kormap2 : 2014년도 한국 행정 지도(시군구별)
# kormap3 : 2014년도 한국 행정 지도(읍면동별)
str(korpop1)
View(korpop1)

library(dplyr)
korpop1 <- rename(korpop1, 
                  pop = 총인구_명, 
                  name = 행정구역별_읍면동)

# 한글 깨짐 현상 시 인코딩의 형식을 UTF-8에서 CP949로 변경
korpop1$name <- iconv(korpop1$name, "UTF-8", "CP949")

ggChoropleth(data = korpop1, 
             aes(fill = pop,
                 map_id = code, 
                 tooltip = name),
             map = kormap1,
             interactive = T)

## 인구 수가 아니라 결핵 환자 수 정보
str(tbc)
View(tbc)
tbc$name <- iconv(tbc$name, 'UTF-8', 'CP949')
tbc@name1  <- iconv(tbc$name1 , 'UTF-8', 'CP949')

ggChoropleth(data = tbc, 
             aes(fill = NewPts, 
                 map_id = code, 
                 tooltip = name),
             map = kormap1,
             interactive = T)


#----------------------------------------------------------#

# 인터렉티브 그래프
# plotly, dygraphs 2개의 패키지를 사용해서 그래프를 작성

# plotly 설치
install.packages("plotly")
library(plotly)
library(ggplot2)

# plotly를 이용해서 인터렉티브 그래프를 그리는 방법
# ggplot을 이용해서 그래프를 완성. 
# -> ggplotly() 함수에 넣으면 인터랙티브 그래프가 완성.
a <- ggplot(data = mpg, aes(x = displ, y = hwy, col = drv)) + geom_point()
ggplotly(a)

p <- ggplot(data = diamonds, aes(x=cut, fill = clarity)) + 
  geom_bar(position="dodge")
ggplotly(p)

# dypraphs 패키지 설치
install.packages("dygraphs")
library(dygraphs)

head(economics)

# dygraphs 그래프를 그릴때 시계열 데이터(xts) 데이터타입 변경
library(xts)
eco <- xts(economics$unemploy, order.by = economics$date)
head(eco)

dygraph(eco)

dygraph(eco) %>% dyRangeSelector()

eco_a <- xts(economics$psavert, order.by = economics$date)
eco_b <- xts(economics$unemploy/1000, order.by = economics$date)

head(eco_a)
head(eco_b)

eco2 <- cbind(eco_a, eco_b)
head(eco2)

colnames(eco2) <- c("psavert", "unemploy")
head(eco2)

dygraph(eco2) %>% dyRangeSelector()




