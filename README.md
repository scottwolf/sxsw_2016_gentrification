# SXSWi 2016 Gentrification Talk
R code that was used to perform the analyses conducted for my talk.

#### "1 LTDB loading and variable creation.R"
* This file preps the decennial Census (1970, 1980, 1990, 2000, 2010) and ACS (2008, 2010, 2011) datasets. 
* There are far more lines of code than were ultimately necessary for the gentrification analyses. This was done in order to transform variables necessary for exploring other possible predictors and indicators. 
* Note: change working directory lines throughout the code to match your needs.

#### "2 ltdb_clustering nyc.R"
* This file is used to explore the gentrification variables of interest in the 5 boroughs of New York City (Bronx, Brooklyn, Manhattan, Queens, Staten Island). 
* Produces a conceptual replication of Gentrification Magazine's analysis as well as a clustering solution based on standardized z-scores for census tracts across the metropolitan area for each time period with regard to change in median home value, change in the percentage of college graduates, and change in median household income. 
* Note that this code is dependent upon running "1 LTDB loading and variable creation.R" first. 
* Note: change working directory lines throughout the code to match your needs.

#### "2 ltdb_clustering bayarea.R"
* Same as above, but for the Bay Area counties of Alameda, Contra Costa, San Francisco, San Mateo, and Marin.
  
  
  
##### After completing the above steps, datasets for each metropolitan area were uploaded to cartodb.com along with the GIS shapefiles of the census tracts for each metropolitan area.
##### The GIS shapefile and the datasets were merged, then visualized (filtered by timeperiod).
