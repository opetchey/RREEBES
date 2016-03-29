# Meetings in 2015

Meetings 14.00 to 15.00 Zurich time, location 34-J-52.

Assign person to take meeting minutes.

New people (get photo)?

Any suggested papers added to the repository?

Any outstanding issues?

Any progress on focal paper since last week?

What to attempt this week (refer to closing note from last week)?

What to attempt next week (to be refered to next week)?

Meetings in 2016 are not yet listed, but will be same time place and frequency as during 2015.

## 3.3

(Minutes by Mikael.)
Owen introduced and outlined REEBBES by going through the GitHub homepage
* How to suggest papers to reproduce
* Meeting schedule
* Potential papers to reproduce
* How to contribute at meetings or outside the meeting schedule
    -State issues on the Github webpage
    -Get an account on Github and edit files

How to make a report in r-studio (see e.g. report in the folder RREEBES/Beninca_etal_2008_Nature on Github)

Owen introduced the Beninca et al 2008 data.
* The raw data is available in a xls-file, available on Github
    -Species abundance and nutrient concentrations are available
    -The data that will be used for the reproduction in R is provided as csv-files, also on Github.
 
Get started with the reproduction in R (see also report in REEBES/Beninca_etal_2008_Nature on Github)
* Import the csv files into R-studio and clean up data.

Frank introduced how to get on Github and to clone info. between Github and your local computer
* Get an account and log in
* Clone by clicking on the fork-button
* Clone to your local computer by copying the URL to your computer

## 10.3

(Minutes by Marco.)
Recap for those that missed the previous meeting:
* what are git and github, what is version control;
* how to keep an eye on a github repository by using the “watch” option;
* using github desktop app for managing repositories.

Homeworks for next time:
* create a github account
* find the RREEBES repository and follow its changes and developments using the “watch” option
* try to make a change to one of the existing files and make a “pull” request

## 17.3

(Minutes by Vanessa.)
New people: Gian Marco

Suggestions
* Email the authors of the papers that we start to reproduce, let them know what we are doing and where the files will be available.

Questions
* Owen and Frank showed how to properly fork and clone the repository into your own account/computer, how to edit the files and then pull them back. Thiss will be available on the wiki page.

Issues
* Jason: what kind of paper we are interested in reproducing, and also which analyses within a paper we would like to reproduce.
* How to read data from github

No progress since last week

Continue to work on the Beninca et al 2008 paper:
* Reproduce fig. 1
* Generated figure is similar to the original one in the paper, but not exactly the same. Is this enough? Do we need to reproduce exactly the same plot?

Next week: go through the modifications sent by Owen


## 24.3

Owen not present.
No meeting.

## 31.3

Owen not present.
No meeting.

## 7.4

Owen not present.
No meeting.

## 14.4

(Minutes by Gian Marco.)

* Owen encourages to meet even in his absence.
* Vanessa has troubles synchronising the github ?> instructions on the wiki.
* Some of us have troubles connecting to the internet ieu Petchey ?> Go to IT to unlock the network.

* Work on the master branch.
* Issue: use package RCurl function getURL to read the file from the internet.
* Recap of previous work done on the Beninca paper.

* Change branch to Figs2b g.
* Fix some details (names of data and variables) in the current branch.
* Check of previous plot of time series.
* Create a color map for the species adding colours to different functional groups.
* Reproduce color figure without magnifications and gaps.
* Try to approximate the gap by removing the data above a given value.
* Plot log scale and fourth root plots.

* Go back to master branch and synchronise.
* Todo for next week: data transformation and Lyapunov exponents.
* Jason shows reproduction of Hiltunen et al. (2014).

## 21.4

(Minutes taken by Frank)

#### Organization:

* no new papers or faces
* change the working of RREEBES: groups (e.g. 2 persons) work in parallel rather than watch Owen code; Tuesdays to present progress and work on specific issues that appeared during group work

##### Continuation reproducing Beninca et al. 2008:

Getting data ready for analysis:

1. interpolation
	* no cubic hermite interpolation function in R, so we use spline to get time points with equidistance of 3.35 days (see open issue)
	* spline -> provides various methods, we are not sure which may be the exact corresponding method but hopefully it should not matter too much for following analysis; potential alternative package pracma

	* interpolations look mostly reasonable, but seems strongly affected by NAs in the data; funky shapes that go below zero for some species

2. transformation 
	* use fourth square root transform to get rid of sharp spikes
	* some question whether we should do the transformation before the interpolation: in Beninca et al, it is done after interpolation, but we do it before

3. Detrending
	* detrending the data with gaussian kernel (function ksmooth())

4. Scaling
	* re-scaling data to mean 0 and SD of 1


**We are now ready analyze the data (y variable in dataset final)**


#### Distributing tasks for next meeting:

* spectral analysis: Jason, Frank
* table: Kevin, Marco
* Lyapunov (direct): Gian-Marco, Mikael
* Lyapunov (indirect): Vanessa, Dennis

Some material collected by Owen to assist with analyses found here: /Beninca_etal_2008_Nature/report/material_to_use



## 28.4
(Minutes taken by Jason)

#### Organization:

* Gian Marco suggests paper on ABC

#### Issues:

*Owen opened issues regarding transformations: not sure if data transformation methods match those of original paper (date ranges not the same: Nature supplement vs Ellner file info)

##### Continuation reproducing Beninca et al. 2008:
##### Progress
*Transformations improved by Owen using Pracma package. Still need to do data removal
*Method avoids values less than zero and large peaks

* Frank and Jason implemented some Spectral density estimation analyses  
* Discussed the purpose of the spectral analysis
* Seem to be differences between the reproduction of J & F when compared to that of Beninca et al.
* Should check for differences between transformed data produced by this group and the authors.

##### Break out to work on group sections

## 5.5
(Minutes by Mikael)

*Owen introduces REEBES to Alejandra
*Progress since last meeting
	-Marco did reproduce table1.
		-Table 1. was reproduced and the results were qualitatively similar. 
	-Frank and Jason did some progress on the spectral analysis.
	-Vanessa and Dennis has started working on the Lyapunov (indirect) but has done little progress.
	-Gian-Marco and Mikael did not make any progress on Lyapunov (direct).
*The different groups worked independently on their problems. 

## 12.5
(Minutes by Mikael)

*The different groups worked independently on their problems.

## 19.5

(Owen takes minutes.)

Colette Ward present as a guest. Many others not present.

* Owen showed the work he did while in China, on the Beninca paper, so that we can move on to a new paper.
* Still a few issues with the Beninca paper reproduction, but probably 90% complete. Owen (and anyone else interested) will clean up the reproduction and fix any remaining issues.
* Next week we will decide on the next paper to reproduce, and start on that.

## 26.5

(Minutes by Gian Marco)

Outstanding issues for Beninca paper

Owen shows figure 2 and 3. Figure 2 seems to be quite wrong and needs a bit of fixing.
Marco shows table 1 which also needs work (issue created).
The code is running and needs just cleaning.

Owen suggests to go through papers we might reproduce, specifically Lagrue et al., Graham et al., Ward et al. 
We need to check data availability. We should split into groups and commit to reproduce the papers working at least one hour a week.

Vanessa knows about a tutorial on Github at the beginning of June.
Thomas would like to add a paper to reproduce.

We split into groups, reading the papers and looking for the data.
Mikael Frank Aurelie work on Ward et al.    
Thomas Vanessa and Gian Marco work on Graham et al.     
Marco and Alejandra work on Lagrue et al.     


## 2.6

(Minutes by Frank)

###Any suggested papers added to the repository?

New papers added by Alejandra, Marco and Thomas

###Any outstanding issues?

Some conflicts resulted from multiple additions of new papers (2 issues); 
Owen resolved the two issues demonstrating how to fix the file causing the conflict.   
NB: being a collaborator you can send a pull request (via github) and then merge it yourself.

2 sections added to organize "potential papers to reproduce": 
* papers in progress
* papers where reproduction failed because of unavailable data etc.

###Any progress on focal paper since last week?

Ward et al. -> raw data, processed data and scripts provided by Eric Ward; does not work out of the box 
because only subset of data available; opens question how to proceed with papers that have high 
degree of reproducibility from the start.

Graham et al. -> data not made public yet, hence no reproduction possible. Will be stated as a matter of fact in the repo. 

Lagrue et al. -> Marco & Alejandra reproduced two first figures of paper




## 9.6
(Minutes by Aurelie)

###New papers added
* Hekstra. But the data could NOT be public. Find a solution to do not show the data (cf. Issue 81)
* Hooper *et al.*. Meta-analysis paper on biodiversity loss as a driver of environmental changes.
	* integrative study
	* deal with big data (200 papers)
	* **high priority** for RREEBES

###On going papers
* Lagrue. 
	* Three figures reproduced, and on going tables (maybe not exactly the same format)
	* it is a goof example for learning R
* Ward.
	* Code provided by the author.
	* Keep on familiarising with the script also provided.
* Graham.
	* CANCELLED because data can not made available to public.
* Vanessa, GM and Thomas focusing now on TREE paper
* Beninca. 
	* Owen fixing the last figures: fig.3 (parameters are not the same), fig.2 (some differences in the slope and pattern), and tab.1 (OK).

###General information
* Publishing the reproduction: using the GitHub webpage instead of RPubs.
* Getting data on desktop: (cf issue 77). possibilities:
	* cloning repository
	* reading from GitHub online and "save as"
	* using the URL of the "raw" script available online
* Finished paper: give a short presentation to the class/group of the methods used.
* Management of the repository: 
	* each paper must has a new branch (and we work on this specific branch until the paper is finished).
	* can work directly on the master branch to update the minutes or new papers.
* Possibility to use a saved back up:
	1. On the local repository, 
	2. in the commit history,
	3. select the last commit that you want to keep,
	4. on the parameter option, prefer to click on "revert this commit" 

## 16.6

(Minutes by Marco)

Present: Owen, Thomas, Aurelie, Marco, Gian Marco, Alejandra, Vanessa.

### Progress

* Lagrue: to be finished in 1-2-hour work time.
* Ward: ongoing.
* Morales-Castilla: foodweb data available. Trait-based criteria used to remove redundant links are obscure.

### Minutes

* No new papers added to the ‘to-reproduce’ list.
* What to do once a reproduced paper is done: publish it on GitHug Pages, but wait until most of the group members are present before giving a wrap-up presentation.
* Owen gave a presentation about the newly-implemented RREEBES “wiki” section. There is already a page explaining how to publish a report using GitHub Pages.

## 23.6

Independent work, no formal meeting.

## 30.6

Independent work, no formal meeting.

## 7.7
(Minutes by Thomas)

### Attendance
* Owen, Mikael, Frank, Thomas, Marco, Ale

### General points (Owen)
* How to proceed with the publication of data?
	* Use a server located at the University of Zurich. The data remains centrally available for us (no local copies on everyone's computers), but is not publicly accessible.
	* The rules of how to deal with (specific) data sets have to be included in the Wiki.

### Progress
* LAGRUE et al. (Marco, Ale)
	* 99% done.
	* Moved to 'finished papers'.
	* Could be reproduced rather easily.
	* Some questions remained open and some doubts were raised. Maybe, these will be answered or better understood when we have all read the paper...
* WARD et al. (Mikael, Frank)
	* (Almost) Done.
* MORALES-CASTILLA et al. (Thomas)
	* The data to immediately reproduce their analyses is still not there. We (Thomas, Vanessa, Gian Marco) would have to go deep into the reference papers to a) see which species feed upon which, and b) get information about the species'/guilds' traits.
	* Once Vanessa and Gian Maro are back, we will discuss whether we will do this - or whether we go with another paper whose data is easy to obtain to immediately start working.
	* A summary is written soon that will a) show how far we proceeded and b) provide our impression of the paper and the attempt to reproduce it.

### Others
* Frank introduced [Project Jupyter](https://jupyter.org), a online platform to share **and** interactively modify code.
	

## 14.7

*No new papers in the repository

*Issues
Make the wiki entry: what is meant by reproducible research; what we mean and in what context; you can add blogs on what this means – reproducible analysis.
Look at how Ropensci might help us – will help on the Data Carpentry course
Morales-Castilla – Thomas, Vanessa and Gian Marco will continue to work on it. 

*Start reproduction of:
Hooper et al. – Ale and Aurelie will start working on this. Maybe Marco and Dennis could join in the future 
Hekstra et al – Frank and Owen will start this (Mikael can join later)
So these two papers were moved to “papers currently being reproduced”

*Ward et al. 
Frank did a presentation of a nice partial reproduction they have been working on with Aurelie and Mikael. Next meeting to discuss more: take a look at the calendar and check when most people will be present


## 21.7

Minutes by Mikael, REEBES 2015-07-21

New papers
Frank presented Tessa et al 2012 and AR models as a potential reproduction. Frank also presented Chih.hao et al 2008 as a potentially interesting paper to reproduce. 

Papers on the way 
The group reproducing Morales-Castilla et al 2015 has had some problems with the structure of data but they are working on the data to get in shape. The reproduction my possibly be terminated.  

Hooper et al 2012 is on its way to be reproduced, meta-analysis data has been downloaded. 

No progress on Hekstra et al 2012

Individual work continued 

## 28.7

No meeting.

## 4.8

No meeting.

## 11.8

Minutes by Frank

No new faces

#New papers added?       
Alejandra suggested a global meta-analysis by Gernster et al. 2014

#Progress on reproductions     

Hoekstra: No progress, except that Owen set up the repository; still waiting for the data    

Hooper:  Ale had issues with Github links -> data was not read properly, but issues could be solved when data is read from raw format page
Otherwise, Alejandra started to get a feeling for the data and started reproducing table 1; some R code to reproduce figures was provided by the authors     

Morales-Castilla paper: GM and Thomas had some issues syncing repos and still work on getting the data into shape -> species description, trophic links etc     

#Best practices

Thomas suggested to discuss best archiving practices. Possiblity of a best practice document about data archiving:
we will look at available articles, focus on user experience rather than logic.      

Some information can be found here:    
[Blog post on Methods in Ecology and Evolution blog](https://methodsblog.wordpress.com/2015/03/26/open_data_and_reproducibility/)

[‘OpenData and Reproducibility Workshop: the Good Scientist in the Open Science era’](http://www.britishecologicalsociety.org/events/current_future_meetings/past-bes-symposia/mee-anniversary-symp/#sthash.px0yaMbb.dpuf)

[White EP, Baldridge E, Brym ZT, Locey KJ, McGlinn DJ, Supp SR.  2013.  Nine simple ways to make it easier to (re)use your data. Ideas in Ecology and Evolution. 6(2):1-10.](http://library.queensu.ca/ojs/index.php/IEE/article/view/4608)

## 18.8

Minutes by Vanessa

###Attendance
* Owen, Frank, Thomas, Karthik and Vanessa

###New people
* Karthik Ram was present in the meeting and gave a brief introduction about his work.

###Progress updates
* Moriles-Castilla et al. 2015: Gian Marco and Thomas have been trying to organize the data and put it in R. 
* Hooper et al. 2012: no members of this reproduction were present in the meeting
* Hekstra & Leibler 2012: Owen in contact with the authors, waiting for the data.

Discussion with Karthik about why we could not reproduce some papers.

Individual work continued.

## 25.8

No meeting.

## 1.9

No meeting.

## 8.9

Minutes to come, from Aurélie.

## 15.9

No meeting.

## 22.9

Minutes by Frank

Attendance: Vanessa, Frank

### New papers
Huisman & Weissing 2001 added by Owen

### Issues
* Frank briefly outlined Tad's suggestion about publishing reproductions on ReScience
* Owen did some trials and aims to publish the Beninca reproduction; however, ReScience probably only suitable as outlet for some reproductions as some effort needed to format our html reports 

### Progress
Ward et al. reproduction finalized and put on gh-pages branch


## 29.9

## 6.10

Minutes by Vanessa

###Attendance
* Owen, Frank, Thomas, Mikael, Gian Marco, Aurèlie, Alessandra and two guests, Sebastian Diehl and Åke Bärnnström 

###Progress updates
* Thomas, Gian Marco and Vanessa (Morales-Castilla et al): not all data available, data in bad format
* Alejandra and Aurèlie (Hooper et al): no progress on the last weeks, R code already available, trying to understand it. Is it a reproduction if the code provided by the authors is used?
* Tad (Yampolsky et al): no update
* Owen, Frank and Mikael (Hekstra et al): data available only on our server on the hekstra branch, not on github for everyone. Original data not in R friendly format, now it is tidy.

###Discussion
* What is the use of the reproductions we do? 

* Which languages are suitable for reproductions? Is Matlab a suitable language? 

* ReSience Journal

* Manual on how to store your data originated from the experience with REEBBES?

* Knowledge network for biocomplexity, a data repository

## 13.10
Minutes by Aurélie

###Attendance
* Frank, Gian Marco, Vanessa and Alejandra

###Progress updates
* Morales-Castilla et al: move it to "inappropriate data" section 
* Allesina et al: move it to "on-going papers" section. Progress on the set up, basic parameters, functions, making foodwebs, plot adjancency matrices, who eats whom and bivariate distribution Z.
* Hooper et al: no progress since last week.

## 20.10

Aurelie and Owen chat about improvements to the Beninca ReScience submission.

## 27.10

Gian Marco, Owen, Aurelie, Alejandra

Hooper reproduction: some decisions about what will not be reporoduced (e.g., a table). This is fine, but that a element won't be reproduced, and the reason for this decision should be documented in the reproduction. Hooper gave the code to make the figures, but we'll make them again using a different method.

Allesina reproduction: still looking at the paper, to understand methods and what will be useful to reproduce.

Hekstra & Leibler: no progress since last week. (at stage of reproducing the first figures.)

Please look at the Beninca ReScience submission for next week.

## 3.11

## 10.11
Minutes by Vanessa

###Attendance
* Owen, Frank, Aurèlie, Alejandra, Vanessa, Thomas, Pablo and Mikael 

###Progress updates
* Owen and Frank (Hekstra et al): no progress since last week
* Owen (Beninca et al): discuss the final version of the reproduction next week  
* Aurèlie and Alejandra (Hooper et al): testing a new package to reproduce the meta-analyses instead of using the R code sent by the authors
* Vanessa, Thomas and Gian Marco (Allesina et al): no progress since last week
* Mikael: will start the reproduction of the paper Ito and Dieckmann 2007

## 17.11
(minutes by Thomas)

* present: Owen, Ale, Frank, Aurélie, Vanessa, Frank, Pablo, David, Thomas

* discussing whether, and if 'yes', when to do an introduction to GitHub (only working group-affiliated people, department-wide ?) -> session on **November 25th, 3-4 pm** for Andrea, Pablo and David

* going through open issues
	* What about the Beninca paper? All people replied or gave feedback/comments?
	* What about a prioity scale for these issues? "What's most important to close?"

* Progress updates:
	* Ale (Hooper, 2012): Need/want more data. No answer for now. Is the raw data available? Will it ever be?
	* Frank/Owen (Hekstra, 2012): "No progress." Wait, Owen has something done!  :smiley:  This progress involves making graphs and plots to dispplay species interactions.
	* Vanessa/Thomas (Allesina, 2015): Data set from Brose et al. (2005, Ecology) implemented in the code/report. This is needed to construct the community matrix *M* from the adjacency matrix *K* and the bivariate distribution *Z*.
	*  Mikael (Ito & Dieckmann, 2007): Started working on this.
	
* How could Pablo and David contribute?

* Submission of the Beninca et al. (2008, Nature) reproduction.
	* What is [Rescience](http://rescience.github.io)? 
	* Owen going through the reproduction/manuscript.
		* in general, all results are **qualitatively** reproduced rather than quantitatively.
		* Instead of putting plot next to each other for comparision, Owen correlated the data. 
		* What hampered one to come up with a quantitatively identical reproduction of reults is discussed in the discussion.
		* Outanding issues are investigated by Rescience.
		* Comments from Frank abut Fig. 4: This missmatch is striking. How careful should one be with publishing reproductions that do not exactly match the original results? How to deal with criticism? "You're telling us we're wrong?! Well have a look at your code, man!"
		* Should one go through the code again, very, very carefully? Owen will check it again!
		* Thomas: Why publishing with Rescience? Frank: To reach more people, gets a DOI...
	* In general, it is very hard to set up a manuscript in the environment Rescience provides/requires. To get more submissions they should make this process easier!
	

## 24.11
Minutes by Vanessa

###Attendance
* Frank, Aurèlie, Pablo, Vanessa, Alejandra and David 

###Progress updates
* Aurélie and Alejandra (Hooper et al): still waiting for the data from the authors, difficulties of reproducing meta analyses
* Vanessa, Thomas and Gian Marco (Allesina et al): still working on the Z matrix, Frank suggested using ROpenSci to access ITIS
* Frank (Hsieh et al): read the paper, started learning a package to perform the forescasts and started simulations in R

* Alejandra suggested creating a list with new packages we learn during the reproductions

## 1.12
Minutes by Aurélie.
Attendance: David, Mikael, Pablo, Gian Marco, Thomas, Ale, Vanessa, and Aurélie

### Progress updates
* Alesina: problem with the database (composition data and website -> possible errors of entries in the database)
* Hooper: finishing the report
* Ye: David involved and learn about the reproduction
* Ito: Some progress and short presentation planned for January


## 8.12
Minutes by David

###Attendance
* Owen, Aurélie, Pablo, Frank, Mikael,  Gian Marco, Alejandra, Thomas, Vanessa, David

###Owen Intro
* Mikael is going to administrate the course, while Owen is on sabbatical
Looking back at 2015
* a lot has been done, mostly about what to do, when to stop and what is to learn from reproductions
* reproduced 4 papers, some attempted and could not be finished

###Progress updates
* Owen (Hekstra et al): figured out what on earth they were doing. They looked at how microbes grow in enclosed vessels, interested in statistical laws (patterns), explain variation across replicates (look for covariation, pc analysis). Owen will delve a bit further in, but will probably not produce a reproduction of the paper
* Frank (Hsieh et al): simulation study, package to do non parametric forecasting, Gian-Marco will help with simulation
* Mikael (Dietmann et al): fast simulation approach, will (hopefully) show some simulation at the beginning of next year
* Alejandra and Aurélie (Hooper et al): metaanalysis, loss of biodiversity is a major driver of change, no access to raw data (only summary), r-codes were however provided, move onto something new after christmas
* Vanessa and Thomas  (Allesina et. al): comparing species names with the taxonomy website does not work, Thomas asked for filtered data, got provided probably everything to reproduce the paper, use the script to see if it really works, or reproduce parts of the code

* next RREEBES at 5.1.2016

## 15.12
no meeting.

## 22.12
no meeting.


## 05.01.2016
Minutes by Mikael

## Attendance
Mikael, Frank, Thomas, Pablo and David

## Introduction by Mikael
We discussed where we want to take REEBES for the year 2016.
    
Mikael suggested that REEBES could be more of journal club were papers and analyses are discussed such that all group members get some insights to all papers. Rather than having each person reading the updates on github or even waiting for the full report to be finished the REBEES meetings can be used more as a presentation and discussion forum. One or two groups could, for example, walk the group through what was done so far in the reproduction and more importantly explain why the analyses were done in the paper.
 
Suggested guidelines for REEBES meetings:  
- Each group introduces the paper before a reproduction starts such that all know what the paper is about and why it is relevant for REEBES and the Petchey group.
 
- At least ones a month each group walks the others through their reproduction and explain what and why the analysis was done. This forces the reproducers to understand the analyses and circumvents the issue of using available code without understanding what it does.
 
Frank suggested having recurrent recap of the tools that lay at hand (e.g git, github and R) for our reproduction. Similar to the R-lunch such recaps can involve presentations of the tools (by e.g. Frank) and jointly solving problems that the groups might have experienced during resent reproductions. This will help each of us reproduce science in REEBES and make our own science better and reproducible.
  
Frank also suggested to have sessions were the group learns more about reproducible science in general. Why is reproducibility important? What facilitates reproducibility? By answering these questions we can change parts of our day to day work towards better reproducibility. 

Thomas suggested having some common template for our reproductions posted on github. In particular it is important to introduce the paper properly and to explain why certain analyses were done. 


## 12.01.2016
Minutes by Pablo

## Attendance
Mikael, Frank, Thomas, Pablo, David, Aurélie, Gian Marco

## Progress update
We discussed the planning for the RREEBES in 2016. Mikael and Frank let the people know about the ideas of the last meeting.
We decided to start effectively the reproductions in the next week meeting (19.01), when Mikael will present the reproduction of the paper Ito and Dieckmann 2007. 
Aurélie, Alejandra and Pablo will present the Hooper et al (2012) paper in the next week or the next. 


## 19.01.2016
Minutes by Aurélie.
Attendance: Mikael, Gian Marco, David, Aurélie and Owen (by Skype)

### Guidelines for RREEBES to Owen 
### Presentation by Mikael
Reported to next week (26th January) with the Hooper's presentation

## 9.2.2016
Minutes by Frank    
Attendance: Aurélie, Andrea, Frank, Vanessa, Thomas, Owen (by Skype), Colette    

Presentation by Aurélie about the reasons why the Hooper et al. reproduction will not be continued:   
- main problem is access to the raw data needed for estimating effect sizes with metafor package  
- authors provided code for some figures that worked well, however, access to code limits motivation to do the cumbersome reproduction yourself   
- still some lessons learned during the reproduction about data integration and different types of errors one has to deal with during meta-analysis
- branch will be merged to master and reproduced bits published on the github page

Andrea and Colette will think about papers they want to reproduce (hint: Thomas looks for help on reproducing the Allesina paper on food webs)   

next presentations by Vanessa and Frank   

## 16.2.2016
Minutes by Frank    
Attendance: Aurélie, Andrea, Frank, Vanessa, Owen (by Skype), Colette, Mikael

Presentation by Vanessa about her reproduction of Xiong et al.:   
- transcriptome analysis on Tetrahymena thermophila during three life stages (growth, starvation, conjugation)
- main goal: learn the methods used by the authors to do transcriptome analysis
- paper already a couple of years old, so difficulty of getting the proper versions of the software used. However, as it is more about learning the tools, newer versions of software and algorithms will be used and consistency with previous results checked.
- challenges with data size with consists of multiple gigabyte sized files

Owen has produced an almost final version of the Beninca et al. 2008 reproduction, ready to be submitted to ReScience asap

Owen has added some analysis to the Ward et al. 2014 reproduction due to some recent discussions of the paper in a journal club at Gainesville University:
- instead of asking what is the best method across all time series, he looked how the error decreases overall by always chosing the best model for a particular time series

Next presentations: Frank, Aurélie and then Colette or Andrea

## 23.02.2016
Minutes by Vanessa

###Attendance
* Frank, Mikael, Vanessa, Wilfredo, Andrea, Colette and Owen (by Skype)

###New people
* Wilfredo 

###Issues
* Data archiving paper: to be discussed in the next meeting with no presentation (March or later)

###Progress updates
* Owen (Beninca et al): code to calculate Lyapunov exponents tested and working well; plots for figure 2 were also enhanced. Manuscript ready to be submitted to ReScience

###Presentation
Frank presented his work so far in the reproduction of Hsieh et al 2008 paper:
* Model to generate the time series was implemented with the help of Gian Marco. Model still needs to be improved.
* Simplex projection from rEDM package

Next week: no meeting (IEU Assembly)
Next presentations: Aurélie and then Andrea


###Meeting 08-03-2016

Minutes by Mikael

Attendance: Aurelie, Frank, Vanessa, Mikael, Andrea, Wilfredo

Issues: Now outstanding issues were discussed. 

Progress updates: Aurelie introduced the paper she is reproducing, Brennan G. and Collins S. (2015) Growth responses of a green alga to multiple environmental drivers. Data available onDRYAD

Future meetings: Andrea will present here reproduction next week, Dambacher et al 2002 Ecology. 
Willfredo will present his paper the week after that, Hanks et al 2015, The Annals of Applied Statistics. 



## 15.03.2016
Minutes by Aurelie

###Attendance
* Mikael, Vanessa, Andrea & Aurelie

###Issues
* no issues

###Progress updates
* Vanessa: some progress and problem. The package used in this paper is not maintained anymore. Which version should be use for the reproduction? The newest would be useful for further analyses.
* Mikael: no new reproduction planned before the baby's venue
* Wilfredo presents next week
* Aurelie: no progress so far

###Presentation
Andrea presented Dambacher's paper.
Interest for this paper: her predictability review.


## 22.03.2016
no meeting

## 29.03.2016

