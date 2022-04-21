# code for fit exploration of tutorial part 4
# https://www.andreashandel.com/posts/longitudinal-multilevel-bayesian-analysis-4/


## ---- packages2 --------
library('dplyr') # for data manipulation
library('ggplot2') # for plotting
library('cmdstanr') #for model fitting
library('rethinking') #for model fitting
library('fs') #for file path


## ---- load_dat2 --------
#loading previously saved fits.
filepath = fs::path("D:","Dropbox","datafiles","longitudinalbayes","ulamfits_dat2", ext="Rds")
fl <- readRDS(filepath)


## ---- explore_dat2 --------
#Model 2a
print(precis(fl[[1]]$fit,depth=1),digits = 2)

#Model 4
a0mean = mean(precis(fl[[2]]$fit,depth=2,"a0")$mean)
b0mean = mean(precis(fl[[2]]$fit,depth=2,"b0")$mean)
print(precis(fl[[2]]$fit,depth=1),digits = 2)
print(c(a0mean,b0mean))


## ---- compare_dat2 --------
comp <- compare(fl[[1]]$fit,fl[[2]]$fit)
print(comp)


## ---- predict_dat2 --------
#this will contain all the predictions from the different models
fitpred = vector(mode = "list", length = length(fl))

# we are looping over each fitted model
for (n in 1:length(fl))
{

  nowmodel = fl[[n]]$fit
  # pull out posterior samples for the parameters
  post <- extract.samples(nowmodel)

  # estimate and CI for parameter variation
  # this uses the link function from rethinking
  linkmod <- rethinking::link(nowmodel)

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
  simmod <- rethinking::sim(nowmodel)

  # mean and credible intervals for outcome predictions
  # mean should agree with above values
  modmeansim <- apply( simmod , 2 , mean )
  modPIsim <- apply( simmod , 2 , PI , prob=0.89 )

  #place all predictions into a data frame
  #and store in a list for each model
  #also add original data, which is in the data slot of the model fit object
  fitpred[[n]] = data.frame(id = as.factor(nowmodel@data$id),
                            time = nowmodel@data$time,
                            dose = as.factor(nowmodel@data$dose),
                            outcome = nowmodel@data$outcome,
                            Estimate = modmean,
                            Q79lo = modPI79[1,], Q79hi = modPI79[2,],
                            Q89lo = modPI89[1,], Q89hi = modPI89[2,],
                            Q97lo = modPI97[1,], Q97hi = modPI97[2,],
                            Qsimlo=modPIsim[1,], Qsimhi=modPIsim[2,]
  )
}


## ---- plot_dat2 --------
#storing all plots
plotlist = vector(mode = "list", length = length(fl))

#adding titles to plots
titles = c('model 2a','model 4')

#again looping over all models, making a plot for each
for (n in 1:length(fl))
{
  # ===============================================
  plotlist[[n]] <- ggplot(data = fitpred[[n]], aes(x = time, y = Estimate, group = id, color = dose ) ) +
    geom_line(color = "black") +
    #geom_ribbon( aes(x=time, ymin=Q79lo, ymax=Q79hi, fill = dose), alpha=0.6, show.legend = F) +
    geom_ribbon(aes(x=time, ymin=Q89lo, ymax=Q89hi, fill = dose, color = NULL), alpha=0.3, show.legend = F) +
    #geom_ribbon(aes(x=time, ymin=Q97lo, ymax=Q97hi, fill = dose), alpha=0.2, show.legend = F) +
    geom_ribbon(aes(x=time, ymin=Qsimlo, ymax=Qsimhi, fill = dose, color = NULL), alpha=0.1, show.legend = F) +
    geom_point(aes(x = time, y = outcome, group = id, color = dose),  shape = 1, size = 2) +
    scale_y_continuous(limits = c(-40,50)) +
    labs(y = "Virus load",
         x = "days post infection") +
    theme_minimal() +
    ggtitle(titles[n])
}
plot(plotlist[[1]])
plot(plotlist[[2]])


## ---- load_big --------
#loading previously saved fits.
filepath = fs::path("D:","Dropbox","datafiles","longitudinalbayes","ulamfits_big", ext="Rds")
fl <- readRDS(filepath)


## ---- explore_big --------
a0mean = mean(precis(fl[[1]]$fit,depth=2,"a0")$mean)
b0mean = mean(precis(fl[[1]]$fit,depth=2,"b0")$mean)
print(precis(fl[[1]]$fit,depth=1),digits = 2)
print(c(a0mean,b0mean))



## ---- load_altpos --------
#loading previously saved fits.
filepath = fs::path("D:","Dropbox","datafiles","longitudinalbayes","ulamfits_altpos", ext="Rds")
fl <- readRDS(filepath)


## ---- explore_altpos --------
#Model 3
a0mean = mean(precis(fl[[1]]$fit,depth=2,"a0")$mean)
b0mean = mean(precis(fl[[1]]$fit,depth=2,"b0")$mean)
print(precis(fl[[1]]$fit,depth=1),digits = 2)
print(c(a0mean,b0mean))

#Model 5
print(precis(fl[[2]]$fit,depth=1),digits = 2)
a0mean = mean(precis(fl[[2]]$fit,depth=2,"a0")$mean)
b0mean = mean(precis(fl[[2]]$fit,depth=2,"b0")$mean)
print(c(a0mean,b0mean))

a1est = (precis(fl[[2]]$fit,pars="a2")[1,]-1)*a0mean
b1est = (precis(fl[[2]]$fit,pars="b2")[1,]-1)*a0mean
print(c(a1est,b1est))


## ---- compare_altpos --------
compare(fl[[1]]$fit,fl[[2]]$fit)


## ---- predict_altpos --------
#this will contain all the predictions from the different models
fitpred = vector(mode = "list", length = length(fl))

# we are looping over each fitted model
for (n in 1:length(fl))
{

  nowmodel = fl[[n]]$fit
  # pull out posterior samples for the parameters
  post <- extract.samples(nowmodel)

  # estimate and CI for parameter variation
  # this uses the link function from rethinking
  linkmod <- rethinking::link(nowmodel)

  #computing mean and credibility interval
  modmean <- apply( linkmod$mu , 2 , mean )
  modPI89 <- apply( linkmod$mu , 2 , PI , prob=0.89 )

  # estimate and CI for prediction intervals
  # this uses the sim function from rethinking
  # the predictions factor in additional uncertainty around the mean (mu)
  # as indicated by sigma
  simmod <- rethinking::sim(nowmodel)
  modPIsim <- apply( simmod , 2 , PI , prob=0.89 )

  #place all predictions into a data frame
  #and store in a list for each model
  #also add original data, which is in the data slot of the model fit object
  fitpred[[n]] = data.frame(id = as.factor(nowmodel@data$id),
                            time = nowmodel@data$time,
                            dose = as.factor(nowmodel@data$dose),
                            outcome = nowmodel@data$outcome,
                            Estimate = modmean,
                            Q89lo = modPI89[1,], Q89hi = modPI89[2,],
                            Qsimlo=modPIsim[1,], Qsimhi=modPIsim[2,]
  )
}



## ---- plot_altpos --------
#storing all plots
plotlist = vector(mode = "list", length = length(fl))

#adding titles to plots
titles = c('model 3','model 5')

#again looping over all models, making a plot for each
for (n in 1:length(fl))
{
  # ===============================================
  plotlist[[n]] <- ggplot(data = fitpred[[n]], aes(x = time, y = Estimate, group = id, color = dose ) ) +
    geom_line(color = "black") +
    geom_ribbon(aes(x=time, ymin=Q89lo, ymax=Q89hi, fill = dose, color = NULL), alpha=0.3, show.legend = F) +
    geom_ribbon(aes(x=time, ymin=Qsimlo, ymax=Qsimhi, fill = dose, color = NULL), alpha=0.1, show.legend = F) +
    geom_point(aes(x = time, y = outcome, group = id, color = dose),  shape = 1, size = 2) +
    scale_y_continuous(limits = c(-40,50)) +
    labs(y = "Virus load",
         x = "days post infection") +
    theme_minimal() +
    ggtitle(titles[n])
}
plot(plotlist[[1]])
plot(plotlist[[2]])


## ---- load_cat --------
#loading previously saved fits.
filepath = fs::path("D:","Dropbox","datafiles","longitudinalbayes","ulamfits_cat", ext="Rds")
fl <- readRDS(filepath)


## ---- explore_cat --------
#Model 6
print(precis(fl[[1]]$fit,depth=2),digits = 2)


## ---- predict_cat --------
#this will contain all the predictions from the different models
fitpred = vector(mode = "list", length = length(fl))

# we are looping over each fitted model
for (n in 1:length(fl))
{

  nowmodel = fl[[n]]$fit
  # pull out posterior samples for the parameters
  post <- extract.samples(nowmodel)

  # estimate and CI for parameter variation
  # this uses the link function from rethinking
  linkmod <- rethinking::link(nowmodel)

  #computing mean and credibility interval
  modmean <- apply( linkmod$mu , 2 , mean )
  modPI89 <- apply( linkmod$mu , 2 , PI , prob=0.89 )

  # estimate and CI for prediction intervals
  # this uses the sim function from rethinking
  # the predictions factor in additional uncertainty around the mean (mu)
  # as indicated by sigma
  simmod <- rethinking::sim(nowmodel)
  modPIsim <- apply( simmod , 2 , PI , prob=0.89 )

  #place all predictions into a data frame
  #and store in a list for each model
  #also add original data, which is in the data slot of the model fit object
  fitpred[[n]] = data.frame(id = as.factor(nowmodel@data$id),
                            time = nowmodel@data$time,
                            dose = as.factor(nowmodel@data$dose),
                            outcome = nowmodel@data$outcome,
                            Estimate = modmean,
                            Q89lo = modPI89[1,], Q89hi = modPI89[2,],
                            Qsimlo=modPIsim[1,], Qsimhi=modPIsim[2,]
  )
}


## ---- plot_cat --------
#storing all plots
plotlist = vector(mode = "list", length = length(fl))

#adding titles to plots
titles = c('model 6')

#again looping over all models, making a plot for each
for (n in 1:length(fl))
{
  # ===============================================
  plotlist[[n]] <- ggplot(data = fitpred[[n]], aes(x = time, y = Estimate, group = id, color = dose ) ) +
    geom_line(color = "black") +
    geom_ribbon(aes(x=time, ymin=Q89lo, ymax=Q89hi, fill = dose, color = NULL), alpha=0.3, show.legend = F) +
    geom_ribbon(aes(x=time, ymin=Qsimlo, ymax=Qsimhi, fill = dose, color = NULL), alpha=0.1, show.legend = F) +
    geom_point(aes(x = time, y = outcome, group = id, color = dose),  shape = 1, size = 2) +
    scale_y_continuous(limits = c(-40,50)) +
    labs(y = "Virus load",
         x = "days post infection") +
    theme_minimal() +
    ggtitle(titles[n])
}
plot(plotlist[[1]])
