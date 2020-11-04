#Feature engineering of dataset

#Dataset
setwd("/media/aviator/Everything/Projects/Demand Analysis/Dataset")
dem_data=read.csv("train.csv")
head(dem_data)

#removing data of 2017
library(lubridate)
dem_data$date=ymd(dem_data$date)
dem_data=dem_data[format(dem_data$date,'%Y')!="2017",]

#Correlated stores for each item
out_item=read.csv("item_corr_btwn_stores_no2017.csv")
head(out_item)

#Correlated items for each store
out_store=read.csv("store_corr_btwn_items_no2017.csv")
head(out_store)

#creating column to keep track of higher correlations
dem_data$high_corr=0*c(1:length(dem_data))

#creating column to keep track of replaced store number
dem_data$rep_store=0*c(1:length(dem_data))

#creating column to keep track of replaced item number
dem_data$rep_item=0*c(1:dim(dem_data)[1])

#analysing data to replace/omit variables

#analysing for out_item values
hcorr.items=unique(out_item$outer_variable)
for (r in 1:dim(dem_data)[1]){
  for (p in 1:length(hcorr.items)){
    if (dem_data$item[r]==hcorr.items[p]){
      print(paste("looping",hcorr.items[p],dem_data[r,]))
      for (g in 1:length(out_item$outer_variable)){
        if(out_item$outer_variable[g]==hcorr.items[p]){
          if (dem_data$store[r]==out_item$inner_col.idx[g]){
            if (dem_data$high_corr[r]<out_item$corr_value[g]){
              dem_data$rep_store[r]=out_item$inner_row.idx[g]
              dem_data$high_corr[r]=out_item$corr_value[g]
            }  
          }
        }
      }
    }
  }
}


#analysing for out_store values
hcorr.store=unique(out_store$outer_variable)
for (r in 1:dim(dem_data)[1]){
  for (p in 1:length(hcorr.store)){
    if (dem_data$store[r]==hcorr.store[p]){
      print(paste("looping",hcorr.store[p],dem_data[r,]))
      for (g in 1:length(out_store$outer_variable)){
        if(out_store$outer_variable[g]==hcorr.store[p]){
          if (dem_data$item[r]==out_store$inner_col.idx[g]){
            if (dem_data$high_corr[r]<out_store$corr_value[g]){
              dem_data$rep_store[r]=0
              dem_data$high_corr[r]=out_store$corr_value[g]
              dem_data$rep_item[r]=out_store$inner_row.idx[g]
            }  
          }
        }
      }
    }
  }
}


#Exporting the dataset after finding possible replacemnets of data upto dec 2016
write.csv(dem_data,"C:\\Users\\user\\Documents\\All programs\\Projects\\Demand Analysis\\featured_data_dec2016.csv",row.names=FALSE)


#removing rows and recording replacements

#replacement information
replace_frame_tmp=subset(dem_data,high_corr!=0)

replace_frame=data.frame(store=NA,item=NA,rep_store=NA,rep_item=NA)
tmp=data.frame(store=replace_frame_tmp$store[1],item=replace_frame_tmp$item[1],rep_store=replace_frame_tmp$rep_store[1],rep_item=replace_frame_tmp$rep_item[1])
replace_frame=rbind(replace_frame,tmp)
for(i in 2:dim(replace_frame_tmp)[1]){
  if( replace_frame_tmp$store[i]==replace_frame_tmp$store[i-1] & replace_frame_tmp$item[i]==replace_frame_tmp$item[i-1]){
    next
  }
  else{
    tmp=data.frame(store=replace_frame_tmp$store[i],item=replace_frame_tmp$item[i],rep_store=replace_frame_tmp$rep_store[i],rep_item=replace_frame_tmp$rep_item[i])
    replace_frame=rbind(replace_frame,tmp)
  }
}
replace_frame=na.omit(replace_frame)
#final dataset
selected_feat_dataset=subset(dem_data,high_corr==0)
selected_feat_dataset=subset(selected_feat_dataset,select=-c(high_corr,rep_store,rep_item))

#re indexing the datasets
row.names(replace_frame)=NULL
row.names(selected_feat_dataset)=NULL

#Extracting the dataframes
write.csv(replace_frame_tmp,"C:\\Users\\user\\Documents\\All programs\\Projects\\Demand Analysis\\replace_frame_tmp_no2017.csv",row.names=FALSE)

write.csv(replace_frame,"C:\\Users\\user\\Documents\\All programs\\Projects\\Demand Analysis\\replace_frame_no2017.csv",row.names=FALSE)

write.csv(selected_feat_dataset,"C:\\Users\\user\\Documents\\All programs\\Projects\\Demand Analysis\\final_dataset_no2017.csv",row.names=FALSE)
