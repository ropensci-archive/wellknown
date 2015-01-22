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

### Polygon


```r
poly <- list(type = 'Polygon',
      coordinates=list(
        list(c(100.001, 0.001), c(101.12345, 0.001), c(101.001, 1.001), c(100.001, 0.001)),
        list(c(100.201, 0.201), c(100.801, 0.201), c(100.801, 0.801), c(100.201, 0.201))
))
dump_polygon(poly)
#> [1] "POLYGON ((100.0010000000000048 0.0010000000000000, 101.1234500000000054 0.0010000000000000, 101.0010000000000048 1.0009999999999999, 100.0010000000000048 0.0010000000000000), (100.2009999999999934 0.2010000000000000, 100.8010000000000019 0.2010000000000000, 100.8010000000000019 0.8010000000000000, 100.2009999999999934 0.2010000000000000))"
```

