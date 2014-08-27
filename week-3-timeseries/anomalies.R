
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

anomaly.functions <- list(
	list(
		name = "z-score",
		fun = anomaly.threesigma,
		weight = 1.00
	),
	list(
		name = "Kolmogorov-Smirnov",
		fun = anomaly.ks,
		weight = 1.00
	),
	list(
		name = "Diff CDF",
		fun = anomaly.diffcdf,
		weight = 1.0
	)
)




