---
title: "Reproduce analyses of Hooper et al. 2012"
author: "Alejandra, Aurelie, Marco et al."
starting date: "14th July 2015"
output:
  html_document:
    toc: yes
  pdf_document:
    toc: yes
---

# Introduction


This is an attempt to reproduce the anaylses presented in the paper *A global synthesis reveals biodiversity loss as a major
driver of ecosystem change by Hooper et al. 2012 ([http://jarrettbyrnes.info/pdfs/Hooper_et_al_2012_Nature.pdf]). 

* From the article summary:
There is evidence that extinctions are altering key processes important to the productivity and sustainability of Earth’s eco- systems. Further species loss will accelerate change in ecosystem processes, but it is unclear how these effects compare to the direct effects of other forms of environmental change that are both driving diversity loss and altering ecosystem function. 
The authors used a suite of meta-analyses of published data to show that the effects of species loss on productivity and decomposition — two processes important in all ecosystems — are of comparable magnitude to the effects of many other global environmental changes. 
NUMBER OF SPECIES LOSS: In experiments, intermediate levels of species loss (21–40%) reduced plant production by 5–10%, comparable to previously documented effects of ultraviolet radiation and climate warming. Higher levels of extinction (41–60%) had effects rivalling those of ozone, acidification, elevated CO2 and nutrient pollution. At intermediate levels, species loss generally had equal or greater effects on de- composition than did elevated CO2 and nitrogen addition. 
IDENTITY OF SPECIES LOSS: The identity of species lost also had a large effect on changes in pro- ductivity and decomposition, generating a wide range of plausible outcomes for extinction. 

* From authors

Many experiments have shown that species loss can alter key processes important to the productivity and sustainability of Earth's ecosystems. However, it is unclear how these effects compare to the direct effects of other forms of environmental change that are both driving diversity loss and altering ecosystem function. We used a suite of meta-analyses of published data to show that the impacts of species loss on productivity and decomposition - two processes important in all ecosystems are of comparable magnitude to impacts of many other global environmental changes. These analyses were published by Hooper et al. in Nature in 2012 (online release date: May 2, 2012, DOI: 10.1038/nature11118). This archive contains the data and statistical details for the two sets of analyses found in that paper. In the first, we performed a broad meta-analysis to compare effects of changing species richness on primary production and decomposition, as derived from a database on biodiversity-ecosystem functioning (BEF) experiments, with effects of major environmental changes as derived from already published meta-analyses. For both biodiversity and environmental effects, we use log response ratios for effect sizes. This analysis allows a broad comparison across many experiments, but in so doing, compares effects of species richness with those of other environmental changes in different experiments performed by different researchers in different ecosystems. Therefore, we undertook a second analysis focusing on the relative magnitude of effects of species richness and environmental change in experiments that factorially manipulated both. For this, we used a much smaller subset of experiments from the BEF database, and only analyzed primary production as the response variable. Here we include the data and any processing steps, including R-code and description, that were used in our analyses. In experiments, intermediate levels of species loss (21-40%) reduced plant production by 5-10%, comparable to previously documented impacts of ultra-violet radiation and climate warming. Higher levels of extinction (41-60%) had impacts rivaling those of ozone, acidification, elevated CO2, and nutrient pollution. At intermediate levels, species loss generally had equal or greater impacts on decomposition than did elevated CO2 and nitrogen addition. The identity of species lost also had a large impact on changes in productivity and decomposition, generating a wide range of plausible outcomes for extinction. Despite need for more studies on interactive effects of diversity loss and environmental changes, our analyses clearly show that the ecosystem consequences of local species loss are as quantitatively significant as direct effects of several global change stressors that have mobilized major international concern and remediation efforts.
