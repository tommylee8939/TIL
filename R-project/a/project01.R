library(ggplot2)
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
  geom_text(aes(x=as.Date('2020-03-30'),y=720),label='1st wave')
  
  

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
  facet_wrap(~구분,ncol=3,scales = 'free_x')




