# Uniform and Scalable Sampling of Highly Configurable Systems

Software artifacts of the following paper submitted for publication to Empirical Software Engineering (2021):

*Ruben Heradio, David Fernandez-Amoros, José Galindo, David Benavides, and Don Batory*. 
**Uniform and Scalable Sampling of Highly Configurable Systems.**

## Abstract

Many relevant analyses on configurable software systems remain intractable because they require examining colossal and highly-constrained configuration spaces. Those analyses could be addressed through statistical inference, i.e., working with a much more tractable sample that later supports generalizing the results obtained to the entire configuration space. To make this possible, the laws of statistical inference impose an indispensable requirement: each member of the population must be equally likely to be included in the sample, i.e., the sampling process needs to be "uniform". Several SAT-samplers have been developed for generating uniform random samples at a reasonable computational cost. Unfortunately, there is a lack of experimental validation over large configuration models to show whether the samplers indeed produce genuine uniform samples or not. This paper (i) presents the new statistical test SFpC to verify to what extent samplers accomplish uniformity, (ii) proposes a new sampler named BDDSampler, and (iii) reports the evaluation of BDDSampler and other five state-of-the-art samplers: KUS, QuickSampler, Smarch, Spur, and Unigen2. According to our experimental results, only BDDSampler satisfies both scalability and uniformity.

## Acknowledgements

This work has been partially funded by the Universidad Nacional de Educacion a Distancia (project OPTIVAC 096-034091 2021V/PUNED/008); the Spanish Ministry of Science, Innovation and Universities (project OPHELIA RTI2018-101204-B-C22); the Community of Madrid (research network ROBOCITY2030-DIH-CM S2018/NMT-4331);  the TASOVA network (MCIU-AEI TIN2017-90644-REDT); and the Junta de Andalucia (METAMORFOSIS project).


## Summary

This repository is organized into two main directories:

* [scripts](https://github.com/rheradio/ConfSystSampling/tree/main/scripts), includes the R scripts to replicate our experimental validation (i.e., to calculate each model's sample size, run the samplers, and test the scalability/uniformity of the samplers).
* [reports](https://github.com/rheradio/ConfSystSampling/tree/main/reports), includes the detailed experimental results we performed to answer the following research questions:
  + [Q1: Samplers’ scalability](https://htmlpreview.github.io/?https://github.com/rheradio/ConfSystSampling/blob/main/reports/q1_samplers_scalability.html). Are BDDSampler, KUS,  QuickSampler, Smarch, Spur, or Unigen2 able to generate samples with 1,000 configurations out of any size models within one hour?
  + [Q2: Samplers’ uniformity](https://htmlpreview.github.io/?https://github.com/rheradio/ConfSystSampling/blob/main/reports/q2_samplers_uniformity.html). Do BDDSampler, KUS,  QuickSampler, Smarch, Spur, or Unigen2 always generate uniform SAT solutions?
  + [Q3: SFpC’s scalability](https://htmlpreview.github.io/?https://github.com/rheradio/ConfSystSampling/blob/main/reports/q3_sfpc_scalability.html). How much time and how many configurations does SFpC need to check the uniformity of a sampler on a model?
  + [Q4: SFpC's validity](https://htmlpreview.github.io/?https://github.com/rheradio/ConfSystSampling/blob/main/reports/q4_sfpc_validity.html). Does SFpC produce results consistent with the results obtained by other uniformity testing methods?
  + [Q5: SFpC's reliability](https://htmlpreview.github.io/?https://github.com/rheradio/ConfSystSampling/blob/main/reports/q5_sfpc_reliability.html). When SFpC is applied repeatedly to the same model and sampler, are the results consistent?
   
The [benchmark](https://htmlpreview.github.io/?https://github.com/rheradio/ConfSystSampling/blob/main/reports/benchmark.html) we used, and all the samples generated are available at [![DOI](https://zenodo.org/badge/DOI/10.5281/zenodo.4514919.svg)](https://doi.org/10.5281/zenodo.4514919) and [![DOI](https://zenodo.org/badge/DOI/10.5281/zenodo.5509947.svg)](https://doi.org/10.5281/zenodo.5509947). In these repositories, there is a zip file per model, which is organized into the following directories:

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

Also, at the beginning of [run_samplers.r](https://github.com/rheradio/sat_sampling/blob/master/scripts/run_samplers.r) you'll have to configure the constants `BDD_SAMPLER`, `KUS_dir`, `QUICK_SAMPLER`, `QUICK_SAMPLER_VALID`, `SMARCH`, `SPUR`, `UNIGEN2_dir`, and `UNIGEN2` according to the locations where you have installed the samplers.

You need [Rmarkdown](https://rmarkdown.rstudio.com/articles_report_from_r_script.html) to run the ".Rmd" scripts. In those scripts, the constant `MODELS_PATH` should point to the directory containing the samples' information. In particular, the information reported in the paper is available at  [![DOI](https://zenodo.org/badge/DOI/10.5281/zenodo.4514919.svg)](https://doi.org/10.5281/zenodo.4514919).
