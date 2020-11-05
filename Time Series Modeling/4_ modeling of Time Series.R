#testing
setwd("C:/Users/user/Documents/All programs/Projects/Demand Analysis/Dataset")
dem_data=read.csv("train.csv")
#removing data of 2017
library(lubridate)
dem_data$date=ymd(dem_data$date)
fcast_data=dem_data[format(dem_data$date,'%Y')=="2017",]
dem_data=dem_data[format(dem_data$date,'%Y')!="2017",]


#STORE 1 ITEM 1
library(dplyr)
s1.i1=ts(filter(dem_data,(item==1 & store==1))$sales)
plot(s1.i1,main="sales of store 1 item 1",col='blue',lw=3)

#log transforming
logd=log(s1.i1)
acf(logd,main="ACF of log data")
pacf(logd,main="PACF of log data")
#We see a seasonal pattern of 7 days, i.e. data has seasonality

#Differencing to remove seasonality
dif_data=diff(logd,7)
acf(dif_data,lag.max=80,main="ACF of seasonally diff data")
pacf(dif_data,lag.max = 120,main="PACF of seasonally diff data")

#Testing for stationarity
Box.test(dif_data,lag=log(length(dif_data)))
#p-values less than alpha hence we reject the null hypothesis that its a stationary process

#trying different models
d=0
DD=1
aic=100000; ss=100000; order.1=NULL; order.2=NULL;
per=7

#value of p causing error. Look into variations for P.
#model failing whenever p>1.

for(p in 1:3){
  for(q in 1:3){
    for(i in 2:8){
      for(j in 2:3){
        if(p+d+q+i+DD+j<=19){
          cat(p-1,d,q-1,i-1,DD,j-1,'\n')
          model<-try(arima(x=logd, order = c((p-1),d,(q-1)), seasonal = list(order=c((i-1),DD,(j-1)), period=per)))
          if(class(model)=="try-error"){next()}
          pval<-Box.test(model$residuals, lag=log(length(model$residuals)))
          sse<-sum(model$residuals^2)
          cat(p-1,d,q-1,i-1,DD,j-1,per, 'AIC=', model$aic, ' SSE=',sse,' p-VALUE=', pval$p.value,'\n')
          if (model$aic<aic){
            aic=model$aic
            order.1=c((p-1),d,(q-1),(i-1),DD,(j-1))
          }
          if (sse<ss){
            ss=sse
            order.2=c((p-1),d,(q-1),(i-1),DD,(j-1))
          }
        }
      }
    }
  }
}


paste("Order with lowest aic is",list(order.1),"with aic value",aic)
paste("Order with lowest sse is",list(order.2),"with sse value",ss)

library(astsa)
model.aic=arima(logd,order = c(1,0,1),seasonal=list(order=c(1,1,1),period=7))
  #sarima(logd,1,0,1,1,1,1,7)
model.sse=arima(logd,order = c(2,0,2),seasonal=list(order=c(5,1,2),period=7))
  #sarima(logd,2,0,2,5,1,2,7)

#forecast
s1.i1.fcast=ts(filter(fcast_data,(item==1 & store==1))$sales)
logfcast=log(s1.i1.fcast)

library(forecast)
plot(forecast(model.aic,92))
s1i1f=predict(model.aic,90)$pred

library(Metrics)
rmse(as.numeric(unlist(s1i1f[1:90])),as.numeric(unlist(logfcast[1:90])))
#0.273078
mape(as.numeric(unlist(s1i1f[1:90])),as.numeric(unlist(logfcast[1:90])))
#0.07550658
mae(as.numeric(unlist(s1i1f[1:90])),as.numeric(unlist(logfcast[1:90])))
#0.2101906

plot(forecast(model.sse,92))
s1i1f.sse=predict(model.sse,90)$pred
rmse(as.numeric(unlist(s1i1f.sse[1:90])),as.numeric(unlist(logfcast[1:90])))
#0.2746473
mape(as.numeric(unlist(s1i1f.sse[1:90])),as.numeric(unlist(logfcast[1:90])))
#0.07608104
mae(as.numeric(unlist(s1i1f.sse[1:90])),as.numeric(unlist(logfcast[1:90])))
#0.211722


#STORE 5 ITEM 35
s5.i35=ts(filter(dem_data,(item==35 & store==5))$sales)
plot(s5.i35,main="sales of store 5 item 35",col='blue',lw=3)

#log transforming
log.s5.i35=log(s5.i35)

#differencing for seasonality
diff.s5.i35=diff(log.s5.i35,7)
acf(diff.s5.i35,main="ACF of diff s5i35")
pacf(diff.s5.i35,lag.max=100,main="PACF of diff s5i35")

#Testing for stationarity
Box.test(diff.s5.i35,lag=log(length(diff.s5.i35)))
#p-values less than alpha hence we reject the null hypothesis that its a stationary process

#trying different models
d=0
DD=1
aic=100000; ss=100000; order.1=NULL; order.2=NULL;
per=7

#value of p causing error. Look into variations for P.
#model failing whenever p>1.

for(p in 1:4){
  for(q in 1:4){
    for(i in 2:12){
      for(j in 2:3){
        if(p+d+q+i+DD+j<=21){
          cat(p-1,d,q-1,i-1,DD,j-1,'\n')
          model<-try(arima(x=log.s5.i35, order = c((p-1),d,(q-1)), seasonal = list(order=c((i-1),DD,(j-1)), period=per)))
          if(class(model)=="try-error"){next()}
          pval<-Box.test(model$residuals, lag=log(length(model$residuals)))
          sse<-sum(model$residuals^2)
          cat(p-1,d,q-1,i-1,DD,j-1,per, 'AIC=', model$aic, ' SSE=',sse,' p-VALUE=', pval$p.value,'\n')
          if (model$aic<aic){
            aic=model$aic
            order.1=c((p-1),d,(q-1),(i-1),DD,(j-1))
          }
          if (sse<ss){
            ss=sse
            order.2=c((p-1),d,(q-1),(i-1),DD,(j-1))
          }
        }
      }
    }
  }
}


paste("Order with lowest aic is",list(order.1),"with aic value",aic)
#"Order with lowest aic is c(3, 0, 3, 4, 1, 1) with aic value -1156.00009261716"

paste("Order with lowest sse is",list(order.2),"with sse value",ss)
#"Order with lowest sse is c(3, 0, 3, 7, 1, 2) with sse value 36.9051846178871"
#compute time 3.5-4hrs

s5i35.aic=arima(logd,order = c(3,0,3),seasonal=list(order=c(4,1,1),period=7))
  #sarima(log.s5.i35,3,0,3,4,1,1,7)
s5i35.sse=arima(logd,order = c(3,0,3),seasonal=list(order=c(7,1,2),period=7))
  #sarima(log.s5.i35,3,0,3,7,1,2,7)

plot(forecast(s5i35.aic,92))
s5i35f.aic=predict(s5i35.aic,90)$pred

library(Metrics)
rmse(as.numeric(unlist(s5i35f.aic[1:90])),as.numeric(unlist(logfcast[1:90])))
#0.2716717
mape(as.numeric(unlist(s5i35f.aic[1:90])),as.numeric(unlist(logfcast[1:90])))
#0.07622295
mae(as.numeric(unlist(s5i35f.aic[1:90])),as.numeric(unlist(logfcast[1:90])))
#0.2102319

s5i35f.sse=predict(s5i35.sse,90)$pred
rmse(as.numeric(unlist(s5i35f.sse[1:90])),as.numeric(unlist(logfcast[1:90])))
#0.2729705
mape(as.numeric(unlist(s5i35f.sse[1:90])),as.numeric(unlist(logfcast[1:90])))
#0.07648157
mae(as.numeric(unlist(s5i35f.sse[1:90])),as.numeric(unlist(logfcast[1:90])))
#0.2113427

#STORE 10 ITEM 50
s10.i50=ts(filter(dem_data,(item==50 & store==10))$sales)
plot(s10.i50,main="sales of store 10 item 50",col='blue',lw=3)

#log transforming
log.s10.i50=log(s10.i50)
plot(log.s10.i50,main="log s10 i50")

#differencing for seasonality
diff.s10.i50=diff(log.s10.i50,7)
acf(diff.s10.i50,main="ACF of diff s10i50")
pacf(diff.s10.i50,lag.max=100,main="PACF of diff s10i50")

#Testing for stationarity
Box.test(diff.s10.i50,lag=log(length(diff.s10.i50)))
#p-values less than alpha hence we reject the null hypothesis that its a stationary process

#trying different models
d=0
DD=1
aic=100000; ss=100000; order.1=NULL; order.2=NULL;
per=7

#value of p causing error. Look into variations for P.
#model failing whenever p>1.

for(p in 2:5){
  for(q in 2:5){
    for(i in 2:7){
      for(j in 2:2){
        if(p+d+q+i+DD+j<=16){
          cat(p-1,d,q-1,i-1,DD,j-1,'\n')
          model<-try(arima(x=log.s10.i50, order = c((p-1),d,(q-1)), seasonal = list(order=c((i-1),DD,(j-1)), period=per)))
          if(class(model)=="try-error"){next()}
          pval<-Box.test(model$residuals, lag=log(length(model$residuals)))
          sse<-sum(model$residuals^2)
          cat(p-1,d,q-1,i-1,DD,j-1,per, 'AIC=', model$aic, ' SSE=',sse,' p-VALUE=', pval$p.value,'\n')
          if (model$aic<aic){
            aic=model$aic
            order.1=c((p-1),d,(q-1),(i-1),DD,(j-1))
          }
          if (sse<ss){
            ss=sse
            order.2=c((p-1),d,(q-1),(i-1),DD,(j-1))
          }
        }
      }
    }
  }
}


paste("Order with lowest aic is",list(order.1),"with aic value",aic)
#"Order with lowest aic is c(4,0,4,0,1,1)  with aic value -1691.9018864269"

paste("Order with lowest sse is",list(order.2),"with sse value",ss)
#"Order with lowest sse is c(3, 0, 3, 4, 1, 1) with sse value 25.7003643372871"

s10i50.aic=arima(log.s10.i50,order = c(4,0,4),seasonal=list(order=c(0,1,1),period=7))
#sarima(log.s10.i50,1,0,2,4,1,1,7)
s10i50.sse=arima(log.s10.i50,order = c(3,0,3),seasonal=list(order=c(4,1,1),period=7))

plot(forecast(s10i50.aic,365))
s10i50f.aic=predict(s10i50.aic,365)$pred

rmse(as.numeric(unlist(s10i50f.aic[1:365])),as.numeric(unlist(logfcast[1:365])))
#1.324649
mape(as.numeric(unlist(s10i50f.aic[1:365])),as.numeric(unlist(logfcast[1:365])))
#0.3177545
mae(as.numeric(unlist(s10i50f.aic[1:365])),as.numeric(unlist(logfcast[1:365])))
#1.296457

s10i50f.sse=predict(s10i50.sse,365)$pred
rmse(as.numeric(unlist(s10i50f.sse[1:365])),as.numeric(unlist(logfcast[1:365])))
#1.315628
mape(as.numeric(unlist(s10i50f.sse[1:365])),as.numeric(unlist(logfcast[1:365])))
#0.3162433
mae(as.numeric(unlist(s10i50f.sse[1:365])),as.numeric(unlist(logfcast[1:365])))
#1.287378





#STORE 9 ITEM 45
s9.i45=ts(filter(dem_data,(item==45 & store==9))$sales)
plot(s9.i45,main="sales of store 10 item 50",col='blue',lw=3)

#log transforming
log.s9.i45=log(s9.i45)
plot(log.s9.i45,main="log s10 i50")

#differencing for seasonality
diff.s10.i50=diff(log.s9.i45,7)
acf(diff.s10.i50,main="ACF of diff s10i50")
pacf(diff.s10.i50,lag.max=100,main="PACF of diff s10i50")

#Testing for stationarity
Box.test(diff.s10.i50,lag=log(length(diff.s10.i50)))
#p-values less than alpha hence we reject the null hypothesis that its a stationary process

#trying different models
d=0
DD=1
aic=100000; ss=100000; order.1=NULL; order.2=NULL;
per=7

#value of p causing error. Look into variations for P.
#model failing whenever p>1.

for(p in 2:5){
  for(q in 2:5){
    for(i in 2:7){
      for(j in 2:2){
        if(p+d+q+i+DD+j<=16){
          cat(p-1,d,q-1,i-1,DD,j-1,'\n')
          model<-try(arima(x=log.s9.i45, order = c((p-1),d,(q-1)), seasonal = list(order=c((i-1),DD,(j-1)), period=per)))
          if(class(model)=="try-error"){next()}
          pval<-Box.test(model$residuals, lag=log(length(model$residuals)))
          sse<-sum(model$residuals^2)
          cat(p-1,d,q-1,i-1,DD,j-1,per, 'AIC=', model$aic, ' SSE=',sse,' p-VALUE=', pval$p.value,'\n')
          if (model$aic<aic){
            aic=model$aic
            order.1=c((p-1),d,(q-1),(i-1),DD,(j-1))
          }
          if (sse<ss){
            ss=sse
            order.2=c((p-1),d,(q-1),(i-1),DD,(j-1))
          }
        }
      }
    }
  }
}


paste("Order with lowest aic is",list(order.1),"with aic value",aic)
#"Order with lowest aic is c(4,0,4,0,1,1)  with aic value -1691.9018864269"

paste("Order with lowest sse is",list(order.2),"with sse value",ss)
#"Order with lowest sse is c(3, 0, 3, 4, 1, 1) with sse value 25.7003643372871"
