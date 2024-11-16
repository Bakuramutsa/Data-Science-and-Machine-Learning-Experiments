1. Project Objective: Predicting  whether or not a cell mass is cancerous (“Malignant”) or not (“Benign”) using KNN and logistic regression techniques. I will compare the predictive capacity of these models based on their overall performance scores.

2. Data Description:
- Title: Wisconsin Diagnostic Breast Cancer (WDBC) 
- predicting field 2, diagnosis: B = benign, M = malignant
- Number of instances: 569
- Number of attributes: 32 (ID, diagnosis, 30 real-valued input features)
- Ten real-valued features are computed for each cell nucleus:

        	a) radius (mean of distances from center to points on the perimeter)
        	b) texture (standard deviation of gray-scale values)
        	c) perimeter
        	d) area
        	e) smoothness (local variation in radius lengths)
       	f) compactness (perimeter^2 / area - 1.0)
        	g) concavity (severity of concave portions of the contour)
       	h) concave points (number of concave portions of the contour)
       	i) symmetry
       	j) fractal dimension ("coastline approximation" - 1)
 
 
The mean, standard error, and "worst" or largest (mean of the three
largest values) of these features were computed for each image,
resulting in 30 features.  For instance, field 3 is Mean Radius, field
13 is Radius SE, field 23 is Worst Radius.
 
- All feature values are recorded with four significant digits.
-  Missing attribute values: none
 - Class distribution: 357 benign, 212 malignant


3.  Modeling Process:

- Data exploration
- Data Visualization
- Data Standardization: This is especially necessary for the KNN model in order to accurately calculate distances without attributes of larger scales influencing the distance calculated disproportionally.
- KNN K=3) model induction and evaluation
- Logistic Regression Model Induction and evaluation

4. Results and Insights:
   
- Precision:
Logistic Regression: 0.941 (94.1%)
KNN: 0.948 (94.8%)
- Recall:
Logistic Regression: 0.927 (92.7%)
KNN: 0.922 (92.2%)

- Logistic regression outperforms k-NN due to its better recall score.
Recall [ True Positive / (True Positive + False Negative) ] is the best metric for evaluating the performance of a classifier on true positive values (aka malignant) as we would like to minimize the False Negatives as much as possible
- Our main goal is to maximize the number of correctly detected True Positive values, which indicate that the patient has cancer.

5. Recommendations to improve the model Performance:

- Tune the parameters to increase the predictive abilities of the logistic model: Although we chose the logistic regression to be the best model, a 0.926587 recall is still not good enough, given the sensitivity of a cancer diagnosis case.
- Although split validation is used, we could also use cross-validation in order to estimate the generalization performance of the model.

6. Skills and Tools:

- Exploratory Data Analysis
- Data pre_processing
- Data Standardization
- KNN classification
- Logistic Regression
- Model Evaluation and Comparison

