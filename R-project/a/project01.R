library(ggplot2)
library(reshape)
library(dplyr)
library(gridExtra)
theme_set(theme_gray(base_family="AppleGothic"))

covid <- read.csv('../data/코로나동향.csv',header = T)
covid$`자치구.기준일`<- as.Date(covid$`자치구.기준일`,format = '%Y.%m.%d')
colnames(covid) <- gsub('\\.',' ',colnames(covid))

covid_new <- covid[,seq(1,53,2)]            
covid_new$합계 <- apply(covid_new[,-1],1,sum)
covid_new <- covid_new[,c(1,28)]
covid_new <- covid_new[seq(518,1,-1),]
row.names(covid_new) <- c()
covid_new <- covid_new %>% filter(`자치구 기준일`<=as.Date('2021-05-31'))
colnames(covid_new) <- c('날짜','합계')
tail(covid_new)

metro<- read.csv('../data/data.csv',encoding = 'UTF-8')
colnames(metro)<-c('날짜','호선','역번호','역명','구분','-06','06-07','07-08','08-09','09-10','10-11','11-12','12-13','13-14','14-15','15-16','16-17','17-18','18-19','19-20','20-21','21-22','22-23','23-','요일')
metro$합계 <-apply(metro[,6:24],1,sum)
metro$`날짜`<-as.Date(metro$`날짜`,format = '%Y-%m-%d')
metro <- metro %>% filter(날짜 >=as.Date('2020-02-28'))  %>% group_by(날짜) %>% 
  summarize(일별총이용량 = sum(합계))
metro <- as.data.frame(metro)
colnames(metro) <- c('날짜','합계')
head(metro)

distancing_x <- c(as.Date('2020-3-22'),as.Date('2020-11-24'),as.Date('2020-12-08'),as.Date('2021-02-15'))
distancing_y <- covid_new$합계[covid_new$`자치구 기준일` %in% distancing_x]
distancing_text <- c('level 1','level 2','level 2.5','level 2')
distancing <- data.frame(xvalue=distancing_x,yvalue=distancing_y)

ggplot(data = covid_new,aes(x=`날짜`,y=합계)) + 
  geom_line(size=0.5,col='tomato') +
  geom_point(data=distancing,aes(x=xvalue,y=yvalue),col='blue')+
  geom_text(data=distancing,aes(x=xvalue,y=yvalue),label=distancing_text,hjust=0, vjust = 2,nudge_y = 0.7,size=2)+
  scale_x_date(date_breaks = '1 week',date_labels = "%Y-%m-%d" )+
  scale_y_continuous(limits = c(0,750))+
  theme(text = element_text(size=5),
        axis.text.x=element_text(angle =- 90, vjust = 0.5)) +
  geom_vline(xintercept = c(as.Date('2020-02-28'),as.Date('2020-05-05'),as.Date('2020-08-12'),as.Date('2020-11-13'),as.Date('2021-02-28')),lty='dashed')+
  geom_text(aes(x=as.Date('2021-01-04'),y=720),label='3rd wave') +
  geom_text(aes(x=as.Date('2020-09-28'),y=720),label='2nd wave')+
  geom_text(aes(x=as.Date('2020-03-30'),y=720),label='1st wave')+
  ggtitle('2020-02-28~2021-05-31/n 서울시 코로나 일별 확진자 변화')
  
  

metro$구분 ='이용량'
covid_new $구분 ='확진자'
rbind(metro,covid_new)

ggplot(data = rbind(metro,covid_new),aes(x=날짜,y=합계,col=구분))+
  geom_line()+
  ggtitle('확진자에 따른 지하철 이용량 추이')+
  facet_grid(구분~.,scales='free')



## 11월 24일 전후 30일 비교

thirty_days_before<-metro[metro$날짜 %in% c(as.Date('2020-11-24')-30:1),]
thirty_days_after<-metro[metro$날짜 %in% c(as.Date('2020-11-24')+1:30),]


thirty_days_before$구분<- '30일 전'
thirty_days_after$구분<- '30일 후'
thirty_days<-rbind(thirty_days_before,thirty_days_after)
thirty_days$평일주말 <-weekdays(thirty_days$날짜,abbr=TRUE)
thirty_days$평일주말<-ifelse((thirty_days$평일주말=='Sat')|(thirty_days$평일주말=='Sun'),'주말','평일')


ggplot(data=thirty_days,aes(x=날짜,y=합계,fill=평일주말))+
  geom_col()+facet_wrap(~구분,ncol=2,scales = 'free_x')+
  scale_x_date(date_breaks = '1 day',date_labels = "%a")+
  ggtitle('2020년 11월 24일\n9시 영업 제한 전후 30일 지하철 이용량')+
  theme(text = element_text(size=5),
        axis.text.x=element_text(angle =- 90, vjust = 0.5))

# 30일 전후를 기준으로 모든 역들이 이동량이 다 감소한건지 
# 아니면 특정 역의 이동량이 감소한건지
# 각 역 기준 시간대별 승하차 합치자

metro_each_station<- read.csv('../data/data.csv',encoding = 'UTF-8')
metro_each_station$역명<-gsub("\\([^)]*\\)","",metro_each_station$역명)
total_station<- metro_each_station[metro_each_station$날짜==as.Date('2019-01-01'),][c('호선','역명')]
total_station_df<-unique(total_station)
row.names(total_station_df)<-c()
total_station_df



metro_each_station$합계 <-apply(metro_each_station[,6:24],1,sum)
metro_each_station<-metro_each_station %>% group_by(날짜,호선,역명) %>% summarise(합계=sum(합계))
metro_each_station<-as.data.frame(metro_each_station)
metro_each_station$날짜<-as.Date(metro_each_station$날짜,format='%Y-%m-%d')
str(metro_each_station)

usage_decreased <- list()
usage_decreased 


for (i in c(1:nrow(total_station_df))){
  line_number = total_station_df$호선[i]
  station_name = total_station_df$역명[i]

  thirty_days_before<-metro_each_station[metro_each_station$날짜 %in% c(as.Date('2020-11-24')-30:1),]
  thirty_days_before<-thirty_days_before[(thirty_days_before$호선==line_number)&(thirty_days_before$역명==station_name),]
  thirty_days_after<-metro_each_station[metro_each_station$날짜 %in% c(as.Date('2020-11-24')+1:30),]
  thirty_days_after<-thirty_days_after[(thirty_days_after$호선==line_number)&(thirty_days_after$역명==station_name),]
  
  if(wilcox.test(thirty_days_after$합계,thirty_days_before$합계,alt='less')[3]<0.05){
    usage_decreased[[i]]<-c(line_number,station_name)
  }
}

usage_decreased 

# 2021년 3월 5월 이용량
# 2020년 3월 5월 이용량
# 2019년 3월 5월 이용량

metro_total<- read.csv('../data/data.csv',encoding = 'UTF-8')
colnames(metro_total)<-c('날짜','호선','역번호','역명','구분','-06','06-07','07-08','08-09','09-10','10-11','11-12','12-13','13-14','14-15','15-16','16-17','17-18','18-19','19-20','20-21','21-22','22-23','23-','요일')
metro_total$합계 <-apply(metro_total[,6:24],1,sum)
metro_total$`날짜`<-as.Date(metro_total$`날짜`,format = '%Y-%m-%d')
metro_total<-metro_total %>% group_by(날짜) %>% summarise('합계'=sum(합계))
metro_total <-as.data.frame(metro_total)

metro_total$구분 <- strftime(metro_total$날짜,'%Y')
metro_total$평일주말 <-weekdays(metro_total$날짜,abbr=TRUE)
metro_total$평일주말<-ifelse((metro_total$평일주말=='Sat')|(metro_total$평일주말=='Sun'),'주말','평일')
index = (metro_total$날짜>=as.Date('2019-03-01')&metro_total$날짜<=as.Date('2019-05-31'))|(metro_total$날짜>=as.Date('2020-03-01')&metro_total$날짜<=as.Date('2020-05-31'))|(metro_total$날짜>=as.Date('2021-03-01')&metro_total$날짜<=as.Date('2021-05-31'))
metro_total<-metro_total[index,]

ggplot(data=metro_total,aes(x=날짜,y=합계,fill=평일주말))+
  geom_col()+
  facet_wrap(~구분,ncol=3,scales = 'free_x')+
  ggtitle('2019년,2020년,2021년 3월~5월 지하철 총 이용량')




#구별 일일 확진자 추가

covid_new_by_distinct<-covid[,seq(1,53,2)] 
colnames(covid_new_by_distinct)<-c('날짜',gsub("추가","",colnames(covid_new_by_distinct)[-1]))
covid_new_by_distinct<-covid_new_by_distinct[,-27]


ggplot(melt(covid_new_by_distinct,
            id.vars = 1),aes(x=날짜,y=value))+
  geom_col() + facet_wrap(~variable)


# 구별 누적 확진자 그래프

covid_new_cumulate<-covid[,c(1,seq(2,53,2))] 
colnames(covid_new_cumulate)<-c('날짜',gsub("전체","",colnames(covid_new_cumulate)[-1]))
covid_new_cumulate <- covid_new_cumulate[-27]
covid_new_cumulate

library(RColorBrewer)
colorRampPalette(brewer.pal(10, "BrBG"))(26)

ggplot(melt(covid_new_cumulate,
            id.vars = 1),aes(x=날짜,y=value,col=variable))+
  geom_line() + scale_color_manual(values=colorRampPalette(brewer.pal(10, "BrBG"))(26))




# 특정 하루의 변동폭은 의미없다 => 평일 주말에 따라 달라지고 사회적 거리두기 시행 유무에 따라 달라진다
 
metro_each_station %>% group_by(날짜) %>% top_n(n=10) %>% head(100) # 날짜별 이용객수 

# 2019년 3월~5월 2021년 3월~5월 평균 이용객 감소량

# 5호선 미사,하남검단사, 하남시청,하남풍산,강일
# 6호선 연신내
# 6호선 신내()
# 3호선 충무로(183)

data<-metro_each_station %>% 
  filter((날짜>=as.Date('2019-03-01')&날짜<=as.Date('2019-05-31'))|(날짜>=as.Date('2021-03-01')&날짜<=as.Date('2021-05-31'))) %>% 
  mutate(구분 = strftime(날짜,format='%Y')) %>% 
  group_by(구분,호선,역명) %>% 
  summarise(평균 = mean(합계)) %>% 
  arrange(호선,역명)

data<-as.data.frame(data)
data<-data[-c(183,340,341,342,285,242,389,398),]
row.names(data)<-c()

data_2019 <- data[seq(1,550,2),]
row.names(data_2019)<-c()

data_2021 <- data[seq(2,550,2),]
row.names(data_2021)<-c()

result <-data.frame(호선=data_2021$호선,역명=data_2021$역명,감소율=(data_2019$평균 - data_2021$평균)/data_2019$평균*100)
result <- result %>% arrange(desc(감소율))
result

# result를 지도로 시각화 => 별 의미가 없는거 같다 

library(devtools)
install_github('dkahle/ggmap')
library(ggmap)

api.key = "AIzaSyCgDWC7eGJBeHTi9mWBf04i-ek_pNDeKOg"
register_google(api.key)
gg_seoul<-get_googlemap('seoul',maptype = 'roadmap',zoom = 11)

most_decreased<-result[1:50,]
station_name <- paste(paste(most_decreased$호선,most_decreased$역명),'역',sep = '')
loction <- geocode(enc2utf8(station_name))
location_df<-data.frame(most_decreased,lon=loction$lon,lat=loction$lat)
location_df[42,]$lon <-127.009529
location_df[42,]$lat <-37.5703848
location_df <- location_df[1:20,]

ggmap(gg_seoul)+
  geom_point(data=location_df,aes(x=lon,y=lat))+
  geom_text(data=location_df,aes(x=lon,y=lat),label=location_df$역명,family="AppleGothic",size=2,vjust=2,col='red')



