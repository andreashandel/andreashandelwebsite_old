# part 2 of code of ulam/rethinking tutorial (part 2)
# https://www.andreashandel.com/posts/longitudinal-multilevel-bayesian-analysis-2/
# this has the code part that explores the fits


## ---- packages2 --------
library('dplyr') # for data manipulation
library('ggplot2') # for plotting
library('cmdstanr') #for model fitting
library('rethinking') #for model fitting
library('fs') #for file path

## ---- loadfits --------
# loading list of previously saved fits.
# useful if we don't want to re-fit
# every time we want to explore the results.
# since the file is too large for GitHub
# it is stored in a local folder
# adjust accordingly for your setup
filepath = fs::path("D:","Dropbox","datafiles","longitudinalbayes","ulamfits", ext="Rds")
fl <- readRDS(filepath)


## ---- mod_1_3_exploration --------
# Model 1
a0mean = mean(precis(fl[[1]]$fit,depth=2,"a0")$mean)
b0mean = mean(precis(fl[[1]]$fit,depth=2,"b0")$mean)
print(precis(fl[[1]]$fit,depth=1),digits = 2)
print(c(a0mean,b0mean))

# Model 3
a0mean = mean(precis(fl[[3]]$fit,depth=2,"a0")$mean)
b0mean = mean(precis(fl[[3]]$fit,depth=2,"b0")$mean)
print(precis(fl[[3]]$fit,depth=1),digits = 2)
print(c(a0mean,b0mean))


## ---- mod_1_3_comparison --------
comp13 = compare(fl[[1]]$fit,fl[[3]]$fit)
print(comp13)


## ---- mod_2_2a_exploration -------
# Compare models 2 and 2a
# first we compute the mean across individuals for model 2
a0mean = mean(precis(fl[[2]]$fit,depth=2,"a0")$mean)
b0mean = mean(precis(fl[[2]]$fit,depth=2,"b0")$mean)

#rest of model 2
print(precis(fl[[2]]$fit,depth=1),digits = 2)
print(c(a0mean,b0mean))

#model 2a
print(precis(fl[[5]]$fit,depth=1),digits = 2)
compare(fl[[2]]$fit,fl[[5]]$fit)




## ---- mod_4_4a_exploration --------
# model 4
print(precis(fl[[4]]$fit,depth=1),digits = 2)
# model 4a
print(precis(fl[[6]]$fit,depth=1),digits = 2)


## ---- mod_4_4a_comparison --------
compare(fl[[3]]$fit,fl[[4]]$fit,fl[[6]]$fit)




## ---- computepredictions --------
# load the data we used for fitting
simdat <- readRDS("simdat.Rds")
#pull our the data set we used for fitting
#if you fit a different one of the simulated datasets, change accordingly
fitdat <- simdat$m3
#small data adjustment for plotting
plotdat <- fitdat %>% data.frame() %>% mutate(id = as.factor(id)) %>% mutate(dose = dose_cat)

#this will contain all the predictions from the different models
fitpred = vector(mode = "list", length = length(fl))

# we are looping over each fitted model
for (n in 1:length(fl))
{
  #get current model
  nowmodel = fl[[n]]$fit

  #make new data for which we want predictions
  #specifically, more time points so the curves are smoother
  timevec = seq(from = 0.1, to = max(fitdat$time), length=100)
  Ntot = max(fitdat$id)
  #data used for predictions
  preddat = data.frame( id = sort(rep(seq(1,Ntot),length(timevec))),
                        time = rep(timevec,Ntot),
                        dose_adj = 0
  )
  #add right dose information for each individual
  for (k in 1:Ntot)
  {
    #dose for a given individual
    nowdose = unique(fitdat$dose_adj[fitdat$id == k])
    nowdose_cat = unique(fitdat$dose_cat[fitdat$id == k])
    #assign that dose
    #the categorical values are just for plotting
    preddat[(preddat$id == k),"dose_adj"] = nowdose
    preddat[(preddat$id == k),"dose_cat"] = nowdose_cat
  }

  # pull out posterior samples for the parameters
  post <- extract.samples(nowmodel)

  # estimate and CI for parameter variation
  # this uses the link function from rethinking
  linkmod <- rethinking::link(nowmodel, data = preddat)

  #computing mean and various credibility intervals
  #these choices are inspired by the Statistical Rethinking book
  #and purposefully do not include 95%
  #to minimize thoughts of statistical significance
  #significance is not applicable here since we are doing bayesian fitting
  modmean <- apply( linkmod$mu , 2 , mean )
  modPI79 <- apply( linkmod$mu , 2 , PI , prob=0.79 )
  modPI89 <- apply( linkmod$mu , 2 , PI , prob=0.89 )
  modPI97 <- apply( linkmod$mu , 2 , PI , prob=0.97 )

  # estimate and CI for prediction intervals
  # this uses the sim function from rethinking
  # the predictions factor in additional uncertainty around the mean (mu)
  # as indicated by sigma
  simmod <- rethinking::sim(nowmodel, data = preddat)

  # mean and credible intervals for outcome predictions
  # mean should agree with above values
  modmeansim <- apply( simmod , 2 , mean )
  modPIsim <- apply( simmod , 2 , PI , prob=0.89 )

  #place all predictions into a data frame
  #and store in a list for each model
  fitpred[[n]] = data.frame(id = as.factor(preddat$id),
                            dose = as.factor(preddat$dose_cat),
                            predtime = preddat$time,
                            Estimate = modmean,
                            Q79lo = modPI79[1,], Q79hi = modPI79[2,],
                            Q89lo = modPI89[1,], Q89hi = modPI89[2,],
                            Q97lo = modPI97[1,], Q97hi = modPI97[2,],
                            Qsimlo=modPIsim[1,], Qsimhi=modPIsim[2,]
                            )
} #end loop over all models



## ---- makeplots --------
#list for storing all plots
plotlist = vector(mode = "list", length = length(fl))

#again looping over all models, making a plot for each
for (n in 1:length(fl))
{
  #adding titles to plots
  title = fl[[n]]$model

  plotlist[[n]] <- ggplot(data = fitpred[[n]], aes(x = predtime, y = Estimate, group = id, color = dose ) ) +
    geom_line() +
    #geom_ribbon( aes(x=time, ymin=Q79lo, ymax=Q79hi, fill = dose), alpha=0.6, show.legend = F) +
    geom_ribbon(aes(x=predtime, ymin=Q89lo, ymax=Q89hi, fill = dose, color = NULL), alpha=0.3, show.legend = F) +
    #geom_ribbon(aes(x=time, ymin=Q97lo, ymax=Q97hi, fill = dose), alpha=0.2, show.legend = F) +
    geom_ribbon(aes(x=predtime, ymin=Qsimlo, ymax=Qsimhi, fill = dose, color = NULL), alpha=0.1, show.legend = F) +
    geom_point(data = plotdat, aes(x = time, y = outcome, group = id, color = dose), shape = 1, size = 2) +
    scale_y_continuous(limits = c(-30,50)) +
    labs(y = "Virus load",
         x = "days post infection") +
    theme_minimal() +
    ggtitle(title)
}
#saving one plot so I can use as featured image
ggsave(file = paste0("fit_m4.png"), plotlist[[4]], dpi = 300, units = "in", width = 7, height = 7)



## ---- mod_1_3_plots --------
plot(plotlist[[1]])
plot(plotlist[[3]])


## ---- mod_2_2a_plots --------
plot(plotlist[[2]])
plot(plotlist[[5]])


## ---- mod_4_4a_plots --------
plot(plotlist[[4]])
plot(plotlist[[6]])
