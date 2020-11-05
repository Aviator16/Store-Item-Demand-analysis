#Reduced combination analysis

setwd("/media/aviator/Everything/Projects/Demand Analysis/Dataset")

library(dplyr)
library(astsa)
library(forecast)
library(stats)
library(Metrics)
library(lubridate)

dem_data=read.csv("train.csv")
dem_data$date=ymd(dem_data$date)
#data of only 2017
fcast_data=dem_data[format(dem_data$date,'%Y')=="2017",]
#data before 2017
dem_data=dem_data[format(dem_data$date,'%Y')!="2017",]

setwd("/media/aviator/Everything/Projects/Demand Analysis")
mod.info=read.csv("models_info_final.csv")
accu.info=read.csv("pred_accu_info_final.csv")
rep.frame=read.csv("replace_frame_no2017.csv")

#Complete set accuracy scores:
frmse=sum(accu.info$RMSE_score)/500
fmape=sum(accu.info$MAPE_score)/500
fmae=sum(accu.info$MAE_score)/500
print(paste("While considering all combinations, finale RMSE is",frmse,"and final MAPE is",fmape,"and final MAE is",fmae))


cnt=1
for(i in 1:50){
  for(s in 1:10){
    if(cnt<=41){
      if(s==rep.frame$store[cnt] & i==rep.frame$item[cnt]){
        if(rep.frame$rep_store[cnt]!=0){
          rs=rep.frame$rep_store[cnt]
          tmp1=filter(mod.info,(Item.no==i & Store.no==rs))
          tmp.model<-ts(filter(dem_data,(item==i & store==rs))$sales)
          model.aic=arima(log(tmp.model),order = c(tmp1$NS.ar,0,tmp1$NS.ma),seasonal=list(order=c(tmp1$S.ar,1,tmp1$S.ma),period=7))
          
          forecast.aic=predict(model.aic,90)$pred
        }
        else if(rep.frame$rep_item[cnt]!=0){
          ri=rep.frame$rep_item[cnt]
          tmp1=filter(mod.info,(Item.no==ri & Store.no==s))
          tmp.model<-ts(filter(dem_data,(item==ri & store==s))$sales)
          model.aic=arima(log(tmp.model),order = c(tmp1$NS.ar,0,tmp1$NS.ma),seasonal=list(order=c(tmp1$S.ar,1,tmp1$S.ma),period=7))
          
          forecast.aic=predict(model.aic,90)$pred
          
        }
        model.actual=ts(filter(fcast_data,(item==i & store==s))$sales)
        logfcast=log(model.actual)
        
        #measuring accuracy of prediction
        m1=rmse(as.numeric(unlist(forecast.aic[1:90])),as.numeric(unlist(logfcast[1:90])))
        
        m2=mape(as.numeric(unlist(forecast.aic[1:90])),as.numeric(unlist(logfcast[1:90])))
        
        m3=mae(as.numeric(unlist(forecast.aic[1:90])),as.numeric(unlist(logfcast[1:90])))
        
        accu.info[accu.info$Store.no==s & accu.info$Item.no==i,]$RMSE_score=exp(m1)
        accu.info[accu.info$Store.no==s & accu.info$Item.no==i,]$MAPE_score=m2
        accu.info[accu.info$Store.no==s & accu.info$Item.no==i,]$MAE_score=exp(m3)
        cnt=cnt+1
      }
    }
  }
}

#Reduced set accuracy scores:
frmse=sum(accu.info$RMSE_score)/500
fmape=sum(accu.info$MAPE_score)/500
fmae=sum(accu.info$MAE_score)/500
print(paste("While considering REDUCED combinations, finale RMSE is",frmse,"and final MAPE is",fmape,"and final MAE is",fmae))
