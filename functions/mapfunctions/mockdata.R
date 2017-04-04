#' Generate mock data for major and minor categories
#' 
#' This function creates mock data for the major and minor categories in the qualtrics survey. Used for testing purposes.
#' 
#' @param seed Ensures reproducibility of results by setting a seed for R's pseudo-random number generator. Defaults to random number between 1 and 10.000
#' @param countries Character vector with country names
#' @param ISO3.codes character vector with ISO3 codes for countries
#' 
#' @author Jasper Ginn

mockData <- function(seed = floor(runif(1, 1, 10000)), countries, ISO3.codes) {
  
  # List for final results
  results <- list()

  # Create a series of n numbers that sum to 1 (simulate percentages)
  jobFun <- function(length.vector, n, seed = floor(runif(1, 1, 10000))) {
    set.seed(seed)
    m <- matrix(runif(length.vector*n,0,1), ncol=n)
    m<- sweep(m, 1, rowSums(m), FUN="/")
    m
  }
  
  #
  # MAJOR CATEGORIES MOCK DATA
  #
  
  # For each, create data
  rdf <- as.data.frame(jobFun(length(countries), 5, seed))
  # Give colnames
  colnames(rdf) <- major.cats
  # Add countries
  rdf <- cbind(countries, ISO3.codes, rdf)
  colnames(rdf)[1] <- "country"
  
  # Add to results
  results[["data.major.cats"]] <- rdf
  
  #
  # MINOR CATEGORIES MOCK DATA
  #
  
  # For each main category, make mock data for sub categories
  minor.mock.data <- lapply(major.cats, function(x) {
    
    tdata <- minor.cats[[x]]
    
    # Create random percentages
    rdf <- as.data.frame(jobFun(length(countries), length(tdata), seed = floor(runif(1, 1, 10000))))
    # Give colnames
    colnames(rdf) <- as.character(tdata)
    # Add countries
    rdf <- cbind(countries, ISO3.codes, rdf)
    colnames(rdf)[1] <- "country"
    # Return
    return(rdf)
    
  })
  
  # Add names for each dataset
  names(minor.mock.data) <- major.cats

  # Add to results
  results[["data.minor.cats"]] <- minor.mock.data

  # Return
  return(results)
  
}
