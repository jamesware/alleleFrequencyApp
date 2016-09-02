### Notes

This effectively reverses the `calculate AC` function: starting with an observed allele count, it computes an associated threshold *filter allele frequency* for a variant. Technically, this is the highest disease-specific *maximum credible population AF* for which the observed AC is **not** compatible with pathogenicity.  More practically, If the *filter allele frequency* of a variant is above the *maximum credible population AF* for a condition of interest, then that variant should be filtered (ie not considered a candidate causative variant). 

The *filter allele frequency* corresponds to the "filter_AF" annotation in the ExAC dataset. The value in ExAC was computed for a 95% confidence - here the user can choose from a range of thresholds.

**Observed population AC** - e.g. in ExAC.

**Reference population size** -  we recommend using the number of alleles successfully sequenced at the site (often denoted AN) rather than the full population size.  Defaults to 121,412, representing a variant succesfully genotyped in the entire ExAC population.

**Confidence** - select in the range 0.9 - 0.999.  This value represents the probability of observing a sample AC $\le$ the reported maximum AC.  Increasing the confidence level increases the maximum AC that would be considered compatible with disease-causation.  Defaults to 0.95.


The homepage contains a link to the references for the mathematical derivations of these computations.  
<br>
<br>
<br>
*alleleFrequencyApp - a Shiny App for allele frequency calculations Copyright (C) 2016 James Ware*
