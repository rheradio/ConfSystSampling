# Uniform and Scalable Sampling of Highly Configurable Systems

Software artifacts of the following paper submitted for publication to Empirical Software Engineering (2021):

*Ruben Heradio, David Fernandez-Amoros, José Galindo, David Benavides, and Don Batory*. 
**Uniform and Scalable Sampling of Highly Configurable Systems.**

## Abstract

Many relevant analyses on configurable software systems remain intractable because they require examining colossal and highly-constrained configuration spaces. Those analyses could be addressed through statistical inference, i.e., working with a much more tractable sample that later supports generalizing the results obtained to the entire configuration space. To make this possible, the laws of statistical inference impose an indispensable requirement: each member of the population must be equally likely to be included in the sample, i.e., the sampling process needs to be "uniform". Several SAT-samplers have been developed for generating uniform random samples at a reasonable computational cost. Unfortunately, there is a lack of experimental validation over large configuration models to show whether the samplers indeed produce genuine uniform samples or not. This paper (i) presents a new statistical test to verify to what extent samplers accomplish uniformity, (ii) proposes a new sampler named BDDSampler, and (iii) reports the evaluation of BDDSampler and other five state-of-the-art samplers: KUS, QuickSampler, Smarch, Spur, and Unigen2. According to our experimental results, only BDDSampler satisfies both scalability and uniformity.

## Summary

This repository is organized into two main directories:

* [scripts](https://github.com/rheradio/ConfSystSampling/tree/main/scripts), includes the R scripts to replicate our experimental validation (i.e., to calculate each model's sample size, run the samplers, and test the scalability/uniformity of the samplers).
* [reports](https://htmlpreview.github.io/?https://github.com/rheradio/ConfSystSampling/blob/main/reports/index.html), includes detailed experimental results in order to answer the following Research Questions:
  + [RQ1: Samplers' scalability](https://htmlpreview.github.io/?https://github.com/rheradio/ConfSystSampling/blob/main/reports/rq1_samplers_scalability.html). Are BDDSampler, KUS,  QuickSampler, Smarch, Spur, or Unigen2 able to generate samples out of any size models within a moderate running time?
  + [RQ2: Scalability of our SAT-solution distribution goodness-of-fit test](https://htmlpreview.github.io/?https://github.com/rheradio/ConfSystSampling/blob/main/reports/rq2_goodness_of_fit_scalability.html). Does the test presented in this paper require fewer configurations than any other state-of-the-art method for checking samplers' uniformity?
  + [RQ3: Samplers' uniformity](https://htmlpreview.github.io/?https://github.com/rheradio/ConfSystSampling/blob/main/reports/rq3_samplers_uniformity.html). Do BDDSampler, KUS,  QuickSampler, Smarch, Spur, or Unigen2 generate uniform SAT solutions?
   
The benchmark we used, and all the samples generated are available at [![DOI](https://zenodo.org/badge/DOI/10.5281/zenodo.4514919.svg)](https://doi.org/10.5281/zenodo.4514919). There is a zip file per model, which is organized into the following directories:

* `bool_formula`: includes the model's Boolean encoding as a BDD (`.dddmp`) and a CNF (`.dimacs`).
* `goodness_of_fit`: includes a graphical analysis of the model's goodness-of-fit.
* `population_desc`: population SAT-solution distribution.
* `samples`: samples generated in each sampler's original format.
* `std_samples`: standardized samples. Each sample is characterized according to how the number of variables assigned to true distributes along the SAT-solutions.

## Script code

![Schema summarizing the scripts' workflow: https://github.com/rheradio/ConfSystSampling/blob/main/doc/scripts_workflow_schema.svg](https://github.com/rheradio/ConfSystSampling/blob/main/doc/scripts_workflow_schema.svg)

The syntax to run the ".r" scripts is:

`Rscript script_name.r directory_name`

Where `directory_name` is the folder that stores the models. Models can be downloaded at [![DOI](https://zenodo.org/badge/DOI/10.5281/zenodo.4514919.svg)](https://doi.org/10.5281/zenodo.4514919).

[run_samplers.r](https://github.com/rheradio/ConfSystSampling/blob/main/scripts/run_samplers.r) requires to have installed the following programs:

* [BDDSampler](https://github.com/davidfa71/BDDSampler)
* [histogram](https://github.com/rheradio/VMStatAnal)
* [KUS](https://github.com/meelgroup/KUS)
* [PicoSAT](http://fmv.jku.at/picosat/)
* [QuickSampler](https://github.com/RafaelTupynamba/quicksampler)
* [Smarch](https://github.com/jeho-oh/Kclause_Smarch)
* [Spur](https://github.com/ZaydH/spur)
* [Unigen2](https://bitbucket.org/kuldeepmeel/unigen)

Also, at the beginning of [run_samplers.r](https://github.com/rheradio/sat_sampling/blob/master/scripts/run_samplers.r) you'll have to configure the constants BDD_SAMPLER, KUS_dir, QUICK_SAMPLER, QUICK_SAMPLER_VALID, SMARCH, SPUR, UNIGEN2_dir, and UNIGEN2 according to the locations where you have installed the samplers.

To run the ".Rmd" scripts [rmarkdown](https://rmarkdown.rstudio.com/articles_report_from_r_script.html) is needed
