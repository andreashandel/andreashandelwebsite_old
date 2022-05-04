---
title: Analysis of pizza restaurants 
subtitle: A TidyTuesday exercise
summary: An analysis of TidyTuesday data for pizza restaurants and their ratings.
author: Andreas Handel
date: '2019-10-12'
lastMod: "2020-03-01"
slug: tidytuesday-analysis
categories: 
- R
- Data Analysis
tags: 
- R
- Data Analysis
featured: no
image:
  caption: ''
  focal_point: ''
  preview_only: no
---

<script src="{{< blogdown/postref >}}index_files/htmlwidgets/htmlwidgets.js"></script>
<script src="{{< blogdown/postref >}}index_files/plotly-binding/plotly.js"></script>
<script src="{{< blogdown/postref >}}index_files/typedarray/typedarray.min.js"></script>
<script src="{{< blogdown/postref >}}index_files/jquery/jquery.min.js"></script>
<link href="{{< blogdown/postref >}}index_files/crosstalk/css/crosstalk.min.css" rel="stylesheet" />
<script src="{{< blogdown/postref >}}index_files/crosstalk/js/crosstalk.min.js"></script>
<link href="{{< blogdown/postref >}}index_files/plotly-htmlwidgets-css/plotly-htmlwidgets.css" rel="stylesheet" />
<script src="{{< blogdown/postref >}}index_files/plotly-main/plotly-latest.min.js"></script>
<script src="{{< blogdown/postref >}}index_files/htmlwidgets/htmlwidgets.js"></script>
<script src="{{< blogdown/postref >}}index_files/plotly-binding/plotly.js"></script>
<script src="{{< blogdown/postref >}}index_files/typedarray/typedarray.min.js"></script>
<script src="{{< blogdown/postref >}}index_files/jquery/jquery.min.js"></script>
<link href="{{< blogdown/postref >}}index_files/crosstalk/css/crosstalk.min.css" rel="stylesheet" />
<script src="{{< blogdown/postref >}}index_files/crosstalk/js/crosstalk.min.js"></script>
<link href="{{< blogdown/postref >}}index_files/plotly-htmlwidgets-css/plotly-htmlwidgets.css" rel="stylesheet" />
<script src="{{< blogdown/postref >}}index_files/plotly-main/plotly-latest.min.js"></script>
<script src="{{< blogdown/postref >}}index_files/htmlwidgets/htmlwidgets.js"></script>
<script src="{{< blogdown/postref >}}index_files/plotly-binding/plotly.js"></script>
<script src="{{< blogdown/postref >}}index_files/typedarray/typedarray.min.js"></script>
<script src="{{< blogdown/postref >}}index_files/jquery/jquery.min.js"></script>
<link href="{{< blogdown/postref >}}index_files/crosstalk/css/crosstalk.min.css" rel="stylesheet" />
<script src="{{< blogdown/postref >}}index_files/crosstalk/js/crosstalk.min.js"></script>
<link href="{{< blogdown/postref >}}index_files/plotly-htmlwidgets-css/plotly-htmlwidgets.css" rel="stylesheet" />
<script src="{{< blogdown/postref >}}index_files/plotly-main/plotly-latest.min.js"></script>

This analysis was performed as part of an exercise for my [Modern Applied Data Analysis course](https://andreashandel.github.io/MADAcourse/).

When I taught the course in fall 2019, one of the weekly assignments for the students was to participate in [TidyTuesday](https://github.com/rfordatascience/tidytuesday). I did the exercise as well, this is my product. You can get the R Markdown file to re-run the analysis [here](/posts/2019-10-02-tidy-tuesday-exploration/index.Rmarkdown).

# Introduction

If you are not familiar with TidyTuesday, you can take a quick look [at the TidyTuesday section on this page](https://andreashandel.github.io/MADAcourse/Data_Analysis_Motivation.html).

This week’s data was all about Pizza. More on the data [is here](https://github.com/rfordatascience/tidytuesday/tree/master/data/2019/2019-10-01).

# Loading packages

``` r
library('readr')
library('ggplot2')
library("dplyr")
library("cowplot")
library("plotly")
library("forcats")
library("geosphere")
library("emoji")
```

# Data loading

Load date following [TidyTueday instructions](https://github.com/rfordatascience/tidytuesday/tree/master/data/2019/2019-10-01).

``` r
pizza_jared <- readr::read_csv("https://raw.githubusercontent.com/rfordatascience/tidytuesday/master/data/2019/2019-10-01/pizza_jared.csv")
pizza_barstool <- readr::read_csv("https://raw.githubusercontent.com/rfordatascience/tidytuesday/master/data/2019/2019-10-01/pizza_barstool.csv")
pizza_datafiniti <- readr::read_csv("https://raw.githubusercontent.com/rfordatascience/tidytuesday/master/data/2019/2019-10-01/pizza_datafiniti.csv")
```

# Analysis Ideas

See the TidyTuesday website for a codebook. These are 3 datasets. Looks like the 1st dataset is ratings of pizza places through some (online?) survey/poll, the 2nd dataset again has ratings of pizza places from various sources, and the 3rd dataset seems to have fairly overlapping information to the 2nd dataset.

Note: When I looked at the website, the codebook for the 3rd dataset seemed mislabeled. Might be fixed by now.

Possibly interesting questions I can think of:

-   For a given pizza restaurant, how do the different ratings/scores agree or differ?
-   Are more expensive restaurants overall rated higher?
-   Is there some systematic dependence of rating on location? Do restaurants located in a certain area in general get rated higher/lower compared to others?

I think those are good enough questions to figure out, let’s see how far we get.

# Initial data exploration

Start with a quick renaming and general check.

``` r
#saves typing
d1 <- pizza_jared 
d2 <- pizza_barstool 
d3 <- pizza_datafiniti 
glimpse(d1)
```

    ## Rows: 375
    ## Columns: 9
    ## $ polla_qid   <dbl> 2, 2, 2, 2, 2, 3, 3, 3, 3, 3, 4, 4, 4, 4, 4, 5, 5, 5, 5, 5~
    ## $ answer      <chr> "Excellent", "Good", "Average", "Poor", "Never Again", "Ex~
    ## $ votes       <dbl> 0, 6, 4, 1, 2, 1, 1, 3, 1, 1, 4, 2, 1, 1, 0, 1, 1, 0, 3, 0~
    ## $ pollq_id    <dbl> 2, 2, 2, 2, 2, 3, 3, 3, 3, 3, 4, 4, 4, 4, 4, 5, 5, 5, 5, 5~
    ## $ question    <chr> "How was Pizza Mercato?", "How was Pizza Mercato?", "How w~
    ## $ place       <chr> "Pizza Mercato", "Pizza Mercato", "Pizza Mercato", "Pizza ~
    ## $ time        <dbl> 1344361527, 1344361527, 1344361527, 1344361527, 1344361527~
    ## $ total_votes <dbl> 13, 13, 13, 13, 13, 7, 7, 7, 7, 7, 8, 8, 8, 8, 8, 5, 5, 5,~
    ## $ percent     <dbl> 0.0000, 0.4615, 0.3077, 0.0769, 0.1538, 0.1429, 0.1429, 0.~

``` r
glimpse(d2)
```

    ## Rows: 463
    ## Columns: 22
    ## $ name                                 <chr> "Pugsley's Pizza", "Williamsburg ~
    ## $ address1                             <chr> "590 E 191st St", "265 Union Ave"~
    ## $ city                                 <chr> "Bronx", "Brooklyn", "New York", ~
    ## $ zip                                  <dbl> 10458, 11211, 10017, 10036, 10003~
    ## $ country                              <chr> "US", "US", "US", "US", "US", "US~
    ## $ latitude                             <dbl> 40.85877, 40.70808, 40.75370, 40.~
    ## $ longitude                            <dbl> -73.88484, -73.95090, -73.97411, ~
    ## $ price_level                          <dbl> 1, 1, 1, 2, 2, 1, 1, 1, 2, 2, 1, ~
    ## $ provider_rating                      <dbl> 4.5, 3.0, 4.0, 4.0, 3.0, 3.5, 3.0~
    ## $ provider_review_count                <dbl> 121, 281, 118, 1055, 143, 28, 95,~
    ## $ review_stats_all_average_score       <dbl> 8.011111, 7.774074, 5.666667, 5.6~
    ## $ review_stats_all_count               <dbl> 27, 27, 9, 2, 1, 4, 5, 17, 14, 6,~
    ## $ review_stats_all_total_score         <dbl> 216.3, 209.9, 51.0, 11.2, 7.1, 16~
    ## $ review_stats_community_average_score <dbl> 7.992000, 7.742308, 5.762500, 0.0~
    ## $ review_stats_community_count         <dbl> 25, 26, 8, 0, 0, 3, 4, 16, 13, 4,~
    ## $ review_stats_community_total_score   <dbl> 199.8, 201.3, 46.1, 0.0, 0.0, 13.~
    ## $ review_stats_critic_average_score    <dbl> 8.8, 0.0, 0.0, 4.3, 0.0, 0.0, 0.0~
    ## $ review_stats_critic_count            <dbl> 1, 0, 0, 1, 0, 0, 0, 0, 0, 1, 0, ~
    ## $ review_stats_critic_total_score      <dbl> 8.8, 0.0, 0.0, 4.3, 0.0, 0.0, 0.0~
    ## $ review_stats_dave_average_score      <dbl> 7.7, 8.6, 4.9, 6.9, 7.1, 3.2, 6.1~
    ## $ review_stats_dave_count              <dbl> 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, ~
    ## $ review_stats_dave_total_score        <dbl> 7.7, 8.6, 4.9, 6.9, 7.1, 3.2, 6.1~

``` r
glimpse(d3)
```

    ## Rows: 10,000
    ## Columns: 10
    ## $ name            <chr> "Shotgun Dans Pizza", "Sauce Pizza Wine", "Mios Pizzer~
    ## $ address         <chr> "4203 E Kiehl Ave", "25 E Camelback Rd", "3703 Paxton ~
    ## $ city            <chr> "Sherwood", "Phoenix", "Cincinnati", "Madison Heights"~
    ## $ country         <chr> "US", "US", "US", "US", "US", "US", "US", "US", "US", ~
    ## $ province        <chr> "AR", "AZ", "OH", "MI", "MD", "MD", "CA", "CA", "FL", ~
    ## $ latitude        <dbl> 34.83230, 33.50927, 39.14488, 42.51667, 39.28663, 39.2~
    ## $ longitude       <dbl> -92.18380, -112.07304, -84.43269, -83.10663, -76.56698~
    ## $ categories      <chr> "Pizza,Restaurant,American restaurants,Pizza Place,Res~
    ## $ price_range_min <dbl> 0, 0, 0, 25, 0, 0, 0, 0, 0, 0, 25, 25, 25, 25, 0, 0, 0~
    ## $ price_range_max <dbl> 25, 25, 25, 40, 25, 25, 25, 25, 25, 25, 40, 40, 40, 40~

The first question I have is if the pizza places in the 3 datasets are the same or at least if there is decent overlap. If not, then one can’t combine the data.

``` r
d1names = unique(d1$place)
d2names = unique(d2$name)
d3names = unique(d3$name)
sum(d1names %in% d2names) #check how many restaurants in d1 are also in d2. Note that this assumes exact spelling.
```

    ## [1] 22

``` r
sum(d1names %in% d3names) #check how many restaurants in d1 are also in d2. Note that this assumes exact spelling.
```

    ## [1] 9

``` r
sum(d2names %in% d3names)
```

    ## [1] 66

22 restaurants out of 56 in dataset 1 are also in dataset 2. Only 9 overlap between dataset 1 and 3. 66 are shared between datasets 2 and 3.

The last dataset has no ratings, and if I look at the overlap of dataset 1 and 2, I only get a few observations. So I think for now I’ll focus on dataset 2 and see if I can address the 3 questions I posed above with just that dataset. Maybe I’ll have ideas for the other 2 datasets as I go along (would be a shame to not use them.)

# Ratings agreement analysis

Ok, I’ll focus on dataset 2 now and look closer at the scores/rating. From the codebook, it’s not quite clear to me what the different scores and counts in dataset 2 actually mean, so let’s look closer to try and figure that out.

From the glimpse function above, I can’t see much of a difference between average and total score. Let’s look at that. Here are a few plots comparing the different score-related variables.

``` r
plot(d2$review_stats_community_total_score,d2$review_stats_community_average_score)
```

<img src="{{< blogdown/postref >}}index_files/figure-html/score-explore-1.png" width="672" />

``` r
plot(d2$review_stats_community_total_score - d2$review_stats_community_average_score* d2$review_stats_community_count)
```

<img src="{{< blogdown/postref >}}index_files/figure-html/score-explore-2.png" width="672" />

``` r
plot(d2$review_stats_critic_total_score-d2$review_stats_critic_average_score)
```

<img src="{{< blogdown/postref >}}index_files/figure-html/score-explore-3.png" width="672" />

``` r
plot(d2$review_stats_dave_total_score-d2$review_stats_dave_average_score)
```

<img src="{{< blogdown/postref >}}index_files/figure-html/score-explore-4.png" width="672" />

``` r
plot(d2$review_stats_all_total_score- (d2$review_stats_community_total_score+d2$review_stats_critic_total_score+d2$review_stats_dave_total_score))  
```

<img src="{{< blogdown/postref >}}index_files/figure-html/score-explore-5.png" width="672" />

Ok, so based on the plots above, and a few other things I tried, it seems that average score is total score divided by number of counts, and the *all* score is just the sum of *dave*, *critic* and *community*.

So to address my first question, I’ll look at correlations between average scores for the 3 types of reviewers, namely *dave*, *critic* and *community*.

However, while playing around with the data in the last section, I noticed a problem. Look at the counts for say critics and the average score.

``` r
table(d2$review_stats_critic_count)
```

    ## 
    ##   0   1   5 
    ## 401  61   1

``` r
table(d2$review_stats_critic_average_score)
```

    ## 
    ##    0    4  4.3  4.5  4.8    5  5.1  5.4  5.5  5.7  5.8  5.9 5.96    6  6.2 6.31 
    ##  401    1    1    1    1    3    1    1    1    1    1    1    1    1    1    1 
    ##  6.5  6.6  6.7 6.76  6.8  6.9    7  7.2  7.3  7.4  7.6 7.76  7.8  7.9    8  8.1 
    ##    3    1    1    1    2    1    5    2    2    1    1    1    2    1    4    2 
    ##  8.5  8.7  8.8    9  9.3  9.4  9.8   10   11 
    ##    3    1    1    1    1    2    1    4    1

A lot of restaurants did not get reviewed by critics, and the score is coded as 0. That’s a problem since if we take averages and such, it will mess up things. This should really be counted as NA. So let’s create new average scores such that any restaurant with no visits/reviews gets an NA as score.

``` r
d2 <- d2 %>% mutate( comm_score = ifelse(review_stats_community_count == 0 ,NA,review_stats_community_average_score)) %>%
             mutate( crit_score = ifelse(review_stats_critic_count == 0 ,NA,review_stats_critic_average_score)) %>%
             mutate( dave_score = ifelse(review_stats_dave_count == 0 ,NA,review_stats_dave_average_score)) 
```

Now let’s plot the 3.

``` r
p1 <- d2 %>% ggplot(aes(x=comm_score, y = crit_score)) + geom_point() + geom_smooth(method = "lm")
p2 <- d2 %>% ggplot(aes(x=comm_score, y = dave_score)) + geom_point() + geom_smooth(method = "lm")
p3 <- d2 %>% ggplot(aes(x=crit_score, y = dave_score)) + geom_point() + geom_smooth(method = "lm")
cowplot::plot_grid(p1, p2, p3, labels = c('A', 'B','C'), label_size = 12)
```

    ## `geom_smooth()` using formula 'y ~ x'
    ## `geom_smooth()` using formula 'y ~ x'
    ## `geom_smooth()` using formula 'y ~ x'

<img src="{{< blogdown/postref >}}index_files/figure-html/plot-1-1.png" width="672" />

Looks like there is some agreement between Dave, the critics and the community on the ratings of various pizza places, though there is a good bit of variation.

I think it would be fun to be able to click on specific points to see for a given score which restaurant that is. For instance I’m curious which restaurant has a close to zero score from both the community and Dave (bottom left of plot B).

I think that can be done with plotly, let’s google it.

Ok, figured it out. This re-creates the 3 scatterplots from above and when one moves over the dots, it shows restaurant name.

``` r
plot_ly(d2, x = ~comm_score, y = ~crit_score, text = ~paste('Restaurant: ', name))
```

    ## No trace type specified:
    ##   Based on info supplied, a 'scatter' trace seems appropriate.
    ##   Read more about this trace type -> https://plotly.com/r/reference/#scatter

    ## No scatter mode specifed:
    ##   Setting the mode to markers
    ##   Read more about this attribute -> https://plotly.com/r/reference/#scatter-mode

<div id="htmlwidget-1" style="width:672px;height:480px;" class="plotly html-widget"></div>
<script type="application/json" data-for="htmlwidget-1">{"x":{"visdat":{"8f1818837a9":["function () ","plotlyVisDat"]},"cur_data":"8f1818837a9","attrs":{"8f1818837a9":{"x":{},"y":{},"text":{},"alpha_stroke":1,"sizes":[10,100],"spans":[1,20]}},"layout":{"margin":{"b":40,"l":60,"t":25,"r":10},"xaxis":{"domain":[0,1],"automargin":true,"title":"comm_score"},"yaxis":{"domain":[0,1],"automargin":true,"title":"crit_score"},"hovermode":"closest","showlegend":false},"source":"A","config":{"modeBarButtonsToAdd":["hoverclosest","hovercompare"],"showSendToCloud":false},"data":[{"x":[7.992,6.725,6.5,6.55,5.9,6.8125,6.25,6.375,3,7.45,7.625,6.1,6.675,5.725,6.75,6.475,4.4,5.1,7.00392156862745,6.5,7.77142857142857,6.36428571428571,7.25,7.14285714285714,6.8,8.85862068965517,5.76666666666667,7.4,5.95,5.25,7.3,8.46,5.97272727272727,8.23333333333333,7.025,7.16,6.75,6.4,7.13684210526316,8.28571428571429,8.45,7.63333333333333,7.62307692307692,7.8,8.6,7.55555555555555,7.15,6.85,8.40504201680672,5.92,6.46666666666667,6.0625,7.3,8.225,5.87894736842105,7.2,6.9],"y":[8.8,6.2,4.5,5.8,8.7,8,5,4,6.6,6,9.4,7.2,6.5,10,6.8,7.4,8,8,10,6.31,8.1,7,7.6,8.5,4.8,8.1,5,6.76,10,9,5,7.76,5.5,7.2,6.5,6.8,10,8.5,8,6.7,8.5,7.8,9.3,9.8,11,5.96,5.1,7.3,7.8,7,7,6.9,5.7,9.4,7.3,6.5,7],"text":["Restaurant:  Pugsley's Pizza","Restaurant:  Bond 45","Restaurant:  Dulono's Pizza","Restaurant:  Fat Lorenzo's","Restaurant:  Red's Savoy Pizza","Restaurant:  Frank From Philly & Andrea Pizza","Restaurant:  LA Traviata Pizzeria","Restaurant:  Percy's Pizza","Restaurant:  Mediterraneo Restaurant","Restaurant:  Tre Sorelle","Restaurant:  Napolese Pizzeria","Restaurant:  Bearno's By the Bridge","Restaurant:  The Original Impellizeri's Pizza","Restaurant:  Marcello's Pizza & Subs","Restaurant:  Piu Bello Pizzeria Restaurant","Restaurant:  Buckhead Pizza","Restaurant:  Picasso Pizza","Restaurant:  Pomodoro Pizza","Restaurant:  Majestic Pizza","Restaurant:  Friendly Gourmet Pizza","Restaurant:  Harry's Italian","Restaurant:  Little Italy Pizza","Restaurant:  Phil's Pizza","Restaurant:  Kesté Pizza & Vino","Restaurant:  Napoli Pizza","Restaurant:  Lucali","Restaurant:  Snacks","Restaurant:  Canal Pizza","Restaurant:  Melani Pizzeria","Restaurant:  Il Piccolo Bufalo","Restaurant:  Pomodoro Ristorante & Pizzeria","Restaurant:  Santarpio's Pizza","Restaurant:  Regina Pizzeria","Restaurant:  Nick's Pizza","Restaurant:  PQR","Restaurant:  Vinnie's Pizzeria","Restaurant:  La Mia Pizza","Restaurant:  Manhattan Brick Oven Pizza","Restaurant:  Francesco's Pizzeria","Restaurant:  Arturo's","Restaurant:  Song E Napule","Restaurant:  Sfila Pizza","Restaurant:  Merilu Pizza Al Metro","Restaurant:  Bricco Ristorante Italiano","Restaurant:  Serafina Broadway","Restaurant:  Don Antonio","Restaurant:  Daniela Trattoria","Restaurant:  Patzeria Perfect Pizza","Restaurant:  John's of Times Square","Restaurant:  Radio City Pizza","Restaurant:  Kiss My Slice","Restaurant:  Cassiano's Pizza","Restaurant:  Angelo Bellini","Restaurant:  Jiannetto's Pizza Truck","Restaurant:  Prova Pizzabar","Restaurant:  Giuseppe's Pizza","Restaurant:  Posto"],"type":"scatter","mode":"markers","marker":{"color":"rgba(31,119,180,1)","line":{"color":"rgba(31,119,180,1)"}},"error_y":{"color":"rgba(31,119,180,1)"},"error_x":{"color":"rgba(31,119,180,1)"},"line":{"color":"rgba(31,119,180,1)"},"xaxis":"x","yaxis":"y","frame":null}],"highlight":{"on":"plotly_click","persistent":false,"dynamic":false,"selectize":false,"opacityDim":0.2,"selected":{"opacity":1},"debounce":0},"shinyEvents":["plotly_hover","plotly_click","plotly_selected","plotly_relayout","plotly_brushed","plotly_brushing","plotly_clickannotation","plotly_doubleclick","plotly_deselect","plotly_afterplot","plotly_sunburstclick"],"base_url":"https://plot.ly"},"evals":[],"jsHooks":[]}</script>

``` r
plot_ly(d2, x = ~comm_score, y = ~dave_score, text = ~paste('Restaurant: ', name))
```

    ## No trace type specified:
    ##   Based on info supplied, a 'scatter' trace seems appropriate.
    ##   Read more about this trace type -> https://plotly.com/r/reference/#scatter
    ## No scatter mode specifed:
    ##   Setting the mode to markers
    ##   Read more about this attribute -> https://plotly.com/r/reference/#scatter-mode

<div id="htmlwidget-2" style="width:672px;height:480px;" class="plotly html-widget"></div>
<script type="application/json" data-for="htmlwidget-2">{"x":{"visdat":{"8f1873ec3d93":["function () ","plotlyVisDat"]},"cur_data":"8f1873ec3d93","attrs":{"8f1873ec3d93":{"x":{},"y":{},"text":{},"alpha_stroke":1,"sizes":[10,100],"spans":[1,20]}},"layout":{"margin":{"b":40,"l":60,"t":25,"r":10},"xaxis":{"domain":[0,1],"automargin":true,"title":"comm_score"},"yaxis":{"domain":[0,1],"automargin":true,"title":"dave_score"},"hovermode":"closest","showlegend":false},"source":"A","config":{"modeBarButtonsToAdd":["hoverclosest","hovercompare"],"showSendToCloud":false},"data":[{"x":[7.992,7.74230769230769,5.7625,4.36666666666667,6.125,7.45,7.35384615384615,6.725,5.79,5.7,6.725,7.23333333333333,8.44444444444444,8.06153846153846,7.47777777777778,8.35714285714286,6.5,5,6.55,5.9,6.8125,8.15454545454545,7.33684210526316,5.72857142857143,7.4,8.14666666666667,6.25,6.375,7.31428571428571,5.94166666666667,5.4,3,7.36666666666667,7.45,5.3,7.1625,6.88,8.4,6.3,6.25,7.92777777777778,4.6,3.1,9.16923076923077,8.07575757575758,6.97857142857143,7.75581395348837,3.33333333333333,7.77777777777778,8.00454545454545,7.425,7.77222222222222,5.2375,7.625,7.73333333333333,10,6.1,6.675,6.92,4.925,5.76666666666667,6.77142857142857,5.42857142857143,8.05,8.1,6.9625,6.97222222222222,6.9,7.6,7.89333333333333,8.01071428571429,7.61428571428571,7.8,6.1,8.1,7.65714285714286,4.25,7.99130434782609,8.16923076923077,7.6,7.8,5.725,6.75,6.475,7.2625,7.2,8.27708333333333,6.1,7.13333333333333,6.3,7.83636363636364,7.48181818181818,6.17894736842105,8.07948717948718,7.84444444444444,8.28141592920354,5.525,7.80606060606061,8.41538461538462,7.75,8.35681818181818,7.6125,6.2,8.29189189189189,7.48888888888889,7.2,8.03076923076923,8.2125,8.44444444444444,7.58684210526316,6.79523809523809,7.73846153846154,4.4,5.1,7.9,3.95714285714286,7.2,5.95,5.82857142857143,6.8,7.64,7.23636363636364,5.8,6.70588235294118,7.00392156862745,7.21666666666667,7.38,6.77333333333333,6.5,6.8,7.77142857142857,7.7,6.36428571428571,9.07380952380952,7.5,4.63333333333333,7.4,7.25,7.97692307692308,7.878125,7.71,7.71111111111111,7.05,7.32826086956522,8.05,7.775,8.88236331569665,7.56666666666667,7.9,8.8,7.14285714285714,6.7,7.54666666666667,7.03846153846154,7.07777777777778,6.44,7.80740740740741,6.8,7.70833333333333,7.6,8.85862068965517,8.53478260869565,5.82857142857143,8.875,8.79473684210526,8.34823529411765,8.92535211267606,6.34,6.97333333333333,8.412,5.16666666666667,5.925,7.84523809523809,7.88181818181818,4.825,4.08181818181818,6.78888888888889,6.12105263157895,5.76666666666667,3.2,7.4,8.19,6.21666666666667,7.10285714285714,5.13333333333333,7.53333333333333,8.4,6.675,6.45,6.82,7.80666666666667,7.47272727272727,7.5,7.25,7.88108108108108,8.40526315789474,8.35694444444444,8.17818181818182,7.64545454545454,8.6,7.78333333333333,5,8.57619047619048,7.85454545454546,7.64545454545454,7.475,7.58333333333333,7.95238095238095,8.52056074766355,8.43703703703704,8.264,8.34590163934426,9.1,4.4,7.26666666666667,7.4,5.95,8.36,7.55454545454545,8.11612903225806,3.65,5.9,7.51111111111111,7.075,6.14545454545454,6.63333333333333,8.2,4.15,5.25,7.2,4.5,7.80714285714286,7.73793103448276,8.1,8.25,7.71818181818182,7.2,7.3,8.60567375886525,8.7025641025641,7.29090909090909,7.8,7.15,7.53684210526316,7.29,8.30697674418605,8.66923076923077,7.63333333333333,8.125,6.8375,8.125,7.58571428571429,8.32,7.24285714285714,7.4,8.1,7.3,6.3,8.06,7.89,8.14,8.70769230769231,6.4,5.95,4.2,8.46,7.5,6.73888888888889,8.1,7.25333333333333,8.71076923076923,7.56666666666667,6.91666666666667,7.50123456790124,7.70416666666667,8.1037037037037,6.68333333333333,7.47619047619048,7.94285714285714,8.67941176470588,3.3625,6.7,8.94117647058824,8.25185185185185,8.545,8.66818181818182,8.2,6.9,6.225,5.97272727272727,8.65443786982248,8.72331606217617,8.94117647058824,7.89791666666667,7.44615384615385,8.02083333333333,9.06363636363636,7.44285714285714,8.23333333333333,7.42,6.7,7.025,7.16,7.80909090909091,6.75,7.25,6.7,7.45769230769231,5.8,7.14285714285714,6.63076923076923,6.4,5.67142857142857,8.08717948717949,7.95714285714286,3.55,5.96666666666667,7.64,8.33333333333333,7.60909090909091,7.13684210526316,5.725,8.38571428571429,8.28571428571429,8.45,7.16666666666667,8.16129032258065,8.29583333333333,7.9,7.63333333333333,7.76521739130435,7.62307692307692,7.8,6.83333333333333,5.6,7.70555555555555,7.975,6.4,7,5.46666666666667,6.86666666666667,8.6,6.55,7.55555555555555,8.63055555555556,4.15,7.5,5.58,3.11666666666667,7.71578947368421,7.15,8.03333333333333,6.85,6.5,8.40504201680672,5.92,4,7.46153846153846,8.94233870967742,3.7,7.88333333333333,7.7,7.225,8.4,4.95,6.16666666666667,6.9,5.6,6.375,7.65,4.03333333333333,5.76666666666667,6.0625,6.3,7.95,6.53333333333333,6.46666666666667,7.62142857142857,7.54444444444445,7.7,6.88571428571429,6.0625,6.0875,4.725,7.73333333333333,6.01111111111111,7.88828828828829,6.3,5.7,6.02857142857143,6.3,6.25,7.3,7.2,6.775,7.2125,6.6,8.36666666666667,6.5,8.225,6.22307692307692,5.02,6.81764705882353,5.87894736842105,7.2,7.64,7.53214285714286,7.86875,6.964,6.1,1,8.2,8.50761904761905,6.18333333333333,6.9,7.68571428571429,7.37,5.23333333333333,6.64,7.721875,6.15,7.03333333333333],"y":[7.7,8.6,4.9,3.2,6.1,7.2,6.8,6.5,6.5,6.4,6.6,7.5,8.6,7.8,7.2,7.5,6.3,3.4,4.1,7.1,6.3,7.6,6.8,5.3,6.8,7.1,5.4,6.1,7.6,4.2,6.2,5.8,7.1,6.7,3.4,6.8,6.9,7.2,6.7,6.3,7.7,8.5,3.2,6.8,8.4,6.2,8.2,1.1,7.1,7.4,7.1,8.1,5.1,4.1,7.1,5.2,6.4,5.8,0.2,3.1,5.4,6.8,1.2,7.6,7.8,5.4,6.9,6.4,1.2,7.4,7.8,6.5,6.1,6.4,7.2,7.1,7.2,8.3,7.1,6.8,6.1,7.4,5.9,7.2,7.1,7.2,8.3,6.8,6.4,6.6,7.5,7.5,6.5,8.3,7.5,8.9,1.9,7.5,7.9,6.6,8.1,7.8,7.2,7.9,6.8,6.8,6.2,7.2,7.6,8.1,6.8,7.4,4.2,4.2,6.8,2.2,7.4,3.3,6.4,5.9,7.4,4.8,2.5,7.1,7.1,5.9,8.1,7.4,4.8,7.2,7.7,7.8,6.3,9.3,7.9,3.4,7.8,7.7,8.2,7.9,8.2,7.2,6.2,6.9,7.6,8.1,9.3,7.4,7.8,8.2,6.4,2.4,7.1,5.8,4.8,5.5,7.9,6.6,5.1,6.9,8.1,8.9,6.9,2.2,8.1,7.4,9.4,7.5,7.4,8.1,6.7,5.4,8.3,8.2,3.2,3.2,6.2,3.4,5,7.8,5.6,7.2,5.9,7.3,7.8,8.2,8.6,7.4,6.1,7.3,8.1,7.2,6.3,7.2,7.9,8.1,7.8,8.6,7.4,6.7,7.4,6.6,8,6.8,7.8,6.7,7.9,7.9,9.1,8,6.9,8.7,7.4,6.2,7.4,1.7,6.8,7.3,8.3,8.6,2.4,6.1,8,5.8,5.1,6.2,7.4,4.8,7.4,5.8,5.9,8.5,8.1,7.4,7.3,6.2,8.1,4.2,8.6,8.1,7.2,8.1,4.8,8.2,7.3,8,8.4,6.6,7.1,7.3,7.7,7.5,9.3,8,7.4,8.6,7.2,5.9,6.2,7.6,10,8.2,6.8,3.8,6.1,8.2,6.9,6.7,6.6,5.8,9.1,7.74,6.8,9.2,8.2,9.2,5.2,7.1,6.7,8,2.4,6.2,8.5,7.5,9,9.4,8.5,6.6,6.4,6.4,8.8,8.5,9.2,7.4,8.2,8.4,9.1,6.2,6.6,7.3,6.9,6.1,7.1,7.8,6.7,7.7,6.2,8.4,1.8,4,7.2,7.9,6.5,8.5,7.9,7.1,6.2,8.1,8.3,8.1,8.1,6.2,7.6,7.9,7.7,7,9,8.5,7.2,7.7,8.1,8.2,6.8,7.1,3.7,8.4,8.1,6.3,7.1,5.8,2.1,7.3,6.4,6.4,9.3,3.1,4.8,4.1,4.1,8.1,3.6,7.1,5,4.8,8.4,6.1,6.3,8.4,9.1,8.1,7.8,7.7,4.6,6.9,6.9,6.2,6.9,1.7,1.4,6.9,4.2,6.2,7.8,6.6,7.4,7.3,6.3,7.3,7.4,7.9,7.3,6.6,6.7,6.4,7.1,7.8,8.2,7.7,7.9,5.4,5.2,4.3,5.7,6.6,6.2,7.8,6.8,8.6,8.4,8.1,5.1,4.9,7.5,7.4,6.2,6.8,7.1,8.1,7.4,5.7,0.08,8.1,9.3,2.8,6.8,7.9,7.7,5.9,3.9,8.2,6.8,8.2],"text":["Restaurant:  Pugsley's Pizza","Restaurant:  Williamsburg Pizza","Restaurant:  99 Cent Fresh Pizza","Restaurant:  La Gusto Pizza","Restaurant:  Cheesy Pizza","Restaurant:  Sal & Carmine's Pizza","Restaurant:  MAMA'S TOO!","Restaurant:  Bond 45","Restaurant:  Casa D'amici","Restaurant:  Pizza Al's","Restaurant:  Colasante's Ristorante & Pub","Restaurant:  Love & Dough","Restaurant:  Patsy's Pizzeria","Restaurant:  Louie & Ernie's Pizza","Restaurant:  Pizza Barn","Restaurant:  Mama's Pizza","Restaurant:  Dulono's Pizza","Restaurant:  Cheetah Pizza","Restaurant:  Fat Lorenzo's","Restaurant:  Red's Savoy Pizza","Restaurant:  Frank From Philly & Andrea Pizza","Restaurant:  Young Joni","Restaurant:  Cossetta Alimentari","Restaurant:  Pizza Luce","Restaurant:  Football Pizza","Restaurant:  Star Tavern","Restaurant:  LA Traviata Pizzeria","Restaurant:  Percy's Pizza","Restaurant:  Pizza Land","Restaurant:  Little Italy Pizza","Restaurant:  B & W Deli & Pizzeria","Restaurant:  Mediterraneo Restaurant","Restaurant:  La Bellezza Pizza","Restaurant:  Tre Sorelle","Restaurant:  Justino's Pizzeria","Restaurant:  Casabianca Pizzeria","Restaurant:  Mariella Pizza","Restaurant:  Bella Blu","Restaurant:  John & Tony's","Restaurant:  Il Forno Pizza","Restaurant:  Scarr's Pizza","Restaurant:  Double Zero","Restaurant:  Rico's Pizza","Restaurant:  Palermo's 95th","Restaurant:  Giordano's","Restaurant:  Gino's East - Magnificent Mile","Restaurant:  Lou Malnati's Pizzeria","Restaurant:  Georgio's Gourmet Pizza","Restaurant:  Armand's Pizzeria","Restaurant:  Pequod's Pizzeria","Restaurant:  Geo's Pizza","Restaurant:  Goodfellas Pizzeria","Restaurant:  BazbeauxPizza","Restaurant:  Napolese Pizzeria","Restaurant:  The Wig & Pen Pizza Pub","Restaurant:  Casey's General Store","Restaurant:  Bearno's By the Bridge","Restaurant:  The Original Impellizeri's Pizza","Restaurant:  The Post","Restaurant:  Cottage Inn Pizza - Ann Arbor","Restaurant:  New York Pizza Depot","Restaurant:  Pizza House","Restaurant:  Backroom Pizza","Restaurant:  Buddy's Pizza","Restaurant:  Leone's Pizza","Restaurant:  Adriatico's New York Style Pizza","Restaurant:  Sicilia Fine Italian Specialties","Restaurant:  The O Patio & Pub","Restaurant:  Catfish Biff's Pizza & Subs","Restaurant:  GoreMade Pizza","Restaurant:  Pies & Pints - Lexington","Restaurant:  Pazzo's Pizza Pub","Restaurant:  PieTana","Restaurant:  Bruno Bros Pizza","Restaurant:  Wedgewood Fernando's Pizza - Austintown","Restaurant:  Avalon Downtown Pizzeria","Restaurant:  Sparky's Pizzeria and Grill","Restaurant:  Black Sheep Pizza - Minneapolis","Restaurant:  Benny Marzano's","Restaurant:  Imperial Pizza","Restaurant:  Mellow Mushroom","Restaurant:  Marcello's Pizza & Subs","Restaurant:  Piu Bello Pizzeria Restaurant","Restaurant:  Buckhead Pizza","Restaurant:  Cosmo's Original Little Italy Pizza","Restaurant:  Fellini's Pizza","Restaurant:  Antico Pizza","Restaurant:  Slice Downtown","Restaurant:  Hawthorne's NY Pizza & Bar","Restaurant:  Pizza Joint","Restaurant:  Empire Slice House","Restaurant:  Santucci's Original Square Pizza","Restaurant:  Lorenzo & Sons Pizza","Restaurant:  Santillo's Brick Oven Pizza","Restaurant:  Kinchley's Tavern","Restaurant:  Ralph's Pizzeria","Restaurant:  Costco","Restaurant:  Pizza Town USA","Restaurant:  Brother's Pizzeria","Restaurant:  Mama Rosa Pizza and Pasta","Restaurant:  Denino's Pizzeria Tavern","Restaurant:  The New Park Tavern","Restaurant:  Vesta Wood Fired Pizza & Bar","Restaurant:  Lee's Tavern","Restaurant:  The Original Goodfella's Brick Oven Pizza","Restaurant:  Tony Boloney's","Restaurant:  Krispy Pizza","Restaurant:  Mario's Classic Pizza","Restaurant:  Johnny Pepperoni","Restaurant:  Basile's Pizza","Restaurant:  Benny Tudino's Pizzeria","Restaurant:  Napoli's Brick Oven Pizza","Restaurant:  Picasso Pizza","Restaurant:  Pomodoro Pizza","Restaurant:  SIMÒ PIZZA","Restaurant:  Steve's Pizza","Restaurant:  The Woodstock","Restaurant:  The Grotto Pizzeria & Ristorante","Restaurant:  Georgio Pizzeria","Restaurant:  Pranzo Pizza & Pasta","Restaurant:  Justino's Pizzeria","Restaurant:  Adrienne's Pizzabar","Restaurant:  Da Vinci Pizza","Restaurant:  Cucina Bene","Restaurant:  Majestic Pizza","Restaurant:  Underground Pizza","Restaurant:  Neapolitan Express","Restaurant:  Stage Door Pizza","Restaurant:  Friendly Gourmet Pizza","Restaurant:  Dona Bella Pizza","Restaurant:  Harry's Italian","Restaurant:  Adoro Lei","Restaurant:  Little Italy Pizza","Restaurant:  Lucali","Restaurant:  Il Mattone West Village","Restaurant:  5 Boroughs Pizza","Restaurant:  Serafina Meatpacking","Restaurant:  Phil's Pizza","Restaurant:  Saluggi's","Restaurant:  Artichoke Basille's Pizza","Restaurant:  Brunetti Pizza","Restaurant:  Emily - West Village","Restaurant:  Black Square Pizza","Restaurant:  Bleecker Street Pizza","Restaurant:  Enzo Bruni La Pizza Gourmet","Restaurant:  Famous Ben's Pizza","Restaurant:  John's of Bleecker Street","Restaurant:  Filaga Pizzeria","Restaurant:  Emmett's","Restaurant:  Numero 28 Pizzeria - West Village","Restaurant:  Kesté Pizza & Vino","Restaurant:  King's Pizza","Restaurant:  Eddie & Sam's NY Pizza","Restaurant:  Home Slice Pizza","Restaurant:  Big Lou's Pizza","Restaurant:  Pizzarita's","Restaurant:  Julian's Italian Pizzeria & Kitchen","Restaurant:  Napoli Pizza","Restaurant:  Biggie's Pizza","Restaurant:  Steve's Pizza","Restaurant:  Lucali","Restaurant:  Mister O1- South Beach","Restaurant:  Pizza Girls WPB","Restaurant:  Pizza Al Fresco","Restaurant:  Totonno's","Restaurant:  L & B Spumoni Gardens","Restaurant:  Di Fara Pizza","Restaurant:  Da Nonna Rosa","Restaurant:  Ciro's Pizzeria & Beerhouse","Restaurant:  Bronx Pizza","Restaurant:  Filippi's Pizza Grotto Pacific Beach","Restaurant:  Manhattan Pizzeria","Restaurant:  Joe's Pizza","Restaurant:  Vito's Pizza","Restaurant:  Bonanno's New York Pizzeria","Restaurant:  Bonanno's New York Pizzeria","Restaurant:  Five50 Pizza Bar","Restaurant:  Secret Pizza","Restaurant:  Snacks","Restaurant:  XS Nightclub","Restaurant:  Naked City Pizza Shop","Restaurant:  Good Pie","Restaurant:  Evel Pie","Restaurant:  Pizza Rock","Restaurant:  Acquolina","Restaurant:  Pope's Italian Restaurant","Restaurant:  Nove Italian Restaurant","Restaurant:  Mama Mia's Restaurant","Restaurant:  Marino's Pizza","Restaurant:  Gennaro's Pizza Parlor","Restaurant:  Caputo's Pizzeria","Restaurant:  Corner Slice","Restaurant:  Francesca's Restaurant & Pizzeria","Restaurant:  Café Crust","Restaurant:  Borrelli's","Restaurant:  King Umberto's of Elmont","Restaurant:  New Park Pizza","Restaurant:  Umberto's Pizzeria & Restaurant","Restaurant:  Dani's House of Pizza","Restaurant:  Rosa's Pizza","Restaurant:  Brooklyn's Homeslice Pizzeria","Restaurant:  Not Ray's Pizza","Restaurant:  Roberta's","Restaurant:  Little Vincent's Pizza","Restaurant:  Carmine's Pizzeria","Restaurant:  Sal's Pizzeria","Restaurant:  Tony's Pizza","Restaurant:  L'industrie Pizzeria","Restaurant:  Best Pizza","Restaurant:  Grimaldi's","Restaurant:  Juliana's Pizza","Restaurant:  Ignazio's","Restaurant:  La Nonna Krispy Krust Pizza","Restaurant:  Alphonso's Pizzeria & Trattoria","Restaurant:  Paulie Gee's Slice Shop","Restaurant:  Canal Pizza","Restaurant:  Melani Pizzeria","Restaurant:  Paulie Gee's","Restaurant:  Speedy Romeo","Restaurant:  Rizzo's Fine Pizza","Restaurant:  Stanton Pizza","Restaurant:  Solo Pizza","Restaurant:  La Margarita Pizza","Restaurant:  Luna Ristorante","Restaurant:  Rosario's Pizza","Restaurant:  Da Gennaro","Restaurant:  Margherita NYC","Restaurant:  Yankee Pizza","Restaurant:  Il Piccolo Bufalo","Restaurant:  Da Nico Ristorante","Restaurant:  Little Gio's Pizza","Restaurant:  Lil' Frankie's","Restaurant:  Sal's Little Italy","Restaurant:  Gnocco","Restaurant:  Pasquale Jones","Restaurant:  Lombardi's Pizza","Restaurant:  Champion Pizza","Restaurant:  Pomodoro Ristorante & Pizzeria","Restaurant:  Prince Street Pizza","Restaurant:  Rubirosa","Restaurant:  Proto's Pizza","Restaurant:  310 Bowery Bar","Restaurant:  La Rossa","Restaurant:  Stromboli Pizza","Restaurant:  Baker's Pizza","Restaurant:  East Village Pizza","Restaurant:  Joe & Pat's Pizzeria","Restaurant:  Muzzarella Pizza","Restaurant:  Sorbillo Pizzeria","Restaurant:  Joey's Pizzeria","Restaurant:  Pizza Barbone","Restaurant:  Palio Pizzeria","Restaurant:  Oath Pizza - Nantucket","Restaurant:  Steamboat Wharf Pizza","Restaurant:  Fusaro's","Restaurant:  Pi Pizzeria","Restaurant:  Sophie T's Pizza","Restaurant:  Muse Pizza","Restaurant:  Moto Pizza","Restaurant:  Poopsie's","Restaurant:  Monte's Restaurant","Restaurant:  Bianchi's Pizza","Restaurant:  Giordano's Restaurant","Restaurant:  Slice Of Edgartown","Restaurant:  Isola","Restaurant:  Santarpio's Pizza","Restaurant:  Rocco's Pizzeria","Restaurant:  Rinas Pizzeria & Cafe","Restaurant:  Galleria Umberto","Restaurant:  Pushcart Pizzeria","Restaurant:  Regina Pizzeria","Restaurant:  Ducali","Restaurant:  1000 Degrees Neapolitan Pizzeria","Restaurant:  Halftime Pizza","Restaurant:  Florina Pizzeria & Paninoteca","Restaurant:  Rosie's Subs and Pizza","Restaurant:  Felcaro Pizzeria","Restaurant:  Dirty Water Dough","Restaurant:  Eataly Boston","Restaurant:  Lynwood Cafe","Restaurant:  Fenway Park","Restaurant:  Baldie's Pizza & Subs","Restaurant:  Cape Cod Cafe","Restaurant:  Louie's Pizza","Restaurant:  Town Spa Pizza","Restaurant:  Frank Pepe Pizzeria Napoletana - Chestnut Hill","Restaurant:  Tony's Place","Restaurant:  Chilmark General Store","Restaurant:  Bill's Pizzeria Kitchen + Grille","Restaurant:  Regina Pizzeria","Restaurant:  Modern Apizza","Restaurant:  Frank Pepe Pizzeria Napoletana","Restaurant:  Sally's Apizza","Restaurant:  BAR","Restaurant:  Riko's Pizza","Restaurant:  Colony Grill","Restaurant:  Johnny's Pizzeria","Restaurant:  Full Moon Pizzeria","Restaurant:  Nick's Pizza","Restaurant:  Pie Pie Pizza","Restaurant:  Mama's Pizzeria","Restaurant:  PQR","Restaurant:  Vinnie's Pizzeria","Restaurant:  Salvo's Pizzabar","Restaurant:  La Mia Pizza","Restaurant:  Italian Village Pizzeria","Restaurant:  Broadway Pizza & Restaurant","Restaurant:  Saba's Pizza","Restaurant:  Cafe Viva","Restaurant:  Pizza Park","Restaurant:  Pizza Pete's","Restaurant:  Manhattan Brick Oven Pizza","Restaurant:  Oath Pizza - East 67th Street","Restaurant:  Brooklyn Pizza Masters","Restaurant:  Made In New York Pizza","Restaurant:  Kiss My Slice","Restaurant:  Farinella Bakery Pizza","Restaurant:  Cafe Daniello's","Restaurant:  Gato","Restaurant:  Freddie & Pepper's","Restaurant:  Francesco's Pizzeria","Restaurant:  Iggy's Pizzeria","Restaurant:  Motorino","Restaurant:  Arturo's","Restaurant:  Song E Napule","Restaurant:  Fiore's Pizza","Restaurant:  Denino's Greenwich Village","Restaurant:  Joe's Pizza","Restaurant:  Cafe Fiorello","Restaurant:  Sfila Pizza","Restaurant:  Sacco Pizza","Restaurant:  Merilu Pizza Al Metro","Restaurant:  Bricco Ristorante Italiano","Restaurant:  New York Sal's Pizza","Restaurant:  Mariella Pizza","Restaurant:  Luigi's Pizza","Restaurant:  Luigi's Gourmet Grill","Restaurant:  B Side Pizza & Wine Bar","Restaurant:  Uncle Mario's Brick Oven Pizza","Restaurant:  Bella Vita Pizzeria","Restaurant:  IPizzaNY","Restaurant:  Serafina Broadway","Restaurant:  Claudio Pizzeria","Restaurant:  Don Antonio","Restaurant:  Angelo's Coal Oven Pizzeria","Restaurant:  Z Deli Pizzeria","Restaurant:  Pazza Notte","Restaurant:  Carve","Restaurant:  A Slice of New York","Restaurant:  PizzArte","Restaurant:  Daniela Trattoria","Restaurant:  Capizzi","Restaurant:  Patzeria Perfect Pizza","Restaurant:  Pasta Lovers","Restaurant:  John's of Times Square","Restaurant:  Radio City Pizza","Restaurant:  Tavola","Restaurant:  Vinny Vincenz","Restaurant:  Sauce Pizzeria","Restaurant:  Pisa Pizza","Restaurant:  Frank's Trattoria","Restaurant:  Pepe Giallo","Restaurant:  Don Giovanni Ristorante","Restaurant:  Ovest Pizzoteca by Luzzo's","Restaurant:  10th Avenue Pizza & Cafe","Restaurant:  Stella's Pizza","Restaurant:  Gotham Pizza","Restaurant:  Highline Pizza","Restaurant:  Rocky's Pizza 14th St","Restaurant:  Village Pizza","Restaurant:  Pizza Italia","Restaurant:  Famous Original Ray's Pizza","Restaurant:  Rivoli Pizza","Restaurant:  Pizza Rollio","Restaurant:  Rosemary's Pizza","Restaurant:  Teresa's Brick Oven Pizza & Cafe","Restaurant:  Kiss My Slice","Restaurant:  Harry's Italian Pizza Bar","Restaurant:  Upside Pizza","Restaurant:  Sofia Pizza Shoppe","Restaurant:  Marinara Pizza","Restaurant:  Cassiano's Pizza","Restaurant:  Primavera Pizza & Pasta","Restaurant:  Belmora Pizza & Restaurant","Restaurant:  Zia Maria-Chelsea","Restaurant:  Joe's Pizza","Restaurant:  NY Pizza Suprema","Restaurant:  3 Giovani","Restaurant:  Rock Pizza Scissors","Restaurant:  Ben's Pizzeria","Restaurant:  Olio e Piú","Restaurant:  My Pie Pizzeria Romana","Restaurant:  Angelo Bellini","Restaurant:  Pizza By Certé","Restaurant:  La Vera Pizzeria & Restaurant","Restaurant:  La Bellezza","Restaurant:  La Trattoria","Restaurant:  Patsy's Pizzeria","Restaurant:  Picciotto NYC","Restaurant:  Jiannetto's Pizza Truck","Restaurant:  Uncle Paul's Pizza","Restaurant:  Previti Pizza","Restaurant:  Royal Pizza","Restaurant:  Prova Pizzabar","Restaurant:  Giuseppe's Pizza","Restaurant:  Garlic New York Pizza Bar","Restaurant:  Lions & Tigers & Squares Detroit Pizza","Restaurant:  Lombardi's pizza","Restaurant:  Famous Famiglia Pizzeria","Restaurant:  Famous Amadeus Pizza","Restaurant:  Amtrak","Restaurant:  Nicoletta Pizzeria","Restaurant:  Lazzara's Pizza","Restaurant:  Rocky's Number II","Restaurant:  Posto","Restaurant:  Patrizia's Pizza and Pasta","Restaurant:  Mike's Pizza","Restaurant:  Joey Pepperoni's Pizza","Restaurant:  Libretto's Pizzeria","Restaurant:  Brick Oven Pizza 33","Restaurant:  J's Pizza","Restaurant:  Rocco's Pizza Joint"],"type":"scatter","mode":"markers","marker":{"color":"rgba(31,119,180,1)","line":{"color":"rgba(31,119,180,1)"}},"error_y":{"color":"rgba(31,119,180,1)"},"error_x":{"color":"rgba(31,119,180,1)"},"line":{"color":"rgba(31,119,180,1)"},"xaxis":"x","yaxis":"y","frame":null}],"highlight":{"on":"plotly_click","persistent":false,"dynamic":false,"selectize":false,"opacityDim":0.2,"selected":{"opacity":1},"debounce":0},"shinyEvents":["plotly_hover","plotly_click","plotly_selected","plotly_relayout","plotly_brushed","plotly_brushing","plotly_clickannotation","plotly_doubleclick","plotly_deselect","plotly_afterplot","plotly_sunburstclick"],"base_url":"https://plot.ly"},"evals":[],"jsHooks":[]}</script>

``` r
plot_ly(d2, x = ~crit_score, y = ~dave_score, text = ~paste('Restaurant: ', name))
```

    ## No trace type specified:
    ##   Based on info supplied, a 'scatter' trace seems appropriate.
    ##   Read more about this trace type -> https://plotly.com/r/reference/#scatter
    ## No scatter mode specifed:
    ##   Setting the mode to markers
    ##   Read more about this attribute -> https://plotly.com/r/reference/#scatter-mode

<div id="htmlwidget-3" style="width:672px;height:480px;" class="plotly html-widget"></div>
<script type="application/json" data-for="htmlwidget-3">{"x":{"visdat":{"8f1869b42b21":["function () ","plotlyVisDat"]},"cur_data":"8f1869b42b21","attrs":{"8f1869b42b21":{"x":{},"y":{},"text":{},"alpha_stroke":1,"sizes":[10,100],"spans":[1,20]}},"layout":{"margin":{"b":40,"l":60,"t":25,"r":10},"xaxis":{"domain":[0,1],"automargin":true,"title":"crit_score"},"yaxis":{"domain":[0,1],"automargin":true,"title":"dave_score"},"hovermode":"closest","showlegend":false},"source":"A","config":{"modeBarButtonsToAdd":["hoverclosest","hovercompare"],"showSendToCloud":false},"data":[{"x":[8.8,4.3,6.2,4.5,5.8,8.7,8,5,4,7.9,6.6,6,7,9.4,7.2,6.5,10,6.8,7.4,8,8,10,6.31,8.1,7,7.6,8.5,4.8,8.1,5,5.4,6.76,10,9,5,7.76,5.5,7.2,6.5,6.8,10,8.5,8,6.7,8.5,7.8,9.3,9.8,11,5.96,5.1,7.3,7.8,7,7,6.9,5.7,9.4,5.9,7.3,6.5,7],"y":[7.7,6.9,6.5,6.3,4.1,7.1,6.3,5.4,6.1,7.1,5.8,6.7,1.2,4.1,6.4,5.8,7.4,5.9,7.2,4.2,4.2,7.1,4.8,7.7,6.3,7.7,6.4,6.6,8.1,5,5.4,1.7,6.8,7.4,4.2,8.2,6.4,6.6,6.1,7.1,6.7,7.9,8.1,7.9,7.7,7.7,8.2,6.8,7.3,6.4,3.6,5,8.4,6.1,6.3,6.6,5.7,8.1,6.1,7.4,6.2,6.8],"text":["Restaurant:  Pugsley's Pizza","Restaurant:  Nino's 46","Restaurant:  Bond 45","Restaurant:  Dulono's Pizza","Restaurant:  Fat Lorenzo's","Restaurant:  Red's Savoy Pizza","Restaurant:  Frank From Philly & Andrea Pizza","Restaurant:  LA Traviata Pizzeria","Restaurant:  Percy's Pizza","Restaurant:  Re Sette","Restaurant:  Mediterraneo Restaurant","Restaurant:  Tre Sorelle","Restaurant:  Buca di Beppo Italian Restaurant","Restaurant:  Napolese Pizzeria","Restaurant:  Bearno's By the Bridge","Restaurant:  The Original Impellizeri's Pizza","Restaurant:  Marcello's Pizza & Subs","Restaurant:  Piu Bello Pizzeria Restaurant","Restaurant:  Buckhead Pizza","Restaurant:  Picasso Pizza","Restaurant:  Pomodoro Pizza","Restaurant:  Majestic Pizza","Restaurant:  Friendly Gourmet Pizza","Restaurant:  Harry's Italian","Restaurant:  Little Italy Pizza","Restaurant:  Phil's Pizza","Restaurant:  Kesté Pizza & Vino","Restaurant:  Napoli Pizza","Restaurant:  Lucali","Restaurant:  Snacks","Restaurant:  42nd Street Pizza","Restaurant:  Canal Pizza","Restaurant:  Melani Pizzeria","Restaurant:  Il Piccolo Bufalo","Restaurant:  Pomodoro Ristorante & Pizzeria","Restaurant:  Santarpio's Pizza","Restaurant:  Regina Pizzeria","Restaurant:  Nick's Pizza","Restaurant:  PQR","Restaurant:  Vinnie's Pizzeria","Restaurant:  La Mia Pizza","Restaurant:  Manhattan Brick Oven Pizza","Restaurant:  Francesco's Pizzeria","Restaurant:  Arturo's","Restaurant:  Song E Napule","Restaurant:  Sfila Pizza","Restaurant:  Merilu Pizza Al Metro","Restaurant:  Bricco Ristorante Italiano","Restaurant:  Serafina Broadway","Restaurant:  Don Antonio","Restaurant:  Daniela Trattoria","Restaurant:  Patzeria Perfect Pizza","Restaurant:  John's of Times Square","Restaurant:  Radio City Pizza","Restaurant:  Kiss My Slice","Restaurant:  Cassiano's Pizza","Restaurant:  Angelo Bellini","Restaurant:  Jiannetto's Pizza Truck","Restaurant:  Deli On Madison","Restaurant:  Prova Pizzabar","Restaurant:  Giuseppe's Pizza","Restaurant:  Posto"],"type":"scatter","mode":"markers","marker":{"color":"rgba(31,119,180,1)","line":{"color":"rgba(31,119,180,1)"}},"error_y":{"color":"rgba(31,119,180,1)"},"error_x":{"color":"rgba(31,119,180,1)"},"line":{"color":"rgba(31,119,180,1)"},"xaxis":"x","yaxis":"y","frame":null}],"highlight":{"on":"plotly_click","persistent":false,"dynamic":false,"selectize":false,"opacityDim":0.2,"selected":{"opacity":1},"debounce":0},"shinyEvents":["plotly_hover","plotly_click","plotly_selected","plotly_relayout","plotly_brushed","plotly_brushing","plotly_clickannotation","plotly_doubleclick","plotly_deselect","plotly_afterplot","plotly_sunburstclick"],"base_url":"https://plot.ly"},"evals":[],"jsHooks":[]}</script>

So apparently the lousy restaurant that got a 1 from the community and almost 0 from Dave is called *Amtrak*. I’m wondering if that refers to pizza on Amtrak trains? Just for the heck of it and because I’m curious, let’s look at that entry.

``` r
d2 %>% filter(name == "Amtrak") %>% knitr::kable()
```

| name   | address1      | city     |   zip | country | latitude | longitude | price_level | provider_rating | provider_review_count | review_stats_all_average_score | review_stats_all_count | review_stats_all_total_score | review_stats_community_average_score | review_stats_community_count | review_stats_community_total_score | review_stats_critic_average_score | review_stats_critic_count | review_stats_critic_total_score | review_stats_dave_average_score | review_stats_dave_count | review_stats_dave_total_score | comm_score | crit_score | dave_score |
|:-------|:--------------|:---------|------:|:--------|---------:|----------:|------------:|----------------:|----------------------:|-------------------------------:|-----------------------:|-----------------------------:|-------------------------------------:|-----------------------------:|-----------------------------------:|----------------------------------:|--------------------------:|--------------------------------:|--------------------------------:|------------------------:|------------------------------:|-----------:|-----------:|-----------:|
| Amtrak | 234 W 31st St | New York | 10001 | US      | 40.74965 |  -73.9934 |           0 |               3 |                   345 |                           0.54 |                      2 |                         1.08 |                                    1 |                            1 |                                  1 |                                 0 |                         0 |                               0 |                            0.08 |                       1 |                          0.08 |          1 |         NA |       0.08 |

I googled the address, and it seems to be indeed Amtrak. Note to self: Never order pizza on an Amtrak train.

# Price vs ratings analysis

Next, let’s look at possible impact of restaurant price level on rating.

``` r
table(d2$price_level)
```

    ## 
    ##   0   1   2   3 
    ##  21 216 218   8

There isn’t much spread, most pizza places are in the middle. Maybe not too surprising. Let’s look at a few plots to see if there is a pattern. First, we should recode price level as a factor.

``` r
d2 <- d2 %>% mutate(price = as.factor(price_level))
```

``` r
p1 <- d2 %>% ggplot(aes(x=price, y=comm_score)) + geom_violin() + geom_point()
p2 <- d2 %>% ggplot(aes(x=price, y=crit_score)) + geom_violin() + geom_point()
p3 <- d2 %>% ggplot(aes(x=price, y=dave_score)) + geom_violin() + geom_point()
cowplot::plot_grid(p1, p2, p3, labels = c('A', 'B','C'), label_size = 12)
```

<img src="{{< blogdown/postref >}}index_files/figure-html/price-plot-1.png" width="672" />

Hard to tell if there’s a trend. Could do some stats to look in more detail, but since this exercise focuses on exploring, I won’t do that. Instead I’ll leave it at that.

# Rating versus location

Ok, on to the last of the questions I started out with. Maybe there are some areas where restaurants are in general better? Or maybe an area where diners are more critical? Let’s see if there is some correlation between ratings and location.

``` r
table(d2$country)
```

    ## 
    ##  US 
    ## 463

``` r
sort(table(d2$city))
```

    ## 
    ##         Alpharetta            Augusta             Austin         Austintown 
    ##                  1                  1                  1                  1 
    ##         Blacksburg          Braintree           Brockton            Buffalo 
    ##                  1                  1                  1                  1 
    ##         Charleston          Charlotte      Chestnut Hill           Chilmark 
    ##                  1                  1                  1                  1 
    ##         Clearwater            Clifton         Coralville      Daytona Beach 
    ##                  1                  1                  1                  1 
    ##           Dearborn        Dennis Port              DUMBO        East Meadow 
    ##                  1                  1                  1                  1 
    ##              Edina          Elizabeth             Elmont         Gansevoort 
    ##                  1                  1                  1                  1 
    ##               Gary       Hampton Bays          Hopkinton       Howard Beach 
    ##                  1                  1                  1                  1 
    ##         Huntington          Iowa City            Jackson Jacksonville Beach 
    ##                  1                  1                  1                  1 
    ##        Jersey City        Kew Gardens          Lakeville      Lawrenceville 
    ##                  1                  1                  1                  1 
    ##               Lynn    Manhattan Beach       Mashantucket              Miami 
    ##                  1                  1                  1                  1 
    ##     Middle Village       Mount Vernon      New Hyde Park      New York City 
    ##                  1                  1                  1                  1 
    ##    North Arlington             Nutley         Oak Bluffs           Oak Lawn 
    ##                  1                  1                  1                  1 
    ##      Oklahoma City             Orange         Palm Beach           Pembroke 
    ##                  1                  1                  1                  1 
    ##          Princeton             Ramsey           Randolph             Revere 
    ##                  1                  1                  1                  1 
    ##         Rutherford      San Francisco           Sandwich        Southampton 
    ##                  1                  1                  1                  1 
    ##          Stoughton              Tampa     Vineyard Haven     West Melbourne 
    ##                  1                  1                  1                  1 
    ##    West Palm Beach       West Roxbury             Woburn            Yonkers 
    ##                  1                  1                  1                  1 
    ##    East Rutherford          Edgartown       Elmwood Park            Hyannis 
    ##                  2                  2                  2                  2 
    ##        Miami Beach       Philadelphia         Saint Paul       Santa Monica 
    ##                  2                  2                  2                  2 
    ##           Stamford              Bronx       Indianapolis          Lexington 
    ##                  2                  3                  3                  3 
    ##         Morgantown        San Antonio          San Diego          Ann Arbor 
    ##                  3                  3                  3                  4 
    ##         Louisville          New Haven      Staten Island         Youngstown 
    ##                  4                  4                  4                  4 
    ##            Atlanta            Chicago           Columbus            Hoboken 
    ##                  6                  6                  6                  6 
    ##          Nantucket   Saratoga Springs        Minneapolis          Las Vegas 
    ##                  6                  6                  8                 11 
    ##             Boston           Brooklyn           New York 
    ##                 13                 20                251

Ok so all restaurants are in the US, and most are in New York. We could look at NY versus “rest of the cities”. Though isn’t Brooklyn (the 2nd largest entry) basically a part of New York? I’m not enough of an expert on all things NY to be sure (**for any real analysis, you need to know a good bit about the subject matter, or work closely with a subject matter expert. If not, more likely than not something dumb will happen**).

For now, I assume that it’s different enough, and make 2 categories, NY and “other” and see if there are differences. Let’s try.

``` r
p1 <- d2 %>% dplyr::mutate(newcity = forcats::fct_lump(city, n = 1)) %>%
              ggplot(aes(x=newcity, y = comm_score)) + geom_violin() + geom_point()
p2 <- d2 %>% dplyr::mutate(newcity = forcats::fct_lump(city, n = 1)) %>%
              ggplot(aes(x=newcity, y = crit_score)) + geom_violin() + geom_point()
p3 <- d2 %>% dplyr::mutate(newcity = forcats::fct_lump(city, n = 1)) %>%
              ggplot(aes(x=newcity, y = dave_score)) + geom_violin() + geom_point()
cowplot::plot_grid(p1, p2, p3, labels = c('A', 'B','C'), label_size = 12)
```

<img src="{{< blogdown/postref >}}index_files/figure-html/plot-location-1.png" width="672" />

Looks like the community in NY gives lower scores compared to other locations, less noticeable difference for critics and Dave.

Ok, the next analysis might not make much sense, but why not check if there is a North-South or East-West trend related to ratings. Maybe restaurants are better in one of those directions? Or people in the South are more polite and give better scores? 😁. I’m mostly doing this because longitude and latitude are continuous variables, so I can make a few more scatterplots. I don’t have any real goal for this otherwise.

``` r
p1 <- d2 %>%  ggplot(aes(x=longitude, y = comm_score)) + geom_point() + geom_smooth(method = 'lm')
p2 <- d2 %>%  ggplot(aes(x=longitude, y = crit_score)) + geom_point() + geom_smooth(method = 'lm')
p3 <- d2 %>%  ggplot(aes(x=longitude, y = dave_score)) + geom_point() + geom_smooth(method = 'lm')
cowplot::plot_grid(p1, p2, p3, labels = c('A', 'B','C'), label_size = 12)
```

    ## `geom_smooth()` using formula 'y ~ x'
    ## `geom_smooth()` using formula 'y ~ x'
    ## `geom_smooth()` using formula 'y ~ x'

<img src="{{< blogdown/postref >}}index_files/figure-html/plot-longitude-1.png" width="672" />

So as we go from the west (-120) to the east (-70), there is a trend in restaurants getting higher scores, by all 3 groups. I guess as we are moving closer to Italy, the pizza quality goes up? 😃.

Next, let’s look at latitude.

``` r
p1 <- d2 %>%  ggplot(aes(x=latitude, y = comm_score)) + geom_point() + geom_smooth(method = 'lm')
p2 <- d2 %>%  ggplot(aes(x=latitude, y = crit_score)) + geom_point() + geom_smooth(method = 'lm')
p3 <- d2 %>%  ggplot(aes(x=latitude, y = dave_score)) + geom_point() + geom_smooth(method = 'lm')
cowplot::plot_grid(p1, p2, p3, labels = c('A', 'B','C'), label_size = 12)
```

    ## `geom_smooth()` using formula 'y ~ x'
    ## `geom_smooth()` using formula 'y ~ x'
    ## `geom_smooth()` using formula 'y ~ x'

<img src="{{< blogdown/postref >}}index_files/figure-html/plot-latitude-1.png" width="672" />

So doesn’t seem as much of a trend going from South (25) to North (45). That finding of course fully confirms our “closer to Italy” theory!

Ok, I was going to leave it at that with location, but since I’m already going down a crazy rabbit hole regarding Italy, let’s do it for real: We’ll take both longitude and latitude of each restaurant and use it compute the distance of each location to Naples, the home of Pizza. And then we’ll plot that and see.

Since I have no idea how to do that, I need Google. Fortunately, the first hit worked, found this one:
https://stackoverflow.com/questions/32363998/function-to-calculate-geospatial-distance-between-two-points-lat-long-using-r

Let’s try.

``` r
coord_naples=cbind(rep(14.2,nrow(d2)),rep(40.8,nrow(d2)))  #location of naples
coord_restaurants = cbind(d2$longitude,d2$latitude)
distvec = rep(0,nrow(d2))
for (n in 1:nrow(d2))
{
  distvec[n] = distm( coord_restaurants[n,], coord_naples[n,], fun = distGeo)
}
d2$distvec = distvec / 1609 #convert to miles since we are in the US :)
```

It’s not tidyverse style, which I tried first but couldn’t get it to work. The trusty old for-loop seems to always work for me. I checked the numbers in distvec, they look reasonable.

Ok, let’s redo the plots above, now with distance to Naples.

``` r
p1 <- d2 %>%  ggplot(aes(x=distvec, y = comm_score)) + geom_point() + geom_smooth(method = 'lm')
p2 <- d2 %>%  ggplot(aes(x=distvec, y = crit_score)) + geom_point() + geom_smooth(method = 'lm')
p3 <- d2 %>%  ggplot(aes(x=distvec, y = dave_score)) + geom_point() + geom_smooth(method = 'lm')
cowplot::plot_grid(p1, p2, p3, labels = c('A', 'B','C'), label_size = 12, nrow = 3)
```

    ## `geom_smooth()` using formula 'y ~ x'
    ## `geom_smooth()` using formula 'y ~ x'
    ## `geom_smooth()` using formula 'y ~ x'

<img src="{{< blogdown/postref >}}index_files/figure-html/plot-naples-distance-1.png" width="672" />

Hm ok, no smoking gun. Looks like there is a bit of a trend that the further away you are from Naples, the lower the score. But really not much.

# Hyping our result

But since this distance-from-Naples makes such a good story, let’s see if I can hype it.

First, to increase potential statistical strength, I’ll combine all 3 scores into an overall mean, i.e. similar ot the `all` variable in the original. I don’t trust that one since I don’t know if they averaged over 0 instead of properly treating it as NA. Of course I could check, but I’m just re-creating it here.

``` r
d2$all_score = rowMeans(cbind(d2$dave_score,d2$crit_score,d2$comm_score),na.rm=TRUE)
```

Ok, let’s check if correlation between this new score and distance is *significant!*

``` r
#compute a linear fit and p-value (it's significant!)
fit=lm(d2$all_score ~ d2$distvec, data = d2)
summary(fit)
```

    ## 
    ## Call:
    ## lm(formula = d2$all_score ~ d2$distvec, data = d2)
    ## 
    ## Residuals:
    ##     Min      1Q  Median      3Q     Max 
    ## -6.7854 -0.5866  0.3027  0.9612  2.3686 
    ## 
    ## Coefficients:
    ##               Estimate Std. Error t value Pr(>|t|)    
    ## (Intercept)  8.9895014  0.7008802  12.826  < 2e-16 ***
    ## d2$distvec  -0.0004772  0.0001525  -3.129  0.00187 ** 
    ## ---
    ## Signif. codes:  0 '***' 0.001 '**' 0.01 '*' 0.05 '.' 0.1 ' ' 1
    ## 
    ## Residual standard error: 1.478 on 459 degrees of freedom
    ##   (2 observations deleted due to missingness)
    ## Multiple R-squared:  0.02089,    Adjusted R-squared:  0.01875 
    ## F-statistic: 9.791 on 1 and 459 DF,  p-value: 0.001865

``` r
pval=anova(fit)$`Pr(>F)`[1]
print(pval)
```

    ## [1] 0.001865357

It is signficant, p\<0.05! We hit pay dirt! Let’s make a great looking figure and go tell the press!

``` r
#make final plot
p1 <- d2 %>%  ggplot(aes(x=distvec, y = all_score)) + geom_point(shape = 21, colour = "black", fill = "red",  size = 2 ) + geom_smooth(method = 'lm', se = TRUE, color = "darkgreen", size = 2) + xlab('Distance from Naples (miles)') + ylab('Pizza Quality (score)') + ylim(c(2.5,max(d2$all_score))) + theme_bw() +theme(axis.text=element_text(size=12), axis.title=element_text(size=14,face="bold")) + annotate("text", x=6000, y=9, label= paste("p =",round(pval,4)),size = 12) 
ggsave('pizzadistance.png')
knitr::include_graphics("pizzadistance.png")
```

<img src="pizzadistance.png" width="1050" />

# The “press release”

A novel study of pizza restaurants in the US found a clear, statistically significant correlation between the distance of the restaurant to Naples and the quality of the pizza as determined by the community and expert restaurant critics. The study authors attribute the finding to the ability of restaurants that are closer to Naples to more easily get genuine fresh and high quality ingredients, such as the famous San Marzano tomatoes.

<img src="pizzadistance.png" width="1050" style="display: block; margin: auto;" />

# Summary

That was a fun exploration. It was the first time I played with the tidyverse data. I had no idea which direction it was going to go, and ideas just came as I was doing it. I’m sure there is interesting stuff in datasets 1 and 3 as well, but I already spent several hours on this and will therefore call it quits now.

While the exercise was supposed to focus on cleaning/wrangling and visualizing, I couldn’t resist going all the way at the end and producing a **statistically significant** and **somewhat plausible sounding** finding. If this were a “real” study/analysis, such a nice result would be happily accepted by most analysts/authors, hyped by a university press release and - if the result is somewhat interesting/cute, picked up by various media outlets.

I had no idea at the beginning what I was going to analyze, I did that longitude/latitude analysis on a whim, and if I hadn’t found this correlation and had that crazy *distance to Italy* idea, nothing would have happened. But now that I have a **significant** result and a good story to go with, I can publish! It’s not really much sillier than for instance the [Chocolate and Nobel Laureates paper](https://www.nejm.org/doi/full/10.1056/NEJMon1211064) paper.

What I illustrated here (without having had any plan to do so), is a big, general problem in secondary data analysis. It’s perfectly ok to do secondary analyses, and computing significance is also (kinda) ok, but selling exploratory (fishing) results as inferential/causal/confirmatory is wrong - and incredibly widespread. If you want to sharpen your critical thinking skills related to all those supposed significant and *real* findings in science we see a lot, a great (though at times sobering) read is [Andrew Gelman’s blog](https://statmodeling.stat.columbia.edu/) where he regularly picks apart studies/results like the one I did here or the chocolate and Nobel laureates one. And now I’ll go eat some chocolate so I can increase my chances for a Nobel prize.
