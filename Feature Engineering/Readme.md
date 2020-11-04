# Analysis of correlations
First we filter out the sales of each item in all the stores.
 ![pic1](https://raw.githubusercontent.com/Aviator16/Store-Item-Demand-analysis/main/Images/1%20NB2.png)
 
 Then we find the correlattions between the sales in these stores for a particular item.
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
