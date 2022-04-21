# exploration of fit objects code of brms tutorial (part 3)
# https://www.andreashandel.com/posts/longitudinal-multilevel-bayesian-analysis-3/


## ---- packages2 --------
library('dplyr') # for data manipulation
library('ggplot2') # for plotting
library('cmdstanr') #for model fitting
library('brms') # for model fitting
library('posterior') #for post-processing
library('fs') #for file path


## ---- loadfits --------
#loading previously saved fits.
#useful if we don't want to re-fit each time
#we want to explore the results.
filepath = fs::path("D:","Dropbox","datafiles","longitudinalbayes","brmsfits", ext="Rds")
fl <- readRDS(filepath)



## ---- mod_1_3_exploration --------
# model 1 first
draws <- posterior::as_draws_array(fl[[1]]$fit)
pars = posterior::summarize_draws(draws, default_summary_measures(), default_convergence_measures())
a0mean <- pars %>% dplyr::filter(grepl('alpha_id',variable)) %>% summarize(mean = mean(mean))
b0mean <- pars %>% dplyr::filter(grepl('beta_id',variable)) %>% summarize(mean = mean(mean))
otherpars <- pars %>% dplyr::filter(!grepl('_id',variable))
print(otherpars)
print(c(a0mean,b0mean))

# repeat for model 3
draws <- posterior::as_draws_array(fl[[3]]$fit)
pars = posterior::summarize_draws(draws, default_summary_measures(), default_convergence_measures())
a0mean <- pars %>% dplyr::filter(grepl('alpha_id',variable)) %>% summarize(mean = mean(mean))
b0mean <- pars %>% dplyr::filter(grepl('beta_id',variable)) %>% summarize(mean = mean(mean))
otherpars <- pars %>% dplyr::filter(!grepl('_id',variable))
print(otherpars)
print(c(a0mean,b0mean))


## ---- mod_1_3_comparison --------
comp <- loo_compare(add_criterion(fl[[1]]$fit,"waic"),
            add_criterion(fl[[3]]$fit,"waic"),
            criterion = "waic")
print(comp, simplify = FALSE)


## ---- mod_2a_exploration --------
draws <- posterior::as_draws_array(fl[[2]]$fit)
pars = posterior::summarize_draws(draws, default_summary_measures(), default_convergence_measures())
print(pars)



## ---- mod_4_exploration --------
draws <- posterior::as_draws_array(fl[[4]]$fit)
pars = posterior::summarize_draws(draws, default_summary_measures(), default_convergence_measures())
print(pars)



## ---- mod_all_comparison --------
comp <- loo_compare(add_criterion(fl[[1]]$fit,"waic"),
                    add_criterion(fl[[3]]$fit,"waic"),
                    add_criterion(fl[[2]]$fit,"waic"),
                    add_criterion(fl[[4]]$fit,"waic"),
                    criterion = "waic")
print(comp, simplify = FALSE)



## ---- priorexploration --------
preprior <- get_prior(m1eqs,data=fitdat,family=gaussian())
postprior <- prior_summary(fl[[2]]$fit)
print(preprior)
print(postprior)



## ---- computepredictions --------
#this will contain all the predictions from the different models
fitpred = vector(mode = "list", length = length(fl))

# load the data we used for fitting
simdat <- readRDS("simdat.Rds")
#pull our the data set we used for fitting
#if you fit a different one of the simulated datasets, change accordingly
fitdat <- simdat$m3
#small data adjustment for plotting
plotdat <- fitdat %>% data.frame() %>% mutate(id = as.factor(id)) %>% mutate(dose = dose_cat)


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

  # estimate and CI for parameter variation
  #brms equivalent to rethinking::link
  #doing 89% CI
  meanpred <- fitted(nowmodel, newdata = preddat, probs = c(0.055, 0.945) )

  # estimate and CI for prediction intervals
  # the predictions factor in additional uncertainty around the mean (mu)
  # as indicated by sigma
  # this is equivalent to rethinking::sim()
  outpred <- predict(nowmodel, newdata = preddat, probs = c(0.055, 0.945) )


  #place all predictions into a data frame
  #and store in a list for each model
  fitpred[[n]] = data.frame(id = as.factor(preddat$id),
                            dose = as.factor(preddat$dose_cat),
                            predtime = preddat$time,
                            Estimate = meanpred[,"Estimate"],
                            Q89lo = meanpred[,"Q5.5"],
                            Q89hi = meanpred[,"Q94.5"],
                            Qsimlo = outpred[,"Q5.5"],
                            Qsimhi = outpred[,"Q94.5"]
  )
}


#########################
# generate plots showing data and model predictions
#########################



## ---- makeplots --------
#storing all plots
plotlist = vector(mode = "list", length = length(fl))

#adding titles to plots
titles = c('model 1','model 2a','model 3','model 4')

#again looping over all models, making a plot for each
for (n in 1:length(fl))
{
  # ===============================================
  plotlist[[n]] <- ggplot(data = fitpred[[n]], aes(x = predtime, y = Estimate, group = id, color = dose ) ) +
    geom_line() +
    geom_ribbon(aes(x=predtime, ymin=Q89lo, ymax=Q89hi, fill = dose, color = NULL), alpha=0.3, show.legend = F) +
    geom_ribbon(aes(x=predtime, ymin=Qsimlo, ymax=Qsimhi, fill = dose, color = NULL), alpha=0.1, show.legend = F) +
    geom_point(data = plotdat, aes(x = time, y = outcome, group = id, color = dose), shape = 1, size = 2) +
    scale_y_continuous(limits = c(-30,50)) +
    labs(y = "Virus load",
         x = "days post infection") +
    theme_minimal() +
    ggtitle(titles[n])
  ggsave(file = paste0(titles[n],".png"), plotlist[[n]], dpi = 300, units = "in", width = 7, height = 7)
}



#########################
# show the plots
#########################

## ---- showplots --------
plot(plotlist[[1]])
plot(plotlist[[3]])
plot(plotlist[[2]])
plot(plotlist[[4]])

