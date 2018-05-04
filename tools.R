# intData
#   Purpose: interpolate a value between two time series observations
#   Arguments:
#     t (POSIXct) the time you want to find an interpolated value for
#     datetimes (POSIXct) a vector of datetimes of continuous observations
#     data (numeric) a vector of measured values corresponding to the datetimes vector
#     maxDiff (numeric) the maximum number of hours between two points used for interpolation
#       if the two points bracketing t are more than maxDiff away from each other, NA will be returned
intData <- function(t, datetimes, data, maxDiff=4) {
  timeDiff <- difftime(t, datetimes)
  if(all(timeDiff < 0) || all(timeDiff > 0))
    return(NA)

  if(any(timeDiff==0)) {
    out <- data[timeDiff==0]
  } else {
    t1 <- datetimes[timeDiff == min(timeDiff[timeDiff > 0])]
    t2 <- datetimes[timeDiff == max(timeDiff[timeDiff < 0])]
    d1 <- data[datetimes==t1]
    d2 <- data[datetimes==t2]
    tL <- as.numeric(difftime(t2, t1, units="hours"))
    tE <- as.numeric(difftime(t, t1, units="hours"))
    if(tL > maxDiff) {
      out <- NA
    } else {
      out <- (((d2 - d1) * tE) / tL) + d1
    }
  }
  return(out)
}

#intDataVector
#   Purpose: Interpolate values of a measured variable for a series of times
 
intDataVector <- function(lookup, datetimes, data, maxDiff=4) {
  
  out <- vector()
  
  for(i in 1:length(lookup)) {
    out[length(out) + 1] <- intData(lookup[i], datetimes, data, maxDiff=maxDiff)
  }
  
  return(out)
  
}

#Interpolate values for a sample data file from a continuous data file
msc <- function(sample_data, sample_dateformat, sample_date_heading = "datetime",
                cont_data, continuous_dateformat, continuous_date_heading = "datetime",
                maxDiff = 4) {
  
  #Read sample data and convert date column
  # sample_data <- sample_data_file
  sample_data[,sample_date_heading] <- 
    as.POSIXct(sample_data[,sample_date_heading], format=sample_dateformat)
  
  #Read continuous data and convert date column
  # cont_data <- cont_data_file
  cont_data[,continuous_date_heading] <-
    as.POSIXct(cont_data[,continuous_date_heading], format=continuous_dateformat)
  
  #Iterate through each non-date, numeric column in the continuous data and add it to the sample frame
  s_datetimes <- sample_data[,sample_date_heading]
  cont_vars <- names(cont_data)[names(cont_data) != continuous_date_heading]
  classes <- sapply(cont_vars, function(x) {class(cont_data[,x])})
  cont_vars <- cont_vars[classes %in% c("numeric", "integer")]
  for(i in cont_vars) {
    
    c_data <- cont_data[,c(continuous_date_heading, i)]
    c_data <- na.omit(c_data)
    
    sample_data[,i] <-
      intDataVector(lookup=s_datetimes,
                    datetimes=c_data[,continuous_date_heading],
                    data = c_data[,i],
                    maxDiff = maxDiff)
    
  }
  
  #Return the sample frame with continuous variables
  return(sample_data)
}
