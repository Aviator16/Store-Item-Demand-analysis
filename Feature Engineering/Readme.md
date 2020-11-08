# Analysis of correlations
First we filter out the sales of each item in all the stores.
 ![pic1](https://raw.githubusercontent.com/Aviator16/Store-Item-Demand-analysis/main/Images/1%20NB2.png)
 
 Then we find the correlations between the sales in these stores for a particular item.
 ![pic2](https://raw.githubusercontent.com/Aviator16/Store-Item-Demand-analysis/main/Images/2%20NB2.png)
 
 This can be visualized as
 ![pic3](https://raw.githubusercontent.com/Aviator16/Store-Item-Demand-analysis/main/Images/3%20NB2.png)
 
 Similarly we filter out the sales of all items in every store individually.
 ![pic4](https://raw.githubusercontent.com/Aviator16/Store-Item-Demand-analysis/main/Images/4%20NB2.png)
 
 The correlations between the sales of these items for a particular store is found thereafter.
 ![pic5](https://raw.githubusercontent.com/Aviator16/Store-Item-Demand-analysis/main/Images/5%20NB2.png)
 
 Which can be visualized as
 ![pic6](https://raw.githubusercontent.com/Aviator16/Store-Item-Demand-analysis/main/Images/6%20NB2.png)
 
 After all these calculations we find the combinations where the correlation is high(>0.85).
 
 **The reason we do this is because if for store 1 item 2 and 3 have high correlation I only need to forecast sales of any one and use it for the other. Similarly if for item 5 store 7 and 8 have high correlation I forecast sales for any one of them and use it as an approximation for the other. If this hypothesis comes true for tens of thousands of store-item combinations forecasting on a few thousand may be enough which reduces the workload many fold.**

# Feature Engineering

Now we have the dataframe which give us the correlation between sales in all stores for each item.
![pic7](https://raw.githubusercontent.com/Aviator16/Store-Item-Demand-analysis/main/Images/1%20NB3.png)

We can see that function head shows us the first few highly correlated stores for item 13. For eg. store 2 and store 3 has correlation 0.85536 for item 13. So we can take item 13 and store 2 sales and use its forecasted values for item 13 and store 3 as well if our hypothesis is corrrect.

Similarly we have the dataframe which give us the correlation between sales of all items for each store.
![pic8](https://raw.githubusercontent.com/Aviator16/Store-Item-Demand-analysis/main/Images/2%20NB3.png)

For eg. for store 2 we have high correlation between items 8 and 13 of 0.85137.

### Creating final training sets ###
Finally we go through the correlations and pick one combination among two highly correlated ones. In case of collisions like, for item 1 stores 2 and 3 have high corr. so possible comb. are i1s2 and i1s3. But say, for store 3 items 1 and 4 have high corr. in whcih case possible comb. are i1s3 and i4s3. **Hence in this case the comb. i1s3 can be approximated by both i1s2 and i4s3 and we pick the one with whom i1s3 has a higher correlation with.**

This way we end up with two dataframes:
* One with all the combinations which need to be modeled and forecasted for future sales, i.e. [this](https://raw.githubusercontent.com/Aviator16/Store-Item-Demand-analysis/main/Feature%20Engineering/final_dataset_no2017.csv).
* Another one with the data of the combinations which can be approximated from the forecasts of the first frame, i.e. [this](https://github.com/Aviator16/Store-Item-Demand-analysis/blob/main/Feature%20Engineering/replace_frame_no2017.csv).
![pic9](https://raw.githubusercontent.com/Aviator16/Store-Item-Demand-analysis/main/Images/3%20NB3.png)

**The first row means that the sales in store 2 of item 13 can be approximated by the sales in store 2 of item 11.**

We now need to forecast and see the accuracy of our forecast and then approximate the sales of the combinations in our replace frame and see if our hypothesis holds true.
