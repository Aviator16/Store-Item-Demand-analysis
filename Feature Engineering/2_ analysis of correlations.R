#Looking at the correlations between stores and items

setwd("/media/aviator/Everything/Projects/Demand Analysis/Dataset")
dem_data=read.csv("train.csv")
head(dem_data)

library(dplyr)

#removing data of 2017
library(lubridate)
dem_data$date=ymd(dem_data$date)
dem_data=dem_data[format(dem_data$date,'%Y')!="2017",]

#Function to create dataframe consisting of sales in all 10 stores for a particular item

item.make_frame=function(data,item_number){
  dframe=data.frame(V1=1:1461)
  for (i in 1:10){
    dframe[[i]]=filter(data,(item==item_number & store==i))$sales
  }
  return(dframe)
}

#for example sales in all stores of item 38 is given by:
item38.all_stores=item.make_frame(dem_data,38)
head(item38.all_stores)

#creating dataframe to store above data for all items:
all_items.all_stores=data.frame(V1=1:1461)
for (i in 1:50){
  all_items.all_stores[[i]]=item.make_frame(dem_data,i)
}

#For each item, finding the correlations between the sales of all the stores
store_store.corr=data.frame(V1=1:10)
for(c in 1:50){
  store_store.corr[[c]]=round(cor(all_items.all_stores[,c]),5)
}
#for example correlation between sales of stores for item 28 is:
head(store_store.corr[28])

#to visualize the correlation:
library(ggcorrplot)
ggcorrplot(store_store.corr[28],method = "circle",type="upper")


#Function to create dataframe consisting of sales in all 50 items for a particular store

store.make_frame=function(data,store_number){
  dframe=data.frame(V1=1:1461)
  for (i in 1:50){
    dframe[[i]]=filter(data,(item==i & store==store_number))$sales
  }
  return(dframe)
}

#for example sales in all items of store 5 is given by:
store5.all_items=store.make_frame(dem_data,5)
head(store5.all_items)

#creating dataframe to store above data for all stores:
all_stores.all_items=data.frame(V1=1:1461)
for (i in 1:10){
  all_stores.all_items[[i]]=store.make_frame(dem_data,i)
}

#For each store, finding the correlations between the sales of all the items
item_item.corr=data.frame(V1=1:50)
for(c in 1:10){
  print(paste(c))
  item_item.corr[[c]]=round(cor(all_stores.all_items[,c]),5)
}
#for example correlation between sales of items for store 3 is:
head(item_item.corr[3])

#to visualize the correlation:
ggcorrplot(item_item.corr[3],method = "circle",type="upper")


#Finding relations where correlation coefficient is greater than or equal to specified value

find.high_corr=function(correlation_frame,out_max,in_max,corr_value){
  out_var=c();in_row=c();in_col=c();in_val=c()
  for (k in 1:out_max){
    tmp=paste("V",k,sep="")
    tmp.frame=data.frame(correlation_frame[k][[tmp]])
    for (i in 1:in_max){
      for(j in 1:in_max){
        if(i<j){                            #looking at the upper triangular matrix only
          if(tmp.frame[i,j]>=corr_value){
            
            #saving index of high correlation
            out_var=append(out_var,k)
            in_row=append(in_row,i)
            in_col=append(in_col,j)
            in_val=append(in_val,tmp.frame[i,j])
          }
        }
      }
    }
    
  }
  high_corr.frame=data.frame("outer_variable"=out_var,"inner_row.idx"=in_row,"inner_col.idx"=in_col,"corr_value"=in_val)
  return(high_corr.frame)
}

item_corr.btwn_stores=find.high_corr(store_store.corr,50,10,0.85)   #finding highest correlations between stores for each item
                                                                    #here outer_variable= item number; inner values= index for 
                                                                    #store-store relation with highest correlations.

store_corr.btwn_items=find.high_corr(item_item.corr,10,50,0.85)     #finding highest correlations between items for each store
                                                                    #here outer_variable= store number; inner values= index for 
                                                                    #item-item relation with highest correlations.

#Exporting correlation dataframes
write.csv(item_corr.btwn_stores,"/media/aviator/Everything/Projects/Demand Analysis/Dataset/item_corr_btwn_stores_no2017.csv",row.names=FALSE)

write.csv(store_corr.btwn_items,"/media/aviator/Everything/Projects/Demand Analysis/Dataset/store_corr_btwn_items_no2017.csv",row.names=FALSE)
