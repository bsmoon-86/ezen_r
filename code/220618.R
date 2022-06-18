
install.packages(c("hash", "tau", "Sejong", "RSQLite", "devtools", "bit", "rex", "lazyeval", "htmlwidgets","crosstalk", "promises", "later", "sessioninfo", "xopen", "bit64", "blob", "DBI", "memoise", "plogr", "covr", "DT", "rcmdcheck", "rversions"),type="binary")

install.packages("remotes")
remotes::install_github('haven-jeon/KoNLP', upgrade="never", 
                        INSTALL_opts=c("--no-multiarch"))

install.packages("multilinguer")
library(multilinguer)
install.packages("dplyr")
library(KoNLP)
library(dplyr)

useNIADic()

# 파일 로드 
txt <- readLines("hiphop.txt")
head(txt)

# 특수문자를 제거하기 위해 패키지 로드
library(stringr)

# str_raplace_all(변수명, '변경 시킬 단어', '변경이 될 단어')
# 특수문자를 공백으로 변경
txt <- str_replace_all(txt, "\\W", " ")

# extractNoun() -> 텍스트에서 명사를 추출.
extractNoun("대한민국의 영토는 한반도와 그 부속도서로 한다.")

# 텍스트 문서에서 명사를 추출
nouns <- extractNoun(txt)
typeof(nouns)

# 추출한 리스트를 문자열 백터로 변환, 단어별로 빈도표를 생성
wordcount <- table(unlist(nouns))
wordcount

# 빈도수 데이터를 데이터프레임의 형태로 변경
df_word <- as.data.frame(wordcount, stringsAsFactors = F)
View(df_word)

# 컬럼의 이름을 변경. rename()
df_word <- rename(df_word, 
                  word = Var1, 
                  freq = Freq)

# 글자 수가 2개 이상인 값들만 필터링.
# nchar() 글자의 길이를 리턴하는 함수
df_word <- filter(df_word, nchar(word) >= 2)

# 이 데이터프레임에서 단어의 빈도 수가 높은 상위 20개를 출력
top20 <- df_word %>% 
  arrange(desc(freq)) %>% 
  head(20)

top20

# 워드클라우드 설치
install.packages("wordcloud")
library(wordcloud)
library(RColorBrewer)

# 색상 목록 로드 
# brewer.pal() 색상 가지고 온다. 
# Dark2 색상 목록에서 8개를 추출
pal <- brewer.pal(8, "Dark2")
pal

#난수가 랜덤하게 배정이 되는데 이 부분은 고정할 수 있는 함수
set.seed(123)
wordcloud(words = df_word$word, #단어
          freq = df_word$freq,  #빈도
          min.freq = 2,         #최소 단어 빈도
          max.words = 200,      #워드클라우드에 표현이 될 단어의 수
          random.order = F,     #빈도가 높은 단어를 중앙 배치
          rot.per = .1,         #단어의 회전 비율
          scale = c(4, 0.3),    #단어 크기의 범위
          colors = pal          #색상 목록
          )

# twitter.csv 파일 로드
twitter <- read.csv("twitter.csv",header = T, fileEncoding = "UTF-8")
head(twitter)

# 데이터프레임의 컬럼이 이름 변경
twitter <- rename(twitter, 
                  no = 번호, 
                  id = 계정이름, 
                  date = 작성일, 
                  tw = 내용)

# 특수문자 공백으로 대체 (내용이라는 컬럼이 데이터)
twitter$tw <- str_replace_all(twitter$tw, "\\W", " ")
head(twitter)

typeof(twitter$tw)
## tw의 타입이 character 아니면 
twitter$tw <- as.character(twitter$tw)



## tw라는 컬럼에 있는 데이터들을 명사로 추출
nouns <- extractNoun(twitter$tw)

## nouns  타입을 백터 형태로 변경하고 빈도 수를 출력
wordcount <- table(unlist(nouns))
wordcount
# 데이터 타입을 데이터프레임으로 변경
wordcount <- as.data.frame(wordcount)
# 컬럼이 이름을 변경
wordcount <- rename(wordcount, 
                    word = Var1, 
                    freq = Freq)
typeof(wordcount$word)

## wordcount$word 데이터 타입이 character가 아니면 character 형으로 변경
wordcount$word <- as.character(wordcount$word)

# 타입이 character 형이 실행이 가능
wordcount <- filter(wordcount, nchar(word) >= 2)
# 글자수가 2개 이상인 값들 중에 빈도 수가 높은 상위 20개를 출력
top20 <- wordcount %>% 
  arrange(desc(freq)) %>% 
  head(20)
top20

# Blues 색상표에서 9개 추출
pal <- brewer.pal(9, 'Blues')[5:9]
pal

set.seed(1234)
wordcloud(words = wordcount$word, 
          freq = wordcount$freq, 
          min.freq = 2, 
          max.words = 200, 
          random.order = F, 
          rot.per = .1, 
          scale = c(6, 0.5), # 
          colors = pal)



