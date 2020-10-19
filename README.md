wellknown
=======



[![Project Status: Active – The project has reached a stable, usable state and is being actively developed.](https://www.repostatus.org/badges/latest/active.svg)](https://www.repostatus.org/#active)
[![cran checks](https://cranchecks.info/badges/summary/wellknown)](https://cranchecks.info/pkgs/wellknown)
[![codecov.io](https://codecov.io/github/ropensci/wellknown/coverage.svg?branch=master)](https://codecov.io/github/ropensci/wellknown?branch=master)
[![rstudio mirror downloads](https://cranlogs.r-pkg.org/badges/wellknown)](https://github.com/metacran/cranlogs.app)
[![cran version](https://www.r-pkg.org/badges/version/wellknown)](https://cran.r-project.org/package=wellknown)

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
remotes::install_github("ropensci/wellknown")
# OR
install.packages("wellknown", repos="https://dev.ropensci.org")
```


```r
library("wellknown")
```

## Meta

* Please [report any issues or bugs](https://github.com/ropensci/wellknown/issues).
* License: MIT
* Get citation information for `wellknown` in R doing `citation(package = 'wellknown')`
* Please note that this package is released with a [Contributor Code of Conduct](https://ropensci.org/code-of-conduct/). By contributing to this project, you agree to abide by its terms.

[![ropensci_footer](https://ropensci.org/public_images/github_footer.png)](https://ropensci.org)
