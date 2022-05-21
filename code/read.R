df = read.csv('test.csv')
if(df[(names(df) %in% "interesRate")] != "0"){
  print(names(df[(names(df) %in% "interesRate")]))
}


files = dir(pattern = "csv")
i=1
df_crawling = data.frame()
while(i <= length(files)){
  df = read.csv(files[i])
  i = i + 1
  price_over100_row = min(which((df$price>100)))
  #interesRate컬럼이 있는지 확인하고 0이 아닌 경우는 컬럼이 존재한다는 뜻
  #0인 경우에는 next를 이용하여 반복문 처음으로 돌아갑니다. 
  #next가 가장 마지막에 있기 때문에 사용하지 않아도 됩니다. 
  if(length(df[(names(df) %in% "interesRate")]) != 0){  
    print(df["interesRate"])  
    
    temp = df[price_over100_row, "interesRate"]
    
    df_crawling = rbind(df_crawling, temp)
    
    print(df_crawling)
  }else{
    next
  }
}