---
title: Create a simple Markdown/Github website in less than 30 minutes
subtitle: 
description: "The following are step-by-step instructions for creating a fairly basic but still useful website using [R Markdown](https://rmarkdown.rstudio.com/) (through [R Studio](https://rstudio.com/products/rstudio/)) and [Github](https://github.com/)."
author: "[Andreas Handel](https://www.andreashandel.com)"
date: '2021-01-11'
aliases: \r\n  -  github-website
draft: false
categories: []
categories: ["R", "markdown", "github", "website"]
featured: no
disable_jquery: no
image:
  caption: Photo by (200 Degrees)[https://pixabay.com/users/200degrees-2051452]/Pixabay
  focal_point: ''
  preview_only: no
projects: []
---




The following blog post provides step-by-step instructions for creating a simple (and free) website using (R)Markdown and Github.


# Motivation

Previously, I wrote a 2-series blog post with instructions for creating your own website using [blogdown](https://bookdown.org/yihui/blogdown/), [Hugo](https://gohugo.io/) and [Netlify](https://www.netlify.com/). (Here are [Part 1](/post/blogdown-website-1/) and [part 2](/post/blogdown-website-2/)). 

The blogdown/Hugo setup is fairly flexible and powerful, but sometimes more complex than what is needed. At least I find this to be the case. While I'm using Hugo/blogdown for my [personal website](https://www.andreashandel.com) I am currently hosting my online courses using a simpler setup, the one I'll be describing here. 


# Required skills

I assume that you have general computer literacy, but no experience with any of the tools that will be used. Also, no coding, web-development or related experience is expected. 

# What this document covers

This document is meant to provide you with the minimum required instructions to get a simple own website up and running quickly. As such, instructions and background information are kept at a minimum. I used a _recipe-like_ approach by giving hopefully detailed and specific enough instructions to get things to work. I'm not covering any _why_ here or provide much further explanations. If you decide you like to use this setup for your website, you will likely want to go beyond this document and learn a bit more about the various tools involved in the process. To that end, links to further resources are provided. 


# Who this is (not) for

**This way of making and hosting a website might be for you if:**

* You are (or would like to be) an R, RMarkdown and GitHub user. This is a method of creating a website using those tools which very efficiently fits into such a workflow. 
* You want a way to host a website where all the content is fully controlled by you, and the website can be hosted without much resources (and for free). 
* You are curious about R/RMarkdown/GitHub, how to use it to build a website, and you've got a bit of time to spare and want to give it a try.
* You want something that's fairly simple and easy to set up and maintain.

**This way of making and hosting a website might not be for you if:**

* Your main workflow is MS Word, Powerpoint, etc. and you are not interested in R/Markdown/GitHub.
* You want everything accessible through a graphical interface.
* You need a complex setup with lots of control over layout and many advanced features.


# Motivating Examples

Here are a few examples of websites written with R Markdown/Github:

* [My modern applied data analysis course](https://andreashandel.github.io/MADAcourse/)
* [Jeff Leek's advanced data science course](http://jtleek.com/advdatasci/)



# Quick tool overview

The tools used here are fairly simple. Github is used for hosting the website and R Markdown and a few extra files contain all the content and formatting.


# Pre-requisites

First, you need to install R and Rstudio and set up a Github account. (That does not count toward the 30 minutes of getting the website up and running 😁.)


## Install R and RStudio 

If you don't already have it on your computer, [install R first](https://www.r-project.org/). You can pick any mirror you like. If you already have R installed, make sure it is a fairly recent version. If yours is old, I suggest you update (install a new R version).

Once you have R installed, install the free version of [RStudio Desktop](https://www.rstudio.com/products/rstudio/download/). Again, make sure it's a recent version. If you have an older verion of RStudio, you should update.

Installing R and RStudio should be fairly straightforward. If you want some more details or need instructions, see [this page](https://andreashandel.GitHub.io/MADAcourse/1c_RandRStudio.html) (which is part of an online course I teach).


## Get Github up and running

If you are new to Github, you need to create an account. At some point, it would also be useful to learn more about what Git/Github is and how to use it, but for this purpose you actually don't need to know much. If you want to read a bit about Git/Github, see e.g. [this document, which I wrote for one of my courses.](https://andreashandel.github.io/MADAcourse/1d_Github.html). But for now, you don't need to know much about Git/Github.

## Install Gitkraken (optional but assumed)
There are many ways you can interact with Git/Github. I mosty use the fairly user-friendly and full-featured [Gitkraken](https://www.gitkraken.com/). You can get a basic version for free, if you are a student, you can get the Pro version through the [Github developer pack](https://education.github.com/pack), teachers can get it through the [Github teacher toolbox](https://education.github.com/toolbox). If you qualify for either, I highly recommend signing up. But you don't need it for our purpose.

I assume for the rest of the post that you are using Gitkraken. If you have your own preferred Git/Github client (e.g. the one that comes with RStudio), you can of course use that one too.
Make sure you [connect Gitkraken to your Github account](https://www.gitkraken.com/resources/gitkraken-github-cheat-sheet).


# Starting your website 

Ok, the 30 minute timer starts now 😁

With the above registration and installation bits out of the way, you can get started with your website. To do so, follow these steps:

### Github
* Go to Github, log in if needed. 
* Somewhere (usually on the left), you should find a green button that says _New_, click it to create a new repository. Give it the name of the webpage you want to create (e.g. `mywebsite`). Provide a brief description (e.g. _My first Github website_.)
* Check the boxes `add readme` and `add .gitignore` and for the template chose `R`. You can keep the license box unchecked, or choose a license for your page.
* Once done, create the new repository.

### Gitkraken
_I assume you'll be using Gitkraken, but if you have another way of using Git/Github, feel free to use your own approach._

* Make sure [Gitkraken is connected to your Github account](https://www.gitkraken.com/resources/gitkraken-github-cheat-sheet).  
* Open Gitkraken, under `File` choose `Clone Repo` go to `Github.com`, find the name of the repository you just created and clone it to some place on your local computer (i.e. copy it from Github to your local computer.) E.g. if your repository was called `mywebsite`, and you place it on your desktop under windows, you might choose `C:\Users\yourname\Desktop` as the target.


### Starter files
* Download the files [_navbar.yml](/post/2021-01-11-simple-github-website/_navbar.yml), [_site.yml](/post/2021-01-11-simple-github-website/_site.yml) and [index.Rmd](/post/2021-01-11-simple-github-website/index.Rmd). You need those are 3 files to create your website and I'm providing you with simple templates. Place all 3 files into the folder of your new website (e.g. `C:\Users\yourname\Desktop\mywebsite`). 


### RStudio
* Open RStudio.
* Choose `File`, `New Project`, `Existing Directory` and find the directory/folder you just created on Github and copied to your local computer (e.g. `C:\Users\yourname\Desktop\mywebsite`).
* Based on the files you copied into the folder earlier, R Studio should recognize that you are making a website and in the top right pane there should be a `Build` tab. Click on it, then `Build Website.` If that doesn't work, you can also type `rmarkdown::render_site()` into the R console (bottom left pane in R Studio).
* If you don't find the `Build Website` button or the `rmarkdown::render_site()` command produced an error message, something went wrong with the setup. You can try to close RStudio, navigate to the folder for your website and click on the `.Rproj` file, which should open RStudio and place you in the project. Maybe the `Build` tab and `Build Website` buttons are now there? If not, revisit the steps above and make sure you did them all, especially make sure the 3 starter files are in the same folder. 
* If things work, a preview window should open with the beginning of your new website. You'll see a menu at the top, but if you click on the links, they won't work. We need to create those files first, which we'll do below.


# A brief explanation of your new website

Your website is fairly simple and consists of these documents.


### The file `index.Rmd` 
This is the main landing page of your website. It always needs to be there and you fill it with the content you want on your main page. It's a regular R Markdown site. If you are new to R Markdown, you can learn more about it [on the R Markdown website](https://rmarkdown.rstudio.com/). I also have a discussion of R Markdown and reproducibility [on one of my course pages](https://andreashandel.github.io/MADAcourse/1e_ToolsforReproducibility.html). You'll find additional links to potentially useful R Markdown (and Github) resources there.


### The file `_site.yml` 
This short file contains the main settings for your site that control the styling. To change the layout, the `theme` setting is the most important. R Markdown supports the [Bootswatch](https://bootswatch.com/) theme library. More information on themes and other configuration options for the `_site.yml` file [can be found here](https://bookdown.org/yihui/rmarkdown/html-document.html#appearance-and-style).
Once you start playing with your website, you'll want to explore and probably adjust those options. You can even include your own style using CSS. [This whole section](https://bookdown.org/yihui/rmarkdown/html-document.html) of the R Markdown book is useful to read (at some point) to learn what you can do.

For now, just to give it a quick try, open the `_site.yml` file (in R Studio or some other text editor) and replace `cerulean` with `spacelab`. Save, then rebuild the website. You should see the layout has changed.


### The file `_navbar.yml`
This file allows you to build a menu for your website. If you open the file, you'll see that I created a small menu. You see links to files `aboutme.html`, `project1.html`, `project2.html` and `contact.html`. Those files currently do not exist, thus if you click on those menus in the preview, you get an error message. You need to make sure that the files of your website match those listed in this menu file.

You can find some more information on the `_navbar.yml` file and what settings are available [in this chapter of the R Markdown book](https://bookdown.org/yihui/rmarkdown/rmarkdown-site.html). As you'll read, it is possible to have only a single `_site.yml` file which contains the `_navbar.yml` content, but I prefer to keep them separate.

If a file is not listed in the `_navbar.yml` file, it is not accessible to users, unless they know the direct link to the file. This can be useful since it means you can have files in development in the Github repository, and they will only become visible once you link them. Of course since they can be found through a direct link or through browsing your Github repository, don't place anything private/confidential in this folder (e.g. if you use this four a course, keep the solutions to your homework problems offline until after the deadline 😄).



### The `docs` folder
This folder is created and updated when you build the website. It contains the html files that are created from your `Rmd` files. Those files will be used by Github to display your website (we'll do that below). Note that you can change the folder name in `_site.yml`, but I recommend leaving it as is, since `docs` is also the default location for Github to look for these files. 


### Additional content
Additional files are either for Github (e.g. `.gitignore` and `README.md`) or for RStudio (e.g. the `mywebsite.Rproj` file). Those should be there, and you might want to edit those at some point, especially the `README.md` file. But since they are not directly part of the website, I'll not further discuss them here.


### Beware!
**Both `_site.yml` and `_navbar.yml` are very picky about the exact formatting, and the number of leading empty spaces. Often, if you change something in those files and the site doesn't compile, it means you forgot to add the required empty spaces or added more than you should. Always check first if the spacing is correct.**




# Creating and editing content

Making new content for your website is very easy, all you need to do is create new Rmd files. Note that if you don't use R code in your file, you could just use plain Markdown/Md files, but I find it easier for consistency to always use Rmd files, even if they don't contain R code. 

Let's create the missing documents. Go to `File`, `New File`, `R Markdown` choose as output format `HTML document` and give it a title and name. A template will open, you can fill it and then save as say `project1.Rmd` into the main folder of your website.

Another option, which I usually use, is to go into the folder, make a copy of an existing file and rename. E.g. copy `project1.Rmd` to `project2.Rmd`, then open and edit. Either approach works.

Use whichever approach you like to create Rmd versions of the 4 files that are listed in the `_navbar.yml` file, namely `aboutme.Rmd`, `project1.Rmd`, `project2.Rmd` and `contact.Rmd`. All files should be in the main folder. Edit the content in those files as much or as little as you want.

Once created, rebuild the website. In the preview that shows up, you should now be able to click on all menus in the preview and reach the pages you just created. (You'll find the newly created html files in the `docs` folder.)


# Making your site public.

The final step involves getting your site public, which is easy. 

* Once you are done editing your content (for now), go to Gitkraken (or your preferred Git client) and push your changes to Github.
* Go to Github.com and find the repository for this website. On the bar at the top, in the right corner there should be the `Settings` button. Click on it. Scroll down until you find the `GitHub Pages` section. Under `Source`, select `Main` and then choose `/docs` as the folder. Don't choose a theme since we are using our own. Save those changes. Now if you look right underneath the `GitHub Pages` section, there should be something like `Your site is ready to be published at https://andreashandel.github.io/mywebsite/`. Click on the link. If everything works, your website is now live and public! 

**That's basically it. Now the hard part starts, creating good content. 😄 **


# Updating your site
This process is fairly simple, you just need to remember to go through all the steps.

1. Make any changes to files you want to make. Create new Rmd files in the main folder, edit them. If you include new files or rename them, don't forget to change your `_navbar.yml` file.
2. Rebuild the website by either clicking the `Build Website` button inside the `Build` tab in the top right R Studio pane, or by typing `rmarkdown::render_site()` into the console.
3. Push your changes to GitHub.
4. Wait a minute or so, then reload your website on Github and check that things look right. 




# Some tips, tricks and comments

Here are some thoughts and suggestions that I've learned by using this setup for several online courses.

* The setup described here works well for fairly simple sites. If you want your content structured in a more complex way and more features, you probably want to use the [blogdown/hugo setup](/post/blogdown-website-1/). Similarly, while you can customize the layout  by trying different themes and by including your own CSS (see links above), if you want to start making it look exactly how you want, you'll likely be wasting a lot of time and might be better off using a different setup (e.g. blogdown/hugo).

* Every time you build your website, everything gets recompiled. If you have simple content, and no/little R code, that's ok. If you are having things that take long to run (e.g. complex R code inside your website), I suggest to move the R code to a separate R script and save results from the code into files (figures/tables/Rdata files). You then just load thpse results into your Rmd file. This way you only need to run the time-consuming R code if those parts have changed, but on a standard website re-build the code won't need to run.

* Sometimes when I build websites like this one on a Windows computer, things slow down markedly. It turns out that Windows Defender is at times not working right and I have to make adjustments to prevent it from trying to scan all newly created files in real time while re-building my website. If you encounter a very slow re-build process on a Windows machine, this could be the issue and you might want to check out [this discussion](https://community.rstudio.com/t/performance-issue-rstudio-windows-10/7608) and especially the provided link which explains how to potentially fix it (the fix worked for me).

* You can have files other than Rmd/Md in your main folder, and you can have files in sub-folders. Those are ignored by `rmarkdown` when the site is built. Having those can be useful for storing additional materials. I generally have a `media` folder in which I place figures and other materials, and link to it from my Rmd files.

* If you use this setup for teaching and want to slowly release content to students (while still making edits to later parts of the course), I recommend using a _staging_ setup. A simple way to do that is to make 2 repositories, the main one for the course, and one where you do the development. Note that even if you set this to a private repository, if you turn on `Github Pages`, students could find it. That's usually not a big deal, nobody is looking. But you might want to be aware of it. With 2 repositories, you can do the testing/development of the course in the _staging_ repository. Once things work and whenever you want to release new content to the students, you copy it over to the main repository, build it there and push it to the main course repo. Alternatively, you can do development in the main repository, as long as you don't make the files visible in the `_navbar.yml` file, students won't easily see them.

* I like to be able to specify the date when a page was last changed. The problem is that all pages are always rebuild, so asking for 'current date' during rebuilding doesn't work. What I found out to work is to have this line in the YAML file header: `file.mtime(knitr::current_input())`. It gets the 'last modified' time stamp of the file that is being processed and displays it. It's not perfect, e.g. if you recently cloned the files from Github to a new computer, it will show that date as the modified date. But it's good enough for me. If you want exact _last edited date_ time stamps, you'll probably have to do it manually.

* It's easy to have broken links when creating any website and it's good to check that things are ok. There are simple free tools out there that let you check to make sure links are not broken. I like using [Dr Link Check](https://www.drlinkcheck.com/) or the [W3C Link Checker](https://validator.w3.org/checklink). I'm sure many others exist. 
 
 

# More Information

The whole area of _use R Markdown to make websites_ is still under rapid development. Here are a few sources that - as of this writing - might be useful and not too outdated.

* Since this setup is fully based on R Markdown, the [R Markdown book](https://bookdown.org/yihui/rmarkdown/) is very useful and contains lots of relevant information, especially [this section](https://bookdown.org/yihui/rmarkdown/rmarkdown-site.html). There is also the newer [R Markdown cookbook](https://bookdown.org/yihui/rmarkdown-cookbook/) which is more of a how-to guide, while the R Markdown book is more of a full reference book. Both are very useful sources of information.

* The R Studio folks have a package called [`distill`](https://rstudio.github.io/distill/) which is still under heavy development and which allows turning R Markdown into lots of outputs, including [basic websites](https://rstudio.github.io/distill/publish_website.html). This is still a work in progress, and while I tried distill in the past (and it couldn't quite do what I want), I haven't tried it lately. I find the setup I describe here works for my teaching needs, but if you need more/different features, I recommend checking out distill. There is aparently also a new package called [`postcards`](https://github.com/seankross/postcards) that works with distill to produce simple websites, very similar to the approach shown here. See e.g. [this blog post by Allison Hill](https://alison.rbind.io/post/2020-12-22-postcards-distill/) for an introduction. I expect these packages to develop and mature quickly.

* In my teaching, I use the Github/R Markdown workflow, so students are exposed to it. Therefore, I have a good bit of information and links on that topic. You can browse through [the website of this 
course](https://andreashandel.github.io/MADAcourse/index.html) and look for relevant content. A lot of the exercises also teach parts of Github and making webpages (even simpler ones than described here).  








