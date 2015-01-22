wellknown
=======



`wellknown` - convert WKT and WKB to GeoJSON and vice versa.

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
geojson2wkt(point)
#> [1] "POINT (116.4000000000000057 45.2000000000000028 11.0999999999999996)"
```

### LineString


```r
st <- list(type = 'LineString',
            coordinates = list(c(0.0, 0.0, 10.0), c(2.0, 1.0, 20.0),
                              c(4.0, 2.0, 30.0), c(5.0, 4.0, 40.0)))
geojson2wkt(st, fmt=0)
#> [1] "LINESTRING (0 0 10, 2 1 20, 4 2 30, 5 4 40)"
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

### Multipoint


```r
mp <- list(type = 'MultiPoint', 
           coordinates=list( c(100.0, 3.101), c(101.0, 2.1), c(3.14, 2.18)
))
geojson2wkt(mp)
#> [1] "MULTIPOINT ((100.0000000000000000 3.1010000000000000), (101.0000000000000000 2.1000000000000001), (3.1400000000000001 2.1800000000000002))"
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
```

Not `Feature`


```r
wkt2geojson(str, feature=FALSE)
#> $type
#> [1] "Point"
#> 
#> $coordinates
#> [1] -116.4   45.2
```

### Multipoint

As a `Feature`


```r
str <- 'MULTIPOINT ((100.000 3.101), (101.000 2.100), (3.140 2.180))'
wkt2geojson(str)
#> $type
#> [1] "Feature"
#> 
#> $geometry
#> $geometry$type
#> [1] "Multipoint"
#> 
#> $geometry$coordinates
#> $geometry$coordinates[[1]]
#> $geometry$coordinates[[1]][[1]]
#> [1] 100.000   3.101
#> 
#> 
#> $geometry$coordinates[[2]]
#> $geometry$coordinates[[2]][[1]]
#> [1] 101.0   2.1
#> 
#> 
#> $geometry$coordinates[[3]]
#> $geometry$coordinates[[3]][[1]]
#> [1] 3.14 2.18
```

Not `Feature`


```r
wkt2geojson(str, feature=FALSE)
#> $type
#> [1] "Multipoint"
#> 
#> $coordinates
#> $coordinates[[1]]
#> $coordinates[[1]][[1]]
#> [1] 100.000   3.101
#> 
#> 
#> $coordinates[[2]]
#> $coordinates[[2]][[1]]
#> [1] 101.0   2.1
#> 
#> 
#> $coordinates[[3]]
#> $coordinates[[3]][[1]]
#> [1] 3.14 2.18
```

### Polygon

As a `Feature`


```r
str <- "POLYGON ((100 0.1, 101.1 0.3, 101 0.5, 100 0.1), (103.2 0.2, 104.8 0.2, 100.8 0.8, 103.2 0.2))"
wkt2geojson(str)
#> $type
#> [1] "Feature"
#> 
#> $geometry
#> $geometry$type
#> [1] "Polygon"
#> 
#> $geometry$coordinates
#> $geometry$coordinates[[1]]
#> $geometry$coordinates[[1]][[1]]
#> [1] 100.0   0.1
#> 
#> $geometry$coordinates[[1]][[2]]
#> [1] 101.1   0.3
#> 
#> $geometry$coordinates[[1]][[3]]
#> [1] 101.0   0.5
#> 
#> $geometry$coordinates[[1]][[4]]
#> [1] 100.0   0.1
#> 
#> 
#> $geometry$coordinates[[2]]
#> $geometry$coordinates[[2]][[1]]
#> [1] 103.2   0.2
#> 
#> $geometry$coordinates[[2]][[2]]
#> [1] 104.8   0.2
#> 
#> $geometry$coordinates[[2]][[3]]
#> [1] 100.8   0.8
#> 
#> $geometry$coordinates[[2]][[4]]
#> [1] 103.2   0.2
```

Not `Feature`


```r
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
```

