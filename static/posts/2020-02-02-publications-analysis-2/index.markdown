---
title: Using R to analyze publications - part 2
subtitle: Some examples using bibliometrix
summary: Some code and examples showing how to process and analyze meta-data for a set of publications using the `bibilometrix` R package. 
author: Andreas Handel
draft: false
publishDate: 2020-02-02T00:00:00
lastmod: 2020-05-15T00:00:00
slug: publications-analysis-2
categories: []
tags: ["R","Data Analysis","bibliometrics"]
featured: no
disable_jquery: no
image:
  caption: 'Photo by Rita Morais on Unsplash'
  focal_point: ''
  preview_only: yes
projects: []
---

# Overview

I needed some information on all my publications for "bean counting" purposes related to preparing my promotion materials. In the past, I also needed similar information for NSF grant applications. 

Instead of doing things by hand, there are nicer/faster ways using R. in [part 1](/post/publications-analysis-1/), I did a few things using the `scholar` package. 
While some parts worked nicely, I encountered 2 problems. First, since my Google Scholar record lists items other than peer-reviewed journal articles, they show up in the analysis and need to be cleaned out. Second, Google Scholar doesn't like automated queries through the API and is quick to block, at which point things don't work anymore.

To get around these issues, I decided to give a different R package a try, namely [`bibliometrix`](https://www.bibliometrix.org/). The workflow is somewhat different.

The RMarkdown file to run this analysis [is here](/post/2020-02-01-publications-analysis-2/index.Rmarkdown).

# Required packages


```r
library(dplyr)
library(knitr)
library(bibliometrix)
```

# Loading data

**Old:** I keep all references to my published papers in a BibTeX file, managed through Zotero/Jabref. I know this file is clean and correct. I'm loading it here for processing. If you don't have such a file, make one using your favorite reference manager. Or create it through a saved search on a bibliographic database, as described [in the bibliometrix vignette](https://cran.r-project.org/web/packages/bibliometrix/vignettes/bibliometrix-vignette.html).

**New:** In the current version of `bibliometrix`, reading in my bibtex file failed. A fairly good alternative is to go to your NIH "My Bibliography" (which anyone with NIH funding needs to have anyway) and export it in MEDLINE format. Then read in the file with the code below. As of the time of writing this, it requires the Github version of `bibliometrix`.


```r
#read bib file, turn file of references into data frame
pubs <- bibliometrix::convert2df("medline.txt", dbsource="pubmed",format="pubmed") 
```

```
## 
## Converting your pubmed collection into a bibliographic dataframe
## 
## Done!
## 
## 
## Generating affiliation field tag AU_UN from C1:  Done!
```

Each row of the data frame created by the `convert2df` function is a publication, the columns contain information for each publication. 
For a list of what each column variable codes for, see [here](https://cran.r-project.org/web/packages/bibliometrix/vignettes/bibliometrix-vignette.html).


# Analyzing 2 time periods

For my purpose, I want to analyze 2 different time periods and compare them.
Therefore, I split the data frame containing publications, then run the analysis on each.


```r
#get all pubs for an author (or multiple)
period_1_start = 2009
period_2_start = 2015
#here I want to separately look at publications in the 2 time periods I defined above
pubs_old <- data.frame(pubs) %>% dplyr::filter((PY>=period_1_start & PY<period_2_start ))
pubs_new <- data.frame(pubs) %>% dplyr::filter(PY>=period_2_start)
res_old <- bibliometrix::biblioAnalysis(pubs_old, sep = ";") #perform analysis
res_new <- bibliometrix::biblioAnalysis(pubs_new, sep = ";") #perform analysis
```


# General information

The `summary` functions provide a lot of information in a fairly readable format. I apply them here to both time periods so I can compare.

Time period 1

```r
summary(res_old, k = 10)
```

```
## 
## 
## MAIN INFORMATION ABOUT DATA
## 
##  Timespan                              2009 : 2014 
##  Sources (Journals, Books, etc)        12 
##  Documents                             19 
##  Average years from publication        9.32 
##  Average citations per documents       0 
##  Average citations per year per doc    0 
##  References                            1 
##  
## DOCUMENT TYPES                     
##  clinical trial;journal article;research support, non-u.s. gov't                                               1 
##  comparative study;journal article;research support, n.i.h., extramural;research support, non-u.s. gov't                                               1 
##  journal article                                               2 
##  journal article;research support, n.i.h., extramural                                               5 
##  journal article;research support, n.i.h., extramural;research support, non-u.s. gov't                                               3 
##  journal article;research support, n.i.h., extramural;research support, non-u.s. gov't;research support, u.s. gov't, non-p.h.s.                               1 
##  journal article;research support, n.i.h., extramural;research support, non-u.s. gov't;research support, u.s. gov't, non-p.h.s.;review;systematic review      1 
##  journal article;research support, non-u.s. gov't                                               3 
##  journal article;research support, non-u.s. gov't;research support, u.s. gov't, non-p.h.s.;research support, u.s. gov't, p.h.s.                               1 
##  journal article;review                                               1 
##  
## DOCUMENT CONTENTS
##  Keywords Plus (ID)                    148 
##  Author's Keywords (DE)                148 
##  
## AUTHORS
##  Authors                               45 
##  Author Appearances                    80 
##  Authors of single-authored documents  0 
##  Authors of multi-authored documents   45 
##  
## AUTHORS COLLABORATION
##  Single-authored documents             0 
##  Documents per Author                  0.422 
##  Authors per Document                  2.37 
##  Co-Authors per Documents              4.21 
##  Collaboration Index                   2.37 
##  
## 
## Annual Scientific Production
## 
##  Year    Articles
##     2009        5
##     2010        2
##     2011        1
##     2012        3
##     2013        2
##     2014        6
## 
## Annual Percentage Growth Rate 3.713729 
## 
## 
## Most Productive Authors
## 
##    Authors        Articles Authors        Articles Fractionalized
## 1   HANDEL A            19  HANDEL A                         5.55
## 2   ANTIA R              6  ANTIA R                          1.78
## 3   DOHERTY PC           3  LONGINI IM JR                    1.00
## 4   LA GRUTA NL          3  DOHERTY PC                       0.56
## 5   LONGINI IM JR        3  LA GRUTA NL                      0.56
## 6   THOMAS PG            3  THOMAS PG                        0.56
## 7   PILYUGIN SS          2  BEAUCHEMIN CA                    0.50
## 8   ROHANI P             2  LI Y                             0.50
## 9   STALLKNECHT D        2  ROHANI P                         0.50
## 10  TURNER SJ            2  ROZEN DE                         0.50
## 
## 
## Top manuscripts per citations
## 
##                               Paper                                   DOI TC TCperYear
## 1  ZHENG N, 2014, PLOS ONE                   10.1371/JOURNAL.PONE.0105721  0         0
## 2  HANDEL A, 2014, PROC BIOL SCI             10.1098/RSPB.2013.3051        0         0
## 3  NGUYEN TH, 2014, J IMMUNOL                10.4049/JIMMUNOL.1303147      0         0
## 4  LI Y, 2014, J THEOR BIOL                  10.1016/J.JTBI.2014.01.008    0         0
## 5  HANDEL A, 2014, J R SOC INTERFACE         10.1098/RSIF.2013.1083        0         0
## 6  CUKALAC T, 2014, PROC NATL ACAD SCI U S A 10.1073/PNAS.1323736111       0         0
## 7  HANDEL A, 2013, PLOS COMPUT BIOL          10.1371/JOURNAL.PCBI.1002989  0         0
## 8  THOMAS PG, 2013, PROC NATL ACAD SCI U S A 10.1073/PNAS.1222149110       0         0
## 9  JACKWOOD MW, 2012, INFECT GENET EVOL      10.1016/J.MEEGID.2012.05.003  0         0
## 10 DESAI R, 2012, CLIN INFECT DIS            10.1093/CID/CIS372            0         0
## 
## 
## Corresponding Author's Countries
## 
##     Country Articles   Freq SCP MCP MCP_Ratio
## 1 USA             14 0.7778  11   3     0.214
## 2 AUSTRALIA        3 0.1667   2   1     0.333
## 3 CANADA           1 0.0556   1   0     0.000
## 
## 
## SCP: Single Country Publications
## 
## MCP: Multiple Country Publications
## 
## 
## Total Citations per Country
## 
##   Country      Total Citations Average Article Citations
## 1    AUSTRALIA               0                         0
## 2    CANADA                  0                         0
## 3    USA                     0                         0
## 
## 
## Most Relevant Sources
## 
##                                                                                                           Sources       
## 1  JOURNAL OF THE ROYAL SOCIETY INTERFACE                                                                               
## 2  JOURNAL OF THEORETICAL BIOLOGY                                                                                       
## 3  JOURNAL OF IMMUNOLOGY (BALTIMORE MD. : 1950)                                                                         
## 4  PLOS ONE                                                                                                             
## 5  PROCEEDINGS OF THE NATIONAL ACADEMY OF SCIENCES OF THE UNITED STATES OF AMERICA                                      
## 6  BMC EVOLUTIONARY BIOLOGY                                                                                             
## 7  BMC PUBLIC HEALTH                                                                                                    
## 8  CLINICAL INFECTIOUS DISEASES : AN OFFICIAL PUBLICATION OF THE INFECTIOUS DISEASES SOCIETY OF AMERICA                 
## 9  EPIDEMICS                                                                                                            
## 10 INFECTION GENETICS AND EVOLUTION : JOURNAL OF MOLECULAR EPIDEMIOLOGY AND EVOLUTIONARY GENETICS IN INFECTIOUS DISEASES
##    Articles
## 1         3
## 2         3
## 3         2
## 4         2
## 5         2
## 6         1
## 7         1
## 8         1
## 9         1
## 10        1
## 
## 
## Most Relevant Keywords
## 
##    Author Keywords (DE)      Articles Keywords-Plus (ID)     Articles
## 1       HUMANS                     13   HUMANS                     13
## 2       MODELS BIOLOGICAL           8   MODELS BIOLOGICAL           8
## 3       ANIMALS                     7   ANIMALS                     7
## 4       COMPUTER SIMULATION         5   COMPUTER SIMULATION         5
## 5       BIOLOGICAL EVOLUTION        4   BIOLOGICAL EVOLUTION        4
## 6       MODELS IMMUNOLOGICAL        4   MODELS IMMUNOLOGICAL        4
## 7       FEMALE                      3   FEMALE                      3
## 8       MICE                        3   MICE                        3
## 9       MUTATION                    3   MUTATION                    3
## 10      AMINO ACID SEQUENCE         2   AMINO ACID SEQUENCE         2
```

Time period 2

```r
summary(res_new, k = 10)
```

```
## 
## 
## MAIN INFORMATION ABOUT DATA
## 
##  Timespan                              2015 : 2020 
##  Sources (Journals, Books, etc)        22 
##  Documents                             29 
##  Average years from publication        3.72 
##  Average citations per documents       0 
##  Average citations per year per doc    0 
##  References                            1 
##  
## DOCUMENT TYPES                     
##  comparative study;journal article;research support, n.i.h., extramural;research support, non-u.s. gov't                             1 
##  journal article                                               7 
##  journal article;multicenter study;research support, n.i.h., extramural                                               1 
##  journal article;research support, n.i.h., extramural                                               5 
##  journal article;research support, n.i.h., extramural;research support, non-u.s. gov't                                               5 
##  journal article;research support, n.i.h., extramural;research support, non-u.s. gov't;review                                        1 
##  journal article;research support, n.i.h., extramural;research support, u.s. gov't, non-p.h.s.                                       1 
##  journal article;research support, n.i.h., extramural;research support, u.s. gov't, non-p.h.s.;review                                1 
##  journal article;research support, non-u.s. gov't                                               4 
##  journal article;research support, non-u.s. gov't;research support, n.i.h., extramural                                               1 
##  journal article;research support, non-u.s. gov't;research support, u.s. gov't, non-p.h.s.;research support, n.i.h., extramural      1 
##  letter                                               1 
##  
## DOCUMENT CONTENTS
##  Keywords Plus (ID)                    198 
##  Author's Keywords (DE)                198 
##  
## AUTHORS
##  Authors                               209 
##  Author Appearances                    332 
##  Authors of single-authored documents  1 
##  Authors of multi-authored documents   208 
##  
## AUTHORS COLLABORATION
##  Single-authored documents             1 
##  Documents per Author                  0.139 
##  Authors per Document                  7.21 
##  Co-Authors per Documents              11.4 
##  Collaboration Index                   7.43 
##  
## 
## Annual Scientific Production
## 
##  Year    Articles
##     2015        5
##     2016        7
##     2017        3
##     2018        6
##     2019        5
##     2020        3
## 
## Annual Percentage Growth Rate -9.711955 
## 
## 
## Most Productive Authors
## 
##    Authors        Articles Authors        Articles Fractionalized
## 1     HANDEL A          29    HANDEL A                      5.494
## 2     WHALEN CC          7    ANTIA R                       0.810
## 3     ANTIA R            5    SHEN Y                        0.723
## 4     MARTINEZ L         5    WHALEN CC                     0.651
## 5     SHEN Y             5    MCKAY B                       0.629
## 6     LA GRUTA NL        4    EBELL MH                      0.571
## 7     MCKAY B            4    THOMAS PG                     0.571
## 8     THOMAS PG          4    LA GRUTA NL                   0.540
## 9     ZALWANGO S         4    ROHANI P                      0.500
## 10    DENHOLM JT         3    MARTINEZ L                    0.485
## 
## 
## Top manuscripts per citations
## 
##                                                       Paper                                    DOI TC TCperYear
## 1  MCKAY B, 2020, PROC BIOL SCI                                      10.1098/RSPB.2020.0496         0         0
## 2  MOORE JR, 2020, BULL MATH BIOL                                    10.1007/S11538-020-00711-4     0         0
## 3  HANDEL A, 2020, NAT REV IMMUNOL                                   10.1038/S41577-019-0235-3      0         0
## 4  MARTINEZ L, 2019, J INFECT DIS                                    10.1093/INFDIS/JIZ328          0         0
## 5  WU T, 2019, NAT COMMUN                                            10.1038/S41467-019-10661-8     0         0
## 6  MCKAY B, 2019, PLOS ONE                                           10.1371/JOURNAL.PONE.0217219   0         0
## 7  DALE AP, 2019, J AM BOARD FAM MED SOCIOLOGICAL METHODS & RESEARCH 10.3122/JABFM.2019.02.180183   0         0
## 8  WOLDU H, 2019, J APPL STAT                                        10.1080/02664763.2018.1470231  0         0
## 9  HANDEL A, 2018, PLOS COMPUT BIOL                                  10.1371/JOURNAL.PCBI.1006505   0         0
## 10 CASTELLANOS ME, 2018, INT J TUBERC LUNG DIS                       10.5588/IJTLD.18.0073          0         0
## 
## 
## Corresponding Author's Countries
## 
##     Country Articles  Freq SCP MCP MCP_Ratio
## 1 USA             16 0.696   7   9     0.562
## 2 AUSTRALIA        5 0.217   1   4     0.800
## 3 GEORGIA          2 0.087   0   2     1.000
## 
## 
## SCP: Single Country Publications
## 
## MCP: Multiple Country Publications
## 
## 
## Total Citations per Country
## 
##   Country      Total Citations Average Article Citations
## 1    AUSTRALIA               0                         0
## 2    GEORGIA                 0                         0
## 3    USA                     0                         0
## 
## 
## Most Relevant Sources
## 
##                                                                                                                                        Sources       
## 1  PLOS ONE                                                                                                                                          
## 2  PLOS COMPUTATIONAL BIOLOGY                                                                                                                        
## 3  THE INTERNATIONAL JOURNAL OF TUBERCULOSIS AND LUNG DISEASE : THE OFFICIAL JOURNAL OF THE INTERNATIONAL UNION AGAINST TUBERCULOSIS AND LUNG DISEASE
## 4  THE LANCET. GLOBAL HEALTH                                                                                                                         
## 5  THE LANCET. RESPIRATORY MEDICINE                                                                                                                  
## 6  AMERICAN JOURNAL OF RESPIRATORY AND CRITICAL CARE MEDICINE                                                                                        
## 7  BMC INFECTIOUS DISEASES                                                                                                                           
## 8  BULLETIN OF MATHEMATICAL BIOLOGY                                                                                                                  
## 9  ELIFE                                                                                                                                             
## 10 EPIDEMICS                                                                                                                                         
##    Articles
## 1         4
## 2         2
## 3         2
## 4         2
## 5         2
## 6         1
## 7         1
## 8         1
## 9         1
## 10        1
## 
## 
## Most Relevant Keywords
## 
##           Author Keywords (DE)      Articles           Keywords-Plus (ID)     Articles
## 1  HUMANS                                 23 HUMANS                                 23
## 2  ANIMALS                                 8 ANIMALS                                 8
## 3  FEMALE                                  7 FEMALE                                  7
## 4  MALE                                    7 MALE                                    7
## 5  MICE                                    6 MICE                                    6
## 6  ADULT                                   5 ADULT                                   5
## 7  CHILD                                   5 CHILD                                   5
## 8  ADOLESCENT                              4 ADOLESCENT                              4
## 9  ANTIVIRAL AGENTS/THERAPEUTIC USE        4 ANTIVIRAL AGENTS/THERAPEUTIC USE        4
## 10 CHILD PRESCHOOL                         4 CHILD PRESCHOOL                         4
```
Note that some values are reported as NA, e.g. the citations. Depending on which source you got the original data from, that information might be included or not. In my case, it is not.

# Getting a table of co-authors

This can be useful for NSF applications. For reasons nobody understands, that agency still asks for a list of all co-authors. An insane request in the age of modern science. If one wanted to do that, the following gives a table. 

**Update:** I have since created a short blog post describing how to do just that part in a bit more detail. It has a few additional components that might be useful, if interested [check it out here](/post/conflict-of-interest-form/).

Here is the full table of my co-authors in the first period dataset.


```r
#removing the 1st one since that's me
authortable = data.frame(res_old$Authors[-1])
colnames(authortable) = c('Co-author name', 'Number of publications')
knitr::kable(authortable)
```



|Co-author name | Number of publications|
|:--------------|----------------------:|
|ANTIA R        |                      6|
|DOHERTY PC     |                      3|
|LA GRUTA NL    |                      3|
|LONGINI IM JR  |                      3|
|THOMAS PG      |                      3|
|PILYUGIN SS    |                      2|
|ROHANI P       |                      2|
|STALLKNECHT D  |                      2|
|TURNER SJ      |                      2|
|AKIN V         |                      1|
|BEAUCHEMIN CA  |                      1|
|BIRD NL        |                      1|
|BROWN J        |                      1|
|CHADDERTON J   |                      1|
|CUKALAC T      |                      1|
|DESAI R        |                      1|
|DICKEY BW      |                      1|
|FUNG IC        |                      1|
|HALL AJ        |                      1|
|HALL D         |                      1|
|HEMBREE CD     |                      1|
|JACKWOOD MW    |                      1|
|KEDZIERSKA K   |                      1|
|KJER-NIELSEN L |                      1|
|KOTSIMBOS TC   |                      1|
|LEBARBENCHON C |                      1|
|LEON JS        |                      1|
|LEVIN BR       |                      1|
|LI Y           |                      1|
|LOPMAN B       |                      1|
|MARGOLIS E     |                      1|
|MATTHEWS JE    |                      1|
|MCDONALD S     |                      1|
|MIFSUD NA      |                      1|
|MOFFAT JM      |                      1|
|NGUYEN TH      |                      1|
|PARASHAR UD    |                      1|
|PELLICCI DG    |                      1|
|ROWNTREE LC    |                      1|
|ROZEN DE       |                      1|
|WHALEN CC      |                      1|
|YATES A        |                      1|
|ZARNITSYNA V   |                      1|
|ZHENG N        |                      1|

Since I have many more co-authors in the second period, I'm not printing a table with all, instead I'm just doing those with whom I have more than 2 joint publications.


```r
#removing the 1st one since that's me
authortable = data.frame(res_new$Authors[-1])
authortable <- authortable %>% dplyr::filter(Freq>2)
colnames(authortable) = c('Co-author name', 'Number of publications')
knitr::kable(authortable)
```



|Co-author name | Number of publications|
|:--------------|----------------------:|
|WHALEN CC      |                      7|
|ANTIA R        |                      5|
|MARTINEZ L     |                      5|
|SHEN Y         |                      5|
|LA GRUTA NL    |                      4|
|MCKAY B        |                      4|
|THOMAS PG      |                      4|
|ZALWANGO S     |                      4|
|DENHOLM JT     |                      3|
|EBELL M        |                      3|
|MCBRYDE ES     |                      3|
|SUMNER T       |                      3|
|TRAUER JM      |                      3|



# Making a table of journals

It can be useful to get a list of all journals in which you published. I'm doing this here for the second time period. With just the `bibliometrix` package, I can get a list of publications and how often I have published in each.


```r
journaltable = data.frame(res_new$Sources)
#knitr::kable(journaltable) #uncomment this to print the table
```

It might also be nice to get some journal metrics, such as impact factors. While this is possible with the `scholar` package, the `bibliometrix` package doesn't have it.

However, the `scholar` package doesn't really get that data from Google Scholar, instead it has an internal spreadsheet/table with impact factors (according to the documentation, taken - probably not fully legally - from some spreadsheet posted on ResearchGate). We can thus access those impact factors stored in the `scholar` package without having to connect to Google Scholar. As long as the journal names stored in the `scholar` package are close to the ones we have here, we might get matches.


```r
library(scholar)
ifvalues = scholar::get_impactfactor(journaltable[,1], max.distance = 0.1)
journaltable = cbind(journaltable, ifvalues$ImpactFactor)
colnames(journaltable) = c('Journal','Number of Pubs','Impact Factor')
knitr::kable(journaltable)
```



|Journal                                                                                                                                            | Number of Pubs| Impact Factor|
|:--------------------------------------------------------------------------------------------------------------------------------------------------|--------------:|-------------:|
|PLOS ONE                                                                                                                                           |              4|         2.766|
|PLOS COMPUTATIONAL BIOLOGY                                                                                                                         |              2|         3.955|
|THE INTERNATIONAL JOURNAL OF TUBERCULOSIS AND LUNG DISEASE : THE OFFICIAL JOURNAL OF THE INTERNATIONAL UNION AGAINST TUBERCULOSIS AND LUNG DISEASE |              2|            NA|
|THE LANCET. GLOBAL HEALTH                                                                                                                          |              2|            NA|
|THE LANCET. RESPIRATORY MEDICINE                                                                                                                   |              2|            NA|
|AMERICAN JOURNAL OF RESPIRATORY AND CRITICAL CARE MEDICINE                                                                                         |              1|        15.239|
|BMC INFECTIOUS DISEASES                                                                                                                            |              1|         2.620|
|BULLETIN OF MATHEMATICAL BIOLOGY                                                                                                                   |              1|         1.484|
|ELIFE                                                                                                                                              |              1|         7.616|
|EPIDEMICS                                                                                                                                          |              1|         3.364|
|EPIDEMIOLOGY AND INFECTION                                                                                                                         |              1|         2.044|
|FRONTIERS IN IMMUNOLOGY                                                                                                                            |              1|         5.511|
|JOURNAL OF APPLIED STATISTICS                                                                                                                      |              1|         0.699|
|JOURNAL OF THE AMERICAN BOARD OF FAMILY MEDICINE : JABFM                                                                                           |              1|            NA|
|NATURE                                                                                                                                             |              1|        41.577|
|NATURE COMMUNICATIONS                                                                                                                              |              1|        12.353|
|NATURE REVIEWS. IMMUNOLOGY                                                                                                                         |              1|        41.982|
|PHILOSOPHICAL TRANSACTIONS OF THE ROYAL SOCIETY OF LONDON. SERIES B BIOLOGICAL SCIENCES                                                            |              1|            NA|
|PLOS BIOLOGY                                                                                                                                       |              1|         9.163|
|PROCEEDINGS OF THE NATIONAL ACADEMY OF SCIENCES OF THE UNITED STATES OF AMERICA                                                                    |              1|         9.504|
|PROCEEDINGS. BIOLOGICAL SCIENCES                                                                                                                   |              1|            NA|
|THE JOURNAL OF INFECTIOUS DISEASES                                                                                                                 |              1|         5.186|

Ok that worked somewhat. It couldn't find several journals. The reported IF seem reasonable. But since I don't know what year those IF are from, and if the rest is fully reliable, I would take this with a grain of salt.

# Discussion

The `bibliometrix` package doesn't suffer from the problems that I encountered in [part 1](/post/publications-analysis-1/) of this post when I tried  the `scholar` package (and Google Scholar). The downside is that I can't get some of the information, e.g. my annual citations. So it seems there is not (yet) a comprehensive solution, and using both packages seems best. 

A larger overall problem is that a lot of this information is controlled by corporations (Google, Elsevier, Clarivate Analytics, etc.), which might or might not allow R packages and individual users (who don't subscribe to their offerings) to access certain information. As such, R packages accessing this information will need to adjust to whatever the companies allow.







