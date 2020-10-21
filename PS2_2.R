# Set working dir
setwd("C:/users/99707/Desktop/Assignment/R_Assignment02")
# Load the libraries
library(tidyr)
library(dplyr)
library(ggplot2)

#2
Keeling_Data <- read.csv("2281305.csv",header=T)
Wind_data <- as_tibble(Keeling_Data)
# Check the class
class(Wind_data)
# Check the variables
head(Wind_data)
#�Է�����ڵ���Ϣ���в�ִ���
Wind          <- Wind_data         %>%
     select(WND,DATE)
Wind_value    <- separate(Wind,WND,into=c("direction_angle","quality_code","tyre_code","speed_rate","speed_code"),sep = ",")
Wind_value1   <- separate(Wind_value,DATE,into=c("year","month","day_hour"),sep = "-")
Wind_value2   <- separate(Wind_value1,day_hour,into=c("day","hour"),sep = "T")
#������Ҫ����Ϣ��������ȫ��Ϊ1��
wind_data1    <- Wind_value2      %>%
  select(year,month,day,speed_rate,speed_code)
wind_data2    <- wind_data1       %>%
  mutate(day_mean = 1)
#��������ƴ�ӣ������µ�һ�� 
wind_ymd  <-  wind_data2          %>%
      mutate(year_month_day=paste(year,month,day_mean,sep="-")) 
    
wind_ymd                          %>%
  select(year,year_month_day,speed_rate,speed_code)          %>%
  filter((speed_code=="1")|(speed_code=="5")|(speed_code=="0")|(speed_code=="4") )  %>%  #��ʶֵΪ0 1 4 5��Ϊ������
  group_by(year_month_day)        %>%
  summarize(mean_speed_rate = mean(as.numeric(speed_rate)))  %>%
  ggplot(aes(x=as.Date(year_month_day,format='%Y-%m-%d'), y=as.numeric(mean_speed_rate))) + 
  labs(x='Year-Month',y='Mean_Monthy-Wind(m/s)') +
  geom_point() +
  geom_line()
