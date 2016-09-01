### Notes

This calculator works step by step through a framework of variant assessment.  For a disease of interest the user inputs parameters that describe the genetic architecture of the condition, and the calculator computes the maximum expected allele frequency of a disease-causing variant in the general population (*maximum credible population AF*). In a second step, the calculator determinues the maximum tolerated allele count in a specific reference population (such as ExAC), based on the size of the population and at a user-specified confidence level.  

#### Define genetic architecture to calculate the maximum credible population AF:

**Inheritance** -  select the mode of inheritance

**Prevalence** - the prevalence of the condition, expressed as e.g. 1/1000 people (rather than 1/2000 chromosomes, for example).

**Genetic and allelic heterogeneity** - `genetic heterogeneity` is the maximum proportion of disease attributable to variation in a single gene, and `allelic heterogeneity` is the maximum proportion of variation *within a gene* that is attributable to a single allele.  For recessive conditions it is important to define these terms separately, as they have distinct effects on the architecture.  For dominant conditions these can be combined if convenient - e.g. if a condition is caused by 5 genes, each harbouring 10 pathogenic alleles of equal prevalence, the user can set `genetic heterogeneity = 0.2` and `allelic heterogeneity = 0.1`, or it may be more convenient or intuititive to leave genetic heterogeneity at 1, and set `allelic heterogeneity = 0.02`, directly indicated that no single variant causes more than 2% of cases.

**Penetrance** - select a value in the range 0-1 to represent penetrance

#### Define reference sample to calculate the corresponding maximum tolerated sample AC:

For a given true population AF, the calculator provides an upper limit to the likely sample AC, depending on the size of the population and the desired confidence.

**Confidence** - select in the range 0.9 - 0.999.  This value represents the probability of observing a sample AC ≤ the reported maximum AC.  Increasing the confidence level increases the maximum AC that would be considered compatible with disease-causation.  Defaults to 0.95.

**Reference population size** -  We recommend using the number of alleles *successfully sequenced* at the site (often denoted AN in the vcf file) rather than the full population size to calculate an accurate maximum AC. The stringency of the approach depends the reference population size: the smaller population, the wider the effective confidence interval will be.  Defaults to 121,412, representing a variant succesfully genotyped in the entire ExAC population.


The homepage contains a link to the references for the mathematical derivations of these computations.  
<br>
<br>
<br>
*alleleFrequencyApp - a Shiny App for allele frequency calculations Copyright (C) 2016 James Ware*