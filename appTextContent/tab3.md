### Notes

Here we start by computing a *maximum credible population AF* for a given genetic architecture, as described under the `calculate AF` tab.  It also allows you to fix the maximum population AF in order to find a genetic architecture that **is** compatible with the observed data. For example, under your initial assumptions about a condition you may find that a variant is reported to be too common, but that it would be compatible with disease under a model of substantially reduced penetrance. 

The calculator takes any three parameters, and returns the fourth.
Currently implemented for dominant conditions only.

**Prevalence** - the prevalence of the condition, expressed as e.g. 1/1000 people (rather than 1/2000 chromosomes, for example).

**Heterogeneity** - combines `genetic heterogeneity` and `allelic heterogeneity` the maximum proportion of cases attributable to any single allele (in any gene).

**Penetrance** - select a value in the range 0-1 to represent penetrance.

**Maximum credible population AF** - likely calculated using the `inverse AF` function, to correspond to an actual observed AC in the reference sample.


The homepage contains a link to the references for the mathematical derivations of these computations.  
<br>
<br>
<br>
*alleleFrequencyApp - a Shiny App for allele frequency calculations Copyright (C) 2016 James Ware*
