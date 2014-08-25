
#
#  chart stuff
#

# maybe pass gradient colors as parameters later
make.gradient <- function() {
	calculate.gradient <- function(p) {
		r <- g <- b <- 0
		if( p >= 0.5 ) {
			r <- (1 - (p)) * 2
			g <- 1
		} else {
			r <- 1
			g <- p * 2
		}

		return(rgb(g, r, b))
	}

	return(calculate.gradient)
}
gradient <- make.gradient()

par(mfrow = c(1,1))

#x <- rnorm(60, size, size * 0.15)
#y <- rnorm(10, size, size * 0.25)
#series <- c(x, y)

#
# series stuff
#

random.walk <- function(n, start, distribution, ...) {
	result <- rep(0, n)
	result[1] <- start

	for(i in 2:n) {
		value <- distribution(1, ...)
		result[i] <- max(result[i - 1] + value, 0)
	}

	return(result)
}


# load up the anoomaly functions (stored in anomaly.functions)
source("anomalies.R")

## get a running window for the series to test if the last
## point in the window is anomalous

score.series <- function(series, window.reference, window.active, anomaly.functions) {
	probs <- matrix(0, nrow = length(series), ncol = length(anomaly.functions))
	
	window.index <- window.active:length(series)
	print(window.index)
	#window.index <- get.series.index(length(series), window.reference)
	for(i in window.index) {
		index.reference <- get.series.index(i, window.reference)
		index.active <- get.series.index(i, window.active)

		if( length(index.reference) == length(index.active) ) {
			probs[i, ] <- rep(0, ncol(probs))
		} else {
			j <- 1
			for(anomaly.function in anomaly.functions) {
				probs[i, j] <- cap(anomaly.function$fun(series[index.reference], series[index.active]), 0, 1)
				j <- j + 1
			}
		}
	}

	w <- unlist(lapply(anomaly.functions, function(x){ x$weight }))

	all.probs <- apply(probs, 1, weighted.mean, w = w)
	#all.probs <- rowMeans(probs)
	probs <- cbind(probs, all.probs)

	lwds <- rep(1, ncol(probs))
	lwds[length(lwds)] <- lwds[length(lwds)] * 3

	cols <- 1:ncol(probs) + 1 # offset colors from 1 -- don't do black!

	#dev.new()
	par(mfrow = c(1, 1))

	plot(series, type = 'l', ylim = c(0, max(series) + (diff(range(series)) * 0.4)),
		ylab = "Segment Size", xlab = "", main = "Random Walk",
		sub = paste("Reference Period: ", window.reference, "\nActive Period: ", window.active, sep = ""))

	for(i in window.index) {
		lines(c(i - 1, i), c(series[i - 1], series[i]), col = gradient(all.probs[i]), lwd = 4)
	}

	matplot(probs, type = 'l', col = cols, lwd = lwds, lty = 1)

	abline(h = 0.95, lwd = 2)
	legend("topleft", c(unlist(lapply(anomaly.functions, function(x){ x$name })),
		"Weighted Average"), lwd = lwds, col = cols, bg = "#FFFFFF")

	return(probs)
}

dev.new()

series <- random.walk(120, 20000, rnorm, mean = 0, sd = size * 0.05)

score.series(series, 14, 7, anomaly.functions)
score.series(series, 7, 2, anomaly.functions)

