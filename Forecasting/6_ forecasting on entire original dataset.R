#Computations on entire dataset

setwd("/media/aviator/Everything/Projects/Demand Analysis/Dataset")
dem_data=read.csv("train.csv")

#removing data of 2017 and keeping only 2017 data for prediction purpose
library(lubridate)
dem_data$date=ymd(dem_data$date)
#data of only 2017
fcast_data=dem_data[format(dem_data$date,'%Y')=="2017",]
#data before 2017
dem_data=dem_data[format(dem_data$date,'%Y')!="2017",]

library(dplyr)
library(astsa)
library(forecast)
library(stats)
library(Metrics)

#Models in dataframe
models.info=data.frame(Store.no=NULL,Item.no=NULL,NS.ar=NULL,NS.diff=NULL,NS.ma=NULL,S.ar=NULL,S.diff=NULL,S.ma=NULL,AIC.value=NULL,SSE.value=NULL)
pred.accu.info=data.frame(Store.no=NULL,Item.no=NULL,RMSE_score=NULL,MAPE_score=NULL,MAE_score=NULL)

for(s in 1:10){
  for(i in 1:50){
    
    cat('store=',s,' item=',i,'\n')
    tmp.model<-ts(filter(dem_data,(item==i & store==s))$sales)
   
    #trying different models
    ap=0;aq=0;aP=0;aQ=0;sp=0;sq=0;sP=0;sQ=0;
    d=0
    DD=1
    aic=1000000; ss=1000000; order.1=NULL; order.2=NULL;
    per=7
    
    for(p in 2:5){
      for(q in 2:5){
        for(h in 2:8){
          for(j in 2:3){
            if(p+d+q+h+DD+j<=10){
              #cat(p-1,d,q-1,h-1,DD,j-1,'\n')
              model<-try(arima(x=(log(tmp.model)), order = c((p-1),d,(q-1)), seasonal = list(order=c((h-1),DD,(j-1)), period=per)))
              if(class(model)=="try-error"){next()}
              pval<-Box.test(model$residuals, lag=log(length(model$residuals)))
              sse<-sum(model$residuals^2)
              #cat(p-1,d,q-1,h-1,DD,j-1,per, 'AIC=', model$aic, ' SSE=',sse,' p-VALUE=', pval$p.value,'\n')
              if (model$aic<aic){
                aic=model$aic
                order.1=c((p-1),d,(q-1),(h-1),DD,(j-1),per)
                ap=p-1;aq=q-1;aP=h-1;aQ=j-1;
              }
              if (sse<ss){
                ss=sse
                order.2=c((p-1),d,(q-1),(h-1),DD,(j-1),per)
                #sp=p-1;sq=q-1;sP=h-1;sQ=j-1;
              }
            }
          }
        }
      }
    }
    print(paste("Order with lowest aic is",list(order.1),"with aic value",aic))
    print(paste("Order with lowest sse is",list(order.2),"with sse value",ss))
    
    tmp.si=data.frame(Store.no=s,Item.no=i,NS.ar=ap,NS.diff=0,NS.ma=aq,S.ar=aP,S.diff=1,S.ma=aQ,AIC.value=aic,SSE.value=ss)
    models.info=rbind(models.info,tmp.si)
    
    #Forecasting
    #using aic models for forecasting to reduce computation time
    model.aic=arima(log(tmp.model),order = c(ap,0,aq),seasonal=list(order=c(aP,1,aQ),period=7))
    #model.sse=arima(log(tmp.model),order = c(sp,0,sq),seasonal=list(order=c(sP,1,sQ),period=7))
    
    #predicting data of Jan, Feb and Mar of 2017
    forecast.aic=predict(model.aic,90)$pred
    
    model.actual=ts(filter(fcast_data,(item==i & store==s))$sales)
    logfcast=log(model.actual)
    
    #measuring accuracy of prediction
    m1=rmse(as.numeric(unlist(forecast.aic[1:90])),as.numeric(unlist(logfcast[1:90])))
    
    m2=mape(as.numeric(unlist(forecast.aic[1:90])),as.numeric(unlist(logfcast[1:90])))
    
    m3=mae(as.numeric(unlist(forecast.aic[1:90])),as.numeric(unlist(logfcast[1:90])))
    
    tmp.metrics=data.frame(Store.no=s,Item.no=i,RMSE_score=exp(m1),MAPE_score=m2,MAE_score=exp(m3))
    pred.accu.info=rbind(pred.accu.info,tmp.metrics)
  }
}

#error in store 6 item 4 data hence removing its value
models.info=models.info[-c(254),]
pred.accu.info=pred.accu.info[-c(254),]
pred.accu.info=pred.accu.info[-c(500),]

#Extracting the dataframes
models.info=na.omit(models.info)
#row.names(models.info)=FALSE
write.csv(models.info,"/media/aviator/Everything/Projects/Demand Analysis/models_info_final.csv",row.names=FALSE)
write.csv(pred.accu.info,"/media/aviator/Everything/Projects/Demand Analysis/pred_accu_info_final.csv",row.names=FALSE)

#Final accuracy scores:
frmse=sum(pred.accu.info$RMSE_score)/500
fmape=sum(pred.accu.info$MAPE_score)/500
fmae=sum(pred.accu.info$MAE_score)/500
print(paste("Finale RMSE is",frmse,"and final MAPE is",fmape,"and final MAE is",fmae))
