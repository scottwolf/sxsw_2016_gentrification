# ONLY RUN THE FOLLOWING LINES IF ltdb_all_joined_reduced_long is not currently loaded from running "LTDB loading and variable creation.R"
setwd("/Users/swolf/Google Drive/Internal Projects/SXSW_gentrification")
ltdb_all_joined_reduced_long <- read.csv("ltdb_all_joined_reduced_long.csv")
ltdb_all_joined_reduced_long$X <- NULL

# MAKE SURE "ltdb_all_joined_reduced_long" is loaded (or load it with code above)

# Creating bayarea-only LTDB dataframe
ltdb_all_joined_reduced_long_bayarea <- ltdb_all_joined_reduced_long[which(
    ltdb_all_joined_reduced_long$state == 'CA' & ltdb_all_joined_reduced_long$county == "Alameda County" |
    ltdb_all_joined_reduced_long$state == 'CA' & ltdb_all_joined_reduced_long$county == "Contra Costa County" |
    ltdb_all_joined_reduced_long$state == 'CA' & ltdb_all_joined_reduced_long$county == "San Francisco County" |
    ltdb_all_joined_reduced_long$state == 'CA' & ltdb_all_joined_reduced_long$county == "San Mateo County" |
    ltdb_all_joined_reduced_long$state == 'CA' & ltdb_all_joined_reduced_long$county == "Marin County")
  ,]



# Reproducing Gentrification Magazine report
# create gentrification categorical variable

# subsetting data from long bayarea file
ltdb_all_joined_reduced_bayarea_1980 <- subset(ltdb_all_joined_reduced_long_bayarea, year == 1980)
ltdb_all_joined_reduced_bayarea_1990 <- subset(ltdb_all_joined_reduced_long_bayarea, year == 1990)
ltdb_all_joined_reduced_bayarea_2000 <- subset(ltdb_all_joined_reduced_long_bayarea, year == 2000)
ltdb_all_joined_reduced_bayarea_2008 <- subset(ltdb_all_joined_reduced_long_bayarea, year == 2008)
ltdb_all_joined_reduced_bayarea_2010 <- subset(ltdb_all_joined_reduced_long_bayarea, year == 2010)
ltdb_all_joined_reduced_bayarea_2011 <- subset(ltdb_all_joined_reduced_long_bayarea, year == 2011)


# 1970 to 1980
quantile(ltdb_all_joined_reduced_long_bayarea$hinc_pre[ltdb_all_joined_reduced_long_bayarea$year == 1980], .40, na.rm=TRUE) # 40th percentile of median HH income
quantile(ltdb_all_joined_reduced_long_bayarea$mhmval_post[ltdb_all_joined_reduced_long_bayarea$year == 1980], .40, na.rm=TRUE) # 40th percentile of median home value
quantile(ltdb_all_joined_reduced_long_bayarea$pcol_delta[ltdb_all_joined_reduced_long_bayarea$year == 1980], .67, na.rm=TRUE) # 67th percentile of growth in 4 year degrees
quantile(ltdb_all_joined_reduced_long_bayarea$mhmval_delta[ltdb_all_joined_reduced_long_bayarea$year == 1980], .67, na.rm=TRUE) # 67th percentile of growth in median home value 


ltdb_all_joined_reduced_bayarea_1980$gent_cat <- ifelse(ltdb_all_joined_reduced_bayarea_1980$pop_pre < 500 | # at least 500 residents at beginning
                                                         ltdb_all_joined_reduced_bayarea_1980$pop_post < 500 | # at least 500 residents at end
                                                         ltdb_all_joined_reduced_bayarea_1980$hinc_pre > quantile(ltdb_all_joined_reduced_bayarea_1980$hinc_pre, .40, na.rm=TRUE) | # NOT in the bottom 40th percentile of median HH income
                                                         ltdb_all_joined_reduced_bayarea_1980$mhmval_pre > quantile(ltdb_all_joined_reduced_bayarea_1980$mhmval_pre, .40, na.rm=TRUE), # NOT in the bottom 40th percentile of median home value
                                                       "not eligible",
                                                       
                                                       ifelse(ltdb_all_joined_reduced_bayarea_1980$pop_pre >= 500 &
                                                                ltdb_all_joined_reduced_bayarea_1980$pop_post >= 500 &
                                                                ltdb_all_joined_reduced_bayarea_1980$hinc_pre <= quantile(ltdb_all_joined_reduced_bayarea_1980$hinc_pre, .40, na.rm=TRUE) &
                                                                ltdb_all_joined_reduced_bayarea_1980$mhmval_pre <= quantile(ltdb_all_joined_reduced_bayarea_1980$mhmval_pre, .40, na.rm=TRUE) &
                                                                ltdb_all_joined_reduced_bayarea_1980$mhmval_delta > 0 &
                                                                ltdb_all_joined_reduced_bayarea_1980$mhmval_delta >= quantile(ltdb_all_joined_reduced_bayarea_1980$mhmval_delta, .67, na.rm=TRUE) &
                                                                ltdb_all_joined_reduced_bayarea_1980$pcol_delta > 0 &
                                                                ltdb_all_joined_reduced_bayarea_1980$pcol_delta >= quantile(ltdb_all_joined_reduced_bayarea_1980$pcol_delta, .67, na.rm=TRUE), 
                                                              "gentrified",
                                                              
                                                              ifelse(ltdb_all_joined_reduced_bayarea_1980$pop_pre >= 500 &
                                                                       ltdb_all_joined_reduced_bayarea_1980$pop_post >= 500 &
                                                                       ltdb_all_joined_reduced_bayarea_1980$hinc_pre <= quantile(ltdb_all_joined_reduced_bayarea_1980$hinc_pre, .40, na.rm=TRUE) &
                                                                       ltdb_all_joined_reduced_bayarea_1980$mhmval_pre <= quantile(ltdb_all_joined_reduced_bayarea_1980$mhmval_pre, .40, na.rm=TRUE) &
                                                                       (ltdb_all_joined_reduced_bayarea_1980$mhmval_delta <= 0 |
                                                                          ltdb_all_joined_reduced_bayarea_1980$mhmval_delta < quantile(ltdb_all_joined_reduced_bayarea_1980$mhmval_delta, .67, na.rm=TRUE) |
                                                                          ltdb_all_joined_reduced_bayarea_1980$pcol_delta <= 0 |
                                                                          ltdb_all_joined_reduced_bayarea_1980$pcol_delta < quantile(ltdb_all_joined_reduced_bayarea_1980$pcol_delta, .67, na.rm=TRUE)), 
                                                                     "did not gentrify", NA)))

ltdb_all_joined_reduced_bayarea_1980$gent_cat <- as.factor(ltdb_all_joined_reduced_bayarea_1980$gent_cat)
table(ltdb_all_joined_reduced_bayarea_1980$gent_cat)
prop.table(table(ltdb_all_joined_reduced_bayarea_1980$gent_cat))


# 1980 to 1990

quantile(ltdb_all_joined_reduced_long_bayarea$hinc_pre[ltdb_all_joined_reduced_long_bayarea$year == 1990], .40, na.rm=TRUE) # 40th percentile of median HH income
quantile(ltdb_all_joined_reduced_long_bayarea$mhmval_post[ltdb_all_joined_reduced_long_bayarea$year == 1990], .40, na.rm=TRUE) # 40th percentile of median home value
quantile(ltdb_all_joined_reduced_long_bayarea$pcol_delta[ltdb_all_joined_reduced_long_bayarea$year == 1990], .67, na.rm=TRUE) # 67th percentile of growth in 4 year degrees
quantile(ltdb_all_joined_reduced_long$mhmval_delta[ltdb_all_joined_reduced_long_bayarea$year == 1990], .67, na.rm=TRUE) # 67th percentile of growth in median home value 


ltdb_all_joined_reduced_bayarea_1990$gent_cat <- ifelse(ltdb_all_joined_reduced_bayarea_1990$pop_pre < 500 | # at least 500 residents at beginning
                                                         ltdb_all_joined_reduced_bayarea_1990$pop_post < 500 | # at least 500 residents at end
                                                         ltdb_all_joined_reduced_bayarea_1990$hinc_pre > quantile(ltdb_all_joined_reduced_bayarea_1990$hinc_pre, .40, na.rm=TRUE) | # NOT in the bottom 40th percentile of median HH income
                                                         ltdb_all_joined_reduced_bayarea_1990$mhmval_pre > quantile(ltdb_all_joined_reduced_bayarea_1990$mhmval_pre, .40, na.rm=TRUE), # NOT in the bottom 40th percentile of median home value
                                                       "not eligible",
                                                       
                                                       ifelse(ltdb_all_joined_reduced_bayarea_1990$pop_pre >= 500 &
                                                                ltdb_all_joined_reduced_bayarea_1990$pop_post >= 500 &
                                                                ltdb_all_joined_reduced_bayarea_1990$hinc_pre <= quantile(ltdb_all_joined_reduced_bayarea_1990$hinc_pre, .40, na.rm=TRUE) &
                                                                ltdb_all_joined_reduced_bayarea_1990$mhmval_pre <= quantile(ltdb_all_joined_reduced_bayarea_1990$mhmval_pre, .40, na.rm=TRUE) &
                                                                ltdb_all_joined_reduced_bayarea_1990$mhmval_delta > 0 &
                                                                ltdb_all_joined_reduced_bayarea_1990$mhmval_delta >= quantile(ltdb_all_joined_reduced_bayarea_1990$mhmval_delta, .67, na.rm=TRUE) &
                                                                ltdb_all_joined_reduced_bayarea_1990$pcol_delta > 0 &
                                                                ltdb_all_joined_reduced_bayarea_1990$pcol_delta >= quantile(ltdb_all_joined_reduced_bayarea_1990$pcol_delta, .67, na.rm=TRUE), 
                                                              "gentrified",
                                                              
                                                              ifelse(ltdb_all_joined_reduced_bayarea_1990$pop_pre >= 500 &
                                                                       ltdb_all_joined_reduced_bayarea_1990$pop_post >= 500 &
                                                                       ltdb_all_joined_reduced_bayarea_1990$hinc_pre <= quantile(ltdb_all_joined_reduced_bayarea_1990$hinc_pre, .40, na.rm=TRUE) &
                                                                       ltdb_all_joined_reduced_bayarea_1990$mhmval_pre <= quantile(ltdb_all_joined_reduced_bayarea_1990$mhmval_pre, .40, na.rm=TRUE) &
                                                                       (ltdb_all_joined_reduced_bayarea_1990$mhmval_delta <= 0 |
                                                                          ltdb_all_joined_reduced_bayarea_1990$mhmval_delta < quantile(ltdb_all_joined_reduced_bayarea_1990$mhmval_delta, .67, na.rm=TRUE) |
                                                                          ltdb_all_joined_reduced_bayarea_1990$pcol_delta <= 0 |
                                                                          ltdb_all_joined_reduced_bayarea_1990$pcol_delta < quantile(ltdb_all_joined_reduced_bayarea_1990$pcol_delta, .67, na.rm=TRUE)), 
                                                                     "did not gentrify", NA)))

ltdb_all_joined_reduced_bayarea_1990$gent_cat <- as.factor(ltdb_all_joined_reduced_bayarea_1990$gent_cat)
table(ltdb_all_joined_reduced_bayarea_1990$gent_cat)
prop.table(table(ltdb_all_joined_reduced_bayarea_1990$gent_cat))



# 1990 to 2000

quantile(ltdb_all_joined_reduced_long_bayarea$hinc_pre[ltdb_all_joined_reduced_long_bayarea$year == 2000], .40, na.rm=TRUE) # 40th percentile of median HH income
quantile(ltdb_all_joined_reduced_long_bayarea$mhmval_post[ltdb_all_joined_reduced_long_bayarea$year == 2000], .40, na.rm=TRUE) # 40th percentile of median home value
quantile(ltdb_all_joined_reduced_long_bayarea$pcol_delta[ltdb_all_joined_reduced_long_bayarea$year == 2000], .67, na.rm=TRUE) # 67th percentile of growth in 4 year degrees
quantile(ltdb_all_joined_reduced_long_bayarea$mhmval_delta[ltdb_all_joined_reduced_long_bayarea$year == 2000], .67, na.rm=TRUE) # 67th percentile of growth in median home value 


ltdb_all_joined_reduced_bayarea_2000$gent_cat <- ifelse(ltdb_all_joined_reduced_bayarea_2000$pop_pre < 500 | # at least 500 residents at beginning
                                                         ltdb_all_joined_reduced_bayarea_2000$pop_post < 500 | # at least 500 residents at end
                                                         ltdb_all_joined_reduced_bayarea_2000$hinc_pre > quantile(ltdb_all_joined_reduced_bayarea_2000$hinc_pre, .40, na.rm=TRUE) | # NOT in the bottom 40th percentile of median HH income
                                                         ltdb_all_joined_reduced_bayarea_2000$mhmval_pre > quantile(ltdb_all_joined_reduced_bayarea_2000$mhmval_pre, .40, na.rm=TRUE), # NOT in the bottom 40th percentile of median home value
                                                       "not eligible",
                                                       
                                                       ifelse(ltdb_all_joined_reduced_bayarea_2000$pop_pre >= 500 &
                                                                ltdb_all_joined_reduced_bayarea_2000$pop_post >= 500 &
                                                                ltdb_all_joined_reduced_bayarea_2000$hinc_pre <= quantile(ltdb_all_joined_reduced_bayarea_2000$hinc_pre, .40, na.rm=TRUE) &
                                                                ltdb_all_joined_reduced_bayarea_2000$mhmval_pre <= quantile(ltdb_all_joined_reduced_bayarea_2000$mhmval_pre, .40, na.rm=TRUE) &
                                                                ltdb_all_joined_reduced_bayarea_2000$mhmval_delta > 0 &
                                                                ltdb_all_joined_reduced_bayarea_2000$mhmval_delta >= quantile(ltdb_all_joined_reduced_bayarea_2000$mhmval_delta, .67, na.rm=TRUE) &
                                                                ltdb_all_joined_reduced_bayarea_2000$pcol_delta > 0 &
                                                                ltdb_all_joined_reduced_bayarea_2000$pcol_delta >= quantile(ltdb_all_joined_reduced_bayarea_2000$pcol_delta, .67, na.rm=TRUE), 
                                                              "gentrified",
                                                              
                                                              ifelse(ltdb_all_joined_reduced_bayarea_2000$pop_pre >= 500 &
                                                                       ltdb_all_joined_reduced_bayarea_2000$pop_post >= 500 &
                                                                       ltdb_all_joined_reduced_bayarea_2000$hinc_pre <= quantile(ltdb_all_joined_reduced_bayarea_2000$hinc_pre, .40, na.rm=TRUE) &
                                                                       ltdb_all_joined_reduced_bayarea_2000$mhmval_pre <= quantile(ltdb_all_joined_reduced_bayarea_2000$mhmval_pre, .40, na.rm=TRUE) &
                                                                       (ltdb_all_joined_reduced_bayarea_2000$mhmval_delta <= 0 |
                                                                          ltdb_all_joined_reduced_bayarea_2000$mhmval_delta < quantile(ltdb_all_joined_reduced_bayarea_2000$mhmval_delta, .67, na.rm=TRUE) |
                                                                          ltdb_all_joined_reduced_bayarea_2000$pcol_delta <= 0 |
                                                                          ltdb_all_joined_reduced_bayarea_2000$pcol_delta < quantile(ltdb_all_joined_reduced_bayarea_2000$pcol_delta, .67, na.rm=TRUE)), 
                                                                     "did not gentrify", NA)))

ltdb_all_joined_reduced_bayarea_2000$gent_cat <- as.factor(ltdb_all_joined_reduced_bayarea_2000$gent_cat)
table(ltdb_all_joined_reduced_bayarea_2000$gent_cat)
prop.table(table(ltdb_all_joined_reduced_bayarea_2000$gent_cat))


# 2000 to 2008

quantile(ltdb_all_joined_reduced_long_bayarea$hinc_pre[ltdb_all_joined_reduced_long_bayarea$year == 2008], .40, na.rm=TRUE) # 40th percentile of median HH income
quantile(ltdb_all_joined_reduced_long_bayarea$mhmval_post[ltdb_all_joined_reduced_long_bayarea$year == 2008], .40, na.rm=TRUE) # 40th percentile of median home value
quantile(ltdb_all_joined_reduced_long_bayarea$pcol_delta[ltdb_all_joined_reduced_long_bayarea$year == 2008], .67, na.rm=TRUE) # 67th percentile of growth in 4 year degrees
quantile(ltdb_all_joined_reduced_long_bayarea$mhmval_delta[ltdb_all_joined_reduced_long_bayarea$year == 2008], .67, na.rm=TRUE) # 67th percentile of growth in median home value 


ltdb_all_joined_reduced_bayarea_2008$gent_cat <- ifelse(ltdb_all_joined_reduced_bayarea_2008$pop_pre < 500 | # at least 500 residents at beginning
                                                         ltdb_all_joined_reduced_bayarea_2008$pop_post < 500 | # at least 500 residents at end
                                                         ltdb_all_joined_reduced_bayarea_2008$hinc_pre > quantile(ltdb_all_joined_reduced_bayarea_2008$hinc_pre, .40, na.rm=TRUE) | # NOT in the bottom 40th percentile of median HH income
                                                         ltdb_all_joined_reduced_bayarea_2008$mhmval_pre > quantile(ltdb_all_joined_reduced_bayarea_2008$mhmval_pre, .40, na.rm=TRUE), # NOT in the bottom 40th percentile of median home value
                                                       "not eligible",
                                                       
                                                       ifelse(ltdb_all_joined_reduced_bayarea_2008$pop_pre >= 500 &
                                                                ltdb_all_joined_reduced_bayarea_2008$pop_post >= 500 &
                                                                ltdb_all_joined_reduced_bayarea_2008$hinc_pre <= quantile(ltdb_all_joined_reduced_bayarea_2008$hinc_pre, .40, na.rm=TRUE) &
                                                                ltdb_all_joined_reduced_bayarea_2008$mhmval_pre <= quantile(ltdb_all_joined_reduced_bayarea_2008$mhmval_pre, .40, na.rm=TRUE) &
                                                                ltdb_all_joined_reduced_bayarea_2008$mhmval_delta > 0 &
                                                                ltdb_all_joined_reduced_bayarea_2008$mhmval_delta >= quantile(ltdb_all_joined_reduced_bayarea_2008$mhmval_delta, .67, na.rm=TRUE) &
                                                                ltdb_all_joined_reduced_bayarea_2008$pcol_delta > 0 &
                                                                ltdb_all_joined_reduced_bayarea_2008$pcol_delta >= quantile(ltdb_all_joined_reduced_bayarea_2008$pcol_delta, .67, na.rm=TRUE), 
                                                              "gentrified",
                                                              
                                                              ifelse(ltdb_all_joined_reduced_bayarea_2008$pop_pre >= 500 &
                                                                       ltdb_all_joined_reduced_bayarea_2008$pop_post >= 500 &
                                                                       ltdb_all_joined_reduced_bayarea_2008$hinc_pre <= quantile(ltdb_all_joined_reduced_bayarea_2008$hinc_pre, .40, na.rm=TRUE) &
                                                                       ltdb_all_joined_reduced_bayarea_2008$mhmval_pre <= quantile(ltdb_all_joined_reduced_bayarea_2008$mhmval_pre, .40, na.rm=TRUE) &
                                                                       (ltdb_all_joined_reduced_bayarea_2008$mhmval_delta <= 0 |
                                                                          ltdb_all_joined_reduced_bayarea_2008$mhmval_delta < quantile(ltdb_all_joined_reduced_bayarea_2008$mhmval_delta, .67, na.rm=TRUE) |
                                                                          ltdb_all_joined_reduced_bayarea_2008$pcol_delta <= 0 |
                                                                          ltdb_all_joined_reduced_bayarea_2008$pcol_delta < quantile(ltdb_all_joined_reduced_bayarea_2008$pcol_delta, .67, na.rm=TRUE)), 
                                                                     "did not gentrify", NA)))

ltdb_all_joined_reduced_bayarea_2008$gent_cat <- as.factor(ltdb_all_joined_reduced_bayarea_2008$gent_cat)
table(ltdb_all_joined_reduced_bayarea_2008$gent_cat)
prop.table(table(ltdb_all_joined_reduced_bayarea_2008$gent_cat))


# 2008 to 2010

quantile(ltdb_all_joined_reduced_long_bayarea$hinc_pre[ltdb_all_joined_reduced_long_bayarea$year == 2010], .40, na.rm=TRUE) # 40th percentile of median HH income
quantile(ltdb_all_joined_reduced_long_bayarea$mhmval_post[ltdb_all_joined_reduced_long_bayarea$year == 2010], .40, na.rm=TRUE) # 40th percentile of median home value
quantile(ltdb_all_joined_reduced_long_bayarea$pcol_delta[ltdb_all_joined_reduced_long_bayarea$year == 2010], .67, na.rm=TRUE) # 67th percentile of growth in 4 year degrees
quantile(ltdb_all_joined_reduced_long_bayarea$mhmval_delta[ltdb_all_joined_reduced_long_bayarea$year == 2010], .67, na.rm=TRUE) # 67th percentile of growth in median home value 


ltdb_all_joined_reduced_bayarea_2010$gent_cat <- ifelse(ltdb_all_joined_reduced_bayarea_2010$pop_pre < 500 | # at least 500 residents at beginning
                                                         ltdb_all_joined_reduced_bayarea_2010$pop_post < 500 | # at least 500 residents at end
                                                         ltdb_all_joined_reduced_bayarea_2010$hinc_pre > quantile(ltdb_all_joined_reduced_bayarea_2010$hinc_pre, .40, na.rm=TRUE) | # NOT in the bottom 40th percentile of median HH income
                                                         ltdb_all_joined_reduced_bayarea_2010$mhmval_pre > quantile(ltdb_all_joined_reduced_bayarea_2010$mhmval_pre, .40, na.rm=TRUE), # NOT in the bottom 40th percentile of median home value
                                                       "not eligible",
                                                       
                                                       ifelse(ltdb_all_joined_reduced_bayarea_2010$pop_pre >= 500 &
                                                                ltdb_all_joined_reduced_bayarea_2010$pop_post >= 500 &
                                                                ltdb_all_joined_reduced_bayarea_2010$hinc_pre <= quantile(ltdb_all_joined_reduced_bayarea_2010$hinc_pre, .40, na.rm=TRUE) &
                                                                ltdb_all_joined_reduced_bayarea_2010$mhmval_pre <= quantile(ltdb_all_joined_reduced_bayarea_2010$mhmval_pre, .40, na.rm=TRUE) &
                                                                ltdb_all_joined_reduced_bayarea_2010$mhmval_delta > 0 &
                                                                ltdb_all_joined_reduced_bayarea_2010$mhmval_delta >= quantile(ltdb_all_joined_reduced_bayarea_2010$mhmval_delta, .67, na.rm=TRUE) &
                                                                ltdb_all_joined_reduced_bayarea_2010$pcol_delta > 0 &
                                                                ltdb_all_joined_reduced_bayarea_2010$pcol_delta >= quantile(ltdb_all_joined_reduced_bayarea_2010$pcol_delta, .67, na.rm=TRUE), 
                                                              "gentrified",
                                                              
                                                              ifelse(ltdb_all_joined_reduced_bayarea_2010$pop_pre >= 500 &
                                                                       ltdb_all_joined_reduced_bayarea_2010$pop_post >= 500 &
                                                                       ltdb_all_joined_reduced_bayarea_2010$hinc_pre <= quantile(ltdb_all_joined_reduced_bayarea_2010$hinc_pre, .40, na.rm=TRUE) &
                                                                       ltdb_all_joined_reduced_bayarea_2010$mhmval_pre <= quantile(ltdb_all_joined_reduced_bayarea_2010$mhmval_pre, .40, na.rm=TRUE) &
                                                                       (ltdb_all_joined_reduced_bayarea_2010$mhmval_delta <= 0 |
                                                                          ltdb_all_joined_reduced_bayarea_2010$mhmval_delta < quantile(ltdb_all_joined_reduced_bayarea_2010$mhmval_delta, .67, na.rm=TRUE) |
                                                                          ltdb_all_joined_reduced_bayarea_2010$pcol_delta <= 0 |
                                                                          ltdb_all_joined_reduced_bayarea_2010$pcol_delta < quantile(ltdb_all_joined_reduced_bayarea_2010$pcol_delta, .67, na.rm=TRUE)), 
                                                                     "did not gentrify", NA)))

ltdb_all_joined_reduced_bayarea_2010$gent_cat <- as.factor(ltdb_all_joined_reduced_bayarea_2010$gent_cat)
table(ltdb_all_joined_reduced_bayarea_2010$gent_cat)
prop.table(table(ltdb_all_joined_reduced_bayarea_2010$gent_cat))


# 2010 to 2011

quantile(ltdb_all_joined_reduced_long_bayarea$hinc_pre[ltdb_all_joined_reduced_long_bayarea$year == 2011], .40, na.rm=TRUE) # 40th percentile of median HH income
quantile(ltdb_all_joined_reduced_long_bayarea$mhmval_post[ltdb_all_joined_reduced_long_bayarea$year == 2011], .40, na.rm=TRUE) # 40th percentile of median home value
quantile(ltdb_all_joined_reduced_long_bayarea$pcol_delta[ltdb_all_joined_reduced_long_bayarea$year == 2011], .67, na.rm=TRUE) # 67th percentile of growth in 4 year degrees
quantile(ltdb_all_joined_reduced_long_bayarea$mhmval_delta[ltdb_all_joined_reduced_long_bayarea$year == 2011], .67, na.rm=TRUE) # 67th percentile of growth in median home value 


ltdb_all_joined_reduced_bayarea_2011$gent_cat <- ifelse(ltdb_all_joined_reduced_bayarea_2011$pop_pre < 500 | # at least 500 residents at beginning
                                                         ltdb_all_joined_reduced_bayarea_2011$pop_post < 500 | # at least 500 residents at end
                                                         ltdb_all_joined_reduced_bayarea_2011$hinc_pre > quantile(ltdb_all_joined_reduced_bayarea_2011$hinc_pre, .40, na.rm=TRUE) | # NOT in the bottom 40th percentile of median HH income
                                                         ltdb_all_joined_reduced_bayarea_2011$mhmval_pre > quantile(ltdb_all_joined_reduced_bayarea_2011$mhmval_pre, .40, na.rm=TRUE), # NOT in the bottom 40th percentile of median home value
                                                       "not eligible",
                                                       
                                                       ifelse(ltdb_all_joined_reduced_bayarea_2011$pop_pre >= 500 &
                                                                ltdb_all_joined_reduced_bayarea_2011$pop_post >= 500 &
                                                                ltdb_all_joined_reduced_bayarea_2011$hinc_pre <= quantile(ltdb_all_joined_reduced_bayarea_2011$hinc_pre, .40, na.rm=TRUE) &
                                                                ltdb_all_joined_reduced_bayarea_2011$mhmval_pre <= quantile(ltdb_all_joined_reduced_bayarea_2011$mhmval_pre, .40, na.rm=TRUE) &
                                                                ltdb_all_joined_reduced_bayarea_2011$mhmval_delta > 0 &
                                                                ltdb_all_joined_reduced_bayarea_2011$mhmval_delta >= quantile(ltdb_all_joined_reduced_bayarea_2011$mhmval_delta, .67, na.rm=TRUE) &
                                                                ltdb_all_joined_reduced_bayarea_2011$pcol_delta > 0 &
                                                                ltdb_all_joined_reduced_bayarea_2011$pcol_delta >= quantile(ltdb_all_joined_reduced_bayarea_2011$pcol_delta, .67, na.rm=TRUE), 
                                                              "gentrified",
                                                              
                                                              ifelse(ltdb_all_joined_reduced_bayarea_2011$pop_pre >= 500 &
                                                                       ltdb_all_joined_reduced_bayarea_2011$pop_post >= 500 &
                                                                       ltdb_all_joined_reduced_bayarea_2011$hinc_pre <= quantile(ltdb_all_joined_reduced_bayarea_2011$hinc_pre, .40, na.rm=TRUE) &
                                                                       ltdb_all_joined_reduced_bayarea_2011$mhmval_pre <= quantile(ltdb_all_joined_reduced_bayarea_2011$mhmval_pre, .40, na.rm=TRUE) &
                                                                       (ltdb_all_joined_reduced_bayarea_2011$mhmval_delta <= 0 |
                                                                          ltdb_all_joined_reduced_bayarea_2011$mhmval_delta < quantile(ltdb_all_joined_reduced_bayarea_2011$mhmval_delta, .67, na.rm=TRUE) |
                                                                          ltdb_all_joined_reduced_bayarea_2011$pcol_delta <= 0 |
                                                                          ltdb_all_joined_reduced_bayarea_2011$pcol_delta < quantile(ltdb_all_joined_reduced_bayarea_2011$pcol_delta, .67, na.rm=TRUE)), 
                                                                     "did not gentrify", NA)))

ltdb_all_joined_reduced_bayarea_2011$gent_cat <- as.factor(ltdb_all_joined_reduced_bayarea_2011$gent_cat)
table(ltdb_all_joined_reduced_bayarea_2011$gent_cat)
prop.table(table(ltdb_all_joined_reduced_bayarea_2011$gent_cat))

# Reducing datasets to only the "gent_cat" and "row_name" variable
gent_cat <- c("gent_cat", "row_name")
gent_cat_long_bayarea_1980 <- ltdb_all_joined_reduced_bayarea_1980[gent_cat]
gent_cat_long_bayarea_1990 <- ltdb_all_joined_reduced_bayarea_1990[gent_cat]
gent_cat_long_bayarea_2000 <- ltdb_all_joined_reduced_bayarea_2000[gent_cat]
gent_cat_long_bayarea_2008 <- ltdb_all_joined_reduced_bayarea_2008[gent_cat]
gent_cat_long_bayarea_2010 <- ltdb_all_joined_reduced_bayarea_2010[gent_cat]
gent_cat_long_bayarea_2011 <- ltdb_all_joined_reduced_bayarea_2011[gent_cat]


# Combining the gent_cat datasets
gent_cat_long_bayarea <- rbind(gent_cat_long_bayarea_1980,
                              gent_cat_long_bayarea_1990,
                              gent_cat_long_bayarea_2000,
                              gent_cat_long_bayarea_2008,
                              gent_cat_long_bayarea_2010,
                              gent_cat_long_bayarea_2011)

table(gent_cat_long_bayarea$gent_cat)
prop.table(table(gent_cat_long_bayarea$gent_cat))

# Adding gent_cat variable to ltdb_all_joined_reduced_long_bayarea
ltdb_all_joined_reduced_long_bayarea <- merge(ltdb_all_joined_reduced_long_bayarea, gent_cat_long_bayarea, by = "row_name", all=TRUE)

write.csv(ltdb_all_joined_reduced_long_bayarea, "ltdb_all_joined_reduced_long_bayarea.csv")

# Remove unnecessaary data frames
rm(ltdb_all_joined_reduced_bayarea_1980,
   ltdb_all_joined_reduced_bayarea_1990,
   ltdb_all_joined_reduced_bayarea_2000,
   ltdb_all_joined_reduced_bayarea_2008,
   ltdb_all_joined_reduced_bayarea_2010,
   ltdb_all_joined_reduced_bayarea_2011,
   
   gent_cat_long_bayarea_1980,
   gent_cat_long_bayarea_1990,
   gent_cat_long_bayarea_2000,
   gent_cat_long_bayarea_2008,
   gent_cat_long_bayarea_2010,
   gent_cat_long_bayarea_2011,
   
   gent_cat_long_bayarea,
   gent_cat)





# Clustering tracts by median HH income, median home value, % of residents with a college degree
# reduced cluster datasets
clusters <- c('year',
              'hinc_delta',
              'mhmval_delta',
              'pcol_delta',
              'pop_post', 
              'pop_pre',
              'row_name') 
bayarea_clusters <- ltdb_all_joined_reduced_long_bayarea[clusters]

# remove rows that have population < 500 pre or post
bayarea_clusters <- subset(bayarea_clusters, (bayarea_clusters$pop_pre >= 500 & bayarea_clusters$pop_post >= 500))

# cleaning up the data (removing incomplete data listwise deletion)
bayarea_clusters <- bayarea_clusters[which(!is.na(bayarea_clusters$hinc_delta) & 
                                           !is.na(bayarea_clusters$mhmval_delta) &
                                           !is.na(bayarea_clusters$pcol_delta)),]

# subsetting data to allow for standardizing variables by year
bayarea_clusters_70_80_z <- bayarea_clusters[ which(bayarea_clusters$year == 1980),] 
bayarea_clusters_80_90_z <- bayarea_clusters[ which(bayarea_clusters$year == 1990),] 
bayarea_clusters_90_00_z <- bayarea_clusters[ which(bayarea_clusters$year == 2000),]
bayarea_clusters_00_0a_z <- bayarea_clusters[ which(bayarea_clusters$year == 2008),] 
bayarea_clusters_0a_0b_z <- bayarea_clusters[ which(bayarea_clusters$year == 2010),] 
bayarea_clusters_0b_0c_z <- bayarea_clusters[ which(bayarea_clusters$year == 2011),] 
# standardizing scores within years
bayarea_clusters_70_80_z$hinc_delta_z <- scale(bayarea_clusters_70_80_z$hinc_delta)
bayarea_clusters_70_80_z$mhmval_delta_z <- scale(bayarea_clusters_70_80_z$mhmval_delta)
bayarea_clusters_70_80_z$pcol_delta_z <- scale(bayarea_clusters_70_80_z$pcol_delta)
bayarea_clusters_80_90_z$hinc_delta_z <- scale(bayarea_clusters_80_90_z$hinc_delta)
bayarea_clusters_80_90_z$mhmval_delta_z <- scale(bayarea_clusters_80_90_z$mhmval_delta)
bayarea_clusters_80_90_z$pcol_delta_z <- scale(bayarea_clusters_80_90_z$pcol_delta)
bayarea_clusters_90_00_z$hinc_delta_z <- scale(bayarea_clusters_90_00_z$hinc_delta)
bayarea_clusters_90_00_z$mhmval_delta_z <- scale(bayarea_clusters_90_00_z$mhmval_delta)
bayarea_clusters_90_00_z$pcol_delta_z <- scale(bayarea_clusters_90_00_z$pcol_delta)
bayarea_clusters_00_0a_z$hinc_delta_z <- scale(bayarea_clusters_00_0a_z$hinc_delta)
bayarea_clusters_00_0a_z$mhmval_delta_z <- scale(bayarea_clusters_00_0a_z$mhmval_delta)
bayarea_clusters_00_0a_z$pcol_delta_z <- scale(bayarea_clusters_00_0a_z$pcol_delta)
bayarea_clusters_0a_0b_z$hinc_delta_z <- scale(bayarea_clusters_0a_0b_z$hinc_delta)
bayarea_clusters_0a_0b_z$mhmval_delta_z <- scale(bayarea_clusters_0a_0b_z$mhmval_delta)
bayarea_clusters_0a_0b_z$pcol_delta_z <- scale(bayarea_clusters_0a_0b_z$pcol_delta)
bayarea_clusters_0b_0c_z$hinc_delta_z <- scale(bayarea_clusters_0b_0c_z$hinc_delta)
bayarea_clusters_0b_0c_z$mhmval_delta_z <- scale(bayarea_clusters_0b_0c_z$mhmval_delta)
bayarea_clusters_0b_0c_z$pcol_delta_z <- scale(bayarea_clusters_0b_0c_z$pcol_delta)

# combining all datasets again
bayarea_clusters_z <- rbind(bayarea_clusters_70_80_z, 
                           bayarea_clusters_80_90_z,
                           bayarea_clusters_90_00_z,
                           bayarea_clusters_00_0a_z,
                           bayarea_clusters_0a_0b_z,
                           bayarea_clusters_0b_0c_z)


# Renaming standardized variables to denote that they are z-scores
names(bayarea_clusters_z) <- c("year",
                              "hinc_delta",  
                              "mhmval_delta",  
                              "pcol_delta",	
                              "pop_post",
                              "pop_pre",
                              "row_name",
                              "hinc_delta_z",
                              "mhmval_delta_z",
                              "pcol_delta_z")


# Removing excess data frames and objects
rm(bayarea_clusters_70_80_z, 
   bayarea_clusters_80_90_z,
   bayarea_clusters_90_00_z,
   bayarea_clusters_00_0a_z,
   bayarea_clusters_0a_0b_z,
   bayarea_clusters_0b_0c_z,
   clusters)


# Determine number of clusters
wss <- (nrow(bayarea_clusters_z)-1)*sum(apply(bayarea_clusters_z,2,var))
for (i in 2:15) wss[i] <- sum(kmeans(bayarea_clusters_z, 
                                     centers=i)$withinss)
plot(1:15, wss, type="b", xlab="Number of Clusters",
     ylab="Within groups sum of squares")


# Ward Hierarchical Clustering
d <- dist(bayarea_clusters_z, method = "euclidean") # distance matrix
fit <- hclust(d, method="ward") 
plot(fit) # display dendogram
groups <- cutree(fit, k=6) # cut tree into 6 clusters
# draw dendogram with red borders around the 6 clusters 
rect.hclust(fit, k=6, border="red")

# SEEMS TO BE 6 CLUSTERS

# K-Means Cluster Analysis
# bayarea_clusters_z$fit.cluster <- NULL # ONLY run this if re-running code multiple times
# rm(cluster_solution_means)
set.seed(76)
fit <- kmeans(bayarea_clusters_z[c("hinc_delta_z", "mhmval_delta_z", "pcol_delta_z")], 6) # X cluster solution
# get cluster means 
cluster_solution_means <- aggregate(bayarea_clusters_z[c("hinc_delta_z", "mhmval_delta_z", "pcol_delta_z")], by=list(fit$cluster), FUN=mean)
# determine "gentrification averages" for each cluster, sorted by mean score
cluster_solution_means$gentrication_score_average <- rowMeans(cluster_solution_means[c("hinc_delta_z", "mhmval_delta_z", "pcol_delta_z")], na.rm=TRUE)
cluster_solution_means <- cluster_solution_means[order(-cluster_solution_means$gentrication_score_average),] 


# append cluster assignment
bayarea_clusters_z <- data.frame(bayarea_clusters_z, fit$cluster)

# standardizing variables for joining
bayarea_clusters_z$hinc_delta_z <- as.numeric(bayarea_clusters_z$hinc_delta_z)
bayarea_clusters_z$mhmval_delta_z <- as.numeric(bayarea_clusters_z$mhmval_delta_z)
bayarea_clusters_z$pcol_delta_z <- as.numeric(bayarea_clusters_z$pcol_delta_z)

# converting row_name vars to factors
bayarea_clusters_z$row_name <- as.factor(bayarea_clusters_z$row_name)
ltdb_all_joined_reduced_long_bayarea_combined$row_name <- as.factor(ltdb_all_joined_reduced_long_bayarea_combined$row_name)

# joining cluster assignment with larger dataset
ltdb_all_joined_reduced_long_bayarea_combined <- merge(ltdb_all_joined_reduced_long_bayarea, bayarea_clusters_z[c("row_name", "hinc_delta_z", "mhmval_delta_z", "pcol_delta_z", "fit.cluster")], by = "row_name", all=TRUE)
sum(table(ltdb_all_joined_reduced_long_bayarea_combined$fit.cluster))

# Creating new cluster variable that orders clusters by average score across the three predictor variables (as opposed to the arbitarary order provided by solution)
ltdb_all_joined_reduced_long_bayarea_combined$cluster_ordered[ltdb_all_joined_reduced_long_bayarea_combined$fit.cluster == 3] <- 1
ltdb_all_joined_reduced_long_bayarea_combined$cluster_ordered[ltdb_all_joined_reduced_long_bayarea_combined$fit.cluster == 4] <- 2
ltdb_all_joined_reduced_long_bayarea_combined$cluster_ordered[ltdb_all_joined_reduced_long_bayarea_combined$fit.cluster == 1] <- 3
ltdb_all_joined_reduced_long_bayarea_combined$cluster_ordered[ltdb_all_joined_reduced_long_bayarea_combined$fit.cluster == 2] <- 4
ltdb_all_joined_reduced_long_bayarea_combined$cluster_ordered[ltdb_all_joined_reduced_long_bayarea_combined$fit.cluster == 5] <- 5
ltdb_all_joined_reduced_long_bayarea_combined$cluster_ordered[ltdb_all_joined_reduced_long_bayarea_combined$fit.cluster == 6] <- 6

# Deleting old cluster variable to avoid confusion
ltdb_all_joined_reduced_long_bayarea_combined$fit.cluster <- NULL

# Determining congruence of fit with old solution (Governing Magazine) vs. New solution (clustering)
table(ltdb_all_joined_reduced_long_bayarea_combined$cluster_ordered, ltdb_all_joined_reduced_long_bayarea_combined$gent_cat)

# Adding a "gentrification score" based on the three clustering variables
ltdb_all_joined_reduced_long_bayarea_combined$gentrication_score <- rowMeans(ltdb_all_joined_reduced_long_bayarea_combined[c("hinc_delta_z", "mhmval_delta_z", "pcol_delta_z")], na.rm=TRUE)

# get cluster means sorted by gentrification score
cluster_solution_means <- aggregate(ltdb_all_joined_reduced_long_bayarea_combined[c("hinc_delta_z", 
                                                                                   "mhmval_delta_z", 
                                                                                   "pcol_delta_z", 
                                                                                   "hinc_delta", 
                                                                                   "mhmval_delta", 
                                                                                   "pcol_delta", 
                                                                                   "hinc_post",  
                                                                                   "hinc_pre",
                                                                                   "mhmval_post",
                                                                                   "mhmval_pre",
                                                                                   "pcol_post",	
                                                                                   "pcol_pre",
                                                                                   "pop_post",
                                                                                   "pop_pre")], by=list(ltdb_all_joined_reduced_long_bayarea_combined$cluster_ordered), FUN=mean)
# determine "gentrification averages" for each cluster, sorted by mean score
cluster_solution_means$gentrication_score_average <- rowMeans(cluster_solution_means[c("hinc_delta_z", "mhmval_delta_z", "pcol_delta_z")], na.rm=TRUE)
cluster_solution_means <- cluster_solution_means[order(-cluster_solution_means$gentrication_score_average),]

# Exporting data, input to CartoDB with SP file, then join
write.csv(ltdb_all_joined_reduced_long_bayarea_combined, "ltdb_all_joined_reduced_long_bayarea_combined.csv", na = "")
