## 텍스트마이닝 KoNLP 패키지를 설치하기 위해서 부수적인 패키지 설치 
install.packages(c("hash", "tau", "Sejong", "RSQLite", "devtools", 
                   "bit", "rex", "lazyeval", "htmlwidgets", "crosstalk", 
                   "promises", "later", "sessioninfo", "xopen", "bit64", 
                   "blob", "DBI", "memoise", "plogr", "covr", "DT", "rcmdcheck", 
                   "rversions"), type = "binary")
install.packages("multilinguer")
library(multilinguer)
## KoNLP 패키지 설치
install.packages("remotes")
remotes::install_github('haven-jeon/KoNLP', upgrade = "never",
                        INSTALL_opts=c("--no-multiarch"))

## 패키지 로드
library(KoNLP)
library(dplyr)

## 사전정보 로드(로드는 최초의 한번만 실행) 
useNIADic()

## 예제 파일 로드
txt <- readLines("hiphop.txt")
head(txt)

# 특수문자를 제거하기 위해서 stringr 패키지 로드
library(stringr)

# 특수문자 제거
# str_replace_all() 값은 치환해주는 함수
txt <- str_replace_all(txt, "\\W", " ")

head(txt)

# txt에서 명사를 추출 extraNoun()
nouns <- extractNoun(txt)
head(nouns)

typeof(nouns)

# 추출한 nouns 타입이 list
# 문자열 백터로 변환
# 단어별 빈도 표 생성
wordcount <- table(unlist(nouns))
wordcount

# wordcount 데이터프레임 형태로 변경
df_word <- as.data.frame(wordcount, stringsAsFactors = F)
View(df_word)

# 컬럼의 이름은 변경
df_word <- rename(df_word, 
                  word = Var1, 
                  freq = Freq)

# 글자의 수가 2자리 이상인 값들만 출력
# nchar()함수는 글자의 길이를 출력하는 함수
df_word <- filter(df_word, nchar(word) >= 2)

# 단어의 빈도수가 높은 상위 20개를 출력 
# freq를 기준으로 내림차순 정렬
# 상위 20개를 출력
top20 <- df_word %>% 
  arrange(desc(freq)) %>% 
  head(20)
top20

# 워드 클라우드설치
install.packages("wordcloud")
# 패키지 로드
library(RColorBrewer)
library(wordcloud)

# 색상 목록 추출
# Dark2 항목에서 8개의 색상을 추출
pal <- brewer.pal(8, "Dark2")

# 난수는 랜덤하게 지정
# set.seed() 함수를 이용해서 고정된 값을 추출
set.seed(1234)
# 워드클라우드 출력
wordcloud(word = df_word$word, ## 단어 리스트
          freq = df_word$freq, ## 빈도 수
          min.freq = 2,        ## 최소 단어의 빈도수
          max.words = 200,     ## 워드클라우드 표현될 단어의 수
          random.order = F,    ## 고빈도 글자의 중앙 배치 여부
          rot.per = .1,        ## 회전 단어의 비율
          scale = c(2, 0.3),   ## 워드 클라우드 사이즈
          color = pal)         ## 글자 색상


