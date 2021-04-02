**Data analysis journal**

**March 26:** For predictions 1 and 3, we considered a general linear model. But we now think a generalized linear model is more appropriate because of the list of fixed effects we need to account for. I (Tovah) is working on the script.

**March 30:** For prediction 2, we will use a permutation analysis. Janice created a new script for all the functions to keep the main script cleaner (e.g, igraph functions). She started the strength permutation in order to have the observed coef for the effect of strength ~ sex. Then randomizing the networks 1000 times to get 1000 new coefs for strength ~ sex under the null hypothesis, but the randomizing isn't working, so we will be figuring this out shortly

**April 1: **Figuring out the Prediction 1 GLM (females will be more social than males). Fixed effects are size and treatment/replicate, since there's currenly one replicate per treatment. No random effects. Family is Gamma because strength is a continuous positive outcome.

**April 1:** Attempting to fix permutation function for prediction 1; I'm trying to use the permute() function from igraph to 
shuffle the nodes of the network while maintaining the edges. Once all the nodes are shuffled, I'd compute a new strength value for each of them 
and run the same glm and use these coefs to create a null distribution. 

Currently stuck with how to combine the lists of strengths back onto the original dataframe with the size data. Lists of lists make my head hurt. Signing off for now. 
