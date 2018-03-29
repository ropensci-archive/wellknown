wellknown 0.5.0
===============

### NEW FEATURES

* New functions `wkt_wkb()` and `wkb_wkt()` for converting WKT to WKB, and WKB to WKT. Depends on `V8` for doing the conversion. (#5)
* New function `get_centroid()` to get a centroid (lon, lat) for a WKT character string or a GeoJSON list object (#14) (#15)
* `wkt2geojson()` gains a new parameter `numeric`. It is `TRUE` by default, meaning that we convert values to numeric unless you set `numeric=FALSE` in which case we maintain numbers as strings, useful when you want to retain zero digits after the decimal (#14)
* `wkt2geojson()` gains a new parameter `simplify`, which if `TRUE` attempts to simplify from a multi- geometry type to a single type (e.g., mulitpolygon to polygon) when there's really only a single object. Applies to multi features only. (#20)
* Throughout package now we account for 3D and 4D WKT. For `wkt2geojson()` GeoJSON doesn't support a 4th dimension so we drop the 4th value, but for `geojson2wkt()` you can have GeoJSON with a 4th value so that you can convert it and any 3D data to WKT. We've added checks to make sure not more than 4D is used, and we follow `sf` by filling in zeros for any objects that are shorter in number of dimensions than the object with the largest number of dimensions (#18) (#23)
* `geojson2wkt()` inputs it accepts have changed. The function now accepts two different formats of GeoJSON like data. 1) The old format of full GeoJSON as a list like `list('type' = 'Point', 'coordinates' = c(116.4, 45.2))`, and 2) a simplified format `list(Point = c(116.4, 52.2))` (#17) (#19)

### MINOR IMPROVEMENTS

* Removed `magrittr` package. Simply load the package to have access to pipes (#25)
* Fixes to `lint()` function for validating WKT to make it work in more cases (#9)

### BUG FIXES

* Fixed bug in `wkt2geojson()` to not be case-sensitive to object names (e.g. , now `point`, `Point`, and `POINT` are all fine) (#16)


wellknown 0.1.0
===============

### NEW FEATURES

* Releasd to CRAN.
