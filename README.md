README
================

This software is preliminary or provisional and is subject to revision. It is being provided to meet the need for timely best science. The software has not received final approval by the U.S. Geological Survey (USGS). No warranty, expressed or implied, is made by the USGS or the U.S. Government as to the functionality of the software and related material nor shall the fact of release constitute any such warranty. The software is provided on the condition that neither the USGS nor the U.S. Government shall be held liable for any damages resulting from the authorized or unauthorized use of the software.

What this app does
------------------

This app merges discrete sample data and continuously measured data. A value for each numerical variable in the continuous data file is interpolated for each sample time in the sample data file, and the result is returned as one merged file.

Running the app remotely
------------------------

You will need to have a recent version of R installed (3.2.0 +). If you're new to R, you can start [here](https://owi.usgs.gov/R/). This application is fairly simple to run if you can get to an R console, whether in RStudio or just a plain R console. You should be able to just copy and paste the code fragments from this page.

You will need to have the [shiny](https://github.com/rstudio/shiny) package installed. This could be done by running the following command in an R Console (or RStudio):

``` r
install.packages("shiny")
```

Once you have the packages installed, you can start the app with the following commands:

``` r
library(shiny)
runGitHub("PatrickEslick/InterpolateTimeSeries", launch.browser=TRUE)
```

Using the app
-------------

### 1 Getting your data ready

You will need to prepare two .csv files, one for your sample data and one for your continuous data. Both files can have any number of columns, but only numerical columns from the continuous file will be included in the output file.

Both files need to have one column that contains the date and time of each observation in one of the formats listed in the dropdown menus below. If it would help you to have a certain date format added to the list, let me know.

The USGS R package [dataRetrieval](http://usgs-r.github.io/dataRetrieval/) makes the task of obtaining sample data and continuous data very easy. The *readNWISuv()* function can be used to get continuous data and the *readNWISqw()* function can be used for sample data. However, if you are not able to use R, or need to get data that is not available on NWIS web, you may have to use a different methodology to obtain the files.

### 2 Running the app

1.  Select your sample data file by clicking "Browse" and navigating to the file location
2.  From the "Datetime column" dropdown, select the name of the column in your file that holds the datetime of the samples
3.  Select which format your datetime column is in
4.  Repeat steps 1 - 3 for the continuous file
5.  Adjust the maximum difference slider to the desired level. This is the maximum time span between two continuous data points for which a value will be interpolated. If the difference is greater than that for a sample, "NA" will be returned.
6.  Click "Interpolate". A file will be downloaded in your browser. This could take a minute.
