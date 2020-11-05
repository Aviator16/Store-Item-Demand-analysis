# Modeling the time series data

For this purpose we take one combination, say sales of item1 in store 1 and try to fit a SARIMA model to it.

Let us first filter out the sales in store 1 of item 1 and visualize it:
![pic1](https://raw.githubusercontent.com/Aviator16/Store-Item-Demand-analysis/main/Images/1%20NB4.png)

Applyling log transformation:
![pic2](https://raw.githubusercontent.com/Aviator16/Store-Item-Demand-analysis/main/Images/2%20NB4.png)

Let us now look at the ACF and PACF of the log transformed data for some clue as to what to do next:
![pic3](https://raw.githubusercontent.com/Aviator16/Store-Item-Demand-analysis/main/Images/3%20NB4.png)
![pic4](https://raw.githubusercontent.com/Aviator16/Store-Item-Demand-analysis/main/Images/4%20NB4.png)

After seasonal differencing at lag 7 we get:
![pic5](https://raw.githubusercontent.com/Aviator16/Store-Item-Demand-analysis/main/Images/5%20NB4.png)

We have detrended the data and let us now look at its ACF and PACF to understand how to model it.
![pic6](https://raw.githubusercontent.com/Aviator16/Store-Item-Demand-analysis/main/Images/6%20NB4.png)
![pic7](https://raw.githubusercontent.com/Aviator16/Store-Item-Demand-analysis/main/Images/7%20NB4.png)

After trying various models in our data as done in this [R Notebook](https://github.com/Aviator16/Store-Item-Demand-analysis/blob/main/Time%20Series%20Modeling/5_%20store%201%20item%201%20sales%20analysis.Rmd), we come to the conclusion:
![pic8](https://raw.githubusercontent.com/Aviator16/Store-Item-Demand-analysis/main/Images/8%20NB4.png)

**Next** we forecast the sales after fitting the data with thw lowest aic model and compare it with original values to check our accuracy as done in this [R program](https://github.com/Aviator16/Store-Item-Demand-analysis/blob/main/Time%20Series%20Modeling/4_%20modeling%20of%20Time%20Series.R).

We do this for a couple of more combinations and come to the conclusion that all the store item combinations can be modeled with SARIMA models quite accurately.
