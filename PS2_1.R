# Set working dir
setwd("C:/users/99707/Desktop/Assignment/R_Assignment02")
# Load the libraries
library(tidyr)
library(dplyr)
library(ggplot2)

#1.1
Keeling_Data <- read.table("signif.txt",sep="\t",header=T,quote="")   #quote=""�������ǽ�������
Sig_Eqs      <- as_tibble(Keeling_Data)
# Check the class
class(Sig_Eqs)
# Check the variables
head(Sig_Eqs)

#1.2
Sig_Eqs                                            %>%  
  select(COUNTRY,TOTAL_DEATHS)                     %>%  
  filter(TOTAL_DEATHS!="NA")                       %>%  #�޳���������δ֪�ĵ���
  group_by(COUNTRY)                                %>%
  summarise(COUNTRY_TOTAL_DEATHS=sum(TOTAL_DEATHS))%>%  #�������������֮��
  arrange(desc(COUNTRY_TOTAL_DEATHS))              %>%  #��������
  head(n=10L)                                           #���ǰ10��

#1.3
#ɸѡ������ȼ�����6����ݣ������ۼӵ������
YEAR_times <- Sig_Eqs                            %>%    
   filter(EQ_PRIMARY > 6.0)                      %>%    #����ȼ�����6������Ϊ1������Ϊ��
   mutate(times = ifelse(EQ_PRIMARY>6.0,1,0))    %>%
   select(YEAR,EQ_PRIMARY,times)                 %>%
   group_by(YEAR)                                %>%
   summarise(total_times = sum(times))           %>%
   select(YEAR,total_times)
YEAR_times                                       %>%
   ggplot(aes(x=YEAR, y=total_times)) + 
   geom_point()

#1.4
Sig_Eqs[is.na(Sig_Eqs)] <- 0                            #��NAֵȫ��ֵΪ0

total_times_country <- Sig_Eqs                   %>%    #�õ�ÿ�����ҵ��������������յ���������С����
  select (YEAR, MONTH, DAY, COUNTRY, DEATHS, EQ_PRIMARY) %>%
  group_by(COUNTRY)                              %>%
  mutate(times = 1)                              %>%
  summarise(total_earthquake = sum(times))       %>%
  arrange(desc(total_earthquake))
#������
total_times_country

maxEq_country       <- Sig_Eqs                   %>%    #�õ�ÿ������������ȼ�
  select( COUNTRY, EQ_PRIMARY)                   %>%
  group_by(COUNTRY)                              %>%
  summarize(MAX_Eq = max(EQ_PRIMARY)) 
#������
maxEq_country 

all_data            <- Sig_Eqs                   %>%    #�����������ݴ���һ��������
  select(COUNTRY,EQ_PRIMARY,YEAR,MONTH,DAY)

CountEq_LargestEq   <-  function(n){
  for(i in 1:nrow(total_times_country)){                #nrow(total_times_country)Ϊ��������
    #����������������������⣨1��
    if (total_times_country[i,1] == n ){
      T_earthquake <- total_times_country[i,2]          #��������ܶ�Ӧ�ϣ��������Ӧ�ĵ�������
      print(paste0(n,'�ĵ�������Ϊ��',T_earthquake))
    }
    #Ȼ������һ�������ʷ��������������ڣ������⣨2��
    if(maxEq_country[i,1] == n ){
      for(j in 1:nrow(all_data)){
        if(all_data[j,1] == n && 
           all_data[j,2] == maxEq_country[i,2])
        {
          print(paste0('�������𼶣�',maxEq_country[i,2],',' ,'�����������ڣ�',
                       all_data[j,3],'��',all_data[j,4],'��',
                       all_data[j,5],'��'))
        }
      }
    }
  }
}
 
 #���Ժ�������
 CountEq_LargestEq("CHINA")
 #���յ��������������ÿ�����ҵĵ�����������������������
 for(i in 1:nrow(total_times_country)){       
   test    <- total_times_country[i,1]
   print(CountEq_LargestEq(test))
 }

 
 