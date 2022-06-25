## api사용해서 데이터를 받아오는 과정 
## api -> url 서버에서 요청 - 
## 서버에서 요청 주소를 확인해서 그에 걸맞는 데이터를 리턴

## XML 데이터형태로 데이터를 받겠다. XML 전처리 하기 위한 패키지 설치
install.packages("XML")
library(XML)

# 접속을 해야될 url 주소
serviceURL <- "http://apis.data.go.kr/1160100/service/GetFnCoBasiInfoService/"

# 오퍼레이션명
operation <- "getFnCoOutl"

# 서비스키(인증키)
ServiceKey <- "dtbWOdJ%2FCz5HE0DGLU%2BCRPe7pOW0NIQBUcGEqsHZaTRiYCI%2F5%2BzugwzQjcvuId7NPdg6rUiW%2Bft3fm7yqyD4pw%3D%3D"

## 페이지의 위치 지정
pageNo <- 1

## 페이지당 얻게 되는 데이터의 개수
rows <- 10

## 추출 데이터 포멧 지정
type_data_format <- "xml"

## 최종적으로 url 완성(현재 지정한 변수들은 연결 시켜준다.)
## url에 데이터를 담아서 보내는 과정
## serviceKey -> 서버 운영 입장 -> servicekey 존재하지 않으면 
## 누구든지 서버 접속해서 데이터를 받아가는데 서버에는 트래픽.
## 트래픽 과부화가 되면 서버에 다운. 이런 경우는 미연에 방지하기 위해
## 특정인들만 접속을 할 수 있게 만들어논 키.
## 서버 요청 servicekey 체크 -> serviceKey 유효하면 데이터를 리턴
## 유효하지 않은 serviceKey 라면 error 리턴
## ex 'error' 문자열을 리턴 , 실제 data 리턴 하는것에 용량의 차이가 무시를 못할 정도?
## 일일 트래픽 
## serviceKey 회원가입 같다 회원인 사람만 데이터를 보내주겠다. 
# pageNo, numOfRows 요청한 사람이 데이터를 몇개가 필요한지 물어보는 부분
# resultType -> json, xml 요청하는 사람이 원하는 데이터타입 물어보는 부분
url <- paste0(serviceURL, 
              operation, 
              paste0("?serviceKey=",ServiceKey),
              paste0("&pageNo=", pageNo),
              paste0("&numOfRows=",rows),
              paste0("&resultType="), type_data_format)
)
url

## 오픈 API에 호출
xmlDocument <- xmlTreeParse(url, 
                            useInternalNodes = TRUE, 
                            encoding = "UTF-8")
xmlDocument
## 현재 오픈 api를 이용하여 데이터를 10개 받아온 상황
## 데이터의 총 개수는 75만개 
## 1페이지부터 75000페이지까지 한번씩 호출을 하여 데이터를 받아 온 뒤
## 받아온 값들은 전부 결합하면 데이터를 다 받았다고 할 수 있습니다. 

## xml root node값 확인
rootNode <- xmlRoot(xmlDocument)
rootNode

## 오픈 api 호출 결과 데이터의 개수를 확인
## 결과 값이 문자형이기 때문에 숫자의 형태로 형태를 변환
numOfRows <- as.numeric(xpathSApply(rootNode, "//numOfRows", xmlValue))
typeof(numOfRows)

## 전체 데이터의 개수 확인
totalCount <- as.numeric(xpathSApply(rootNode, "//totalCount", xmlValue))
typeof(totalCount)

## totalCount -> 25 , numOfRows -> 10 이라면 두 값은 나눈 값은 2.5
## 전체 데이터를 다 받으면 3번 반복 나눈값에 올림처리 3을 만들어주는 작업
## 총 오픈 api를 몇번 불러와야되는가.? 
## 계산을 하기위해 numOfRows와 totalCount를 받아왔습니다. 
## (totalCount / numOfRows)의 값이 소수점으로 나오게 된다면 올림처리를 해서 횟수를 1회 증가
loopCount <- ceiling(totalCount / numOfRows)
loopCount

## 비어있는 데이터프레임 생성
TotalData <- data.frame()

##10번 반복 10이라는 숫자를 loopCount 변경을 해주면 오픈 api의 
##데이터를 전부 가지고 올 수 있다. 
for (i in 1:10){            
  url <- paste0(serviceURL, 
                operation, 
                paste0("?serviceKey=", ServiceKey),
                paste0("&pageNo=", i),   ## i로 넣어줘야 페이지를 1번 부터 10번까지 데이터를 호출
                paste0("&numOfRows=", rows),
                paste0("&resultType=", type_data_format))
  
  #오픈 api 호출
  document <- xmlTreeParse(url,
                           useInternalNodes = TRUE, 
                           encoding = "UTF-8")
  # XML 데이터의 rootNode 호출
  rootNode <- xmlRoot(document)
  
  # item Node의 데이터를 추출
  node <- getNodeSet(rootNode, "//item")
  
  # 데이터를 데이터프레임의 형태로 변경
  xmlData <- xmlToDataFrame(node)
  
  # 추출한 데이터를 위에서 생성한 빈 데이터프레임에 결합
  # rbind() 함수는 데이터프레임 결합(열을 추가)
  TotalData <- rbind(TotalData, xmlData)
}

# TotalData 크기를 확인
dim(TotalData)

# api에서 받은 파일을 csv 파일로 저장.
write.csv(TotalData, "openapi.csv", row.names = FALSE)






