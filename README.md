wellknown
=======



[![Build Status](https://travis-ci.org/ropensci/wellknown.svg)](https://travis-ci.org/ropensci/wellknown)

`wellknown` - convert WKT to GeoJSON and vice versa.

Inspiration partly comes from Python's [geomet/geomet](https://github.com/geomet/geomet) - and the name from Javascript's [wellknown](https://github.com/mapbox/wellknown) (it's a good name).

## Install


```r
install.packages("devtools")
devtools::install_github("ropensci/wellknown")
```


```r
library("wellknown")
```

## GeoJSON to WKT

### Point


```r
point <- list('type' = 'Point', 'coordinates' = c(116.4, 45.2, 11.1))
geojson2wkt(point)
#> [1] "POINT (116.4000000000000057  45.2000000000000028  11.0999999999999996)"
```

### Multipoint


```r
mp <- list(type = 'MultiPoint',
           coordinates=list( c(100.0, 3.101), c(101.0, 2.1), c(3.14, 2.18)
))
geojson2wkt(mp)
#> [1] "MULTIPOINT ((100.0000000000000000 3.1010000000000000), (101.0000000000000000 2.1000000000000001), (3.1400000000000001 2.1800000000000002))"
```

### LineString


```r
st <- list(type = 'LineString',
            coordinates = list(c(0.0, 0.0, 10.0), c(2.0, 1.0, 20.0),
                              c(4.0, 2.0, 30.0), c(5.0, 4.0, 40.0)))
geojson2wkt(st, fmt=0)
#> [1] "LINESTRING (0 0 10, 2 1 20, 4 2 30, 5 4 40)"
```

### Multilinestring


```r
multist <- list(type = 'MultiLineString',
      coordinates = list(
        list(c(0.0, -1.0), c(-2.0, -3.0), c(-4.0, -5.0)),
        list(c(1.66, -31023.5), c(10000.9999, 3.0), c(100.9, 1.1), c(0.0, 0.0))
      ))
geojson2wkt(multist)
#> [1] "MULTILINESTRING ((0.0000000000000000 -1.0000000000000000, -2.0000000000000000 -3.0000000000000000, -4.0000000000000000 -5.0000000000000000), (1.6599999999999999 -31023.5000000000000000, 10000.9999000000007072 3.0000000000000000, 100.9000000000000057 1.1000000000000001, 0.0000000000000000 0.0000000000000000))"
```

### Polygon


```r
poly <- list(type = 'Polygon',
      coordinates=list(
        list(c(100.001, 0.001), c(101.12345, 0.001), c(101.001, 1.001), c(100.001, 0.001)),
        list(c(100.201, 0.201), c(100.801, 0.201), c(100.801, 0.801), c(100.201, 0.201))
))
geojson2wkt(poly)
#> [1] "POLYGON ((100.0010000000000048 0.0010000000000000, 101.1234500000000054 0.0010000000000000, 101.0010000000000048 1.0009999999999999, 100.0010000000000048 0.0010000000000000), (100.2009999999999934 0.2010000000000000, 100.8010000000000019 0.2010000000000000, 100.8010000000000019 0.8010000000000000, 100.2009999999999934 0.2010000000000000))"
```

### Multipolygon


```r
mpoly <- list(type = "MultiPolygon",
              coordinates = list(list(list(c(30, 20), c(45, 40), c(10, 40), c(30, 20))),
                                 list(list(c(15, 5), c(40, 10), c(10, 20), c(5 ,10), c(15, 5))))
              )
geojson2wkt(mpoly, fmt=1)
#> [1] "MULTIPOLYGON (((30.0 20.0, 45.0 40.0, 10.0 40.0, 30.0 20.0)), ((15.0 5.0, 40.0 10.0, 10.0 20.0, 5.0 10.0, 15.0 5.0)))"
```

### GeometryCollection


```r
gmcoll <- list(type = 'GeometryCollection',
   geometries = list(
     list(type = "Point", coordinates = list(0.0, 1.0)),
     list(type = 'LineString', coordinates = list(c(-100.0, 0.0), c(-101.0, -1.0))),
     list(type = 'MultiPoint',
          'coordinates' = list(c(100.0, 3.101), c(101.0, 2.1), c(3.14, 2.18))
          )
     )
   )
geojson2wkt(gmcoll, fmt=0)
#> [1] "GEOMETRYCOLLECTION (POINT (0 1), LINESTRING (-100 0, -101 -1), MULTIPOINT ((100.000 3.101), (101.0 2.1), (3.14 2.18)))"
```

## WKT to GeoJSON

### Point

As a `Feature`


```r
str <- "POINT (-116.4000000000000057 45.2000000000000028)"
wkt2geojson(str)
#> $type
#> [1] "Feature"
#> 
#> $geometry
#> $geometry$type
#> [1] "Point"
#> 
#> $geometry$coordinates
#> [1] -116.4   45.2
#> 
#> 
#> attr(,"class")
#> [1] "geojson"
```

Not `Feature`


```r
wkt2geojson(str, feature=FALSE)
#> $type
#> [1] "Point"
#> 
#> $coordinates
#> [1] -116.4   45.2
#> 
#> attr(,"class")
#> [1] "geojson"
```

### Multipoint


```r
str <- 'MULTIPOINT ((100.000 3.101), (101.000 2.100), (3.140 2.180))'
wkt2geojson(str, feature=FALSE)
#> $type
#> [1] "Multipoint"
#> 
#> $coordinates
#> $coordinates[[1]]
#> [1] 100.000   3.101
#> 
#> $coordinates[[2]]
#> [1] 101.0   2.1
#> 
#> $coordinates[[3]]
#> [1] 3.14 2.18
#> 
#> 
#> attr(,"class")
#> [1] "geojson"
```

### Polygon

As a `Feature`


```r
str <- "POLYGON ((100 0.1, 101.1 0.3, 101 0.5, 100 0.1), (103.2 0.2, 104.8 0.2, 100.8 0.8, 103.2 0.2))"
wkt2geojson(str, feature=FALSE)
#> $type
#> [1] "Polygon"
#> 
#> $coordinates
#> $coordinates[[1]]
#> $coordinates[[1]][[1]]
#> [1] 100.0   0.1
#> 
#> $coordinates[[1]][[2]]
#> [1] 101.1   0.3
#> 
#> $coordinates[[1]][[3]]
#> [1] 101.0   0.5
#> 
#> $coordinates[[1]][[4]]
#> [1] 100.0   0.1
#> 
#> 
#> $coordinates[[2]]
#> $coordinates[[2]][[1]]
#> [1] 103.2   0.2
#> 
#> $coordinates[[2]][[2]]
#> [1] 104.8   0.2
#> 
#> $coordinates[[2]][[3]]
#> [1] 100.8   0.8
#> 
#> $coordinates[[2]][[4]]
#> [1] 103.2   0.2
#> 
#> 
#> 
#> attr(,"class")
#> [1] "geojson"
```

### MultiPolygon

As a `Feature`


```r
str <- "MULTIPOLYGON (((40 40, 20 45, 45 30, 40 40)),
    ((20 35, 45 20, 30 5, 10 10, 10 30, 20 35), (30 20, 20 25, 20 15, 30 20)))"
wkt2geojson(str, feature=FALSE)
#> $type
#> [1] "MultiPolygon"
#> 
#> $coordinates
#> $coordinates[[1]]
#> $coordinates[[1]][[1]]
#> $coordinates[[1]][[1]][[1]]
#> [1] 40 40
#> 
#> $coordinates[[1]][[1]][[2]]
#> [1] 20 45
#> 
#> $coordinates[[1]][[1]][[3]]
#> [1] 45 30
#> 
#> $coordinates[[1]][[1]][[4]]
#> [1] 40 40
#> 
#> 
#> 
#> $coordinates[[2]]
#> $coordinates[[2]][[1]]
#> $coordinates[[2]][[1]][[1]]
#> [1] 20 35
#> 
#> $coordinates[[2]][[1]][[2]]
#> [1] 45 20
#> 
#> $coordinates[[2]][[1]][[3]]
#> [1] 30  5
#> 
#> $coordinates[[2]][[1]][[4]]
#> [1] 10 10
#> 
#> $coordinates[[2]][[1]][[5]]
#> [1] 10 30
#> 
#> $coordinates[[2]][[1]][[6]]
#> [1] 20 35
#> 
#> 
#> $coordinates[[2]][[2]]
#> $coordinates[[2]][[2]][[1]]
#> [1] 30 20
#> 
#> $coordinates[[2]][[2]][[2]]
#> [1] 20 25
#> 
#> $coordinates[[2]][[2]][[3]]
#> [1] 20 15
#> 
#> $coordinates[[2]][[2]][[4]]
#> [1] 30 20
#> 
#> 
#> 
#> 
#> attr(,"class")
#> [1] "geojson"
```

### Linestring


```r
wkt2geojson("LINESTRING (0 -1, -2 -3, -4 5)", feature=FALSE)
#> $type
#> [1] "Linestring"
#> 
#> $coordinates
#> $coordinates[[1]]
#> [1]  0 -1
#> 
#> $coordinates[[2]]
#> [1] -2 -3
#> 
#> $coordinates[[3]]
#> [1] -4  5
#> 
#> 
#> attr(,"class")
#> [1] "geojson"
```

## Meta

* Please [report any issues or bugs](https://github.com/ropensci/wellknown/issues).
* License: MIT
* Get citation information for `wellknown` in R doing `citation(package = 'wellknown')`

[![ropensci footer](http://ropensci.org/public_images/github_footer.png)](http://ropensci.org)
