# Todo

* Update this document to reflect move to Quarto.
* Fix logos on project page

# Notes 

## General
* Some information that applies to this site and handelgroup is not repeated here, see the handelgroup notes file.

* It seems that qmd sites can't handle the weaving of code with markdown using the read_chunk setup. They ignore eval=FALSE and run stuff anyway. Might need to run those as Rmd files until fixed.


## Needed R packages
This is a hopefully complete list of all R packages needed to recompile all the posts of the website:

install.packages(c('cowplot','geosphere','scholar','wordcloud','bibliometrix','tidytext','visdat','kableExtra','janitor','ggplot2','dplyr','stringr','tidytuesdayR','readr','emoji',"rethinking","cmdstanr","brms"))


## Customization


## Website Logo
* Save your icon as a square 512x512 pixel image named icon.png and place the image in your root assets/images/ folder, creating the assets and images folders if they don't already exist. (https://sourcethemes.com/academic/docs/customization/)
* To show logo on site, place icon/logo in assets/images and/or assets/media


## Rmarkdown vs Rmd
For math to render properly, one needs to use Rmd files (see e.g. here: https://github.com/wowchemy/wowchemy-hugo-themes/issues/870)
Otherwise, there is a recommendation to use Rmarkdown instead of Rmd.

https://github.com/rstudio/blogdown/issues/530
https://masalmon.eu/2020/02/29/hugo-maintenance/
https://bookdown.org/yihui/blogdown/output-format.html



## To deploy site
Run this quarto build/publish command on console:

quarto publish netlify

This should automatically try to connect to Netlify and publish.

No automated building from Github at this point, need to rebuild with quarto, then run quarto command to push updates to Netlify.


## To implement commenting
I'm using utterances, implemented by installing utterances into github folder and adding comments.html into the layouts/partials folder
https://mscipio.github.io/post/utterances-comment-engine/
https://masalmon.eu/2019/10/02/disqus/
https://www.davidfong.info/post/hugoacademiccommentswithutterances/



## Change footer



## Ideas for new posts/content



### Science/Research

* Reading/managing/publishing papers: turn my presentation and my text on the 'teaching-research-resources' list into a blog post.

Blog post discussing stats vs mechanistic models and non-parametric vs parametric (how they are somewhat similar, one trades off power for assumptions). Almost like a bias variance trade-off.



### Teaching/Tech

Review of my technology stack for online courses
  * Github
  * Slack
  * gradingapp

* Experiences teaching a course using Github organization versus not.
  
* gh_class package to manage class with github and my experience using github for teaching: workflow, exercises

* conceptual thought of usefulness of certain teaching aids like metaphors/examples/jokes that might confuse-enlighten or disengage-engage

* quizgrader description


### Others

* See "started blog posts": staying mentally in good shape in grad school (and in general). comparing mental exercise/meditation to physical exercise, where do analogies work and where do they not.

* epidemiological biases and "learn from experts" literature (e.g. tim ferriss books)
