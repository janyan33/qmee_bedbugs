# QMEE final project
## Our plan

Predictions:
1.	Females will be more social than males 
2.	Networks will have assortativity based on sex
3.	The among of harassment females receive will increase as a function of female sociality
4.  The effects described in predictions 1 and 2 will be stronger in the low sexual conflict treatment (12 shelters) compared to the high sexual conflict treatment (2 shelters) as more shelters should provide females more opportunity to use behavioural avoidance strategies 

## Data
The data is located in the **"data"** folder within this repository. The **bbsna_attributes** file contains all the key attributes (sex, size, etc.) and information (replicate, treatment etc.) about each individual bedbug from our experiments. The **bbsna_aggregations** file contains lists of group members in each aggregation along with when these aggregations were observed. This is used to create association matrices for each replicate using the asnipe R package. 

Within the data folder, there is another folder for interaction matrices named **"matrices"**. Each replicate has a corresponding mating and mounting matrix that was created manually by tallying interactions that occured between individuals in our raw observation file.* Lastly, we've also included a folder within "data" named **"raw"** for the raw observation spreadsheets so that collaborators can get a better sense of how data was collected and converted into matrices. 

*I'm (JY) hoping to write an Rscript that will automate the process of extracting interactions from the observation file to create the mating and mounting matrices but haven't found the spare time to do this yet
