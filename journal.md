**Data analysis journal**

**March 26:** For predictions 1 and 3, we considered a general linear model. But we now think a generalized linear model is more appropriate because of the list of fixed effects we need to account for. I (Tovah) is working on the script.

**March 30:** For prediction 2, we will use a permutation analysis. Janice created a new script for all the functions to keep the main script cleaner (e.g, igraph functions). She started the strength permutation in order to have the observed coef for the effect of strength ~ sex. Then randomizing the networks 1000 times to get 1000 new coefs for strength ~ sex under the null hypothesis, but the randomizing isn't working, so we will be figuring this out shortly

**April 1:** Figuring out the Prediction 1 GLM (females will be more social than males). Fixed effects are size and treatment/replicate, since there's currenly one replicate per treatment. No random effects. Family is Gamma because strength is a continuous positive outcome.

Also attempting to fix permutation function for prediction 1; I'm trying to use the permute() function from igraph to 
shuffle the nodes of the network while maintaining the edges. Once all the nodes are shuffled, I'd compute a new strength value for each of them 
and run the same glm and use these coefs to create a null distribution. 

**April 2**: Created a function that assigns vertex attributes to all the nodes for the observed networks and outputs this as a dataframe which can then be used for the linear model of the observed networks. Also created a function that performs creates igraph objects where node-labels have been randomized. Now trying to correctly assign the other node attributes to these shuffled networks.

Also trying GLM for prediction one, after first diagnostic plots we added replicate as a predictor, then we also added a quadratic size variable and our diagnostic plots look better.

Got the permutation for prediction 1 to work. The code runs the glm on 1000 simulated networks and compares the observed coef for sex to the simulated coefs. I used a combination of different functions documented in the functions.R file (there are probably simpler ways to get this working but it was a struggle). 
To do tomorrow (April 3rd): get the script to compute p-values, then check for errors in the permutation process, then begin working on the next predictions

**April 3rd**: Updated code for prediction 1 so that it would compute p-values. 

**April 4th**: Created a function that does the permutation test for assortativity scores. It seems to work but I get different numbers than when I used slightly different code before so at least one of them must be doing it wrong. I need to figure out where the problem is. Sidenote: it feels like the number of functions we're creating that each do a very specific thing is getting out of hand... haven't thought of a better way to do things though. 

Update: The prediction 2 permutation now gives me the same answers as when I coded this before so that's a good sign. I don't know what I changed but that's ok. The function now outputs the histogram, p-value, and observed assortativity score. 


