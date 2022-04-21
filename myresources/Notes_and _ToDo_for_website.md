# Todo

* The talk pages don't display the date and location. Not sure how to fix.
* Fix logos on project page, update project page.
* Have talks and blog posts show not just updated date but also creation date.


# Notes 

## General
* Some information that applies to this site and handelgroup is not repeated here, see the handelgroup notes file.

## Needed R packages
This is a hopefully complete list of all R packages needed to recompile all the posts of the website:

install.packages(c('cowplot','geosphere','scholar','wordcloud','bibliometrix','tidytext','visdat','kableExtra','janitor','ggplot2','dplyr','stringr','tidytuesdayR','readr','emoji',"rethinking","cmdstanr","brms"))


## Customization
* Edit config.yaml to update website name and title and uRL, etc.
* Edit params.yaml to include google analytics, set twitter

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
Run build_site(). This command keeps changing, might need to manually build Rmarkdown to markdown.
push to github. Netlify will automatically build and serve site.


## To implement commenting
I'm using utterances, implemented by installing utterances into github folder and adding comments.html into the layouts/partials folder
https://mscipio.github.io/post/utterances-comment-engine/
https://masalmon.eu/2019/10/02/disqus/
https://www.davidfong.info/post/hugoacademiccommentswithutterances/


## Change footer
add custom footer site_footer.html to layouts/partials folder



## Ideas for new posts/content

### Science/Research

* Reading/managing/publishing papers: turn my presentation and my text on the 'teaching-research-resources' list into a blog post.


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

