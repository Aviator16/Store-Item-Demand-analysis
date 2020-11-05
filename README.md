![pic0](https://raw.githubusercontent.com/Aviator16/Store-Item-Demand-analysis/main/Images/header.png)
# Store-Item-Demand-analysis

This is a data science project for demand analysis of items in stores. The data is a **Multiple time series data** where we have 500 combinations of stores and items and are required to forecast thier sales. I have used **Time Series Forcasting** for the purpose of this project. The project has been done in **R Studio**. Different parts of the project have been saved in R notebooks and are available in this repository.

I have used correlation analysis and SARIMA models for the purpose of modeling and forecasting the time series data.

## Exploring the dataset
This part is carried out [here](https://github.com/Aviator16/Store-Item-Demand-analysis/tree/main/Dataset%20Exploration).
We find that the dataset has 10 stores and 50 items and sales of all combinations of these need to forecasted for this project.

## Objectives
As the project description indicates we need to forecast sales for each **item-store combination**. But also forecasting of so many combinations can be tiresome. Hence in this project I also try to find if its possible to reduce our workload and still get our desired results through correlations among the store-item combinations.
#### Hypothesis ####
Suppose store 1 and store 2 are in Agra and store 3 is in Kolkata. Let item 1 be a cold-drink, item 2 be an ice-cream and item 3 be salt. It can be safely said that stores 1 and 2 will have similar sales for any given item. Similarly items 1 and 2 will have similar sales for any given store. **Hence for a particular item if I have sales for store 1, I may use it as an approximation for sale of that item in store 2 as well. Similarly for any given store if I have sales of either item 1 or 2, I can approximate the other using it.** This will lead to reduction in combinations of items and stores I need, to forecast the sales for.

Hence the **objectives** are as follows:
* Forecasting future sale values for each store-item combination.
* Finding high correlation combinations between stores for a given item and items for a given store, and checking if using any one among two highly correlated combinations for forecasting and approximating the other using that provides us with accurate predictions. 

## Feature engineering
In this part we carry out analysis on our features and see if reduction in the number of combinations is possible [here](https://github.com/Aviator16/Store-Item-Demand-analysis/tree/main/Feature%20Engineering).

At the conslusion of this portion we obtain two dataframes on which we will model our time series models and forecast on. We take data till 2016 as training set and data of the first 3 months (90 days) from the year 2017 as test set.

## Time Series Modeling
Here we consider one store-item combination and try to fit its sales to a SARIMA model so that we can forecast its future values. At this stage, we run these [programs](https://github.com/Aviator16/Store-Item-Demand-analysis/tree/main/Time%20Series%20Modeling) and try to do the following:
* Plot the sales as Time Series data.
* Apply suitable transformations to make it suitable to be fit into a SARIMA model like log transformation and differencing.
* Observe the ACF and PACF plots to ascertain the seasonal and non-seasonal moving average and auto-regressive terms.
* Try multiple models to find the ones with lowest AIC and SSE.
* Fit the data to the model with the lowest AIC and check the error in forecast.
* Repeat for a few more sample combinations.

#### Conclusion
Model with lowest AIC gave very low RMSE,MAPE and MAE score which proves the fitting to be a success.
