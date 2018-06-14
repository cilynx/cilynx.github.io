---
layout: post
title:  Machine Learning Brain Dump
date:   2018-06-14 11:15:43 -0700
tags:   machine_learning
---
<https://www.youtube.com/channel/UCQALLeQPoZdZC4JNUboVEUg>



<https://www.youtube.com/watch?v=IpGxLWOIZy4>

Linear Regression - Home Prices by Size
* Grading Descent
 * Least squares

Naive Bayes - Email Spam Classifier

Decision Tree - Recommending Apps

Logistic Regression - Slicing Data Set in Two - Admission to University
* Gradient descent
 * Log-loss Function (assigns large value to mis-classified points and small value to classified points)

Neural Network - Intersecting Multiple Logistic Regressions to Isolate a Section
* Linear Optimization - Find the line that maximizes the distance to the boundary points
 * Support Vector Machine - Cuts dataset in two at the best "line"
   * Kernel Trick - Find a function that gives high values for red and low for green on vice-versa

K-Means Clustering - Define clusters and centroids (pizza parlors) when you know how many clusters you want
* Pick one random point for each cluster you have
* Assign each house to the parlor closest to it
* Move the parlor to the center of its assigned houses
* Repeat previous two steps until parlor doesn't move

Heirarchical (agglomerative) Clustering
* Define what is "too far apart"
* Find smallest distance between houses including at least one unclustered house and add them to a cluster
* If the distance is "too far", stop clustering  

<http://www.dummies.com/programming/big-data/data-science/data-science-performing-hierarchical-clustering-with-python/>

Linkage Methods
* Ward - Tends to look for spherical clusters, very cohesive inside and extremely differentiated from other groups.  Another nice characteristic is that the method tends to find clusters of similar size.  It works only with the Euclidean distance.
* Complete - Links clusters using their furthest observations, that is, their most dissimilar data points.  Consequently, clusters created using this method tend to be comprised of highly similar observations, making the resulting groups quite compact.
* Average - Links clusters using their centroids and ignoring their boundaries.  The method creates larger groups than the complete method.  In addition, the clusters can be different size and shapes, contrary to the Ward's solutions.  Consequently, this average, multipurpose approach sees successful use in the field of biological sciences.

Distance Metrics
* Euclidean (euclidean or l2) - In a map, the shortest distance between two points
* Manhattan (manhattan or l1) - Calculated by summing the absolute value of the difference between the dimensions.  Think of moving along one axis and then the other, like a car driving along city blocks
* Cosine (cosine) - A good choice when there are too many variables and you worry that some variable may not be significant.  Cosine distance reduces noise by taking the shape of the variables, more than their values, into account.  It tends to associate observations that have the same maximum and minimum variables, regardless of their effective value.

<https://www.youtube.com/watch?v=BR9h47Jtqyw>

Gradient descent error function
* Probability function
* Activation function -- every point in the domain gets mapped to somewhere between 0 and 1 in the probability function
** f(x) = 1/(1+e^(-x)) -- sigmoid function
** Maximum Likelihood
** sum of -log of probabilities -- lower is less error

Combining Regions
* Add probabilities from each area (weighted as desired), map via the activation function to get combined probability

Neural Network - 29:00

Deep Neural Network -- Neural network w/ multiple hidden layers - 31:00

<https://www.youtube.com/watch?v=2-Ol7ZB0MmU>

Friedly indroduction to Convolutional Neural Networks & Image Recognition
* Mapping / \ X and O from pixels to understood characters

<https://www.youtube.com/watch?v=UNmqTiOnRfg>

Friendly introducetion to Recurrent Neural Networks
* Perfect roommate -- Apple pie, Burger, Chicken
* Vector / matrix math

<https://www.youtube.com/watch?v=aDW44NPhNw0>

Machine Learning: Testing and Error Metrics
* K-Fold Cross Validation - 5:00
* High Recall (medical diagnosis -- better to send a healthy person for more tests) vs. High Precision (spam -- better to miss a spam)
* F1 Score = Harmonic Mean = 2xy/(x+y)
* Fb score -- if b small (<1) weigh towards precision -- if large (>1) weigh towards recall
* Overfitting / underfitting - 27:00
  * Under -- error due to bias -- too simple
    * Bad Train, Bad Test
  * Over -- error due to variance -- too specific
    * Great train, Bad test
Grid Search Cross Validation - 41:00
* Kernel and Gamma
Parameters and Hyperparameters - 42:00

<https://youtu.be/A8jysqMTEQU>

dbpedia.org -- Wikipedia, turned into structured knowledge

WordNet.  Because WordNet.

<https://github.com/dair-iitd/OpenIE-standalone>

<https://www.w3.org/TR/rdf11-primer/#section-triple>

<https://en.wikipedia.org/wiki/Semantic_triple>

<https://www.parson-europe.com/en/knowledge-base/430-knowledge-modeling.html>
* RDF / Turtle
* RDFS / RDF Schema
* OWL / OWL DL
* Hierarchies
* Taxonomies
* Ontologies
* SPARQL

<https://github.com/aoldoni/tetre>

<https://github.com/machinalis/iepy> -- REALLY __ LOOK AT THIS ONE

<https://gate.ac.uk/>
<https://www.youtube.com/playlist?list=PLO0_lNc5k9lJQnH9CsyXMIBevoZDmYYj0>

<https://www.cs.waikato.ac.nz/ml/weka/>

<https://en.wikipedia.org/wiki/Orange_(software)>


jupyter notebook

<https://www.toptal.com/machine-learning/machine-learning-theory-an-introductory-primer>
* Sigmoid Function

<https://www.youtube.com/channel/UCYO_jab_esuFRV4b17AJtAw>
<https://www.youtube.com/watch?v=aircAruvnKk>
* Multilayer Perceptron / Plain Vanilla Neural Network
* Sigmoid function squishes outputs to between 0 and 1 -- ReLU(a) = max(0, a) is the newer / "better" way
* Bias for inactivity

<https://www.youtube.com/watch?v=IHZwWFHWa-w>
* Cost function
* Back-propagation -- making the adjustments towards gradient descent to minimize the cost function
  * Doing this finds a local minimum
* Multilayer perceptron -- 80's and 90's technology

<https://www.youtube.com/watch?v=Ilg3gGewQ5U>
* Back-propagation
* Stochastic gradient descent -- drunk guy stumbling down the hill - 10:00

<https://www.youtube.com/watch?v=tIeHLnjs5U8>
* Backpropagation calculus
* Super freakin useful.

<https://www.khanacademy.org/math/multivariable-calculus/thinking-about-multivariable-function/introduction-to-multivariable-calculus/v/multivariable-functions>
* Grant (3b1b) on Khan

# Roadmaps

<https://github.com/mihui/ml>

<https://medium.com/@thisismetis/roadmap-how-to-learn-machine-learning-in-6-months-7c501889b545>

<https://www.quora.com/What-is-the-best-roadmap-to-learn-machine-learning-using-Python>
