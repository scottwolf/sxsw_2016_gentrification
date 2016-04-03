setwd("~/Google Drive/Internal Projects/SXSW_gentrification")

# Manually download all ltdb full and sample datsets from:
# http://www.s4.brown.edu/us2010/Researcher/LTBDDload/Default.aspx
# Note: Required email address and terms agreement

# Variable creation

# Loading LTDB tables
ltdb_full_1970 <- read.csv("LTDB census tract files/LTDB_Std_All_fullcount/LTDB_Std_1970_fullcount.csv")
ltdb_full_1980 <- read.csv("LTDB census tract files/LTDB_Std_All_fullcount/LTDB_Std_1980_fullcount.csv")
ltdb_full_1990 <- read.csv("LTDB census tract files/LTDB_Std_All_fullcount/LTDB_Std_1990_fullcount.csv")
ltdb_full_2000 <- read.csv("LTDB census tract files/LTDB_Std_All_fullcount/LTDB_Std_2000_fullcount.csv")
ltdb_full_2010 <- read.csv("LTDB census tract files/LTDB_Std_All_fullcount/LTDB_Std_2010_fullcount.csv")

ltdb_sample_1970 <- read.csv("LTDB census tract files/LTDB_Std_All_sample/LTDB_Std_1970_sample.csv")
ltdb_sample_1980 <- read.csv("LTDB census tract files/LTDB_Std_All_sample/LTDB_Std_1980_sample.csv")
ltdb_sample_1990 <- read.csv("LTDB census tract files/LTDB_Std_All_sample/LTDB_Std_1990_sample.csv")
ltdb_sample_2000 <- read.csv("LTDB census tract files/LTDB_Std_All_sample/LTDB_Std_2000_sample.csv")
ltdb_sample_2010 <- read.csv("LTDB census tract files/LTDB_Std_All_sample/LTDB_Std_2010_sample.csv")

# Standardizing TRTID10 name for joining (key variable at census tract level)
ltdb_full_2010$TRTID10 <- ltdb_full_2010$tractid
ltdb_sample_1980$TRTID10 <- ltdb_sample_1980$trtid10
ltdb_sample_2010$TRTID10 <- ltdb_sample_2010$tractid

# Deleting redundant variables
ltdb_full_2010$tractid <- NULL
ltdb_sample_1980$trtid10 <- NULL
ltdb_sample_2010$tractid <- NULL

# Joining all files by TRTID10
library(plyr)
ltdb_full_joined <- join(ltdb_full_1970, ltdb_full_1980, by = "TRTID10", type = "full")
ltdb_full_joined <- join(ltdb_full_joined, ltdb_full_1990, by = "TRTID10", type = "full")
ltdb_full_joined <- join(ltdb_full_joined, ltdb_full_2000, by = "TRTID10", type = "full")
ltdb_full_joined <- join(ltdb_full_joined, ltdb_full_2010, by = "TRTID10", type = "full")

ltdb_sample_joined <- join(ltdb_sample_1970, ltdb_sample_1980, by = "TRTID10", type = "full")
ltdb_sample_joined <- join(ltdb_sample_joined, ltdb_sample_1990, by = "TRTID10", type = "full")
ltdb_sample_joined <- join(ltdb_sample_joined, ltdb_sample_2000, by = "TRTID10", type = "full")
ltdb_sample_joined <- join(ltdb_sample_joined, ltdb_sample_2010, by = "TRTID10", type = "full")

ltdb_all_joined <- join(ltdb_sample_joined, ltdb_full_joined, by = "TRTID10", type = "full")

# Removing LTDB datasets
rm(ltdb_full_1970, ltdb_full_1980, ltdb_full_1990, ltdb_full_2000, ltdb_full_2010,
   ltdb_sample_1970, ltdb_sample_1980, ltdb_sample_1990, ltdb_sample_2000, ltdb_sample_2010,
   ltdb_full_joined,
   ltdb_sample_joined)


# Adding two additional ACS files from Census Planning Database
# http://www.census.gov/research/data/planning_database/
temp <- tempfile()
download.file("http://www.census.gov/research/data/planning_database/2014/docs/PDB_Tract_2014-11-20.zip",temp)
ACS_2008_2012 <- read.csv(unz(temp, "pdb2014trv9_us.csv"))
unlink(temp)
rm(temp)

temp <- tempfile()
download.file("http://www.census.gov/research/data/planning_database/2015/docs/PDB_Tract_2015-07-28.zip",temp)
ACS_2009_2013 <- read.csv(unz(temp, "PDB_2015_Tract.csv"))
unlink(temp)
rm(temp)


# reducing 2008-2012 ACS datafiles to variables that overlap with LTDB datasets
reduced_acs_2008_2012 <- c("GIDTR", 
                           "State", 
                           "County",
                           "Tract",
                           "Tot_Population_ACS_08_12",
                           "Med_HHD_Inc_ACS_08_12",
                           "Med_House_value_ACS_08_12",
                           "pct_NH_Asian_alone_ACS_08_12",
                           "pct_College_ACS_08_12",
                           "pct_Born_foreign_ACS_08_12",
                           "pct_NH_NHOPI_alone_ACS_08_12",
                           "pct_Hispanic_ACS_08_12",
                           "pct_MLT_U2_9_STRC_ACS_08_12",
                           "pct_US_Cit_Nat_ACS_08_12",
                           "pct_NH_Blk_alone_ACS_08_12",
                           "pct_NH_White_alone_ACS_08_12",
                           "pct_NH_AIAN_alone_ACS_08_12",
                           "pct_Othr_Lang_ACS_08_12",
                           "pct_Owner_Occp_HU_ACS_08_12",
                           "pct_Prs_Blw_Pov_Lev_ACS_08_12",
                           "pct_Vacant_Units_ACS_08_12")

ACS_2008_2012_reduced <- ACS_2008_2012[reduced_acs_2008_2012]
rm (ACS_2008_2012, reduced_acs_2008_2012)


# reducing 2009-2013 ACS datafiles to only the variables that overlap with LTDB datasets
reduced_acs_2009_2013 <- c("GIDTR", 
                           "State", 
                           "County",
                           "Tract",
                           "Tot_Population_ACS_09_13",
                           "Med_HHD_Inc_ACS_09_13",
                           "Med_House_value_ACS_09_13",
                           "pct_NH_Asian_alone_ACS_09_13",
                           "pct_College_ACS_09_13",
                           "pct_Born_foreign_ACS_09_13",
                           "pct_NH_NHOPI_alone_ACS_09_13",
                           "pct_Hispanic_ACS_09_13",
                           "pct_MLT_U2_9_STRC_ACS_09_13",
                           "pct_US_Cit_Nat_ACS_09_13",
                           "pct_NH_Blk_alone_ACS_09_13",
                           "pct_NH_White_alone_ACS_09_13",
                           "pct_NH_AIAN_alone_ACS_09_13",
                           "pct_Othr_Lang_ACS_09_13",
                           "pct_Owner_Occp_HU_ACS_09_13",
                           "pct_Prs_Blw_Pov_Lev_ACS_09_13",
                           "pct_Vacant_Units_ACS_09_13")

ACS_2009_2013_reduced <- ACS_2009_2013[reduced_acs_2009_2013]
rm (ACS_2009_2013, reduced_acs_2009_2013)


# Standardizing variable names across ACS datasets and LTDB dataset
library(reshape)
ACS_2008_2012_reduced <- rename(ACS_2008_2012_reduced, c(Tot_Population_ACS_08_12 = 'pop0b'))
ACS_2008_2012_reduced <- rename(ACS_2008_2012_reduced, c(Med_HHD_Inc_ACS_08_12 = 'hinc0b'))
ACS_2008_2012_reduced <- rename(ACS_2008_2012_reduced, c(Med_House_value_ACS_08_12 = 'mhmval0b'))
ACS_2008_2012_reduced <- rename(ACS_2008_2012_reduced, c(pct_NH_Asian_alone_ACS_08_12 = 'pasian0b'))
ACS_2008_2012_reduced <- rename(ACS_2008_2012_reduced, c(pct_College_ACS_08_12 = 'pcol0b'))
ACS_2008_2012_reduced <- rename(ACS_2008_2012_reduced, c(pct_Born_foreign_ACS_08_12 = 'pfb0b'))
ACS_2008_2012_reduced <- rename(ACS_2008_2012_reduced, c(pct_NH_NHOPI_alone_ACS_08_12 = 'phaw0b'))
ACS_2008_2012_reduced <- rename(ACS_2008_2012_reduced, c(pct_Hispanic_ACS_08_12 = 'phisp0b'))
ACS_2008_2012_reduced <- rename(ACS_2008_2012_reduced, c(pct_MLT_U2_9_STRC_ACS_08_12 = 'pmulti0b'))
ACS_2008_2012_reduced <- rename(ACS_2008_2012_reduced, c(pct_US_Cit_Nat_ACS_08_12 = 'pnat0b'))
ACS_2008_2012_reduced <- rename(ACS_2008_2012_reduced, c(pct_NH_Blk_alone_ACS_08_12 = 'pnhblk0b'))
ACS_2008_2012_reduced <- rename(ACS_2008_2012_reduced, c(pct_NH_White_alone_ACS_08_12 = 'pnhwht0b'))
ACS_2008_2012_reduced <- rename(ACS_2008_2012_reduced, c(pct_NH_AIAN_alone_ACS_08_12 = 'pntv0b'))
ACS_2008_2012_reduced <- rename(ACS_2008_2012_reduced, c(pct_Othr_Lang_ACS_08_12 = 'polang0b'))
ACS_2008_2012_reduced <- rename(ACS_2008_2012_reduced, c(pct_Owner_Occp_HU_ACS_08_12 = 'pown0b'))
ACS_2008_2012_reduced <- rename(ACS_2008_2012_reduced, c(pct_Prs_Blw_Pov_Lev_ACS_08_12 = 'ppov0b'))
ACS_2008_2012_reduced <- rename(ACS_2008_2012_reduced, c(pct_Vacant_Units_ACS_08_12 = 'pvac0b'))
ACS_2008_2012_reduced <- rename(ACS_2008_2012_reduced, c(GIDTR = 'TRTID10'))

ACS_2009_2013_reduced <- rename(ACS_2009_2013_reduced, c(Tot_Population_ACS_09_13 = 'pop0c'))
ACS_2009_2013_reduced <- rename(ACS_2009_2013_reduced, c(Med_HHD_Inc_ACS_09_13 = 'hinc0c'))
ACS_2009_2013_reduced <- rename(ACS_2009_2013_reduced, c(Med_House_value_ACS_09_13 = 'mhmval0c'))
ACS_2009_2013_reduced <- rename(ACS_2009_2013_reduced, c(pct_NH_Asian_alone_ACS_09_13 = 'pasian0c'))
ACS_2009_2013_reduced <- rename(ACS_2009_2013_reduced, c(pct_College_ACS_09_13 = 'pcol0c'))
ACS_2009_2013_reduced <- rename(ACS_2009_2013_reduced, c(pct_Born_foreign_ACS_09_13 = 'pfb0c'))
ACS_2009_2013_reduced <- rename(ACS_2009_2013_reduced, c(pct_NH_NHOPI_alone_ACS_09_13 = 'phaw0c'))
ACS_2009_2013_reduced <- rename(ACS_2009_2013_reduced, c(pct_Hispanic_ACS_09_13 = 'phisp0c'))
ACS_2009_2013_reduced <- rename(ACS_2009_2013_reduced, c(pct_MLT_U2_9_STRC_ACS_09_13 = 'pmulti0c'))
ACS_2009_2013_reduced <- rename(ACS_2009_2013_reduced, c(pct_US_Cit_Nat_ACS_09_13 = 'pnat0c'))
ACS_2009_2013_reduced <- rename(ACS_2009_2013_reduced, c(pct_NH_Blk_alone_ACS_09_13 = 'pnhblk0c'))
ACS_2009_2013_reduced <- rename(ACS_2009_2013_reduced, c(pct_NH_White_alone_ACS_09_13 = 'pnhwht0c'))
ACS_2009_2013_reduced <- rename(ACS_2009_2013_reduced, c(pct_NH_AIAN_alone_ACS_09_13 = 'pntv0c'))
ACS_2009_2013_reduced <- rename(ACS_2009_2013_reduced, c(pct_Othr_Lang_ACS_09_13 = 'polang0c'))
ACS_2009_2013_reduced <- rename(ACS_2009_2013_reduced, c(pct_Owner_Occp_HU_ACS_09_13 = 'pown0c'))
ACS_2009_2013_reduced <- rename(ACS_2009_2013_reduced, c(pct_Prs_Blw_Pov_Lev_ACS_09_13 = 'ppov0c'))
ACS_2009_2013_reduced <- rename(ACS_2009_2013_reduced, c(pct_Vacant_Units_ACS_09_13 = 'pvac0c'))
ACS_2009_2013_reduced <- rename(ACS_2009_2013_reduced, c(GIDTR = 'TRTID10'))


# converting dollar values to straight numeric values
ACS_2008_2012_reduced$hinc0b <- gsub(",","", ACS_2008_2012_reduced$hinc0b)
ACS_2008_2012_reduced$hinc0b <- gsub("\\$","", ACS_2008_2012_reduced$hinc0b)
ACS_2008_2012_reduced$hinc0b <- as.numeric (ACS_2008_2012_reduced$hinc0b)

ACS_2009_2013_reduced$hinc0c <- gsub(",","", ACS_2009_2013_reduced$hinc0c)
ACS_2009_2013_reduced$hinc0c <- gsub("\\$","", ACS_2009_2013_reduced$hinc0c)
ACS_2009_2013_reduced$hinc0c <- as.numeric (ACS_2009_2013_reduced$hinc0c)

ACS_2008_2012_reduced$mhmval0b <- gsub(",","", ACS_2008_2012_reduced$mhmval0b)
ACS_2008_2012_reduced$mhmval0b <- gsub("\\$","", ACS_2008_2012_reduced$mhmval0b)
ACS_2008_2012_reduced$mhmval0b <- as.numeric (ACS_2008_2012_reduced$mhmval0b)

ACS_2009_2013_reduced$mhmval0c <- gsub(",","", ACS_2009_2013_reduced$mhmval0c)
ACS_2009_2013_reduced$mhmval0c <- gsub("\\$","", ACS_2009_2013_reduced$mhmval0c)
ACS_2009_2013_reduced$mhmval0c <- as.numeric (ACS_2009_2013_reduced$mhmval0c)


# Joining ACS datasets with the LTDB dataset
ltdb_all_joined <- join(ltdb_all_joined, ACS_2008_2012_reduced, by = "TRTID10", type = "full")
ltdb_all_joined <- join(ltdb_all_joined, ACS_2009_2013_reduced, by = "TRTID10", type = "full")


# Removing ACS datasets
rm(ACS_2008_2012_reduced, ACS_2009_2013_reduced)


# converting all variable names to lower case for standardization
names(ltdb_all_joined) <- tolower(names(ltdb_all_joined))


# converting 2008-2012 and 2009-2013 ACS percentage values to .XX format (rather than XX.XX)
ltdb_all_joined$pasian0c <- ltdb_all_joined$pasian0c/100
ltdb_all_joined$pcol0b <- ltdb_all_joined$pcol0b/100
ltdb_all_joined$pcol0c <- ltdb_all_joined$pcol0c/100
ltdb_all_joined$pfb0b <- ltdb_all_joined$pfb0b/100	
ltdb_all_joined$pfb0c <- ltdb_all_joined$pfb0c/100
ltdb_all_joined$phaw0b <- ltdb_all_joined$phaw0b/100	
ltdb_all_joined$phaw0c <- ltdb_all_joined$phaw0c/100
ltdb_all_joined$phisp0b <- ltdb_all_joined$phisp0b/100	
ltdb_all_joined$phisp0c <- ltdb_all_joined$phisp0c/100
ltdb_all_joined$pmulti0b <- ltdb_all_joined$pmulti0b/100	
ltdb_all_joined$pmulti0c <- ltdb_all_joined$pmulti0c/100
ltdb_all_joined$pnat0b <- ltdb_all_joined$pnat0b/100	
ltdb_all_joined$pnat0c <- ltdb_all_joined$pnat0c/100
ltdb_all_joined$pnhblk0b <- ltdb_all_joined$pnhblk0b/100	
ltdb_all_joined$pnhblk0c <- ltdb_all_joined$pnhblk0c/100
ltdb_all_joined$pnhwht0b <- ltdb_all_joined$pnhwht0b/100	
ltdb_all_joined$pnhwht0c <- ltdb_all_joined$pnhwht0c/100
ltdb_all_joined$pntv0b <- ltdb_all_joined$pntv0b/100	
ltdb_all_joined$pntv0c <- ltdb_all_joined$pntv0c/100
ltdb_all_joined$polang0b <- ltdb_all_joined$polang0b/100	
ltdb_all_joined$polang0c <- ltdb_all_joined$polang0c/100
ltdb_all_joined$pown0b <- ltdb_all_joined$pown0b/100	
ltdb_all_joined$pown0c <- ltdb_all_joined$pown0c/100
ltdb_all_joined$ppov0b <- ltdb_all_joined$ppov0b/100	
ltdb_all_joined$ppov0c <- ltdb_all_joined$ppov0c/100
ltdb_all_joined$pvac0b <- ltdb_all_joined$pvac0b/100	
ltdb_all_joined$pvac0c <- ltdb_all_joined$pvac0c/100
ltdb_all_joined$pasian0b <- ltdb_all_joined$pasian0b/100  
ltdb_all_joined$pasian0c <- ltdb_all_joined$pasian0c/100




# LTDB VARIABLE CREATION

# VARIABLE GROUP 1: RACE AND AGE BY RACE

# percentage of persons of white race
ltdb_all_joined$pwhite70 <- ltdb_all_joined$white70/ltdb_all_joined$pop70

# percentage of persons of white race, not hispanic origin
ltdb_all_joined$pnhwht80 <- ltdb_all_joined$nhwht80/ltdb_all_joined$pop80
ltdb_all_joined$pnhwht90 <- ltdb_all_joined$nhwht90/ltdb_all_joined$pop90
ltdb_all_joined$pnhwht00 <- ltdb_all_joined$nhwht00/ltdb_all_joined$pop00
ltdb_all_joined$pnhwht0a <- ltdb_all_joined$nhwht0a/ltdb_all_joined$pop0a
ltdb_all_joined$pnhwht10 <- ltdb_all_joined$nhwht10/ltdb_all_joined$pop10

# percentage of persons of black race
ltdb_all_joined$pblack70 <- ltdb_all_joined$black70/ltdb_all_joined$pop70

# percentage of persons of black race, not hispanic origin
ltdb_all_joined$pnhblk80 <- ltdb_all_joined$nhblk80/ltdb_all_joined$pop80
ltdb_all_joined$pnhblk90 <- ltdb_all_joined$nhblk90/ltdb_all_joined$pop90
ltdb_all_joined$pnhblk00 <- ltdb_all_joined$nhblk00/ltdb_all_joined$pop00
ltdb_all_joined$pnhblk0a <- ltdb_all_joined$nhblk0a/ltdb_all_joined$pop0a
ltdb_all_joined$pnhblk10 <- ltdb_all_joined$nhblk10/ltdb_all_joined$pop10

# percentage of persons of hispanic origin
ltdb_all_joined$phisp80 <- ltdb_all_joined$hisp80/ltdb_all_joined$pop80
ltdb_all_joined$phisp90 <- ltdb_all_joined$hisp90/ltdb_all_joined$pop90
ltdb_all_joined$phisp00 <- ltdb_all_joined$hisp00/ltdb_all_joined$pop00
ltdb_all_joined$phisp0a <- ltdb_all_joined$hisp0a/ltdb_all_joined$pop0a
ltdb_all_joined$phisp10 <- ltdb_all_joined$hisp10/ltdb_all_joined$pop10

# percentage of persons of native american race
ltdb_all_joined$pntv80 <- ltdb_all_joined$ntv80/ltdb_all_joined$pop80
ltdb_all_joined$pntv90 <- ltdb_all_joined$ntv90/ltdb_all_joined$pop90
ltdb_all_joined$pntv00 <- ltdb_all_joined$ntv00/ltdb_all_joined$pop00
ltdb_all_joined$pntv0a <- ltdb_all_joined$ntv0a/ltdb_all_joined$pop0a
ltdb_all_joined$pntv10 <- ltdb_all_joined$ntv10/ltdb_all_joined$pop10

# percentage of persons of asian race (and pacific islander)
ltdb_all_joined$pasian70 <- ltdb_all_joined$asian70/ltdb_all_joined$pop70
ltdb_all_joined$pasian80 <- ltdb_all_joined$asian80/ltdb_all_joined$pop80
ltdb_all_joined$pasian90 <- ltdb_all_joined$asian90/ltdb_all_joined$pop90
ltdb_all_joined$pasian00 <- ltdb_all_joined$asian00/ltdb_all_joined$pop00
ltdb_all_joined$pasian0a <- ltdb_all_joined$asian0a/ltdb_all_joined$pop0a
ltdb_all_joined$pasian10 <- ltdb_all_joined$asian10/ltdb_all_joined$pop10

# percentage of persons of hawaiian race
ltdb_all_joined$phaw70 <- ltdb_all_joined$haw70/ltdb_all_joined$pop70
ltdb_all_joined$phaw80 <- ltdb_all_joined$haw80/ltdb_all_joined$pop80
ltdb_all_joined$phaw90 <- ltdb_all_joined$haw90/ltdb_all_joined$pop90
ltdb_all_joined$phaw00 <- ltdb_all_joined$haw00/ltdb_all_joined$pop00
ltdb_all_joined$phaw0a <- ltdb_all_joined$haw0a/ltdb_all_joined$pop0a
ltdb_all_joined$phaw10 <- ltdb_all_joined$haw10/ltdb_all_joined$pop10

# percentage of persons of asian indian race
ltdb_all_joined$pindia70 <- ltdb_all_joined$india70/ltdb_all_joined$pop70
ltdb_all_joined$pindia80 <- ltdb_all_joined$india80/ltdb_all_joined$pop80
ltdb_all_joined$pindia90 <- ltdb_all_joined$india90/ltdb_all_joined$pop90
ltdb_all_joined$pindia00 <- ltdb_all_joined$india00/ltdb_all_joined$pop00
ltdb_all_joined$pindia0a <- ltdb_all_joined$india0a/ltdb_all_joined$pop0a
ltdb_all_joined$pindia10 <- ltdb_all_joined$india10/ltdb_all_joined$pop10

# percentage of persons of chinese race
ltdb_all_joined$pchina70 <- ltdb_all_joined$china70/ltdb_all_joined$pop70
ltdb_all_joined$pchina80 <- ltdb_all_joined$china80/ltdb_all_joined$pop80
ltdb_all_joined$pchina90 <- ltdb_all_joined$china90/ltdb_all_joined$pop90
ltdb_all_joined$pchina00 <- ltdb_all_joined$china00/ltdb_all_joined$pop00
ltdb_all_joined$pchina0a <- ltdb_all_joined$china0a/ltdb_all_joined$pop0a
ltdb_all_joined$pchina10 <- ltdb_all_joined$china10/ltdb_all_joined$pop10

# percentage of persons of filipino race
ltdb_all_joined$pfilip70 <- ltdb_all_joined$filip70/ltdb_all_joined$pop70
ltdb_all_joined$pfilip80 <- ltdb_all_joined$filip80/ltdb_all_joined$pop80
ltdb_all_joined$pfilip90 <- ltdb_all_joined$filip90/ltdb_all_joined$pop90
ltdb_all_joined$pfilip00 <- ltdb_all_joined$filip00/ltdb_all_joined$pop00
ltdb_all_joined$pfilip0a <- ltdb_all_joined$filip0a/ltdb_all_joined$pop0a
ltdb_all_joined$pfilip10 <- ltdb_all_joined$filip10/ltdb_all_joined$pop10

# percentage of persons of japanese race
ltdb_all_joined$pjapan70 <- ltdb_all_joined$japan70/ltdb_all_joined$pop70
ltdb_all_joined$pjapan80 <- ltdb_all_joined$japan80/ltdb_all_joined$pop80
ltdb_all_joined$pjapan90 <- ltdb_all_joined$japan90/ltdb_all_joined$pop90
ltdb_all_joined$pjapan00 <- ltdb_all_joined$japan00/ltdb_all_joined$pop00
ltdb_all_joined$pjapan0a <- ltdb_all_joined$japan0a/ltdb_all_joined$pop0a
ltdb_all_joined$pjapan10 <- ltdb_all_joined$japan10/ltdb_all_joined$pop10

# percentage of persons of korean race
ltdb_all_joined$pkorea70 <- ltdb_all_joined$korea70/ltdb_all_joined$pop70
ltdb_all_joined$pkorea80 <- ltdb_all_joined$korea80/ltdb_all_joined$pop80
ltdb_all_joined$pkorea90 <- ltdb_all_joined$korea90/ltdb_all_joined$pop90
ltdb_all_joined$pkorea00 <- ltdb_all_joined$korea00/ltdb_all_joined$pop00
ltdb_all_joined$pkorea0a <- ltdb_all_joined$korea0a/ltdb_all_joined$pop0a
ltdb_all_joined$pkorea10 <- ltdb_all_joined$korea10/ltdb_all_joined$pop10

# percentage of persons of vietnamese race
ltdb_all_joined$pviet80 <- ltdb_all_joined$viet80/ltdb_all_joined$pop80
ltdb_all_joined$pviet90 <- ltdb_all_joined$viet90/ltdb_all_joined$pop90
ltdb_all_joined$pviet00 <- ltdb_all_joined$viet00/ltdb_all_joined$pop00
ltdb_all_joined$pviet0a <- ltdb_all_joined$viet0a/ltdb_all_joined$pop0a
ltdb_all_joined$pviet10 <- ltdb_all_joined$viet10/ltdb_all_joined$pop10


# percentage of 0-15 years old of white race
ltdb_all_joined$p15wht70 <- ltdb_all_joined$a15wht70/ltdb_all_joined$agewht70
ltdb_all_joined$p15wht80 <- ltdb_all_joined$a15wht80/ltdb_all_joined$agewht80
ltdb_all_joined$p15wht90 <- ltdb_all_joined$a15wht90/ltdb_all_joined$agewht90
ltdb_all_joined$p15wht00 <- ltdb_all_joined$a15wht00/ltdb_all_joined$agewht00
ltdb_all_joined$p15wht0a <- ltdb_all_joined$a15wht0a/ltdb_all_joined$agewht0a
ltdb_all_joined$p15wht10 <- ltdb_all_joined$a15wht10/ltdb_all_joined$agewht10

# percentage of 60 years and older of white race
ltdb_all_joined$p60wht70 <- ltdb_all_joined$a60wht70/ltdb_all_joined$agewht70
ltdb_all_joined$p60wht80 <- ltdb_all_joined$a60wht80/ltdb_all_joined$agewht80
ltdb_all_joined$p60wht90 <- ltdb_all_joined$a60wht90/ltdb_all_joined$agewht90
ltdb_all_joined$p60wht00 <- ltdb_all_joined$a60wht00/ltdb_all_joined$agewht00
ltdb_all_joined$p60wht10 <- ltdb_all_joined$a60wht10/ltdb_all_joined$agewht10

# percentage of 65 years and older of non-hispanic whites
ltdb_all_joined$p65wht0a <- ltdb_all_joined$a65wht0a/ltdb_all_joined$agewht0a


# percentage of 0-15 years old of black race
ltdb_all_joined$p15blk70 <- ltdb_all_joined$a15blk70/ltdb_all_joined$ageblk70
ltdb_all_joined$p15blk80 <- ltdb_all_joined$a15blk80/ltdb_all_joined$ageblk80
ltdb_all_joined$p15blk90 <- ltdb_all_joined$a15blk90/ltdb_all_joined$ageblk90
ltdb_all_joined$p15blk00 <- ltdb_all_joined$a15blk00/ltdb_all_joined$ageblk00
ltdb_all_joined$p15blk0a <- ltdb_all_joined$a15blk0a/ltdb_all_joined$ageblk0a
ltdb_all_joined$p15blk10 <- ltdb_all_joined$a15blk10/ltdb_all_joined$ageblk10

# percentage of 60 years and older of black race
ltdb_all_joined$p60blk70 <- ltdb_all_joined$a60blk70/ltdb_all_joined$ageblk70
ltdb_all_joined$p60blk80 <- ltdb_all_joined$a60blk80/ltdb_all_joined$ageblk80
ltdb_all_joined$p60blk90 <- ltdb_all_joined$a60blk90/ltdb_all_joined$ageblk90
ltdb_all_joined$p60blk00 <- ltdb_all_joined$a60blk00/ltdb_all_joined$ageblk00
ltdb_all_joined$p60blk10 <- ltdb_all_joined$a60blk10/ltdb_all_joined$ageblk10

# percentage of 65 years and older of black race
ltdb_all_joined$p65blk0a <- ltdb_all_joined$a65blk0a/ltdb_all_joined$ageblk0a


# percentage of 0-15 years old, persons of hispanic origins
ltdb_all_joined$p15hsp80 <- ltdb_all_joined$a15hsp80/ltdb_all_joined$agehsp80
ltdb_all_joined$p15hsp90 <- ltdb_all_joined$a15hsp90/ltdb_all_joined$agehsp90
ltdb_all_joined$p15hsp00 <- ltdb_all_joined$a15hsp00/ltdb_all_joined$agehsp00
ltdb_all_joined$p15hsp0a <- ltdb_all_joined$a15hsp0a/ltdb_all_joined$agehsp0a
ltdb_all_joined$p15hsp10 <- ltdb_all_joined$a15hsp10/ltdb_all_joined$agehsp10

# percentage of 60 years and older of hispanic origins
ltdb_all_joined$p60hsp80 <- ltdb_all_joined$a60hsp80/ltdb_all_joined$agehsp80
ltdb_all_joined$p60hsp90 <- ltdb_all_joined$a60hsp90/ltdb_all_joined$agehsp90
ltdb_all_joined$p60hsp00 <- ltdb_all_joined$a60hsp00/ltdb_all_joined$agehsp00
ltdb_all_joined$p60hsp10 <- ltdb_all_joined$a60hsp10/ltdb_all_joined$agehsp10

# percentage of 65 years and older of hispanic origins
ltdb_all_joined$p65hsp0a <- ltdb_all_joined$a65hsp0a/ltdb_all_joined$agehsp0a


# percentage of 0-15 years old of native american race
ltdb_all_joined$p15ntv80 <- ltdb_all_joined$a15ntv80/ltdb_all_joined$agentv80
ltdb_all_joined$p15ntv90 <- ltdb_all_joined$a15ntv90/ltdb_all_joined$agentv90
ltdb_all_joined$p15ntv00 <- ltdb_all_joined$a15ntv00/ltdb_all_joined$agentv00
ltdb_all_joined$p15ntv0a <- ltdb_all_joined$a15ntv0a/ltdb_all_joined$agentv0a
ltdb_all_joined$p15ntv10 <- ltdb_all_joined$a15ntv10/ltdb_all_joined$agentv10

# percentage of 60 years and older of native american race
ltdb_all_joined$p60ntv80 <- ltdb_all_joined$a60ntv80/ltdb_all_joined$agentv80
ltdb_all_joined$p60ntv90 <- ltdb_all_joined$a60ntv90/ltdb_all_joined$agentv90
ltdb_all_joined$p60ntv00 <- ltdb_all_joined$a60ntv00/ltdb_all_joined$agentv00
ltdb_all_joined$p60ntv10 <- ltdb_all_joined$a60ntv10/ltdb_all_joined$agentv10

# percentage of 65 years and older of native american race
ltdb_all_joined$p65ntv0a <- ltdb_all_joined$a65ntv0a/ltdb_all_joined$agentv0a


# percentage of 0-15 years old of asians and pacific islanders
ltdb_all_joined$p15asn80 <- ltdb_all_joined$a15asn80/ltdb_all_joined$ageasn80
ltdb_all_joined$p15asn90 <- ltdb_all_joined$a15asn90/ltdb_all_joined$ageasn90
ltdb_all_joined$p15asn00 <- ltdb_all_joined$a15asn00/ltdb_all_joined$ageasn00
ltdb_all_joined$p15asn0a <- ltdb_all_joined$a15asn0a/ltdb_all_joined$ageasn0a
ltdb_all_joined$p15asn10 <- ltdb_all_joined$a15asn10/ltdb_all_joined$ageasn10

# percentage of 60 years and older of asians and pacific islanders
ltdb_all_joined$p60asn80 <- ltdb_all_joined$a60asn80/ltdb_all_joined$ageasn80
ltdb_all_joined$p60asn90 <- ltdb_all_joined$a60asn90/ltdb_all_joined$ageasn90
ltdb_all_joined$p60asn00 <- ltdb_all_joined$a60asn00/ltdb_all_joined$ageasn00
ltdb_all_joined$p60asn10 <- ltdb_all_joined$a60asn10/ltdb_all_joined$ageasn10

# percentage of 65 years and older of asians and pacific islanders
ltdb_all_joined$p65asn0a <- ltdb_all_joined$a65asn0a/ltdb_all_joined$ageasn0a



# LTDB VARIABLE GROUP 2: ETHNICITY AND IMMIGRATION

# percentage of mexicans
ltdb_all_joined$pmex70 <- ltdb_all_joined$mex70/ltdb_all_joined$pop70sp2
ltdb_all_joined$pmex80 <- ltdb_all_joined$mex80/ltdb_all_joined$pop80
ltdb_all_joined$pmex90 <- ltdb_all_joined$mex90/ltdb_all_joined$pop90
ltdb_all_joined$pmex00 <- ltdb_all_joined$mex00/ltdb_all_joined$pop00
ltdb_all_joined$pmex0a <- ltdb_all_joined$mex0a/ltdb_all_joined$pop0a
ltdb_all_joined$pmex10 <- ltdb_all_joined$mex10/ltdb_all_joined$pop10

# percentage of cubans
ltdb_all_joined$pcuban70 <- ltdb_all_joined$cuban70/ltdb_all_joined$pop70sp2
ltdb_all_joined$pcuban80 <- ltdb_all_joined$cuban80/ltdb_all_joined$pop80
ltdb_all_joined$pcuban90 <- ltdb_all_joined$cuban90/ltdb_all_joined$pop90
ltdb_all_joined$pcuban00 <- ltdb_all_joined$cuban00/ltdb_all_joined$pop00
ltdb_all_joined$pcuban0a <- ltdb_all_joined$cuban0a/ltdb_all_joined$pop0a
ltdb_all_joined$pcuban10 <- ltdb_all_joined$cuban10/ltdb_all_joined$pop10

# percentage of puerto ricans
ltdb_all_joined$ppr70 <- ltdb_all_joined$pr70/ltdb_all_joined$pop70sp2
ltdb_all_joined$ppr80 <- ltdb_all_joined$pr80/ltdb_all_joined$pop80
ltdb_all_joined$ppr90 <- ltdb_all_joined$pr90/ltdb_all_joined$pop90
ltdb_all_joined$ppr00 <- ltdb_all_joined$pr00/ltdb_all_joined$pop00
ltdb_all_joined$ppr0a <- ltdb_all_joined$pr0a/ltdb_all_joined$pop0a
ltdb_all_joined$ppr10 <- ltdb_all_joined$pr10/ltdb_all_joined$pop10

# percentage of persons of russian/ussr parentage or ancestry
ltdb_all_joined$pruanc70 <- ltdb_all_joined$ruanc70/ltdb_all_joined$pop70sp2
ltdb_all_joined$pruanc80 <- ltdb_all_joined$ruanc80/ltdb_all_joined$pop80sf3
ltdb_all_joined$pruanc90 <- ltdb_all_joined$ruanc90/ltdb_all_joined$pop90sf3
ltdb_all_joined$pruanc00 <- ltdb_all_joined$ruanc00/ltdb_all_joined$pop00sf3
ltdb_all_joined$pruanc0a <- ltdb_all_joined$ruanc0a/ltdb_all_joined$pop0a

# percentage of persons of italian parentage or ancestry
ltdb_all_joined$pitanc70 <- ltdb_all_joined$itanc70/ltdb_all_joined$pop70sp2
ltdb_all_joined$pitanc80 <- ltdb_all_joined$itanc80/ltdb_all_joined$pop80sf3
ltdb_all_joined$pitanc90 <- ltdb_all_joined$itanc90/ltdb_all_joined$pop90sf3
ltdb_all_joined$pitanc00 <- ltdb_all_joined$itanc00/ltdb_all_joined$pop00sf3
ltdb_all_joined$pitanc0a <- ltdb_all_joined$itanc0a/ltdb_all_joined$pop0a

# percentage of persons of german parentage or ancestry
ltdb_all_joined$pgeanc70 <- ltdb_all_joined$geanc70/ltdb_all_joined$pop70sp2
ltdb_all_joined$pgeanc80 <- ltdb_all_joined$geanc80/ltdb_all_joined$pop80sf3
ltdb_all_joined$pgeanc90 <- ltdb_all_joined$geanc90/ltdb_all_joined$pop90sf3
ltdb_all_joined$pgeanc00 <- ltdb_all_joined$geanc00/ltdb_all_joined$pop00sf3
ltdb_all_joined$pgeanc0a <- ltdb_all_joined$geanc0a/ltdb_all_joined$pop0a

# percentage of persons of irish parentage or ancestry
ltdb_all_joined$piranc70 <- ltdb_all_joined$iranc70/ltdb_all_joined$pop70sp2
ltdb_all_joined$piranc80 <- ltdb_all_joined$iranc80/ltdb_all_joined$pop80sf3
ltdb_all_joined$piranc90 <- ltdb_all_joined$iranc90/ltdb_all_joined$pop90sf3
ltdb_all_joined$piranc00 <- ltdb_all_joined$iranc00/ltdb_all_joined$pop00sf3
ltdb_all_joined$piranc0a <- ltdb_all_joined$iranc0a/ltdb_all_joined$pop0a

# percentage of persons of scandinavian parentage/ancestry (finnish, swedish, danish, norwegian)
ltdb_all_joined$pscanc70 <- ltdb_all_joined$scanc70/ltdb_all_joined$pop70sp2
ltdb_all_joined$pscanc80 <- ltdb_all_joined$scanc80/ltdb_all_joined$pop80sf3
ltdb_all_joined$pscanc90 <- ltdb_all_joined$scanc90/ltdb_all_joined$pop90sf3
ltdb_all_joined$pscanc00 <- ltdb_all_joined$scanc00/ltdb_all_joined$pop00sf3
ltdb_all_joined$pscanc0a <- ltdb_all_joined$scanc0a/ltdb_all_joined$pop0a


# percentage of foreign-born
ltdb_all_joined$pfb70 <- ltdb_all_joined$fb70/ltdb_all_joined$pop70sp1
ltdb_all_joined$pfb80 <- ltdb_all_joined$fb80/ltdb_all_joined$dfb80
ltdb_all_joined$pfb90 <- ltdb_all_joined$fb90/ltdb_all_joined$pop90sf3
ltdb_all_joined$pfb00 <- ltdb_all_joined$fb00/ltdb_all_joined$pop00sf3
ltdb_all_joined$pfb0a <- ltdb_all_joined$fb0a/ltdb_all_joined$pop0a

# percentage of recent immigrants (within the past 10 years)
ltdb_all_joined$p10imm70 <- ltdb_all_joined$n10imm70/ltdb_all_joined$pop70sp1
ltdb_all_joined$p10imm80 <- ltdb_all_joined$n10imm80/ltdb_all_joined$pop80sf4
ltdb_all_joined$p10imm90 <- ltdb_all_joined$n10imm90/ltdb_all_joined$pop90sf3
ltdb_all_joined$p10imm00 <- ltdb_all_joined$n10imm00/ltdb_all_joined$pop00sf3
ltdb_all_joined$p10imm0a <- ltdb_all_joined$n10imm0a/ltdb_all_joined$pop0a

# percentage of naturalized foreign-born
ltdb_all_joined$pnat70 <- ltdb_all_joined$nat70/ltdb_all_joined$pop70sp1
ltdb_all_joined$pnat80 <- ltdb_all_joined$nat80/ltdb_all_joined$pop80sf4
ltdb_all_joined$pnat90 <- ltdb_all_joined$nat90/ltdb_all_joined$pop90sf3
ltdb_all_joined$pnat00 <- ltdb_all_joined$nat00/ltdb_all_joined$pop00sf3
ltdb_all_joined$pnat0a <- ltdb_all_joined$nat0a/ltdb_all_joined$pop0a

# percentage of persons who speak language other than english at home
ltdb_all_joined$polang80 <- ltdb_all_joined$olang80/ltdb_all_joined$ag5up80
ltdb_all_joined$polang90 <- ltdb_all_joined$olang90/ltdb_all_joined$ag5up90
ltdb_all_joined$polang00 <- ltdb_all_joined$olang00/ltdb_all_joined$ag5up00
ltdb_all_joined$polang0a <- ltdb_all_joined$olang0a/ltdb_all_joined$ag5up0a

# percentage of persons who speak english not well
ltdb_all_joined$plep80 <- ltdb_all_joined$lep80/ltdb_all_joined$ag5up80
ltdb_all_joined$plep90 <- ltdb_all_joined$lep90/ltdb_all_joined$ag5up90
ltdb_all_joined$plep00 <- ltdb_all_joined$lep00/ltdb_all_joined$ag5up00
ltdb_all_joined$plep0a <- ltdb_all_joined$lep0a/ltdb_all_joined$ag5up0a


# percentage of persons who were born in russia/ ussr
ltdb_all_joined$prufb70 <- ltdb_all_joined$rufb70/ltdb_all_joined$pop70sp2
ltdb_all_joined$prufb80 <- ltdb_all_joined$rufb80/ltdb_all_joined$pop80sf4
ltdb_all_joined$prufb90 <- ltdb_all_joined$rufb90/ltdb_all_joined$pop90sf4
ltdb_all_joined$prufb00 <- ltdb_all_joined$rufb00/ltdb_all_joined$pop00sf3
ltdb_all_joined$prufb0a <- ltdb_all_joined$rufb0a/ltdb_all_joined$pop0a

# percentage of persons who were born in italy
ltdb_all_joined$pitfb70 <- ltdb_all_joined$itfb70/ltdb_all_joined$pop70sp2
ltdb_all_joined$pitfb80 <- ltdb_all_joined$itfb80/ltdb_all_joined$pop80sf4
ltdb_all_joined$pitfb90 <- ltdb_all_joined$itfb90/ltdb_all_joined$pop90sf4
ltdb_all_joined$pitfb00 <- ltdb_all_joined$itfb00/ltdb_all_joined$pop00sf3
ltdb_all_joined$pitfb0a <- ltdb_all_joined$itfb0a/ltdb_all_joined$pop0a

# percentage of persons who were born in germany
ltdb_all_joined$pgefb70 <- ltdb_all_joined$gefb70/ltdb_all_joined$pop70sp2
ltdb_all_joined$pgefb80 <- ltdb_all_joined$gefb80/ltdb_all_joined$pop80sf4
ltdb_all_joined$pgefb90 <- ltdb_all_joined$gefb90/ltdb_all_joined$pop90sf4
ltdb_all_joined$pgefb00 <- ltdb_all_joined$gefb00/ltdb_all_joined$pop00sf3
ltdb_all_joined$pgefb0a <- ltdb_all_joined$gefb0a/ltdb_all_joined$pop0a

# percentage of persons who were born in ireland
ltdb_all_joined$pirfb70 <- ltdb_all_joined$irfb70/ltdb_all_joined$pop70sp2
ltdb_all_joined$pirfb80 <- ltdb_all_joined$irfb80/ltdb_all_joined$pop80sf4
ltdb_all_joined$pirfb90 <- ltdb_all_joined$irfb90/ltdb_all_joined$pop90sf4
ltdb_all_joined$pirfb00 <- ltdb_all_joined$irfb00/ltdb_all_joined$pop00sf3
ltdb_all_joined$pirfb0a <- ltdb_all_joined$irfb0a/ltdb_all_joined$pop0a

# percentage of persons who were born in scandinavian countries (swedish, norwegian, finnish, danish)
ltdb_all_joined$pscfb70 <- ltdb_all_joined$scfb70/ltdb_all_joined$pop70sp2
ltdb_all_joined$pscfb80 <- ltdb_all_joined$scfb80/ltdb_all_joined$pop80sf4
ltdb_all_joined$pscfb90 <- ltdb_all_joined$scfb90/ltdb_all_joined$pop90sf4
ltdb_all_joined$pscfb00 <- ltdb_all_joined$scfb00/ltdb_all_joined$pop00sf3
ltdb_all_joined$pscfb0a <- ltdb_all_joined$scfb0a/ltdb_all_joined$pop0a



# LTDB variable group 3: socioeconomic status

# percentage of persons with high school degree or less
ltdb_all_joined$phs70 <- ltdb_all_joined$hs70/ltdb_all_joined$ag25up70
ltdb_all_joined$phs80 <- ltdb_all_joined$hs80/ltdb_all_joined$ag25up80
ltdb_all_joined$phs90 <- ltdb_all_joined$hs90/ltdb_all_joined$ag25up90
ltdb_all_joined$phs00 <- ltdb_all_joined$hs00/ltdb_all_joined$ag25up00
ltdb_all_joined$phs0a <- ltdb_all_joined$hs0a/ltdb_all_joined$ag25up0a

# percentage of persons with at least a four-year college degree
ltdb_all_joined$pcol70 <- ltdb_all_joined$col70/ltdb_all_joined$ag25up70
ltdb_all_joined$pcol80 <- ltdb_all_joined$col80/ltdb_all_joined$ag25up80
ltdb_all_joined$pcol90 <- ltdb_all_joined$col90/ltdb_all_joined$ag25up90
ltdb_all_joined$pcol00 <- ltdb_all_joined$col00/ltdb_all_joined$ag25up00
ltdb_all_joined$pcol0a <- ltdb_all_joined$col0a/ltdb_all_joined$ag25up0a


# percent unemployed
ltdb_all_joined$punemp70 <- ltdb_all_joined$unemp70/ltdb_all_joined$clf70
ltdb_all_joined$punemp80 <- ltdb_all_joined$unemp80/ltdb_all_joined$clf80
ltdb_all_joined$punemp90 <- ltdb_all_joined$unemp90/ltdb_all_joined$clf90
ltdb_all_joined$punemp00 <- ltdb_all_joined$unemp00/ltdb_all_joined$clf00
ltdb_all_joined$punemp0a <- ltdb_all_joined$unemp0a/ltdb_all_joined$clf0a

# percentage of females in labor force
ltdb_all_joined$pflabf70 <- ltdb_all_joined$flabf70/ltdb_all_joined$dflabf70
ltdb_all_joined$pflabf80 <- ltdb_all_joined$flabf80/ltdb_all_joined$dflabf80
ltdb_all_joined$pflabf90 <- ltdb_all_joined$flabf90/ltdb_all_joined$dflabf90
ltdb_all_joined$pflabf00 <- ltdb_all_joined$flabf00/ltdb_all_joined$dflabf00
ltdb_all_joined$pflabf0a <- ltdb_all_joined$flabf0a/ltdb_all_joined$dflabf0a

# percentage of professional employees (by occupations)
ltdb_all_joined$pprof70 <- ltdb_all_joined$prof70/ltdb_all_joined$empclf70
ltdb_all_joined$pprof80 <- ltdb_all_joined$prof80/ltdb_all_joined$empclf80
ltdb_all_joined$pprof90 <- ltdb_all_joined$prof90/ltdb_all_joined$empclf90
ltdb_all_joined$pprof00 <- ltdb_all_joined$prof00/ltdb_all_joined$empclf00
ltdb_all_joined$pprof0a <- ltdb_all_joined$prof0a/ltdb_all_joined$empclf0a

# percentage of manufacturing employees (by industries)
ltdb_all_joined$pmanuf70 <- ltdb_all_joined$manuf70/ltdb_all_joined$empclf70
ltdb_all_joined$pmanuf80 <- ltdb_all_joined$manuf80/ltdb_all_joined$empclf80
ltdb_all_joined$pmanuf90 <- ltdb_all_joined$manuf90/ltdb_all_joined$empclf90
ltdb_all_joined$pmanuf00 <- ltdb_all_joined$manuf00/ltdb_all_joined$empclf00
ltdb_all_joined$pmanuf0a <- ltdb_all_joined$manuf0a/ltdb_all_joined$empclf0a

# percentage of self-employed
ltdb_all_joined$psemp70 <- ltdb_all_joined$semp70/ltdb_all_joined$empclf70
ltdb_all_joined$psemp80 <- ltdb_all_joined$semp80/ltdb_all_joined$empclf80
ltdb_all_joined$psemp90 <- ltdb_all_joined$semp90/ltdb_all_joined$empclf90
ltdb_all_joined$psemp00 <- ltdb_all_joined$semp00/ltdb_all_joined$empclf00
ltdb_all_joined$psemp0a <- ltdb_all_joined$semp0a/ltdb_all_joined$empclf0a


# percentage of veterans
ltdb_all_joined$pvet70 <- ltdb_all_joined$vet70/ltdb_all_joined$ag16cv70
ltdb_all_joined$pvet80 <- ltdb_all_joined$vet80/ltdb_all_joined$ag16cv80
ltdb_all_joined$pvet90 <- ltdb_all_joined$vet90/ltdb_all_joined$ag16cv90
ltdb_all_joined$pvet00 <- ltdb_all_joined$vet00/ltdb_all_joined$ag18cv00
ltdb_all_joined$pvet0a <- ltdb_all_joined$vet0a/ltdb_all_joined$ag18cv0a


# percent with disability
ltdb_all_joined$pdis70 <- ltdb_all_joined$dis70/ltdb_all_joined$cni16u70
ltdb_all_joined$pdis80 <- ltdb_all_joined$dis80/ltdb_all_joined$cni16u80
ltdb_all_joined$pdis90 <- ltdb_all_joined$dis90/ltdb_all_joined$cni16u90
ltdb_all_joined$pdis00 <- ltdb_all_joined$dis00/ltdb_all_joined$cni16u00


# percent poor
ltdb_all_joined$ppov70 <- ltdb_all_joined$npov70/ltdb_all_joined$dpov70
ltdb_all_joined$ppov80 <- ltdb_all_joined$npov80/ltdb_all_joined$dpov80
ltdb_all_joined$ppov90 <- ltdb_all_joined$npov90/ltdb_all_joined$dpov90
ltdb_all_joined$ppov00 <- ltdb_all_joined$npov00/ltdb_all_joined$dpov00
ltdb_all_joined$ppov0a <- ltdb_all_joined$npov0a/ltdb_all_joined$dpov0a

# percentage of 65 years and older in poverty
ltdb_all_joined$p65pov70 <- ltdb_all_joined$n65pov70/ltdb_all_joined$dpov70
ltdb_all_joined$p65pov80 <- ltdb_all_joined$n65pov80/ltdb_all_joined$dpov80
ltdb_all_joined$p65pov90 <- ltdb_all_joined$n65pov90/ltdb_all_joined$dpov90
ltdb_all_joined$p65pov00 <- ltdb_all_joined$n65pov00/ltdb_all_joined$dpov00
ltdb_all_joined$p65pov0a <- ltdb_all_joined$n65pov0a/ltdb_all_joined$dpov0a

# percentage of families with children in poverty
ltdb_all_joined$pfmpov70 <- ltdb_all_joined$nfmpov70/ltdb_all_joined$dfmpov70
ltdb_all_joined$pfmpov80 <- ltdb_all_joined$nfmpov80/ltdb_all_joined$dfmpov80
ltdb_all_joined$pfmpov90 <- ltdb_all_joined$nfmpov90/ltdb_all_joined$dfmpov90
ltdb_all_joined$pfmpov00 <- ltdb_all_joined$nfmpov00/ltdb_all_joined$dfmpov00
ltdb_all_joined$pfmpov0a <- ltdb_all_joined$nfmpov0a/ltdb_all_joined$dfmpov0a

# percentage of whites in poverty
ltdb_all_joined$pwpov70 <- ltdb_all_joined$nwpov70/ltdb_all_joined$dwpov70
ltdb_all_joined$pwpov80 <- ltdb_all_joined$nwpov80/ltdb_all_joined$dwpov80
ltdb_all_joined$pwpov90 <- ltdb_all_joined$nwpov90/ltdb_all_joined$dwpov90
ltdb_all_joined$pwpov00 <- ltdb_all_joined$nwpov00/ltdb_all_joined$dwpov00
ltdb_all_joined$pwpov0a <- ltdb_all_joined$nwpov0a/ltdb_all_joined$dwpov0a

# percentage of blacks in poverty
ltdb_all_joined$pbpov70 <- ltdb_all_joined$nbpov70/ltdb_all_joined$dbpov70
ltdb_all_joined$pbpov80 <- ltdb_all_joined$nbpov80/ltdb_all_joined$dbpov80
ltdb_all_joined$pbpov90 <- ltdb_all_joined$nbpov90/ltdb_all_joined$dbpov90
ltdb_all_joined$pbpov00 <- ltdb_all_joined$nbpov00/ltdb_all_joined$dbpov00
ltdb_all_joined$pbpov0a <- ltdb_all_joined$nbpov0a/ltdb_all_joined$dbpov0a

# percentage of hispanics in poverty
ltdb_all_joined$phpov80 <- ltdb_all_joined$nhpov80/ltdb_all_joined$dhpov80
ltdb_all_joined$phpov90 <- ltdb_all_joined$nhpov90/ltdb_all_joined$dhpov90
ltdb_all_joined$phpov00 <- ltdb_all_joined$nhpov00/ltdb_all_joined$dhpov00
ltdb_all_joined$phpov0a <- ltdb_all_joined$nhpov0a/ltdb_all_joined$dhpov0a

# percentage of native americans in poverty
ltdb_all_joined$pnapov80 <- ltdb_all_joined$nnapov80/ltdb_all_joined$dnapov80
ltdb_all_joined$pnapov90 <- ltdb_all_joined$nnapov90/ltdb_all_joined$dnapov90
ltdb_all_joined$pnapov00 <- ltdb_all_joined$nnapov00/ltdb_all_joined$dnapov00
ltdb_all_joined$pnapov0a <- ltdb_all_joined$nnapov0a/ltdb_all_joined$dnapov0a

# percentage of asian and pacific islanders in poverty
ltdb_all_joined$papov80 <- ltdb_all_joined$napov80/ltdb_all_joined$dapov80
ltdb_all_joined$papov90 <- ltdb_all_joined$napov90/ltdb_all_joined$dapov90
ltdb_all_joined$papov00 <- ltdb_all_joined$napov00/ltdb_all_joined$dapov00
ltdb_all_joined$papov0a <- ltdb_all_joined$napov0a/ltdb_all_joined$dapov0a



# LTDB variable group 4: housing, age, and marital status

# percentage of vacant housing units
ltdb_all_joined$pvac70 <- ltdb_all_joined$vac70/ltdb_all_joined$hu70
ltdb_all_joined$pvac80 <- ltdb_all_joined$vac80/ltdb_all_joined$hu80
ltdb_all_joined$pvac90 <- ltdb_all_joined$vac90/ltdb_all_joined$hu90
ltdb_all_joined$pvac00 <- ltdb_all_joined$vac00/ltdb_all_joined$hu00
ltdb_all_joined$pvac0a <- ltdb_all_joined$vac0a/ltdb_all_joined$hu0a
ltdb_all_joined$pvac10 <- ltdb_all_joined$vac10/ltdb_all_joined$hu10

# percentage of owner-occupied housing units
ltdb_all_joined$pown70 <- ltdb_all_joined$own70/ltdb_all_joined$ohu70
ltdb_all_joined$pown80 <- ltdb_all_joined$own80/ltdb_all_joined$ohu80
ltdb_all_joined$pown90 <- ltdb_all_joined$own90/ltdb_all_joined$ohu90
ltdb_all_joined$pown00 <- ltdb_all_joined$own00/ltdb_all_joined$ohu00
ltdb_all_joined$pown0a <- ltdb_all_joined$own0a/ltdb_all_joined$ohu0a
ltdb_all_joined$pown10 <- ltdb_all_joined$own10/ltdb_all_joined$ohu10

# percentage of housing units in multi-unit structures
ltdb_all_joined$pmulti70 <- ltdb_all_joined$multi70/ltdb_all_joined$dmulti70
ltdb_all_joined$pmulti80 <- ltdb_all_joined$multi80/ltdb_all_joined$dmulti80
ltdb_all_joined$pmulti90 <- ltdb_all_joined$multi90/ltdb_all_joined$dmulti90
ltdb_all_joined$pmulti00 <- ltdb_all_joined$multi00/ltdb_all_joined$dmulti00
ltdb_all_joined$pmulti0a <- ltdb_all_joined$multi0a/ltdb_all_joined$dmulti0a

# percentage of structures built more than 30 years ago
ltdb_all_joined$p30old70 <- ltdb_all_joined$h30old70/ltdb_all_joined$hu70sp
ltdb_all_joined$p30old80 <- ltdb_all_joined$h30old80/ltdb_all_joined$hu80sp
ltdb_all_joined$p30old90 <- ltdb_all_joined$h30old90/ltdb_all_joined$hu90sp
ltdb_all_joined$p30old00 <- ltdb_all_joined$h30old00/ltdb_all_joined$hu00sp
ltdb_all_joined$p30old0a <- ltdb_all_joined$h30old0a/ltdb_all_joined$hu0a

# percentage of household heads moved into unit less than 10 years ago
ltdb_all_joined$p10yrs70 <- ltdb_all_joined$h10yrs70/ltdb_all_joined$ohu70sp
ltdb_all_joined$p10yrs80 <- ltdb_all_joined$h10yrs80/ltdb_all_joined$ohu80sp
ltdb_all_joined$p10yrs90 <- ltdb_all_joined$h10yrs90/ltdb_all_joined$ohu90sp
ltdb_all_joined$p10yrs00 <- ltdb_all_joined$h10yrs00/ltdb_all_joined$ohu00sp
ltdb_all_joined$p10yrs0a <- ltdb_all_joined$h10yrs0a/ltdb_all_joined$ohu0a

# percentage of persons age 17 years and under
ltdb_all_joined$p18und70 <- ltdb_all_joined$a18und70/ltdb_all_joined$pop70
ltdb_all_joined$p18und80 <- ltdb_all_joined$a18und80/ltdb_all_joined$pop80
ltdb_all_joined$p18und90 <- ltdb_all_joined$a18und90/ltdb_all_joined$pop90
ltdb_all_joined$p18und00 <- ltdb_all_joined$a18und00/ltdb_all_joined$pop00
ltdb_all_joined$p18und10 <- ltdb_all_joined$a18und10/ltdb_all_joined$pop10
ltdb_all_joined$p18und0a <- ltdb_all_joined$a18und0a/ltdb_all_joined$pop0a

# percentage of persons age 60 years and over
ltdb_all_joined$p60up70 <- ltdb_all_joined$a60up70/ltdb_all_joined$pop70
ltdb_all_joined$p60up80 <- ltdb_all_joined$a60up80/ltdb_all_joined$pop80
ltdb_all_joined$p60up90 <- ltdb_all_joined$a60up90/ltdb_all_joined$pop90
ltdb_all_joined$p60up00 <- ltdb_all_joined$a60up00/ltdb_all_joined$pop00
ltdb_all_joined$p60up10 <- ltdb_all_joined$a60up10/ltdb_all_joined$pop10
ltdb_all_joined$p60up0a <- ltdb_all_joined$a60up0a/ltdb_all_joined$pop0a

# percentage of persons age 75 years and over
ltdb_all_joined$p75up70 <- ltdb_all_joined$a75up70/ltdb_all_joined$pop70
ltdb_all_joined$p75up80 <- ltdb_all_joined$a75up80/ltdb_all_joined$pop80
ltdb_all_joined$p75up90 <- ltdb_all_joined$a75up90/ltdb_all_joined$pop90
ltdb_all_joined$p75up00 <- ltdb_all_joined$a75up00/ltdb_all_joined$pop00
ltdb_all_joined$p75up10 <- ltdb_all_joined$a75up10/ltdb_all_joined$pop10
ltdb_all_joined$p75up0a <- ltdb_all_joined$a75up0a/ltdb_all_joined$pop0a

# percent currently married (excluding separated)
ltdb_all_joined$pmar70 <- ltdb_all_joined$mar70/ltdb_all_joined$ag15up70
ltdb_all_joined$pmar80 <- ltdb_all_joined$mar80/ltdb_all_joined$ag15up80
ltdb_all_joined$pmar90 <- ltdb_all_joined$mar90/ltdb_all_joined$ag15up90
ltdb_all_joined$pmar00 <- ltdb_all_joined$mar.00/ltdb_all_joined$ag15up00
ltdb_all_joined$pmar0a <- ltdb_all_joined$mar0a/ltdb_all_joined$ag15up0a

# percent widowed, divorced, and separated
ltdb_all_joined$pwds70 <- ltdb_all_joined$wds70/ltdb_all_joined$ag15up70
ltdb_all_joined$pwds80 <- ltdb_all_joined$wds80/ltdb_all_joined$ag15up80
ltdb_all_joined$pwds90 <- ltdb_all_joined$wds90/ltdb_all_joined$ag15up90
ltdb_all_joined$pwds00 <- ltdb_all_joined$wds00/ltdb_all_joined$ag15up00
ltdb_all_joined$pwds0a <- ltdb_all_joined$wds0a/ltdb_all_joined$ag15up0a

# percentage of female-headed families with children
ltdb_all_joined$pfhh70 <- ltdb_all_joined$fhh70/ltdb_all_joined$family70
ltdb_all_joined$pfhh80 <- ltdb_all_joined$fhh80/ltdb_all_joined$family80
ltdb_all_joined$pfhh90 <- ltdb_all_joined$fhh90/ltdb_all_joined$family90
ltdb_all_joined$pfhh00 <- ltdb_all_joined$fhh00/ltdb_all_joined$family00
ltdb_all_joined$pfhh0a <- ltdb_all_joined$fhh0a/ltdb_all_joined$family0a



# Change in percentages across time periods

# Adjusting dollars values across time for inflation
# INFLATION VALUES FROM http://www.usinflationcalculator.com/
#### Equivalent 2010 values for $1 ####

# 2011 (Oc):  .97
# 2010 (0b): 1.00
# 2008 (0a): 1.01

# 2000:      1.27
# 1990:      1.67
# 1980:      2.65
# 1970:      5.62

# change in median home value, controlling for inflation (in 2010 $ values)
ltdb_all_joined$mhmval_delta_00_0a <- 1.01*ltdb_all_joined$mhmval0a - 1.27*ltdb_all_joined$mhmval00
ltdb_all_joined$mhmval_delta_90_00 <- 1.27*ltdb_all_joined$mhmval00 - 1.67*ltdb_all_joined$mhmval90
ltdb_all_joined$mhmval_delta_80_90 <- 1.67*ltdb_all_joined$mhmval90 - 2.65*ltdb_all_joined$mhmval80
ltdb_all_joined$mhmval_delta_70_80 <- 2.65*ltdb_all_joined$mhmval80 - 5.62*ltdb_all_joined$mhmval70

ltdb_all_joined$mhmval_delta_0a_0b <- 1.00*ltdb_all_joined$mhmval0b - 1.01*ltdb_all_joined$mhmval0a
ltdb_all_joined$mhmval_delta_0b_0c <- .97*ltdb_all_joined$mhmval0c - 1.00*ltdb_all_joined$mhmval0b


# change in household income, controlling for inflation
ltdb_all_joined$hinc_delta_00_0a <- 1.01*ltdb_all_joined$hinc0a - 1.27*ltdb_all_joined$hinc00
ltdb_all_joined$hinc_delta_90_00 <- 1.27*ltdb_all_joined$hinc00 - 1.67*ltdb_all_joined$hinc90
ltdb_all_joined$hinc_delta_80_90 <- 1.67*ltdb_all_joined$hinc90 - 2.65*ltdb_all_joined$hinc80
ltdb_all_joined$hinc_delta_70_80 <- 2.65*ltdb_all_joined$hinc80 - 5.62*ltdb_all_joined$hinc70

ltdb_all_joined$hinc_delta_0a_0b <- 1.00*ltdb_all_joined$hinc0b - 1.01*ltdb_all_joined$hinc0a
ltdb_all_joined$hinc_delta_0b_0c <- .97*ltdb_all_joined$hinc0c - 1.00*ltdb_all_joined$hinc0b


# change in educational level (percentage of residents age 25 and over holding bachelor’s degrees)
ltdb_all_joined$pcol_delta_00_0a <- ltdb_all_joined$pcol0a - ltdb_all_joined$pcol00
ltdb_all_joined$pcol_delta_90_00 <- ltdb_all_joined$pcol00 - ltdb_all_joined$pcol90
ltdb_all_joined$pcol_delta_80_90 <- ltdb_all_joined$pcol90 - ltdb_all_joined$pcol80
ltdb_all_joined$pcol_delta_70_80 <- ltdb_all_joined$pcol80 - ltdb_all_joined$pcol70

ltdb_all_joined$pcol_delta_0a_0b <- ltdb_all_joined$pcol0b - ltdb_all_joined$pcol0a
ltdb_all_joined$pcol_delta_0b_0c <- ltdb_all_joined$pcol0c - ltdb_all_joined$pcol0b


# Change in other demographic percentages

# change in percentage white
ltdb_all_joined$pnhwht_delta_00_10 <- ltdb_all_joined$pnhwht10 - ltdb_all_joined$pnhwht00
ltdb_all_joined$pnhwht_delta_00_0a <- ltdb_all_joined$pnhwht0a - ltdb_all_joined$pnhwht00
ltdb_all_joined$pnhwht_delta_90_00 <- ltdb_all_joined$pnhwht00 - ltdb_all_joined$pnhwht90
ltdb_all_joined$pnhwht_delta_80_90 <- ltdb_all_joined$pnhwht90 - ltdb_all_joined$pnhwht80
ltdb_all_joined$pnhwht_delta_70_80 <- ltdb_all_joined$pnhwht80 - ltdb_all_joined$pwhite70

ltdb_all_joined$pnhwht_delta_0a_0b <- ltdb_all_joined$pnhwht0b - ltdb_all_joined$pnhwht0a
ltdb_all_joined$pnhwht_delta_0b_0c <- ltdb_all_joined$pnhwht0c - ltdb_all_joined$pnhwht0b

# change in percentage black
ltdb_all_joined$pnhblk_delta_00_10 <- ltdb_all_joined$pnhblk10 - ltdb_all_joined$pnhblk00
ltdb_all_joined$pnhblk_delta_00_0a <- ltdb_all_joined$pnhblk0a - ltdb_all_joined$pnhblk00
ltdb_all_joined$pnhblk_delta_90_00 <- ltdb_all_joined$pnhblk00 - ltdb_all_joined$pnhblk90
ltdb_all_joined$pnhblk_delta_80_90 <- ltdb_all_joined$pnhblk90 - ltdb_all_joined$pnhblk80
ltdb_all_joined$pnhblk_delta_70_80 <- ltdb_all_joined$pnhblk80 - ltdb_all_joined$pblack70

ltdb_all_joined$pnhblk_delta_0a_0b <- ltdb_all_joined$pnhblk0b - ltdb_all_joined$pnhblk0a
ltdb_all_joined$pnhblk_delta_0b_0c <- ltdb_all_joined$pnhblk0c - ltdb_all_joined$pnhblk0b

# change in percentage hispanic
ltdb_all_joined$phisp_delta_00_10 <- ltdb_all_joined$phisp10 - ltdb_all_joined$phisp00
ltdb_all_joined$phisp_delta_00_0a <- ltdb_all_joined$phisp0a - ltdb_all_joined$phisp00
ltdb_all_joined$phisp_delta_90_00 <- ltdb_all_joined$phisp00 - ltdb_all_joined$phisp90
ltdb_all_joined$phisp_delta_80_90 <- ltdb_all_joined$phisp90 - ltdb_all_joined$phisp80

ltdb_all_joined$phisp_delta_0a_0b <- ltdb_all_joined$phisp0b - ltdb_all_joined$phisp0a
ltdb_all_joined$phisp_delta_0b_0c <- ltdb_all_joined$phisp0c - ltdb_all_joined$phisp0b

# change in percentage native american
ltdb_all_joined$pntv_delta_00_10 <- ltdb_all_joined$pntv10 - ltdb_all_joined$pntv00
ltdb_all_joined$pntv_delta_00_0a <- ltdb_all_joined$pntv0a - ltdb_all_joined$pntv00
ltdb_all_joined$pntv_delta_90_00 <- ltdb_all_joined$pntv00 - ltdb_all_joined$pntv90
ltdb_all_joined$pntv_delta_80_90 <- ltdb_all_joined$pntv90 - ltdb_all_joined$pntv80

ltdb_all_joined$pntv_delta_0a_0b <- ltdb_all_joined$pntv0b - ltdb_all_joined$pntv0a
ltdb_all_joined$pntv_delta_0b_0c <- ltdb_all_joined$pntv0c - ltdb_all_joined$pntv0b
  				
# change in percentage asian
ltdb_all_joined$pasian_delta_00_10 <- ltdb_all_joined$pasian10 - ltdb_all_joined$pasian00
ltdb_all_joined$pasian_delta_00_0a <- ltdb_all_joined$pasian0a - ltdb_all_joined$pasian00
ltdb_all_joined$pasian_delta_90_00 <- ltdb_all_joined$pasian00 - ltdb_all_joined$pasian90
ltdb_all_joined$pasian_delta_80_90 <- ltdb_all_joined$pasian90 - ltdb_all_joined$pasian80
ltdb_all_joined$pasian_delta_70_80 <- ltdb_all_joined$pasian80 - ltdb_all_joined$pasian70

ltdb_all_joined$pasian_delta_0a_0b <- ltdb_all_joined$pasian0b - ltdb_all_joined$pasian0a
ltdb_all_joined$pasian_delta_0b_0c <- ltdb_all_joined$pasian0c - ltdb_all_joined$pasian0b

# change in percentage hawaiian
ltdb_all_joined$phaw_delta_00_10 <- ltdb_all_joined$phaw10 - ltdb_all_joined$phaw00
ltdb_all_joined$phaw_delta_00_0a <- ltdb_all_joined$phaw0a - ltdb_all_joined$phaw00
ltdb_all_joined$phaw_delta_90_00 <- ltdb_all_joined$phaw00 - ltdb_all_joined$phaw90
ltdb_all_joined$phaw_delta_80_90 <- ltdb_all_joined$phaw90 - ltdb_all_joined$phaw80
ltdb_all_joined$phaw_delta_70_80 <- ltdb_all_joined$phaw80 - ltdb_all_joined$phaw70

ltdb_all_joined$phaw_delta_0a_0b <- ltdb_all_joined$phaw0b - ltdb_all_joined$phaw0a
ltdb_all_joined$phaw_delta_0b_0c <- ltdb_all_joined$phaw0c - ltdb_all_joined$phaw0b

# change in percentage indian
ltdb_all_joined$pindia_delta_00_10 <- ltdb_all_joined$pindia10 - ltdb_all_joined$pindia00
ltdb_all_joined$pindia_delta_00_0a <- ltdb_all_joined$pindia0a - ltdb_all_joined$pindia00
ltdb_all_joined$pindia_delta_90_00 <- ltdb_all_joined$pindia00 - ltdb_all_joined$pindia90
ltdb_all_joined$pindia_delta_80_90 <- ltdb_all_joined$pindia90 - ltdb_all_joined$pindia80
ltdb_all_joined$pindia_delta_70_80 <- ltdb_all_joined$pindia80 - ltdb_all_joined$pindia70

# change in percentage chinese
ltdb_all_joined$pchina_delta_00_10 <- ltdb_all_joined$pchina10 - ltdb_all_joined$pchina00
ltdb_all_joined$pchina_delta_00_0a <- ltdb_all_joined$pchina0a - ltdb_all_joined$pchina00
ltdb_all_joined$pchina_delta_90_00 <- ltdb_all_joined$pchina00 - ltdb_all_joined$pchina90
ltdb_all_joined$pchina_delta_80_90 <- ltdb_all_joined$pchina90 - ltdb_all_joined$pchina80
ltdb_all_joined$pchina_delta_70_80 <- ltdb_all_joined$pchina80 - ltdb_all_joined$pchina70

# change in percentage filipino
ltdb_all_joined$pfilip_delta_00_10 <- ltdb_all_joined$pfilip10 - ltdb_all_joined$pfilip00
ltdb_all_joined$pfilip_delta_00_0a <- ltdb_all_joined$pfilip0a - ltdb_all_joined$pfilip00
ltdb_all_joined$pfilip_delta_90_00 <- ltdb_all_joined$pfilip00 - ltdb_all_joined$pfilip90
ltdb_all_joined$pfilip_delta_80_90 <- ltdb_all_joined$pfilip90 - ltdb_all_joined$pfilip80
ltdb_all_joined$pfilip_delta_70_80 <- ltdb_all_joined$pfilip80 - ltdb_all_joined$pfilip70

# change in percentage japanese
ltdb_all_joined$pjapan_delta_00_10 <- ltdb_all_joined$pjapan10 - ltdb_all_joined$pjapan00
ltdb_all_joined$pjapan_delta_00_0a <- ltdb_all_joined$pjapan0a - ltdb_all_joined$pjapan00
ltdb_all_joined$pjapan_delta_90_00 <- ltdb_all_joined$pjapan00 - ltdb_all_joined$pjapan90
ltdb_all_joined$pjapan_delta_80_90 <- ltdb_all_joined$pjapan90 - ltdb_all_joined$pjapan80
ltdb_all_joined$pjapan_delta_70_80 <- ltdb_all_joined$pjapan80 - ltdb_all_joined$pjapan70

# change in percentage korean
ltdb_all_joined$pkorea_delta_00_10 <- ltdb_all_joined$pkorea10 - ltdb_all_joined$pkorea00
ltdb_all_joined$pkorea_delta_00_0a <- ltdb_all_joined$pkorea0a - ltdb_all_joined$pkorea00
ltdb_all_joined$pkorea_delta_90_00 <- ltdb_all_joined$pkorea00 - ltdb_all_joined$pkorea90
ltdb_all_joined$pkorea_delta_80_90 <- ltdb_all_joined$pkorea90 - ltdb_all_joined$pkorea80
ltdb_all_joined$pkorea_delta_70_80 <- ltdb_all_joined$pkorea80 - ltdb_all_joined$pkorea70

# change in percentage vietnamese
ltdb_all_joined$pviet_delta_00_10 <- ltdb_all_joined$pviet10 - ltdb_all_joined$pviet00
ltdb_all_joined$pviet_delta_00_0a <- ltdb_all_joined$pviet0a - ltdb_all_joined$pviet00
ltdb_all_joined$pviet_delta_90_00 <- ltdb_all_joined$pviet00 - ltdb_all_joined$pviet90
ltdb_all_joined$pviet_delta_80_90 <- ltdb_all_joined$pviet90 - ltdb_all_joined$pviet80

# change in percentage of 0-15 year olds who are white
ltdb_all_joined$p15wht_delta_00_10 <- ltdb_all_joined$p15wht10 - ltdb_all_joined$p15wht00
ltdb_all_joined$p15wht_delta_00_0a <- ltdb_all_joined$p15wht0a - ltdb_all_joined$p15wht00
ltdb_all_joined$p15wht_delta_90_00 <- ltdb_all_joined$p15wht00 - ltdb_all_joined$p15wht90
ltdb_all_joined$p15wht_delta_80_90 <- ltdb_all_joined$p15wht90 - ltdb_all_joined$p15wht80
ltdb_all_joined$p15wht_delta_70_80 <- ltdb_all_joined$p15wht80 - ltdb_all_joined$p15wht70

# change in percentage of 60+ year olds who are white
ltdb_all_joined$p60wht_delta_00_10 <- ltdb_all_joined$p60wht10 - ltdb_all_joined$p60wht00
ltdb_all_joined$p60wht_delta_90_00 <- ltdb_all_joined$p60wht00 - ltdb_all_joined$p60wht90
ltdb_all_joined$p60wht_delta_80_90 <- ltdb_all_joined$p60wht90 - ltdb_all_joined$p60wht80
ltdb_all_joined$p60wht_delta_70_80 <- ltdb_all_joined$p60wht80 - ltdb_all_joined$p60wht70

# change in percentage of 0-15 year olds who are black
ltdb_all_joined$p15blk_delta_00_10 <- ltdb_all_joined$p15blk10 - ltdb_all_joined$p15blk00
ltdb_all_joined$p15blk_delta_00_0a <- ltdb_all_joined$p15blk0a - ltdb_all_joined$p15blk00
ltdb_all_joined$p15blk_delta_90_00 <- ltdb_all_joined$p15blk00 - ltdb_all_joined$p15blk90
ltdb_all_joined$p15blk_delta_80_90 <- ltdb_all_joined$p15blk90 - ltdb_all_joined$p15blk80
ltdb_all_joined$p15blk_delta_70_80 <- ltdb_all_joined$p15blk80 - ltdb_all_joined$p15blk70

# change in percentage of 60+ year olds who are black
ltdb_all_joined$p60blk_delta_00_10 <- ltdb_all_joined$p60blk10 - ltdb_all_joined$p60blk00
ltdb_all_joined$p60blk_delta_90_00 <- ltdb_all_joined$p60blk00 - ltdb_all_joined$p60blk90
ltdb_all_joined$p60blk_delta_80_90 <- ltdb_all_joined$p60blk90 - ltdb_all_joined$p60blk80
ltdb_all_joined$p60blk_delta_70_80 <- ltdb_all_joined$p60blk80 - ltdb_all_joined$p60blk70

# change in percentage of 0-15 year olds who are hispanic
ltdb_all_joined$p15hsp_delta_00_10 <- ltdb_all_joined$p15hsp10 - ltdb_all_joined$p15hsp00
ltdb_all_joined$p15hsp_delta_00_0a <- ltdb_all_joined$p15hsp0a - ltdb_all_joined$p15hsp00
ltdb_all_joined$p15hsp_delta_90_00 <- ltdb_all_joined$p15hsp00 - ltdb_all_joined$p15hsp90
ltdb_all_joined$p15hsp_delta_80_90 <- ltdb_all_joined$p15hsp90 - ltdb_all_joined$p15hsp80

# change in percentage of 60+ year olds who are hispanic
ltdb_all_joined$p60hsp_delta_00_10 <- ltdb_all_joined$p60hsp10 - ltdb_all_joined$p60hsp00
ltdb_all_joined$p60hsp_delta_90_00 <- ltdb_all_joined$p60hsp00 - ltdb_all_joined$p60hsp90
ltdb_all_joined$p60hsp_delta_80_90 <- ltdb_all_joined$p60hsp90 - ltdb_all_joined$p60hsp80

# change in percentage of 0-15 year olds who are native american
ltdb_all_joined$p15ntv_delta_00_10 <- ltdb_all_joined$p15ntv10 - ltdb_all_joined$p15ntv00
ltdb_all_joined$p15ntv_delta_00_0a <- ltdb_all_joined$p15ntv0a - ltdb_all_joined$p15ntv00
ltdb_all_joined$p15ntv_delta_90_00 <- ltdb_all_joined$p15ntv00 - ltdb_all_joined$p15ntv90
ltdb_all_joined$p15ntv_delta_80_90 <- ltdb_all_joined$p15ntv90 - ltdb_all_joined$p15ntv80

# change in percentage of 60+ year olds who are native american
ltdb_all_joined$p60ntv_delta_00_10 <- ltdb_all_joined$p60ntv10 - ltdb_all_joined$p60ntv00
ltdb_all_joined$p60ntv_delta_90_00 <- ltdb_all_joined$p60ntv00 - ltdb_all_joined$p60ntv90
ltdb_all_joined$p60ntv_delta_80_90 <- ltdb_all_joined$p60ntv90 - ltdb_all_joined$p60ntv80

# change in percentage of 0-15 year olds who are asian
ltdb_all_joined$p15asn_delta_00_10 <- ltdb_all_joined$p15asn10 - ltdb_all_joined$p15asn00
ltdb_all_joined$p15asn_delta_00_0a <- ltdb_all_joined$p15asn0a - ltdb_all_joined$p15asn00
ltdb_all_joined$p15asn_delta_90_00 <- ltdb_all_joined$p15asn00 - ltdb_all_joined$p15asn90
ltdb_all_joined$p15asn_delta_80_90 <- ltdb_all_joined$p15asn90 - ltdb_all_joined$p15asn80

# change in percentage of 60+ year olds who are asian
ltdb_all_joined$p60asn_delta_00_10 <- ltdb_all_joined$p60asn10 - ltdb_all_joined$p60asn00
ltdb_all_joined$p60asn_delta_90_00 <- ltdb_all_joined$p60asn00 - ltdb_all_joined$p60asn90
ltdb_all_joined$p60asn_delta_80_90 <- ltdb_all_joined$p60asn90 - ltdb_all_joined$p60asn80

# change in percentage mexican
ltdb_all_joined$pmex_delta_00_10 <- ltdb_all_joined$pmex10 - ltdb_all_joined$pmex00
ltdb_all_joined$pmex_delta_00_0a <- ltdb_all_joined$pmex0a - ltdb_all_joined$pmex00
ltdb_all_joined$pmex_delta_90_00 <- ltdb_all_joined$pmex00 - ltdb_all_joined$pmex90
ltdb_all_joined$pmex_delta_80_90 <- ltdb_all_joined$pmex90 - ltdb_all_joined$pmex80
ltdb_all_joined$pmex_delta_70_80 <- ltdb_all_joined$pmex80 - ltdb_all_joined$pmex70

# change in percentage cuban
ltdb_all_joined$pcuban_delta_00_10 <- ltdb_all_joined$pcuban10 - ltdb_all_joined$pcuban00
ltdb_all_joined$pcuban_delta_00_0a <- ltdb_all_joined$pcuban0a - ltdb_all_joined$pcuban00
ltdb_all_joined$pcuban_delta_90_00 <- ltdb_all_joined$pcuban00 - ltdb_all_joined$pcuban90
ltdb_all_joined$pcuban_delta_80_90 <- ltdb_all_joined$pcuban90 - ltdb_all_joined$pcuban80
ltdb_all_joined$pcuban_delta_70_80 <- ltdb_all_joined$pcuban80 - ltdb_all_joined$pcuban70

# change in percentage puerto rican
ltdb_all_joined$ppr_delta_00_10 <- ltdb_all_joined$ppr10 - ltdb_all_joined$ppr00
ltdb_all_joined$ppr_delta_00_0a <- ltdb_all_joined$ppr0a - ltdb_all_joined$ppr00
ltdb_all_joined$ppr_delta_90_00 <- ltdb_all_joined$ppr00 - ltdb_all_joined$ppr90
ltdb_all_joined$ppr_delta_80_90 <- ltdb_all_joined$ppr90 - ltdb_all_joined$ppr80
ltdb_all_joined$ppr_delta_70_80 <- ltdb_all_joined$ppr80 - ltdb_all_joined$ppr70

# change in percentage russian/ussr ancestry
ltdb_all_joined$pruanc_delta_00_0a <- ltdb_all_joined$pruanc0a - ltdb_all_joined$pruanc00
ltdb_all_joined$pruanc_delta_90_00 <- ltdb_all_joined$pruanc00 - ltdb_all_joined$pruanc90
ltdb_all_joined$pruanc_delta_80_90 <- ltdb_all_joined$pruanc90 - ltdb_all_joined$pruanc80
ltdb_all_joined$pruanc_delta_70_80 <- ltdb_all_joined$pruanc80 - ltdb_all_joined$pruanc70

# change in percentage italian ancestry
ltdb_all_joined$pitanc_delta_00_0a <- ltdb_all_joined$pitanc0a - ltdb_all_joined$pitanc00
ltdb_all_joined$pitanc_delta_90_00 <- ltdb_all_joined$pitanc00 - ltdb_all_joined$pitanc90
ltdb_all_joined$pitanc_delta_80_90 <- ltdb_all_joined$pitanc90 - ltdb_all_joined$pitanc80
ltdb_all_joined$pitanc_delta_70_80 <- ltdb_all_joined$pitanc80 - ltdb_all_joined$pitanc70

# change in percentage german ancestry
ltdb_all_joined$pgeanc_delta_00_0a <- ltdb_all_joined$pgeanc0a - ltdb_all_joined$pgeanc00
ltdb_all_joined$pgeanc_delta_90_00 <- ltdb_all_joined$pgeanc00 - ltdb_all_joined$pgeanc90
ltdb_all_joined$pgeanc_delta_80_90 <- ltdb_all_joined$pgeanc90 - ltdb_all_joined$pgeanc80
ltdb_all_joined$pgeanc_delta_70_80 <- ltdb_all_joined$pgeanc80 - ltdb_all_joined$pgeanc70

# change in percentage irish ancestry
ltdb_all_joined$piranc_delta_00_0a <- ltdb_all_joined$piranc0a - ltdb_all_joined$piranc00
ltdb_all_joined$piranc_delta_90_00 <- ltdb_all_joined$piranc00 - ltdb_all_joined$piranc90
ltdb_all_joined$piranc_delta_80_90 <- ltdb_all_joined$piranc90 - ltdb_all_joined$piranc80
ltdb_all_joined$piranc_delta_70_80 <- ltdb_all_joined$piranc80 - ltdb_all_joined$piranc70

# change in percentage scandinavian ancestry
ltdb_all_joined$pscanc_delta_00_0a <- ltdb_all_joined$pscanc0a - ltdb_all_joined$pscanc00
ltdb_all_joined$pscanc_delta_90_00 <- ltdb_all_joined$pscanc00 - ltdb_all_joined$pscanc90
ltdb_all_joined$pscanc_delta_80_90 <- ltdb_all_joined$pscanc90 - ltdb_all_joined$pscanc80
ltdb_all_joined$pscanc_delta_70_80 <- ltdb_all_joined$pscanc80 - ltdb_all_joined$pscanc70

# change in percentage foreign born
ltdb_all_joined$pfb_delta_00_0a <- ltdb_all_joined$pfb0a - ltdb_all_joined$pfb00
ltdb_all_joined$pfb_delta_90_00 <- ltdb_all_joined$pfb00 - ltdb_all_joined$pfb90
ltdb_all_joined$pfb_delta_80_90 <- ltdb_all_joined$pfb90 - ltdb_all_joined$pfb80
ltdb_all_joined$pfb_delta_70_80 <- ltdb_all_joined$pfb80 - ltdb_all_joined$pfb70

ltdb_all_joined$pfb_delta_0a_0b <- ltdb_all_joined$pfb0b - ltdb_all_joined$pfb0a
ltdb_all_joined$pfb_delta_0b_0c <- ltdb_all_joined$pfb0c - ltdb_all_joined$pfb0b

# change in percentage recent immigrants
ltdb_all_joined$p10imm_delta_00_0a <- ltdb_all_joined$p10imm0a - ltdb_all_joined$p10imm00
ltdb_all_joined$p10imm_delta_90_00 <- ltdb_all_joined$p10imm00 - ltdb_all_joined$p10imm90
ltdb_all_joined$p10imm_delta_80_90 <- ltdb_all_joined$p10imm90 - ltdb_all_joined$p10imm80
ltdb_all_joined$p10imm_delta_70_80 <- ltdb_all_joined$p10imm80 - ltdb_all_joined$p10imm70

# change in percentage naturalized foreign born
ltdb_all_joined$pnat_delta_00_0a <- ltdb_all_joined$pnat0a - ltdb_all_joined$pnat00
ltdb_all_joined$pnat_delta_90_00 <- ltdb_all_joined$pnat00 - ltdb_all_joined$pnat90
ltdb_all_joined$pnat_delta_80_90 <- ltdb_all_joined$pnat90 - ltdb_all_joined$pnat80
ltdb_all_joined$pnat_delta_70_80 <- ltdb_all_joined$pnat80 - ltdb_all_joined$pnat70

ltdb_all_joined$pnat_delta_0a_0b <- ltdb_all_joined$pnat0b - ltdb_all_joined$pnat0a
ltdb_all_joined$pnat_delta_0b_0c <- ltdb_all_joined$pnat0c - ltdb_all_joined$pnat0b

# change in percentage other language at home
ltdb_all_joined$polang_delta_00_0a <- ltdb_all_joined$polang0a - ltdb_all_joined$polang00
ltdb_all_joined$polang_delta_90_00 <- ltdb_all_joined$polang00 - ltdb_all_joined$polang90
ltdb_all_joined$polang_delta_80_90 <- ltdb_all_joined$polang90 - ltdb_all_joined$polang80

ltdb_all_joined$polang_delta_0a_0b <- ltdb_all_joined$polang0b - ltdb_all_joined$polang0a
ltdb_all_joined$polang_delta_0b_0c <- ltdb_all_joined$polang0c - ltdb_all_joined$polang0b

# change in percentage poor english speakers
ltdb_all_joined$plep_delta_00_0a <- ltdb_all_joined$plep0a - ltdb_all_joined$plep00
ltdb_all_joined$plep_delta_90_00 <- ltdb_all_joined$plep00 - ltdb_all_joined$plep90
ltdb_all_joined$plep_delta_80_90 <- ltdb_all_joined$plep90 - ltdb_all_joined$plep80

# change in percentage russian/ussr born
ltdb_all_joined$prufb_delta_00_0a <- ltdb_all_joined$prufb0a - ltdb_all_joined$prufb00
ltdb_all_joined$prufb_delta_90_00 <- ltdb_all_joined$prufb00 - ltdb_all_joined$prufb90
ltdb_all_joined$prufb_delta_80_90 <- ltdb_all_joined$prufb90 - ltdb_all_joined$prufb80
ltdb_all_joined$prufb_delta_70_80 <- ltdb_all_joined$prufb80 - ltdb_all_joined$prufb70

# change in percentage italy born
ltdb_all_joined$pitfb_delta_00_0a <- ltdb_all_joined$pitfb0a - ltdb_all_joined$pitfb00
ltdb_all_joined$pitfb_delta_90_00 <- ltdb_all_joined$pitfb00 - ltdb_all_joined$pitfb90
ltdb_all_joined$pitfb_delta_80_90 <- ltdb_all_joined$pitfb90 - ltdb_all_joined$pitfb80
ltdb_all_joined$pitfb_delta_70_80 <- ltdb_all_joined$pitfb80 - ltdb_all_joined$pitfb70

# change in percentage germany born
ltdb_all_joined$pgefb_delta_00_0a <- ltdb_all_joined$pgefb0a - ltdb_all_joined$pgefb00
ltdb_all_joined$pgefb_delta_90_00 <- ltdb_all_joined$pgefb00 - ltdb_all_joined$pgefb90
ltdb_all_joined$pgefb_delta_80_90 <- ltdb_all_joined$pgefb90 - ltdb_all_joined$pgefb80
ltdb_all_joined$pgefb_delta_70_80 <- ltdb_all_joined$pgefb80 - ltdb_all_joined$pgefb70

# change in percentage ireland born
ltdb_all_joined$pirfb_delta_00_0a <- ltdb_all_joined$pirfb0a - ltdb_all_joined$pirfb00
ltdb_all_joined$pirfb_delta_90_00 <- ltdb_all_joined$pirfb00 - ltdb_all_joined$pirfb90
ltdb_all_joined$pirfb_delta_80_90 <- ltdb_all_joined$pirfb90 - ltdb_all_joined$pirfb80
ltdb_all_joined$pirfb_delta_70_80 <- ltdb_all_joined$pirfb80 - ltdb_all_joined$pirfb70

# change in percentage scandinavia born
ltdb_all_joined$pscfb_delta_00_0a <- ltdb_all_joined$pscfb0a - ltdb_all_joined$pscfb00
ltdb_all_joined$pscfb_delta_90_00 <- ltdb_all_joined$pscfb00 - ltdb_all_joined$pscfb90
ltdb_all_joined$pscfb_delta_80_90 <- ltdb_all_joined$pscfb90 - ltdb_all_joined$pscfb80
ltdb_all_joined$pscfb_delta_70_80 <- ltdb_all_joined$pscfb80 - ltdb_all_joined$pscfb70

# change in percentage high school degree or less
ltdb_all_joined$phs_delta_00_0a <- ltdb_all_joined$phs0a - ltdb_all_joined$phs00
ltdb_all_joined$phs_delta_90_00 <- ltdb_all_joined$phs00 - ltdb_all_joined$phs90
ltdb_all_joined$phs_delta_80_90 <- ltdb_all_joined$phs90 - ltdb_all_joined$phs80
ltdb_all_joined$phs_delta_70_80 <- ltdb_all_joined$phs80 - ltdb_all_joined$phs70

# change in percentage unemployed
ltdb_all_joined$punemp_delta_00_0a <- ltdb_all_joined$punemp0a - ltdb_all_joined$punemp00
ltdb_all_joined$punemp_delta_90_00 <- ltdb_all_joined$punemp00 - ltdb_all_joined$punemp90
ltdb_all_joined$punemp_delta_80_90 <- ltdb_all_joined$punemp90 - ltdb_all_joined$punemp80
ltdb_all_joined$punemp_delta_70_80 <- ltdb_all_joined$punemp80 - ltdb_all_joined$punemp70

# change in percentage females in labor force
ltdb_all_joined$pflabf_delta_00_0a <- ltdb_all_joined$pflabf0a - ltdb_all_joined$pflabf00
ltdb_all_joined$pflabf_delta_90_00 <- ltdb_all_joined$pflabf00 - ltdb_all_joined$pflabf90
ltdb_all_joined$pflabf_delta_80_90 <- ltdb_all_joined$pflabf90 - ltdb_all_joined$pflabf80
ltdb_all_joined$pflabf_delta_70_80 <- ltdb_all_joined$pflabf80 - ltdb_all_joined$pflabf70

# change in percentage professional employees
ltdb_all_joined$pprof_delta_00_0a <- ltdb_all_joined$pprof0a - ltdb_all_joined$pprof00
ltdb_all_joined$pprof_delta_90_00 <- ltdb_all_joined$pprof00 - ltdb_all_joined$pprof90
ltdb_all_joined$pprof_delta_80_90 <- ltdb_all_joined$pprof90 - ltdb_all_joined$pprof80
ltdb_all_joined$pprof_delta_70_80 <- ltdb_all_joined$pprof80 - ltdb_all_joined$pprof70

# change in percentage professional employees
ltdb_all_joined$pmanuf_delta_00_0a <- ltdb_all_joined$pmanuf0a - ltdb_all_joined$pmanuf00
ltdb_all_joined$pmanuf_delta_90_00 <- ltdb_all_joined$pmanuf00 - ltdb_all_joined$pmanuf90
ltdb_all_joined$pmanuf_delta_80_90 <- ltdb_all_joined$pmanuf90 - ltdb_all_joined$pmanuf80
ltdb_all_joined$pmanuf_delta_70_80 <- ltdb_all_joined$pmanuf80 - ltdb_all_joined$pmanuf70

# change in percentage self-employed
ltdb_all_joined$psemp_delta_00_0a <- ltdb_all_joined$psemp0a - ltdb_all_joined$psemp00
ltdb_all_joined$psemp_delta_90_00 <- ltdb_all_joined$psemp00 - ltdb_all_joined$psemp90
ltdb_all_joined$psemp_delta_80_90 <- ltdb_all_joined$psemp90 - ltdb_all_joined$psemp80
ltdb_all_joined$psemp_delta_70_80 <- ltdb_all_joined$psemp80 - ltdb_all_joined$psemp70

# change in percentage veterans
ltdb_all_joined$pvet_delta_00_0a <- ltdb_all_joined$pvet0a - ltdb_all_joined$pvet00
ltdb_all_joined$pvet_delta_90_00 <- ltdb_all_joined$pvet00 - ltdb_all_joined$pvet90
ltdb_all_joined$pvet_delta_80_90 <- ltdb_all_joined$pvet90 - ltdb_all_joined$pvet80
ltdb_all_joined$pvet_delta_70_80 <- ltdb_all_joined$pvet80 - ltdb_all_joined$pvet70

# change in percentage poor
ltdb_all_joined$ppov_delta_00_0a <- ltdb_all_joined$ppov0a - ltdb_all_joined$ppov00
ltdb_all_joined$ppov_delta_90_00 <- ltdb_all_joined$ppov00 - ltdb_all_joined$ppov90
ltdb_all_joined$ppov_delta_80_90 <- ltdb_all_joined$ppov90 - ltdb_all_joined$ppov80
ltdb_all_joined$ppov_delta_70_80 <- ltdb_all_joined$ppov80 - ltdb_all_joined$ppov70

ltdb_all_joined$ppov_delta_0a_0b <- ltdb_all_joined$ppov0b - ltdb_all_joined$ppov0a
ltdb_all_joined$ppov_delta_0b_0c <- ltdb_all_joined$ppov0c - ltdb_all_joined$ppov0b

# change in percentage of 65+ poor
ltdb_all_joined$p65pov_delta_00_0a <- ltdb_all_joined$p65pov0a - ltdb_all_joined$p65pov00
ltdb_all_joined$p65pov_delta_90_00 <- ltdb_all_joined$p65pov00 - ltdb_all_joined$p65pov90
ltdb_all_joined$p65pov_delta_80_90 <- ltdb_all_joined$p65pov90 - ltdb_all_joined$p65pov80
ltdb_all_joined$p65pov_delta_70_80 <- ltdb_all_joined$p65pov80 - ltdb_all_joined$p65pov70

# change in percentage of families with children in poverty
ltdb_all_joined$pfmpov_delta_00_0a <- ltdb_all_joined$pfmpov0a - ltdb_all_joined$pfmpov00
ltdb_all_joined$pfmpov_delta_90_00 <- ltdb_all_joined$pfmpov00 - ltdb_all_joined$pfmpov90
ltdb_all_joined$pfmpov_delta_80_90 <- ltdb_all_joined$pfmpov90 - ltdb_all_joined$pfmpov80
ltdb_all_joined$pfmpov_delta_70_80 <- ltdb_all_joined$pfmpov80 - ltdb_all_joined$pfmpov70

# change in percentage of whites in poverty
ltdb_all_joined$pwpov_delta_00_0a <- ltdb_all_joined$pwpov0a - ltdb_all_joined$pwpov00
ltdb_all_joined$pwpov_delta_90_00 <- ltdb_all_joined$pwpov00 - ltdb_all_joined$pwpov90
ltdb_all_joined$pwpov_delta_80_90 <- ltdb_all_joined$pwpov90 - ltdb_all_joined$pwpov80
ltdb_all_joined$pwpov_delta_70_80 <- ltdb_all_joined$pwpov80 - ltdb_all_joined$pwpov70

# change in percentage of blacks in poverty
ltdb_all_joined$pbpov_delta_00_0a <- ltdb_all_joined$pbpov0a - ltdb_all_joined$pbpov00
ltdb_all_joined$pbpov_delta_90_00 <- ltdb_all_joined$pbpov00 - ltdb_all_joined$pbpov90
ltdb_all_joined$pbpov_delta_80_90 <- ltdb_all_joined$pbpov90 - ltdb_all_joined$pbpov80
ltdb_all_joined$pbpov_delta_70_80 <- ltdb_all_joined$pbpov80 - ltdb_all_joined$pbpov70

# change in percentage of hispanics in poverty
ltdb_all_joined$phpov_delta_00_0a <- ltdb_all_joined$phpov0a - ltdb_all_joined$phpov00
ltdb_all_joined$phpov_delta_90_00 <- ltdb_all_joined$phpov00 - ltdb_all_joined$phpov90
ltdb_all_joined$phpov_delta_80_90 <- ltdb_all_joined$phpov90 - ltdb_all_joined$phpov80

# change in percentage of native americans in poverty
ltdb_all_joined$pnapov_delta_00_0a <- ltdb_all_joined$pnapov0a - ltdb_all_joined$pnapov00
ltdb_all_joined$pnapov_delta_90_00 <- ltdb_all_joined$pnapov00 - ltdb_all_joined$pnapov90
ltdb_all_joined$pnapov_delta_80_90 <- ltdb_all_joined$pnapov90 - ltdb_all_joined$pnapov80

# change in percentage of asians/pacific islanders in poverty
ltdb_all_joined$papov_delta_00_0a <- ltdb_all_joined$papov0a - ltdb_all_joined$papov00
ltdb_all_joined$papov_delta_90_00 <- ltdb_all_joined$papov00 - ltdb_all_joined$papov90
ltdb_all_joined$papov_delta_80_90 <- ltdb_all_joined$papov90 - ltdb_all_joined$papov80


# change in percentage of vacant housing units
ltdb_all_joined$pvac_delta_00_10 <- ltdb_all_joined$pvac10 - ltdb_all_joined$pvac00
ltdb_all_joined$pvac_delta_00_0a <- ltdb_all_joined$pvac0a - ltdb_all_joined$pvac00
ltdb_all_joined$pvac_delta_90_00 <- ltdb_all_joined$pvac00 - ltdb_all_joined$pvac90
ltdb_all_joined$pvac_delta_80_90 <- ltdb_all_joined$pvac90 - ltdb_all_joined$pvac80
ltdb_all_joined$pvac_delta_70_80 <- ltdb_all_joined$pvac80 - ltdb_all_joined$pvac70

ltdb_all_joined$pvac_delta_0a_0b <- ltdb_all_joined$pvac0b - ltdb_all_joined$pvac0a
ltdb_all_joined$pvac_delta_0b_0c <- ltdb_all_joined$pvac0c - ltdb_all_joined$pvac0b

# change in percentage of owner occupied housing units
ltdb_all_joined$pown_delta_00_10 <- ltdb_all_joined$pown10 - ltdb_all_joined$pown00
ltdb_all_joined$pown_delta_00_0a <- ltdb_all_joined$pown0a - ltdb_all_joined$pown00
ltdb_all_joined$pown_delta_90_00 <- ltdb_all_joined$pown00 - ltdb_all_joined$pown90
ltdb_all_joined$pown_delta_80_90 <- ltdb_all_joined$pown90 - ltdb_all_joined$pown80
ltdb_all_joined$pown_delta_70_80 <- ltdb_all_joined$pown80 - ltdb_all_joined$pown70

ltdb_all_joined$pown_delta_0a_0b <- ltdb_all_joined$pown0b - ltdb_all_joined$pown0a
ltdb_all_joined$pown_delta_0b_0c <- ltdb_all_joined$pown0c - ltdb_all_joined$pown0b

# change in percentage of housing units in multi-unit structures
ltdb_all_joined$pmulti_delta_00_0a <- ltdb_all_joined$pmulti0a - ltdb_all_joined$pmulti00
ltdb_all_joined$pmulti_delta_90_00 <- ltdb_all_joined$pmulti00 - ltdb_all_joined$pmulti90
ltdb_all_joined$pmulti_delta_80_90 <- ltdb_all_joined$pmulti90 - ltdb_all_joined$pmulti80
ltdb_all_joined$pmulti_delta_70_80 <- ltdb_all_joined$pmulti80 - ltdb_all_joined$pmulti70

ltdb_all_joined$pmulti_delta_0a_0b <- ltdb_all_joined$pmulti0b - ltdb_all_joined$pmulti0a
ltdb_all_joined$pmulti_delta_0b_0c <- ltdb_all_joined$pmulti0c - ltdb_all_joined$pmulti0b

# change in percentage of structures built more than 30 years ago
ltdb_all_joined$p30old_delta_00_0a <- ltdb_all_joined$p30old0a - ltdb_all_joined$p30old00
ltdb_all_joined$p30old_delta_90_00 <- ltdb_all_joined$p30old00 - ltdb_all_joined$p30old90
ltdb_all_joined$p30old_delta_80_90 <- ltdb_all_joined$p30old90 - ltdb_all_joined$p30old80
ltdb_all_joined$p30old_delta_70_80 <- ltdb_all_joined$p30old80 - ltdb_all_joined$p30old70

# change in percentage of household heads moved into unit less than 10 years ago
ltdb_all_joined$p10yrs_delta_00_0a <- ltdb_all_joined$p10yrs0a - ltdb_all_joined$p10yrs00
ltdb_all_joined$p10yrs_delta_90_00 <- ltdb_all_joined$p10yrs00 - ltdb_all_joined$p10yrs90
ltdb_all_joined$p10yrs_delta_80_90 <- ltdb_all_joined$p10yrs90 - ltdb_all_joined$p10yrs80
ltdb_all_joined$p10yrs_delta_70_80 <- ltdb_all_joined$p10yrs80 - ltdb_all_joined$p10yrs70

# change in percentage of persons aged 17 years and under
ltdb_all_joined$p18und_delta_00_10 <- ltdb_all_joined$p18und10 - ltdb_all_joined$p18und00
ltdb_all_joined$p18und_delta_00_0a <- ltdb_all_joined$p18und0a - ltdb_all_joined$p18und00
ltdb_all_joined$p18und_delta_90_00 <- ltdb_all_joined$p18und00 - ltdb_all_joined$p18und90
ltdb_all_joined$p18und_delta_80_90 <- ltdb_all_joined$p18und90 - ltdb_all_joined$p18und80
ltdb_all_joined$p18und_delta_70_80 <- ltdb_all_joined$p18und80 - ltdb_all_joined$p18und70

# change in percentage of persons aged 60+
ltdb_all_joined$p60up_delta_00_10 <- ltdb_all_joined$p60up10 - ltdb_all_joined$p60up00
ltdb_all_joined$p60up_delta_00_0a <- ltdb_all_joined$p60up0a - ltdb_all_joined$p60up00
ltdb_all_joined$p60up_delta_90_00 <- ltdb_all_joined$p60up00 - ltdb_all_joined$p60up90
ltdb_all_joined$p60up_delta_80_90 <- ltdb_all_joined$p60up90 - ltdb_all_joined$p60up80
ltdb_all_joined$p60up_delta_70_80 <- ltdb_all_joined$p60up80 - ltdb_all_joined$p60up70

# change in percentage of persons aged 75+
ltdb_all_joined$p75up_delta_00_10 <- ltdb_all_joined$p75up10 - ltdb_all_joined$p75up00
ltdb_all_joined$p75up_delta_00_0a <- ltdb_all_joined$p75up0a - ltdb_all_joined$p75up00
ltdb_all_joined$p75up_delta_90_00 <- ltdb_all_joined$p75up00 - ltdb_all_joined$p75up90
ltdb_all_joined$p75up_delta_80_90 <- ltdb_all_joined$p75up90 - ltdb_all_joined$p75up80
ltdb_all_joined$p75up_delta_70_80 <- ltdb_all_joined$p75up80 - ltdb_all_joined$p75up70

# change in percentage of household heads moved into unit less than 10 years ago
ltdb_all_joined$p10yrs_delta_00_0a <- ltdb_all_joined$p10yrs0a - ltdb_all_joined$p10yrs00
ltdb_all_joined$p10yrs_delta_90_00 <- ltdb_all_joined$p10yrs00 - ltdb_all_joined$p10yrs90
ltdb_all_joined$p10yrs_delta_80_90 <- ltdb_all_joined$p10yrs90 - ltdb_all_joined$p10yrs80
ltdb_all_joined$p10yrs_delta_70_80 <- ltdb_all_joined$p10yrs80 - ltdb_all_joined$p10yrs70

# change in percentage of married persons
ltdb_all_joined$pmar_delta_00_0a <- ltdb_all_joined$pmar0a - ltdb_all_joined$pmar00
ltdb_all_joined$pmar_delta_90_00 <- ltdb_all_joined$pmar00 - ltdb_all_joined$pmar90
ltdb_all_joined$pmar_delta_80_90 <- ltdb_all_joined$pmar90 - ltdb_all_joined$pmar80
ltdb_all_joined$pmar_delta_70_80 <- ltdb_all_joined$pmar80 - ltdb_all_joined$pmar70

# change in percentage of widowed, divorced, separated
ltdb_all_joined$pwds_delta_00_0a <- ltdb_all_joined$pwds0a - ltdb_all_joined$pwds00
ltdb_all_joined$pwds_delta_90_00 <- ltdb_all_joined$pwds00 - ltdb_all_joined$pwds90
ltdb_all_joined$pwds_delta_80_90 <- ltdb_all_joined$pwds90 - ltdb_all_joined$pwds80
ltdb_all_joined$pwds_delta_70_80 <- ltdb_all_joined$pwds80 - ltdb_all_joined$pwds70

# change in percentage of female-headed families with children
ltdb_all_joined$pfhh_delta_00_0a <- ltdb_all_joined$pfhh0a - ltdb_all_joined$pfhh00
ltdb_all_joined$pfhh_delta_90_00 <- ltdb_all_joined$pfhh00 - ltdb_all_joined$pfhh90
ltdb_all_joined$pfhh_delta_80_90 <- ltdb_all_joined$pfhh90 - ltdb_all_joined$pfhh80
ltdb_all_joined$pfhh_delta_70_80 <- ltdb_all_joined$pfhh80 - ltdb_all_joined$pfhh70

# change in overall population
ltdb_all_joined$pop_delta_00_10 <- ltdb_all_joined$pop10 - ltdb_all_joined$pop00
ltdb_all_joined$pop_delta_00_0a <- ltdb_all_joined$pop0a - ltdb_all_joined$pop00
ltdb_all_joined$pop_delta_90_00 <- ltdb_all_joined$pop00 - ltdb_all_joined$pop90
ltdb_all_joined$pop_delta_80_90 <- ltdb_all_joined$pop90 - ltdb_all_joined$pop80
ltdb_all_joined$pop_delta_70_80 <- ltdb_all_joined$pop80 - ltdb_all_joined$pop70

# change in number of families
ltdb_all_joined$family_delta_00_10 <- ltdb_all_joined$family10 - ltdb_all_joined$family00
ltdb_all_joined$family_delta_00_0a <- ltdb_all_joined$family0a - ltdb_all_joined$family00
ltdb_all_joined$family_delta_90_00 <- ltdb_all_joined$family00 - ltdb_all_joined$family90
ltdb_all_joined$family_delta_80_90 <- ltdb_all_joined$family90 - ltdb_all_joined$family80
ltdb_all_joined$family_delta_70_80 <- ltdb_all_joined$family80 - ltdb_all_joined$family70

# change in median household income - asians / pacific islanders (controlling for inflation)
ltdb_all_joined$hinca_delta_00_0a <- 1.01*ltdb_all_joined$hinca0a - 1.27*ltdb_all_joined$hinca00
ltdb_all_joined$hinca_delta_90_00 <- 1.27*ltdb_all_joined$hinca00 - 1.67*ltdb_all_joined$hinca90
ltdb_all_joined$hinca_delta_80_90 <- 1.67*ltdb_all_joined$hinca90 - 2.65*ltdb_all_joined$hinca80

# change in median household income - blacks (controlling for inflation)
ltdb_all_joined$hincb_delta_00_0a <- 1.01*ltdb_all_joined$hincb0a - 1.27*ltdb_all_joined$hincb00
ltdb_all_joined$hincb_delta_90_00 <- 1.27*ltdb_all_joined$hincb00 - 1.67*ltdb_all_joined$hincb90
ltdb_all_joined$hincb_delta_80_90 <- 1.67*ltdb_all_joined$hincb90 - 2.65*ltdb_all_joined$hincb80

# change in median household income - hispanics (controlling for inflation)
ltdb_all_joined$hinch_delta_00_0a <- 1.01*ltdb_all_joined$hinch0a - 1.27*ltdb_all_joined$hinch00
ltdb_all_joined$hinch_delta_90_00 <- 1.27*ltdb_all_joined$hinch00 - 1.67*ltdb_all_joined$hinch90
ltdb_all_joined$hinch_delta_80_90 <- 1.67*ltdb_all_joined$hinch90 - 2.65*ltdb_all_joined$hinch80

# change in median household income - whites (controlling for inflation)
ltdb_all_joined$hincw_delta_00_0a <- 1.01*ltdb_all_joined$hincw0a - 1.27*ltdb_all_joined$hincw00
ltdb_all_joined$hincw_delta_90_00 <- 1.27*ltdb_all_joined$hincw00 - 1.67*ltdb_all_joined$hincw90
ltdb_all_joined$hincw_delta_80_90 <- 1.67*ltdb_all_joined$hincw90 - 2.65*ltdb_all_joined$hincw80

# change in number of housing units
ltdb_all_joined$hu_delta_00_10 <- ltdb_all_joined$hu10 - ltdb_all_joined$hu00
ltdb_all_joined$hu_delta_00_0a <- ltdb_all_joined$hu0a - ltdb_all_joined$hu00
ltdb_all_joined$hu_delta_90_00 <- ltdb_all_joined$hu00 - ltdb_all_joined$hu90
ltdb_all_joined$hu_delta_80_90 <- ltdb_all_joined$hu90 - ltdb_all_joined$hu80
ltdb_all_joined$hu_delta_70_80 <- ltdb_all_joined$hu80 - ltdb_all_joined$hu70

# change in per capita income
ltdb_all_joined$incpc_delta_00_0a <- 1.01*ltdb_all_joined$incpc0a - 1.27*ltdb_all_joined$incpc00
ltdb_all_joined$incpc_delta_90_00 <- 1.27*ltdb_all_joined$incpc00 - 1.67*ltdb_all_joined$incpc90
ltdb_all_joined$incpc_delta_80_90 <- 1.67*ltdb_all_joined$incpc90 - 2.65*ltdb_all_joined$incpc80
ltdb_all_joined$incpc_delta_70_80 <- 2.65*ltdb_all_joined$incpc80 - 5.62*ltdb_all_joined$incpc70

# change in median monthly contract rent
ltdb_all_joined$mrent_delta_00_0a <- 1.01*ltdb_all_joined$mrent0a - 1.27*ltdb_all_joined$mrent00
ltdb_all_joined$mrent_delta_90_00 <- 1.27*ltdb_all_joined$mrent00 - 1.67*ltdb_all_joined$mrent90
ltdb_all_joined$mrent_delta_80_90 <- 1.67*ltdb_all_joined$mrent90 - 2.65*ltdb_all_joined$mrent80
ltdb_all_joined$mrent_delta_70_80 <- 2.65*ltdb_all_joined$mrent80 - 5.62*ltdb_all_joined$mrent70

write.csv(ltdb_all_joined, "ltdb_all_joined.csv")



# Reduced data set with only relevant variables
reduced <- c('trtid10',
             'state',
             'county',
             
             'hinc_delta_00_0a',
             'hinc_delta_90_00',
             'hinc_delta_80_90',
             'hinc_delta_70_80',
             'hinc_delta_0a_0b',
             'hinc_delta_0b_0c',

             'mhmval_delta_70_80',
             'mhmval_delta_80_90',
             'mhmval_delta_90_00',
             'mhmval_delta_00_0a',
             'mhmval_delta_0a_0b',
             'mhmval_delta_0b_0c',
             
             'pcol_delta_70_80',
             'pcol_delta_80_90',
             'pcol_delta_90_00',
             'pcol_delta_00_0a',
             'pcol_delta_0a_0b',
             'pcol_delta_0b_0c',
             
             'hinc70',
             'hinc80',
             'hinc90',
             'hinc00',
             'hinc0a',
             'hinc0b',
             'hinc0c',
             
             'mhmval70',
             'mhmval80',
             'mhmval90',
             'mhmval00',
             'mhmval0a',
             'mhmval0b',
             'mhmval0c',
             
             'pcol70',
             'pcol80',
             'pcol90',
             'pcol00',
             'pcol0a',
             'pcol0b',
             'pcol0c',
             
             'pop70',
             'pop80',
             'pop90',
             'pop00',
             'pop10',
             'pop0a',
             'pop0b',
             'pop0c')

ltdb_all_joined_reduced_wide <- ltdb_all_joined[reduced]
write.csv(ltdb_all_joined_reduced_wide, "ltdb_all_joined_reduced_wide.csv")


# Removing excess dataset and values
rm(ltdb_all_joined)
rm(reduced)



# Creating "pre" and "post" values for each timeperiod in order to create a long dataset including all time frames

# 1980 dataset
ltdb_all_joined_reduced_1980 <- data.frame(matrix(nrow = 74073, ncol = 1))
ltdb_all_joined_reduced_1980$matrix.nrow...74073..ncol...1. <- NULL

ltdb_all_joined_reduced_1980$year <- 1980
ltdb_all_joined_reduced_1980$trtid10 <- ltdb_all_joined_reduced_wide$trtid10
ltdb_all_joined_reduced_1980$state <- ltdb_all_joined_reduced_wide$state
ltdb_all_joined_reduced_1980$county <- ltdb_all_joined_reduced_wide$county
ltdb_all_joined_reduced_1980$hinc_delta <- ltdb_all_joined_reduced_wide$hinc_delta_70_80
ltdb_all_joined_reduced_1980$pcol_delta <- ltdb_all_joined_reduced_wide$pcol_delta_70_80
ltdb_all_joined_reduced_1980$mhmval_delta <- ltdb_all_joined_reduced_wide$mhmval_delta_70_80
ltdb_all_joined_reduced_1980$hinc_post <- ltdb_all_joined_reduced_wide$hinc80
ltdb_all_joined_reduced_1980$hinc_pre <- ltdb_all_joined_reduced_wide$hinc70
ltdb_all_joined_reduced_1980$mhmval_post <- ltdb_all_joined_reduced_wide$mhmval80
ltdb_all_joined_reduced_1980$mhmval_pre <- ltdb_all_joined_reduced_wide$mhmval70
ltdb_all_joined_reduced_1980$pcol_post <- ltdb_all_joined_reduced_wide$pcol80
ltdb_all_joined_reduced_1980$pcol_pre <- ltdb_all_joined_reduced_wide$pcol70
ltdb_all_joined_reduced_1980$pop_post <- ltdb_all_joined_reduced_wide$pop80
ltdb_all_joined_reduced_1980$pop_pre <- ltdb_all_joined_reduced_wide$pop70


# 1990 dataset
ltdb_all_joined_reduced_1990 <- data.frame(matrix(nrow = 74073, ncol = 1))
ltdb_all_joined_reduced_1990$matrix.nrow...74073..ncol...1. <- NULL

ltdb_all_joined_reduced_1990$year <- 1990
ltdb_all_joined_reduced_1990$trtid10 <- ltdb_all_joined_reduced_wide$trtid10
ltdb_all_joined_reduced_1990$state <- ltdb_all_joined_reduced_wide$state
ltdb_all_joined_reduced_1990$county <- ltdb_all_joined_reduced_wide$county
ltdb_all_joined_reduced_1990$tract <- ltdb_all_joined_reduced_wide$tract
ltdb_all_joined_reduced_1990$hinc_delta <- ltdb_all_joined_reduced_wide$hinc_delta_80_90
ltdb_all_joined_reduced_1990$pcol_delta <- ltdb_all_joined_reduced_wide$pcol_delta_80_90
ltdb_all_joined_reduced_1990$mhmval_delta <- ltdb_all_joined_reduced_wide$mhmval_delta_80_90
ltdb_all_joined_reduced_1990$hinc_post <- ltdb_all_joined_reduced_wide$hinc90
ltdb_all_joined_reduced_1990$hinc_pre <- ltdb_all_joined_reduced_wide$hinc80
ltdb_all_joined_reduced_1990$mhmval_post <- ltdb_all_joined_reduced_wide$mhmval90
ltdb_all_joined_reduced_1990$mhmval_pre <- ltdb_all_joined_reduced_wide$mhmval80
ltdb_all_joined_reduced_1990$pcol_post <- ltdb_all_joined_reduced_wide$pcol90
ltdb_all_joined_reduced_1990$pcol_pre <- ltdb_all_joined_reduced_wide$pcol80
ltdb_all_joined_reduced_1990$pop_post <- ltdb_all_joined_reduced_wide$pop90
ltdb_all_joined_reduced_1990$pop_pre <- ltdb_all_joined_reduced_wide$pop80


# 2000 dataset
ltdb_all_joined_reduced_2000 <- data.frame(matrix(nrow = 74073, ncol = 1))
ltdb_all_joined_reduced_2000$matrix.nrow...74073..ncol...1. <- NULL

ltdb_all_joined_reduced_2000$year <- 2000
ltdb_all_joined_reduced_2000$trtid10 <- ltdb_all_joined_reduced_wide$trtid10
ltdb_all_joined_reduced_2000$state <- ltdb_all_joined_reduced_wide$state
ltdb_all_joined_reduced_2000$county <- ltdb_all_joined_reduced_wide$county
ltdb_all_joined_reduced_2000$hinc_delta <- ltdb_all_joined_reduced_wide$hinc_delta_90_00
ltdb_all_joined_reduced_2000$pcol_delta <- ltdb_all_joined_reduced_wide$pcol_delta_90_00
ltdb_all_joined_reduced_2000$mhmval_delta <- ltdb_all_joined_reduced_wide$mhmval_delta_90_00
ltdb_all_joined_reduced_2000$hinc_post <- ltdb_all_joined_reduced_wide$hinc00
ltdb_all_joined_reduced_2000$hinc_pre <- ltdb_all_joined_reduced_wide$hinc90
ltdb_all_joined_reduced_2000$mhmval_post <- ltdb_all_joined_reduced_wide$mhmval00
ltdb_all_joined_reduced_2000$mhmval_pre <- ltdb_all_joined_reduced_wide$mhmval90
ltdb_all_joined_reduced_2000$pcol_post <- ltdb_all_joined_reduced_wide$pcol00
ltdb_all_joined_reduced_2000$pcol_pre <- ltdb_all_joined_reduced_wide$pcol90
ltdb_all_joined_reduced_2000$pop_post <- ltdb_all_joined_reduced_wide$pop00
ltdb_all_joined_reduced_2000$pop_pre <- ltdb_all_joined_reduced_wide$pop90


# 2008 dataset
ltdb_all_joined_reduced_2008 <- data.frame(matrix(nrow = 74073, ncol = 1))
ltdb_all_joined_reduced_2008$matrix.nrow...74073..ncol...1. <- NULL

ltdb_all_joined_reduced_2008$year <- 2008
ltdb_all_joined_reduced_2008$trtid10 <- ltdb_all_joined_reduced_wide$trtid10
ltdb_all_joined_reduced_2008$state <- ltdb_all_joined_reduced_wide$state
ltdb_all_joined_reduced_2008$county <- ltdb_all_joined_reduced_wide$county
ltdb_all_joined_reduced_2008$hinc_delta <- ltdb_all_joined_reduced_wide$hinc_delta_00_0a
ltdb_all_joined_reduced_2008$pcol_delta <- ltdb_all_joined_reduced_wide$pcol_delta_00_0a
ltdb_all_joined_reduced_2008$mhmval_delta <- ltdb_all_joined_reduced_wide$mhmval_delta_00_0a
ltdb_all_joined_reduced_2008$hinc_post <- ltdb_all_joined_reduced_wide$hinc0a
ltdb_all_joined_reduced_2008$hinc_pre <- ltdb_all_joined_reduced_wide$hinc00
ltdb_all_joined_reduced_2008$mhmval_post <- ltdb_all_joined_reduced_wide$mhmval0a
ltdb_all_joined_reduced_2008$mhmval_pre <- ltdb_all_joined_reduced_wide$mhmval00
ltdb_all_joined_reduced_2008$pcol_post <- ltdb_all_joined_reduced_wide$pcol0a
ltdb_all_joined_reduced_2008$pcol_pre <- ltdb_all_joined_reduced_wide$pcol00
ltdb_all_joined_reduced_2008$pop_post <- ltdb_all_joined_reduced_wide$pop0a
ltdb_all_joined_reduced_2008$pop_pre <- ltdb_all_joined_reduced_wide$pop00


# 2010 dataset
ltdb_all_joined_reduced_2010 <- data.frame(matrix(nrow = 74073, ncol = 1))
ltdb_all_joined_reduced_2010$matrix.nrow...74073..ncol...1. <- NULL

ltdb_all_joined_reduced_2010$year <- 2010
ltdb_all_joined_reduced_2010$trtid10 <- ltdb_all_joined_reduced_wide$trtid10
ltdb_all_joined_reduced_2010$state <- ltdb_all_joined_reduced_wide$state
ltdb_all_joined_reduced_2010$county <- ltdb_all_joined_reduced_wide$county
ltdb_all_joined_reduced_2010$hinc_delta <- ltdb_all_joined_reduced_wide$hinc_delta_0a_0b
ltdb_all_joined_reduced_2010$pcol_delta <- ltdb_all_joined_reduced_wide$pcol_delta_0a_0b
ltdb_all_joined_reduced_2010$mhmval_delta <- ltdb_all_joined_reduced_wide$mhmval_delta_0a_0b
ltdb_all_joined_reduced_2010$hinc_post <- ltdb_all_joined_reduced_wide$hinc0b
ltdb_all_joined_reduced_2010$hinc_pre <- ltdb_all_joined_reduced_wide$hinc0a
ltdb_all_joined_reduced_2010$mhmval_post <- ltdb_all_joined_reduced_wide$mhmval0b
ltdb_all_joined_reduced_2010$mhmval_pre <- ltdb_all_joined_reduced_wide$mhmval0a
ltdb_all_joined_reduced_2010$pcol_post <- ltdb_all_joined_reduced_wide$pcol0b
ltdb_all_joined_reduced_2010$pcol_pre <- ltdb_all_joined_reduced_wide$pcol0a
ltdb_all_joined_reduced_2010$pop_post <- ltdb_all_joined_reduced_wide$pop0b
ltdb_all_joined_reduced_2010$pop_pre <- ltdb_all_joined_reduced_wide$pop0a


# 2011 dataset
ltdb_all_joined_reduced_2011 <- data.frame(matrix(nrow = 74073, ncol = 1))
ltdb_all_joined_reduced_2011$matrix.nrow...74073..ncol...1. <- NULL

ltdb_all_joined_reduced_2011$year <- 2011
ltdb_all_joined_reduced_2011$trtid10 <- ltdb_all_joined_reduced_wide$trtid10
ltdb_all_joined_reduced_2011$state <- ltdb_all_joined_reduced_wide$state
ltdb_all_joined_reduced_2011$county <- ltdb_all_joined_reduced_wide$county
ltdb_all_joined_reduced_2011$hinc_delta <- ltdb_all_joined_reduced_wide$hinc_delta_0b_0c
ltdb_all_joined_reduced_2011$pcol_delta <- ltdb_all_joined_reduced_wide$pcol_delta_0b_0c
ltdb_all_joined_reduced_2011$mhmval_delta <- ltdb_all_joined_reduced_wide$mhmval_delta_0b_0c
ltdb_all_joined_reduced_2011$hinc_post <- ltdb_all_joined_reduced_wide$hinc0c
ltdb_all_joined_reduced_2011$hinc_pre <- ltdb_all_joined_reduced_wide$hinc0b
ltdb_all_joined_reduced_2011$mhmval_post <- ltdb_all_joined_reduced_wide$mhmval0c
ltdb_all_joined_reduced_2011$mhmval_pre <- ltdb_all_joined_reduced_wide$mhmval0b
ltdb_all_joined_reduced_2011$pcol_post <- ltdb_all_joined_reduced_wide$pcol0c
ltdb_all_joined_reduced_2011$pcol_pre <- ltdb_all_joined_reduced_wide$pcol0b
ltdb_all_joined_reduced_2011$pop_post <- ltdb_all_joined_reduced_wide$pop0c
ltdb_all_joined_reduced_2011$pop_pre <- ltdb_all_joined_reduced_wide$pop0b


# Combining the datasets
ltdb_all_joined_reduced_long <- rbind(ltdb_all_joined_reduced_1980, 
                                      ltdb_all_joined_reduced_1990, 
                                      ltdb_all_joined_reduced_2000, 
                                      ltdb_all_joined_reduced_2008,
                                      ltdb_all_joined_reduced_2010,
                                      ltdb_all_joined_reduced_2011)

# Removing excess data sets
rm(ltdb_all_joined_reduced_1980,
   ltdb_all_joined_reduced_1990,
   ltdb_all_joined_reduced_2000,
   ltdb_all_joined_reduced_2008,
   ltdb_all_joined_reduced_2010,
   ltdb_all_joined_reduced_2011)


# creating "row_names" column for later joining
ltdb_all_joined_reduced_long$row_name <- rownames(ltdb_all_joined_reduced_long)


write.csv(ltdb_all_joined_reduced_long, "ltdb_all_joined_reduced_long.csv")