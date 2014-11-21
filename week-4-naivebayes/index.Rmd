---
title       : Naive Bayesian Classification
subtitle    : Document Classification
author      : Drew Lanenga
job         : Data Scientist, Lytics
framework   : shower        # {io2012, html5slides, shower, dzslides, ...}
highlighter : highlight.js  # {highlight.js, prettify, highlight}
hitheme     : tomorrow      # 
widgets     : []            # {mathjax, quiz, bootstrap}
mode        : selfcontained # {standalone, draft}

--- .shout

## Bayesian Probability

--- 

## Bayesian Probability

> A Bayesian is one who, vaguely expecting a horse, and catching a glimpse of a donkey, strongly believes he has seen a mule.
                     - **Karl Pearson**

```
             likelihood * prior
posterior = ---------------------
                  evidence
```

---

## Vocabulary

- **Prior**
    - Prior expectation of the probability of the outcome of an event
    - Can be informed by previous data, expert opinion, etc.
- **Likelihood**
    - What's the probability of getting what you got?
    - It's the **joint probability** of the realized events
- **Posterior**
    - Probability based on information from both prior and likelihood

---

## Vocabulary

- **Joint Probability &mdash; P(A, B)**
    - The probability of the outcome of multiple events *together*
    - Events may or may not be independent.
- **Conditional Probability &mdash; P(A|B)**
    - The probability of an event, *given* that the outcome of another event occurs
- **Marginal Probability &mdash; P(A)**
    - The *unconditional* probability of an event

---

## Naive Bayes

A *naive* Bayesian classifier assumes that event outcomes are independent.

--- .shout 

## Example

---

## Document Classification

In NLP, a bag-of-words model *tokenizes* text and throws each token in a proverbial bag.

|                   | aaron | cat | dog | ebola | fleas |
| ----------------- | ----- | --- | --- | ----- | ----- |
| My dog has fleas  |   0   |  0  |  1  |   0   |   1   |
| My cat has ebola  |   0   |  0  |  0  |   1   |   0   |
| Aaron has ebola   |   0   |  0  |  0  |   1   |   0   |

---

## Document Classification

Let's add classes to each document.


|                   | aaron | cat | dog | ebola | fleas | CLASS |
| ----------------- | ----- | --- | --- | ----- | ----- | ----- |
| My dog has fleas  |   0   |  0  |  1  |   0   |   1   |  vet  |
| My cat has ebola  |   0   |  0  |  0  |   1   |   0   |  vet  |
| Aaron has ebola   |   1   |  0  |  0  |   1   |   0   |  cdc  |


Let's predict the class for a new document: "Aaron's dog has fleas"

---

## Document Classification

```
          P(B|A) * P(A)
P(A|B) = ---------------
              P(B)
```

```
                P(Doc|Class) * P(Class)
P(Class|Doc) = -------------------------
                         P(Doc)
```

---

## "aaron", "dog", "fleas"

| aaron | dog  | fleas |
| ----- | ---- | ----- |
| 0.33  | 0.33 | 0.33  |


|     | P(Class) | P(Doc&#124;Class)   |
| --- | -------- | -------------- |
| vet |   0.66   | 0 * 0.5 * 0.5  |
| cdc |   0.33   | 1 * 0 * 0      |

Predicted Class: ?

---

## "aaron", "dog", "fleas"

| aaron | dog  | fleas |
| ----- | ---- | ----- |
| 0.33  | 0.33 | 0.33  |


|     | P(Class) | P(Doc&#124;Class)   |
| --- | -------- | -------------- |
| vet |   0.66   | 0 * 0.5 * 0.5  |
| cdc |   0.33   | 1 * 0 * 0      |

Predicted Class: Nothing! Too many zeros.

---

## Smoothing

*Additive smoothers* help prevent 0's from killing everything.  A constant is added to each class.  When the smoother is 1, it's called a *Laplace smoother*.

Predicted class with Laplace smoothing: Vet

- Vet: 54.2%
- CDC: 45.8%

---

## Multiclass Classification

Multinomial classifiers perform a one-of-many classification.

What if you want if you should call the vet *and* the CDC when your cat has ebola?

[https://github.com/drewlanenga/multibayes](https://github.com/drewlanenga/multibayes) performs **multiclass** classifcation &mdash; many-of-many





