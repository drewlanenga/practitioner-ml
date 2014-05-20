---
title       : PractitionerML
subtitle    : A Practitioner's Guide to Machine Learning
author      : Drew Lanenga
job         : Data Scientist, Lytics
framework   : io2012        # {io2012, html5slides, shower, dzslides, ...}
highlighter : highlight.js  # {highlight.js, prettify, highlight}
hitheme     : tomorrow      #
widgets     : []            # {mathjax, quiz, bootstrap}
mode        : selfcontained # {standalone, draft}
---

## Schedule

1. Resampling, bootstrapping, boosting and bagging (predicting return rates in Lytics event streams)
2. Bayes rule and naive Bayes classifiers (spam detection)
3. Dimension reduction, clustering and recommendation (building a recomendation engine)
4. Graph analytics and social network analysis (Collaboration and importance in GitHub)

--- .class #id

## Linear Statistical Models

Predicting output from well-defined input


`Y ~ B1*X1 + B2*X2 + ... + BM*XM + e`

```
Y = BX   --(linear algebra)-->   B = (XtX)^-1 * XtY
```

```
Y   = Vector (n) of values to predict
X   = Matrix (m x n) of useful data
B   = Vector (m) of coefficients
```

* Can be computationally expensive -- matrix inversion is hard
* Can be numerically unstable -- `XtX` needs to be full rank to invert
* Implies a global model


Let's do an example with Fisher's Iris data

---


```r
data(iris)
pairs(iris)
```

![plot of chunk unnamed-chunk-1](assets/fig/unnamed-chunk-1.png) 


---


```r
data(iris)
model <- lm(Sepal.Length ~ Sepal.Width + Petal.Length + as.factor(Species), 
    data = iris)
print(summary(model)$coefficients)
```

```
##                              Estimate Std. Error t value  Pr(>|t|)
## (Intercept)                    2.3904    0.26227   9.114 5.943e-16
## Sepal.Width                    0.4322    0.08139   5.310 4.026e-07
## Petal.Length                   0.7756    0.06425  12.073 1.151e-23
## as.factor(Species)versicolor  -0.9558    0.21520  -4.442 1.760e-05
## as.factor(Species)virginica   -1.3941    0.28566  -4.880 2.760e-06
```


---

## Regression Trees

* Idea is the same
    - For given set of data `X`, predict an outcome `Y`
* Methodology is different
    - Recursively partition data, then fit simple localized models to the partition.

Supplemental Reading:
- http://www.stat.cmu.edu/~cshalizi/350-2006/lecture-10.pdf
- http://cran.r-project.org/web/packages/rpart/vignettes/longintro.pdf

---

## Scalability

* Least Squares problems don't scale well -- difficulty of inverting `XtX` increases exponentially
* Regression trees work better, but still fitting one tree to a giant dataset can be intensive


In both cases, you can use an [ensemble](http://en.wikipedia.org/wiki/Ensemble_learning)-based approach (wisdom in the masses)
* Ensembles in least squares is called [bagging](http://en.wikipedia.org/wiki/Bootstrap_aggregating)
* Ensembles in regression trees are called random forests

---

## Random Forests in Action

We'll grow a random forest to predict the probability that a user will return to a stream (in the next 30 days)

```
# include a glimpse of the event format
```

---

## Random Forests in Action

### Hypothesis
The best users have a predictable (regular) usage pattern for most streams.


Formula

Check out the gist!  GIST_URL

