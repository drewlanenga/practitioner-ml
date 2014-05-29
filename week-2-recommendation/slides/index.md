---
title       : Data Overflow
subtitle    : Clustering, Recommendation and Collaborative Filtering
author      : 
job         : 
framework   : io2012        # {io2012, html5slides, shower, dzslides, ...}
highlighter : highlight.js  # {highlight.js, prettify, highlight}
hitheme     : tomorrow      # 
widgets     : []            # {mathjax, quiz, bootstrap}
mode        : selfcontained # {standalone, draft}
---

## Clustering

Again, throw everything in a matrix.

Example: Crime/Demographics of US States

```r
head(USArrests)
```

```
##            Murder Assault UrbanPop Rape
## Alabama      13.2     236       58 21.2
## Alaska       10.0     263       48 44.5
## Arizona       8.1     294       80 31.0
## Arkansas      8.8     190       50 19.5
## California    9.0     276       91 40.6
## Colorado      7.9     204       78 38.7
```


---


```r
plot(hclust(dist(USArrests)))
```

<img src="assets/fig/dendrogram.png" title="plot of chunk dendrogram" alt="plot of chunk dendrogram" style="display: block; margin: auto;" />


---

## Dimension Reduction

Multidimensional Scaling: For when we have too many columns in a matrix.

Example: Distance between European cities
```
                Athens Barcelona Brussels Calais Cherbourg Cologne Copenhagen
Barcelona         3313                                                       
Brussels          2963      1318                                             
Calais            3175      1326      204                                    
Cherbourg         3339      1294      583    460                             
Cologne           2762      1498      206    409       785                   
Copenhagen        3276      2218      966   1136      1545     760           
Geneva            2610       803      677    747       853    1662       1418
Gibraltar         4485      1172     2256   2224      2047    2436       3196
Hamburg           2977      2018      597    714      1115     460        460
Hook of Holland   3030      1490      172    330       731     269        269
Lisbon            4532      1305     2084   2052      1827    2290       2971
Lyons             2753       645      690    739       789     714       1458
```

---

## Eigenvalues are magic


```r
euroscale <- cmdscale(eurodist, k = 11, eig = TRUE)
plot(euroscale$eig, ylab = "Eigenvalues")
```

<img src="assets/fig/eigen.png" title="plot of chunk eigen" alt="plot of chunk eigen" style="display: block; margin: auto;" />


---


```r
print(head(euroscale$points))
```

```
##              [,1]   [,2]    [,3]    [,4]    [,5]     [,6]    [,7]   [,8]
## Athens    2290.27 1798.8   53.79 -103.83 -156.96   54.755  47.677  1.241
## Barcelona -825.38  546.8 -113.86   84.59  291.44  -33.046  74.527  3.766
## Brussels    59.18 -367.1  177.55   38.80  -95.62   40.058  -2.321 34.352
## Calais     -82.85 -429.9  300.19  106.35 -180.45   31.337 -88.654  5.103
## Cherbourg -352.50 -290.9  457.35  111.45 -417.50 -138.973 -46.776 23.807
## Cologne    293.69 -405.3  360.09 -636.20  159.39   -9.561 -33.109  9.194
##               [,9]    [,10]    [,11]
## Athens      14.893   -6.367    4.818
## Barcelona -225.620  -21.271   22.050
## Brussels     2.262 -129.299   75.569
## Calais     -87.657   86.867  156.097
## Cherbourg -108.307   99.579 -103.623
## Cologne    -19.417    7.925   -1.272
```


---


```r
x <- euroscale$points[, 1]
y <- -euroscale$points[, 2]
plot(x, y, type = "n", xlab = "", ylab = "", asp = 1, axes = FALSE, main = "eurodist")
```

<img src="assets/fig/simple.png" title="plot of chunk simple" alt="plot of chunk simple" style="display: block; margin: auto;" />

```r
text(x, y, rownames(loc), cex = 0.6)
```

```
## Error: object 'loc' not found
```




---

## Matrix Decomposition

Eigenvalue decomposition, Singular value decomposition (super nice)


```
M = U * D * V`
```

```
M = (m x n) matrix
U = (m x n) matrix
D = (n x 1) vector (eigenvalues)
V = (n x n) matrix
```

* Pull out howerver many dimensions as show important eigenvalues
* `U` yields a matrix with user vectors (preference) as row vectors
* `V` yields a matrix with item vectors (similarity) as column vectors

---


## Recommendation

Typically based off of a user-item matrix

```
        Item1   Item2   Item3   Item4   Item5
User1      0        1       1       0       1
User2      0        1       0       0       1
User3      0        1       1       0       0
User4      1        0       0       0       0
```

Decompose matrix to get user vectors and role vectors


---

## Vector Similarity

Use the cosine between two vectors to determine how similar they are

![Cosine Similarity](http://upload.wikimedia.org/math/f/3/6/f369863aa2814d6e283f859986a1574d.png)

http://en.wikipedia.org/wiki/Cosine_similarity


### Recommendation

* Find user vectors that are similar
* Find item vectors that are similar

---





```r
data("MovieLense")
MovieLense100 <- MovieLense[rowCounts(MovieLense) > 100, ]
train <- MovieLense100[1:50]
rec <- Recommender(train, method = "POPULAR")

## create top-N recommendations for new users
pre <- predict(rec, MovieLense100[101:102], n = 5)
print(as(pre, "list"))
```

```
## [[1]]
## [1] "Titanic (1997)"               "Sting, The (1973)"           
## [3] "Alien (1979)"                 "Schindler's List (1993)"     
## [5] "2001: A Space Odyssey (1968)"
## 
## [[2]]
## [1] "Titanic (1997)"                  "Empire Strikes Back, The (1980)"
## [3] "Usual Suspects, The (1995)"      "Schindler's List (1993)"        
## [5] "Braveheart (1995)"
```



---

## Resources

* Singular Value Decomposition: http://en.wikipedia.org/wiki/Singular_value_decomposition
* Recommendation at **Spotify**: http://vimeo.com/57900625


