# Meetings in 2015

Meetings 10.45 to 12.00 Zurich time, location is variable.

Assign person to take meeting minutes.

New people (get photo)?

Any suggested papers added to the repository?

Any outstanding issues?

Any progress on focal paper since last week?

What to attempt this week (refer to closing note from last week)?

What to attempt next week (to be refered to next week)?

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

## 30.6

## 7.7

## 14.7

## 21.7

## 28.7

## 4.8

## 11.8

## 18.8

## 25.8

## 1.9

## 8.9

## 15.9

## 22.9

## 29.9

## 6.10

## 13.10

## 20.10

## 27.10

## 3.11

## 10.11

## 17.11

## 24.11

## 1.12

## 8.12

## 15.12

## 22.12
