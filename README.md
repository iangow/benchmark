## Instructions 

0. Make sure you have the following packages installed: `dplyr`, `tidyr`, `xtable`, `lfe`. If you don't running `install.packages(c("dplyr", "tidyr", "xtable", "lfe"))` in R should take care of this for you.
1. Clone this repository.
```bash
git clone git@github.com:iangow/benchmark.git
```
2. Open `benchmark` project in RStudio. 
3. Run the following lines.

```r
system.time(source("benchmark.R", echo = FALSE))
```

## Results

1. Mac mini M1.

```r
system.time(source("benchmark.R", echo = FALSE))
   user  system elapsed 
 48.427   3.359  50.993 
```

2. 2013 i7 3770k

```r
> system.time(source("benchmark.R", echo = FALSE))
   user  system elapsed 
111.875   3.732 112.726 
```
3. 2017 12-core Xeon

```r
> system.time(source("benchmark.R", echo = FALSE))
   user  system elapsed 
132.974   5.147 136.355 
```
4. 2009 Mac Pro (2011 hex-core Xeon W3690)
```r
> system.time(source("benchmark.R", echo = FALSE))
   user  system elapsed 
136.982  15.603 149.548 
```
