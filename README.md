wellknown
=======

`wellknown` - convert WKT and WKB to GeoJSON.

## Install


```r
install.packages("devtools")
devtools::install_github("sckott/wellknown")
```


```r
library("wellknown")
```

## GeoJSON to WKT

### Point


```r
point <- list('type' = 'Point', 'coordinates' = c(116.4, 45.2, 11.1))
dump_point(point)
```

```
## [1] "POINT (116.4000000000000057 45.2000000000000028 11.0999999999999996)"
```
