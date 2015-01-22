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
#> [1] "POINT (116.4000000000000057 45.2000000000000028 11.0999999999999996)"
```

### LineString


```r
st <- list(type = 'LineString',
            coordinates = list(c(0.0, 0.0, 10.0), c(2.0, 1.0, 20.0),
                              c(4.0, 2.0, 30.0), c(5.0, 4.0, 40.0)))
dump_linestring(st, fmt=0)
#> [1] "LINESTRING (0 0 10, 2 1 20, 4 2 30, 5 4 40)"
```

