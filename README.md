## Instructions 

1. Clone this repository.
```bash
git clone git@github.com:iangow/benchmark.git
```
2. Open `benchmark` project in RStudio. 
3. Run the following lines.

```r
library(knitr)
system.time(knit("benchmark.Rnw", quiet = TRUE))
```

## Results

1. Mac mini M1.

```r
> library(knitr)
> system.time(knit("benchmark.Rnw", quiet = TRUE))
   user  system elapsed 
 55.158   4.612  59.430 
```

2. 2013 i7 3770k

```r
> library(knitr)
> system.time(knit("benchmark.Rnw", quiet = TRUE))
   user  system elapsed 
122.423   5.316 124.959 
```
3. 2017 12-core Xeon

```r
> library(knitr)
> system.time(knit("benchmark.Rnw", quiet = TRUE))
   user  system elapsed 
147.332   8.139 153.510 
```
4. 2009 Mac Pro (2011 hex-core Xeon W3690)
```r
> library(knitr)
> system.time(knit("benchmark.Rnw", quiet = TRUE))
   user  system elapsed 
152.317  20.556 170.725 
```
