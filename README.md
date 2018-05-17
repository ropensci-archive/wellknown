wellknown
=======



[![cran checks](https://cranchecks.info/badges/summary/wellknown)](https://cranchecks.info/pkgs/wellknown)
[![Build Status](https://travis-ci.org/ropensci/wellknown.svg)](https://travis-ci.org/ropensci/wellknown)
[![Build status](https://ci.appveyor.com/api/projects/status/ot3lth177a6f8jgg?svg=true)](https://ci.appveyor.com/project/sckott/wellknown)
[![codecov.io](https://codecov.io/github/ropensci/wellknown/coverage.svg?branch=master)](https://codecov.io/github/ropensci/wellknown?branch=master)
[![rstudio mirror downloads](http://cranlogs.r-pkg.org/badges/wellknown)](https://github.com/metacran/cranlogs.app)
[![cran version](http://www.r-pkg.org/badges/version/wellknown)](https://cran.r-project.org/package=wellknown)

`wellknown` - convert WKT to GeoJSON and vice versa.

Inspiration partly comes from Python's [geomet/geomet](https://github.com/geomet/geomet) - and the name from Javascript's [wellknown](https://github.com/mapbox/wellknown) (it's a good name).

## Different interfaces

### WKT from R stuctures

There's a family of functions that make it easy to go from familiar R objects like lists and data.frames to WKT, including:

* `point()` - make a point, e.g., `POINT (-116 45)`
* `multipoint()` - make a multipoint, e.g., `MULTIPOINT ((100 3), (101 2))`
* `linestring()` - make a linestring, e.g., `LINESTRING (100 0, 101 1)`
* `polygon()` - make a polygon, e.g., `POLYGON ((100 0), (101 0), (101 1), (100 0))`
* `multipolygon()` - make a multipolygon, e.g., `MULTIPOLYGON (((30 20, 45 40, 10 40, 30 20)), ((15 5, 40 10, 10 20, 5 10, 15 5)))`

The above currently accept (depending on the fxn) `numeric`, `list`, and `data.frame` (and `character` for special case of `EMPTY` WKT objects).

### Geojson to WKT and vice versa

`geojson2wkt()` and `wkt2geojson()` cover a subset of the various formats available:

* `Point`
* `MultiPoint`
* `Polygon`
* `MultiPolygon`
* `LineString`
* `MultilineString`
* `Geometrycollection`

#### Geojson to WKT

`geojson2wkt()` converts any geojson as a list to a WKT string (the same format )

#### WKT to Geojson

`wkt2geojson()` converts any WKT string into geojson as a list. This list format for geojson can be used downstream e.g., in the `leaflet` package.

#### WKT to WKB, and vice versa

`wkt_wkb()` converts WKT to WKB, while `wkb_wkt()` converts WKB to WKT

## Install

Stable version


```r
install.packages("wellknown")
```

Dev version


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
point <- list(Point = c(116.4, 45.2, 11.1))
geojson2wkt(point)
#> [1] "POINT Z(116.4000000000000057  45.2000000000000028  11.0999999999999996)"
```

### Multipoint


```r
mp <- list(
  MultiPoint = matrix(c(100, 101, 3.14, 3.101, 2.1, 2.18), 
    ncol = 2)
)
geojson2wkt(mp)
#> [1] "MULTIPOINT ((100.0000000000000000 3.1010000000000000), (101.0000000000000000 2.1000000000000001), (3.1400000000000001 2.1800000000000002))"
```

### LineString


```r
st <- list(
  LineString = matrix(c(0.0, 2.0, 4.0, 5.0,
                         0.0, 1.0, 2.0, 4.0), ncol = 2)
)
geojson2wkt(st, fmt=0)
#> [1] "LINESTRING (0 0, 2 1, 4 2, 5 4)"
```

### Multilinestring


```r
multist <- list(
  MultiLineString = list(
   matrix(c(0, -2, -4, -1, -3, -5), ncol = 2),
   matrix(c(1.66, 10.9999, 10.9, 0, -31.5, 3.0, 1.1, 0), ncol = 2)
 )
)
geojson2wkt(multist)
#> [1] "MULTILINESTRING ((0.0000000000000000 -1.0000000000000000, -2.0000000000000000 -3.0000000000000000, -4.0000000000000000 -5.0000000000000000), (1.6599999999999999 -31.5000000000000000, 10.9999000000000002 3.0000000000000000, 10.9000000000000004 1.1000000000000001, 0.0000000000000000 0.0000000000000000))"
```

### Polygon


```r
poly <- list(
  Polygon = list(
    matrix(c(100.001, 101.1, 101.001, 100.001, 0.001, 0.001, 1.001, 0.001),
      ncol = 2),
    matrix(c(100.201, 100.801, 100.801, 100.201, 0.201, 0.201, 0.801, 0.201),
      ncol = 2)
  )
)
geojson2wkt(poly)
#> [1] "POLYGON ((100.0010000000000048 0.0010000000000000, 101.0999999999999943 0.0010000000000000, 101.0010000000000048 1.0009999999999999, 100.0010000000000048 0.0010000000000000), (100.2009999999999934 0.2010000000000000, 100.8010000000000019 0.2010000000000000, 100.8010000000000019 0.8010000000000000, 100.2009999999999934 0.2010000000000000))"
```

### Multipolygon


```r
mpoly <- list(
  MultiPolygon = list(
    list(
      matrix(c(100, 101, 101, 100, 0.001, 0.001, 1.001, 0.001), ncol = 2),
      matrix(c(100.2, 100.8, 100.8, 100.2, 0.2, 0.2, 0.8, 0.2), ncol = 2)
    ),
    list(
      matrix(c(1.0, 2.0, 3.0, 4.0, 5.0, 6.0, 7.0, 8.0, 1.0), ncol = 3),
      matrix(c(9.0, 10.0, 11.0, 12.0, 1.0, 2.0, 3.0, 4.0, 9.0), ncol = 3)
    )
  )
)
geojson2wkt(mpoly, fmt=1)
#> [1] "MULTIPOLYGON Z(((100.000 0.001 0.000, 101.000 0.001 0.000, 101.000 1.001 0.000, 100.000 0.001 0.000), (100.2 0.2 0.0, 100.8 0.2 0.0, 100.8 0.8 0.0, 100.2 0.2 0.0)), ((1.0 4.0 7.0, 2.0 5.0 8.0, 3.0 6.0 1.0), (9.0 12.0 3.0, 10.0 1.0 4.0, 11.0 2.0 9.0)))"
```

### GeometryCollection


```r
gmcoll <- list(
 GeometryCollection = list(
   list(type = 'Point', coordinates = c(0.0, 1.0)),
   list(type = 'LineString', coordinates = matrix(c(0.0, 2.0, 4.0, 5.0,
                           0.0, 1.0, 2.0, 4.0),
                           ncol = 2)),
   list(type = 'Polygon', coordinates = list(
     matrix(c(100.001, 101.1, 101.001, 100.001, 0.001, 0.001, 1.001, 0.001),
       ncol = 2),
     matrix(c(100.201, 100.801, 100.801, 100.201, 0.201, 0.201, 0.801, 0.201),
       ncol = 2)
  ))
 )
)
geojson2wkt(gmcoll, fmt=0)
#> [1] "GEOMETRYCOLLECTION (POINT (0 1), LINESTRING (0 0, 2 1, 4 2, 5 4), POLYGON ((100.001 0.001, 101.100 0.001, 101.001 1.001, 100.001 0.001), (100.201 0.201, 100.801 0.201, 100.801 0.801, 100.201 0.201)))"
```

### Convert json or character objects

You can convert directly from an object of class `json`, which is output from `jsonlite::toJSON()`.


```r
library("jsonlite")
(json <- toJSON(list(Point = c(-105, 39)), auto_unbox = TRUE))
#> {"Point":[-105,39]}
```


```r
geojson2wkt(json)
#> [1] "POINT (-105   39)"
```

And you can convert from a geojson character string:


```r
str <- '{"type":"LineString","coordinates":[[0,0,10],[2,1,20],[4,2,30],[5,4,40]]}'
geojson2wkt(str)
#> [1] "LINESTRING Z(0 0 10, 2 1 20, 4 2 30, 5 4 40)"
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
...
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
#> [1] "MultiPoint"
#> 
#> $coordinates
#>        [,1]  [,2]
#> [1,] 100.00 3.101
#> [2,] 101.00 2.100
#> [3,]   3.14 2.180
#> 
#> attr(,"class")
...
```

### Polygon


```r
str <- "POLYGON ((100 0.1, 101.1 0.3, 101 0.5, 100 0.1), (103.2 0.2, 104.8 0.2, 100.8 0.8, 103.2 0.2))"
wkt2geojson(str, feature=FALSE)
#> $type
#> [1] "Polygon"
#> 
#> $coordinates
#> $coordinates[[1]]
#>       [,1] [,2]
#> [1,] 100.0  0.1
#> [2,] 101.1  0.3
#> [3,] 101.0  0.5
#> [4,] 100.0  0.1
...
```

### MultiPolygon


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
#>      [,1] [,2]
#> [1,]   40   40
#> [2,]   20   45
#> [3,]   45   30
...
```

### Linestring


```r
wkt2geojson("LINESTRING (0 -1, -2 -3, -4 5)", feature=FALSE)
#> $type
#> [1] "LineString"
#> 
#> $coordinates
#>      [,1] [,2]
#> [1,]    0   -1
#> [2,]   -2   -3
#> [3,]   -4    5
#> 
#> attr(,"class")
...
```

## lint WKT


```r
lint("POINT (1 2)")
#> [1] TRUE
lint("LINESTRING EMPTY")
#> [1] TRUE
lint("MULTIPOINT ((1 2), (3 4), (-10 100))")
#> [1] TRUE
lint("POLYGON((20.3 28.6, 20.3 19.6, 8.5 19.6, 8.5 28.6, 20.3 28.6))")
#> [1] TRUE
lint("MULTIPOLYGON (((30 20, 45 40, 10 40, 30 20)), ((15 5, 40 10, 10 20, 5 10, 15 5)))")
#> [1] TRUE
lint("POINT (1 2 3 4 5)")
#> [1] FALSE
lint("LINESTRING (100)")
#> [1] FALSE
lint("MULTIPOLYGON (((30 20, 45 40, 10 40, 30 20)), ((15 5, a b, 10 20, 5 10, 15 5)))")
#> [1] FALSE
```

## WKT <--> WKB

WKT to WKB


```r
## point
wkt_wkb("POINT (-116.4 45.2)")
#>  [1] 01 01 00 00 00 9a 99 99 99 99 19 5d c0 9a 99 99 99 99 99 46 40

## polygon
wkt_wkb("POLYGON ((100.0 0.0, 101.1 0.0, 101.0 1.0, 100.0 0.0))")
#>  [1] 01 03 00 00 00 01 00 00 00 04 00 00 00 00 00 00 00 00 00 59 40 00 00
#> [24] 00 00 00 00 00 00 66 66 66 66 66 46 59 40 00 00 00 00 00 00 00 00 00
#> [47] 00 00 00 00 40 59 40 00 00 00 00 00 00 f0 3f 00 00 00 00 00 00 59 40
#> [70] 00 00 00 00 00 00 00 00
```

WKB to WKT


```r
## point
(x <- wkt_wkb("POINT (-116.4 45.2)"))
#>  [1] 01 01 00 00 00 9a 99 99 99 99 19 5d c0 9a 99 99 99 99 99 46 40
wkb_wkt(x)
#> [1] "POINT(-116.4 45.2)"

## polygon
(x <- wkt_wkb("POLYGON ((100.0 0.0, 101.1 0.0, 101.0 1.0, 100.0 0.0))"))
#>  [1] 01 03 00 00 00 01 00 00 00 04 00 00 00 00 00 00 00 00 00 59 40 00 00
#> [24] 00 00 00 00 00 00 66 66 66 66 66 46 59 40 00 00 00 00 00 00 00 00 00
#> [47] 00 00 00 00 40 59 40 00 00 00 00 00 00 f0 3f 00 00 00 00 00 00 59 40
#> [70] 00 00 00 00 00 00 00 00
wkb_wkt(x)
#> [1] "POLYGON((100 0,101.1 0,101 1,100 0))"
```

## Meta

* Please [report any issues or bugs](https://github.com/ropensci/wellknown/issues).
* License: MIT
* Get citation information for `wellknown` in R doing `citation(package = 'wellknown')`
* Please note that this project is released with a [Contributor Code of Conduct](CODE_OF_CONDUCT.md). By participating in this project you agree to abide by its terms.

[![ropensci_footer](http://ropensci.org/public_images/github_footer.png)](http://ropensci.org)
