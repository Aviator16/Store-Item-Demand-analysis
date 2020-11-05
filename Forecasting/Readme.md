# Forecasting on entire original train dataset
We take the original train set of sales upto year 2017 for items 1 to 50 in stores 1 to 10 and try to fit suitable SARIMA models to each store-item combination.
The program can be viewed [here](https://github.com/Aviator16/Store-Item-Demand-analysis/blob/main/Forecasting/6_%20forecasting%20on%20entire%20original%20dataset.R).

#### Here we make use of the parsimony principle and try to select the model that yeilds best results with minimum parameters.

We save the model parameters for each store-item combination in the [models_info](https://github.com/Aviator16/Store-Item-Demand-analysis/blob/main/Forecasting/models_info_final.csv) dataframe.
Once we have fit the models we test their accuracy by comparing the forcast sales value of **Jan,Feb & Mar 2017** with the original ones. We use RMSE score, MAPE score and MAE score to measure error and get the following result:
![pic1](https://raw.githubusercontent.com/Aviator16/Store-Item-Demand-analysis/main/Images/1%20NB5.png)

As we can see the Root Mean Square error and Mean Absolute Error are both very low. The Mean Absolute Percentage Error shows a very low percentage of error too.
We save the individual scores for the forecasts of each store-item combination in [model_prediction_accuracy](https://github.com/Aviator16/Store-Item-Demand-analysis/blob/main/Forecasting/pred_accu_info_final.csv) dataframe.

# Forecasting on reduced combinations of store and item
Now we work on our second objective where we omit some store item combinations from our analysis and approximate their sales from other combinations with whom they are highly correlated.
We make use of the replace frame dataframe here and the steps we do in this [program](https://github.com/Aviator16/Store-Item-Demand-analysis/blob/main/Forecasting/7_%20Reduced%20combinations%20analysis.R) are as follows:
* Row-wise we go through the replace_frame dataframe and for each store and item we look at the corresponding non-zero value in the last two columns.
* If the non-zero value lies in the rep_store column, we replace the store column value with the rep_store column value and fit its model from the models_info dataframe.
For example,in row 1 of replace_frame, the sales in **store 2 of iem 13** is appoximated by the results we got when forecasting sales in **store 2 of item 11**.
* Then we measure the accuracy of the approximation. Like for the above example, sales forecast of store 2 item 11 is comapred with the original sales for the test period in store 2 item 13 and so on for the rest of the rows in replace_frame.

In the end the results of our approximation comes to be satisfactory:
![pic2](https://raw.githubusercontent.com/Aviator16/Store-Item-Demand-analysis/main/Images/2%20NB5.png)
which are very close to our errors while using original dataset.

## This concludes my project with success.
