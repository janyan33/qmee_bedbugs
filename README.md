# QMEE final project

## Background
Bedbugs _(Cimex lectularius)_ are an ideal model for studying the social implications of sexual conflict because of their notably harmful mode of copulation – traumatic insemination. Repeated traumatic inseminations reduce female longevity and lifetime reproductive output due to the energetic costs of wound healing and increased likelihood of infection. As a result, we expect the high fitness costs associated with repeated traumatic matings to result in divergent social preferences between the sexes. To investigate the impact of sexual harassment (quantified by # of matings and mountings) on social structure, we devised a novel experimental arena that provides bedbug populations with high-quality shelters as well as an artificial “host” to facilitate natural foraging behaviour. By manipulating the number of shelters, we've created two treatments: **low sexual conflict** where populations get 12 shelters to move between and **high sexual confict** where populations are contrained to 2 shelters. This allows us to compare networks for when females have the opportunity to evade males vs. when opportunities for behavioural avoidance are limited. Using a combination of video-recordings and live observation, we are tracking sexual and social interactions between individually marked bedbugs over six consecutive  days at a time. With this data, we can use social network analysis to analyze and visualize bedbug social structure and assess various predictions about how the presence of intense sexual conflict influences animal sociality. So far, we've one run replicate for each of the two treatments and will run another one of each soon (March 25th - April 13th). 

## Predictions

### 1.	Females will be more social than males
To quantify sociability, we'll construct weighted undirected networks where each edge represents an association index calculated based on how often two bedbugs were seen in the same aggregation. Specifically, we use the Simple Ratio Index (SRI) method of inferring associations (CITATION). Aggregations are defined as a continous group of bedbugs where each individual is physically touching at least one other individual in the aggregation. Using these association networks, we can then calculate several centrality measure that quantify sociability. However, we decided a priori to use **strength** as our measure of sociability which quantifies the number of and weight of each individual's edges (or associations) because this seems biologically intuitive and reasonable. By calculating strength for each individual, we should be able to compare the sociability of males vs. females across replicates. 
Statistics: TBD

**JY's questions:** We'd use some kind of linear model right? A mixed model to control for things like replicate, bedbug size, and other potentially important things I'm not thinking of? Also, I think we may have a problem with non-independence seeing as individual strength relies on interactions with other individuals? How do we address this? 

### 2.	Networks will show preferential assortment between same-sex individuals; networks will have higher assortativity indexes (based on sex) than expected by chance. 
We can calculate phenotypic assortment based on sex using the "assortnet" R package which will give us a single value between -1 and 1 where positive numbers indicate assortment while negative values indicate disassortment and 0 represents no assortment (individuals interact with either sex at equal rates). After obtaining the observed assortativity index, we can construct a null model using node-label permutations (suggested by Croft et al., 2011 for when you are fairly confident in the edges of the network). By randomly shuffling the nodes, our null model will assume that any individual can occupy any network position. This seems fair seeing as there are no obvious spatial or individual contraints in my experimental setup meaning all bedbugs can move about rather freely. Creating the null distribution will allow us to calculate a p-value representing the liklihood of obtaining an assortativity index as extreme as our observed value if social associations were not sex-biased. 

Statistics: Permutations

### 3.	The amount of harassment females receive will increase as a function of female sociality 
Describe how this will be measured here
Statistics: TBD

### 4.  The effects described in predictions 1 and 2 will be stronger in the low sexual conflict treatment (12 shelters) compared to the high sexual conflict treatment (2 shelters) as more shelters should provide females more opportunity to use behavioural avoidance strategies
Describe how this will be measured here
Statistics: TBD, unsure if we will test this prediction

## Data

The data is located in the `data` folder within this repository. The `bbsna_attributes` file contains all the key attributes (sex, size, etc.) and information (replicate, treatment etc.) about each individual bedbug from our experiments. The `bbsna_aggregations` file contains lists of group members in each aggregation along with when these aggregations were observed. This is used to create association matrices for each replicate using the `asnipe` R package. 

Within the data folder, there is another folder for interaction matrices named `matrices`. Each replicate has a corresponding mating and mounting matrix that was created manually by tallying interactions that occured between individuals in our raw observation file.* Lastly, we've also included a folder within `data` named `raw` for the raw observation spreadsheets so that collaborators can get a better sense of how data was collected and converted into matrices.

We've added a "bbsna_raw_combined.csv" file into the data folder which compiles the raw data across all days for all replicates and intend to use this file to obtain the mounting and mating matrices using the data_cleaning.R script that we're currently working on. 

*I'm (JY) hoping to write an Rscript that will automate the process of extracting interactions from the observation file to create the mating and mounting matrices but haven't found the spare time to do this yet

JD: THis could be a good thing to do on Thursday I hope.

JY: Started doing this (data_cleaning.R); got some feedback from JD on Thursday for how to best finish this
