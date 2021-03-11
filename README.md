# QMEE final project
## Our plan


## Data
The data is located in the **"data"** folder within this repository. The **bbsna_attributes** file contains all the key attributes (sex, size, etc.) and information (replicate, treatment etc.) about each individual bedbug from our experiments. The **bbsna_aggregations** file contains lists of group members in each aggregation along with when these aggregations were observed. This is used to create association matrices for each replicate using the asnipe R package. 

Within the data folder, there is another folder for interaction matrices named **"matrices"**. Each replicate has a corresponding mating and mounting matrix that was created manually by tallying interactions that occured between individuals in our raw observation file.* Lastly, we've also included a folder within "data" named **"raw"** for the raw observation spreadsheets so that collaborators can get a better sense of how data was collected and converted into matrices. 

*I'm (Janice) hoping to write an Rscript that will automate the process of extracting interactions from the observation file to create the mating and mounting matrices but haven't found the spare time to do this yet
