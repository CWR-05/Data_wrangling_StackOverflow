##########################################
# Stackoverflow question 17 October 2023 #
##########################################

#==========================================================================================================#
# How to convert dataframe from wide to long and fill new rows of non-ID and not-to-be-gathered            #
#                                          columns with NA                                                 #
#==========================================================================================================#

#load data
df<- read.csv("example_dataset_20231017.csv")

#separate ID columns and columns to gather into a core dataframe, and columns that are neither ID or to be gathered into a separate df
core<- df %>%
  dplyr::select(AnimalID, datein, dateout, area, species) %>% #select columns
  gather(date_t, date, datein:dateout, factor_key = TRUE) %>% #wide o long
  arrange(AnimalID) #re-order columns

sub<- df %>%
  arrange(AnimalID) %>% #re-arrange columns to match core df
  dplyr::select(event, season, group_y, group) %>% #select columns
  group_by(grp = (row_number() - 1)) %>%  #group by row number
  group_modify(~ add_row(.x, .before = 0)) %>%  #add row BEFORE each row of df
  ungroup() %>% 
  select(-grp) #remove the grp column

#bind the 2 df together
df.long<- cbind(core, sub)