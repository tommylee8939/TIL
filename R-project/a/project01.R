library(ggplot2)
theme_set(theme_gray(base_family="AppleGothic"))

corona <- read.csv('../data/코로나동향.csv',header = T)

corona_new <- corona[,seq(1,53,2)]
# sum 
corona_new$합계 <- apply(corona_new[,-1],1,sum)

# date format
corona_new$`자치구.기준일`<- as.Date(corona_new$`자치구.기준일`,format = '%Y.%m.%d')

# exclude only sum and date
corona_new <- corona_new[,c(1,28)]

# 날짜 정렬 
corona_new <- corona_new[seq(519,1,-1),]
# 5월31일 기준으로 맞춤
corona_new<- corona_new[corona_new$자치구.기준일<as.Date("2021-06-01"),]
tail(corona_new)

distancing_x <- c(as.Date('2020-3-22'),as.Date('2020-11-24'),as.Date('2020-12-08'),as.Date('2021-02-15'))
distnacing_y <- corona_new$합계[corona_new$자치구.기준일 %in% distancing_x]
distancing_text <- c('level 1','level 2','level 2.5','level 2')

ggplot(data = corona_new,aes(x=자치구.기준일,y=합계)) + 
  geom_line(size=0.5) +
  scale_x_date(date_breaks = '1 week',date_labels = "%Y-%m-%d",limits = )+
  theme(text = element_text(size=5),
        axis.text.x=element_text(angle =- 90, vjust = 0.5)) +
  scale_y_continuous(limits = c(0,750))+
  geom_vline(xintercept = c(as.Date('2020-08-12'),as.Date('2020-11-13'),as.Date('2021-02-28')),lty='dashed')+
  geom_text(aes(x=as.Date('2021-01-04'),y=700),label='3rd wave') +
  geom_text(aes(x=as.Date('2020-09-28'),y=700),label='2nd wave') +
  geom_text(aes(x=as.Date('2020-12-08'),y=distnacing_y[3]),label='level2.5',hjust=0, vjust = 2,nudge_y = 0.7,size=2)+
  geom_point(aes(x=as.Date('2020-12-08'),y=distnacing_y[3]),col='red')
#geom_text(aes(x=distancing_x,y=distnacing_y),label=distancing_text,hjust=0, vjust = 0,nudge_y = 0.7,size=2)


data<- read.csv('../data/data.csv',encoding = 'UTF-8')
colnames(data)<-c('날짜','호선','역번호','역명','구분','-06','06-07','07-08','08-09','09-10','10-11','11-12','12-13','13-14','14-15','15-16','16-17','17-18','18-19','19-20','20-21','21-22','22-23','23-','요일')
data$합계 <-apply(data[,6:24],1,sum)
data$날짜 <- as.Date(data$날짜,format = '%Y-%m-%d')
head(data)
tail(data)

data_distancing <- data[data$날짜>=as.Date('2020-02-28'),]

head(data_distancing)

result <- aggregate(합계~날짜,data_distancing,sum)


p<-ggplot(data=result,aes(x=날짜,y=합계))+
  geom_col(size=0.5)+
  scale_x_date(date_breaks = '1 week',date_labels = "%Y-%m-%d",limits = )+
  theme(text = element_text(size=5),
        axis.text.x=element_text(angle =- 90, vjust = 0.5))





colnames(corona_new) <- c('날짜','확진자 합계')

total_data <- merge(result,corona_new)


