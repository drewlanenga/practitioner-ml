
# two-sided probabilities
z.to.p <- function(z) {
	p <- pnorm(z)

	if(p > 0.5) {
		p <- 1 - p
	}

	return(p.to.prob(p / 2))
}

p.to.prob <- function(p) {
	return( 1 - p )
}

cap <- function(x, x.min, x.max) {
	return( max(min(x, x.max), x.min) )
}

get.series.index <- function(n, window) {
	index <- 1:n
	if(window < n) {
		index <- (n - window + 1):n
	}
	return( index )
}

anomaly.threesigma <- function(series.reference, series.active) {
	z <- (mean(series.active) - mean(series.reference)) / sd(series.reference)
	return( z.to.p(z) )
}

anomaly.ks <- function(series.reference, series.active) {
	test <- ks.test(series.reference, series.active, exact = FALSE)
	return( 1 - (test$p.value * 2) )
}

anomaly.diffcdf <- function(series.reference, series.active) {
	reference.diff <- diff(series.reference)

	# find the empirical percentiles
	reference.ecdf <- ecdf(reference.diff)

	# difference between active and reference
	active.diff <- mean(series.active) - mean(series.reference)

	# scale so max probability is in tails and prob at 0.5 is 0
	print(reference.ecdf(active.diff))
	return( abs(0.5 - reference.ecdf(active.diff)) * 2)
}

anomaly.prob <- function(series.reference, series.active) {
	pdiff <- (mean(series.active) - mean(series.reference)) / mean(series.reference)
	return( 1 / (1 + exp(-(6*pdiff)) ))
}

anomaly.rank <- function(series.reference, series.active) {
	refsize <- length(series.reference)
	vector <- append(series.reference, series.active)
	totsize <- length(vector)

	samp <- rank(abs(diff(vector)), ties.method="min")
	samp <- samp[refsize:(totsize-1)]
	summ <- sum(samp)
	print(summ)

	i <- count <- 0
	tempsumm <- 0.0

	while (i < 100) {
		temp <- rank(abs(diff(sample(vector))), ties.method="min")
		
		temp <- temp[refsize:(totsize-1)]
		tempsumm <- sum(temp)
		print(tempsumm)
		
		if (tempsumm < summ) {
			count <- count + 1
		}
		i <- i + 1
	}
	return (count / 100)
}

anomaly.functions <- list(
	list(
		name = "Kolmogorov-Smirnov",
		fun = anomaly.ks,
		weight = 1.00
	),
	list(
		name = "Diff CDF",
		fun = anomaly.diffcdf,
		weight = 1.0
	),
	list(
		name = "Rank",
		fun = anomaly.rank,
		weight = 1.0
	)
)




