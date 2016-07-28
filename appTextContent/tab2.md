###Notes

For a given *maximum credible population AF*, this calculator determinues the maximum permissible allele count in a specific reference population (such as ExAC), based on the size of the population and at a user-specified confidence level.  

**Maximum population AF** - this can be calculated from the genetic architecture on the `calculate AF` tab, or input directly here (intended to save time for returning users).

**Reference population size** -  we recommend using the number of individuals successfully sequenced at the site rather than the full population size to calculate an accurate maximum AC. The stringency of the approach depends the reference population size: the smaller population, the wider the effective confidence interval will be.  Defaults to 121,412, representing a variant succesfully genotyped in the entire ExAC population.

**Confidence** - select in the range 0.9 - 0.999.  This value represents the probability of observing a sample AC $\le$ the reported maximum AC.  Increasing the confidence level increases the maximum AC that would be considered compatible with disease-causation.  Defaults to 0.95.


The homepage contains a link to the references for the mathematical derivations of these computations.  