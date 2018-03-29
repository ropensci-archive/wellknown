#' @examples
#' # point
#' ## new format
#' point <- list(Point = c(116.4, 45.2))
#' geojson2wkt(point)
#' ## old format, warns
#' point <- list(type = 'Point', coordinates = c(116.4, 45.2))
#' geojson2wkt(point)
#'
#' # multipoint
#' ## new format
#' mp <- list(MultiPoint = matrix(c(100, 101, 3.14, 3.101, 2.1, 2.18),
#'    ncol = 2))
#' geojson2wkt(mp)
#' ## 3D
#' mp <- list(MultiPoint = matrix(c(100, 101, 3, 3, 2, 2, 4, 5, 6),
#'    ncol = 3))
#' geojson2wkt(mp)
#' ## old format, warns
#' mp <- list(
#'   type = 'MultiPoint',
#'   coordinates = matrix(c(100, 101, 3.14, 3.101, 2.1, 2.18), ncol = 2)
#' )
#' geojson2wkt(mp)
#'
#' # linestring
#' ## new format
#' st <- list(LineString = matrix(c(0.0, 2.0, 4.0, 5.0,
#'                                0.0, 1.0, 2.0, 4.0),
#'                                ncol = 2))
#' geojson2wkt(st)
#' ## 3D
#' st <- list(LineString = matrix(
#'   c(0.0, 0, 0, 
#'    2, 1, 5,
#'    100, 300, 800), nrow = 3))
#' geojson2wkt(st, fmt = 2)
#' geojson2wkt(st, fmt = 2, third = "m")
#' ## old format, warns
#' st <- list(
#'   type = 'LineString',
#'   coordinates = matrix(c(0.0, 2.0, 4.0, 5.0,
#'                          0.0, 1.0, 2.0, 4.0), ncol = 2)
#' )
#' geojson2wkt(st)
#' ## 3D
#' st <- list(LineString = matrix(c(0.0, 2.0, 4.0, 5.0,
#'                                0.0, 1.0, 2.0, 4.0,
#'                                10, 20, 30, 40),
#'                                ncol = 3))
#' geojson2wkt(st, fmt = 2)
#'
#' ## 4D
#' st <- list(LineString = matrix(c(0.0, 2.0, 4.0, 5.0,
#'                                0.0, 1.0, 2.0, 4.0,
#'                                10, 20, 30, 40,
#'                                1, 2, 3, 4),
#'                                ncol = 4))
#' geojson2wkt(st, fmt = 2)
#'
#'
#' # multilinestring
#' ## new format
#' multist <- list(MultiLineString = list(
#'    matrix(c(0, -2, -4, -1, -3, -5), ncol = 2),
#'    matrix(c(1.66, 10.9999, 10.9, 0, -31.5, 3.0, 1.1, 0), ncol = 2)
#'  )
#' )
#' geojson2wkt(multist)
#' ## 3D
#' multist <- list(MultiLineString = list(
#'    matrix(c(0, -2, -4, -1, -3, -5, 100, 200, 300), ncol = 3),
#'    matrix(c(1, 10, 10.9, 0, -31.5, 3.0, 1.1, 0, 3, 3, 3, 3), ncol = 3)
#'  )
#' )
#' geojson2wkt(multist, fmt = 2)
#' geojson2wkt(multist, fmt = 2, third = "m")
#' ## old format, warns
#' multist <- list(
#'   type = 'MultiLineString',
#'   coordinates = list(
#'    matrix(c(0, -2, -4, -1, -3, -5), ncol = 2),
#'    matrix(c(1.66, 10.9999, 10.9, 0, -31.5, 3.0, 1.1, 0), ncol = 2)
#'  )
#' )
#' geojson2wkt(multist)
#' 
#' ## points within MultiLineString that differ 
#' ## -> use length of longest 
#' ## -> fill with zeros
#' # 3D and 2D
#' multist <- list(MultiLineString = list(
#'     matrix(1:6, ncol = 3), matrix(1:8, ncol = 2)))
#' geojson2wkt(multist, fmt = 0)
#' # 4D and 2D
#' multist <- list(MultiLineString = list(
#'     matrix(1:8, ncol = 4), matrix(1:8, ncol = 2)))
#' geojson2wkt(multist, fmt = 0)
#' # 2D and 2D
#' multist <- list(MultiLineString = list(
#'     matrix(1:4, ncol = 2), matrix(1:8, ncol = 2)))
#' geojson2wkt(multist, fmt = 0)
#' # 5D and 2D - FAILS
#' # multist <- list(MultiLineString = list(
#' #    matrix(1:10, ncol = 5), matrix(1:8, ncol = 2)))
#' # geojson2wkt(multist, fmt = 0)
#' 
#'
#' # polygon
#' ## new format
#' poly <- list(Polygon = list(
#'    matrix(c(100.001, 101.1, 101.001, 100.001, 0.001, 0.001, 1.001, 0.001), ncol = 2),
#'    matrix(c(100.201, 100.801, 100.801, 100.201, 0.201, 0.201, 0.801, 0.201), ncol = 2)
#' ))
#' geojson2wkt(poly)
#' geojson2wkt(poly, fmt=6)
#' ## 3D
#' poly <- list(Polygon = list(
#'    matrix(c(100.1, 101.1, 101.1, 100.1, 0.1, 0.1, 1.1, 0.1, 1, 1, 1, 1), ncol = 3),
#'    matrix(c(100.2, 100.8, 100.8, 100.2, 0.2, 0.2, 0.80, 0.2, 3, 3, 3, 3), ncol = 3)
#' ))
#' geojson2wkt(poly, fmt = 2)
#' geojson2wkt(poly, fmt = 2, third = "m")
#' ## old format, warns
#' poly <- list(
#'   type = 'Polygon',
#'   coordinates = list(
#'     matrix(c(100.001, 101.1, 101.001, 100.001, 0.001, 0.001, 1.001, 0.001),
#'       ncol = 2),
#'     matrix(c(100.201, 100.801, 100.801, 100.201, 0.201, 0.201, 0.801, 0.201),
#'       ncol = 2)
#'   )
#' )
#' geojson2wkt(poly)
#' geojson2wkt(poly, fmt=6)
#'
#' ## points within Polygon that differ 
#' ## -> use length of longest 
#' ## -> fill with zeros
#' # 3D and 2D
#' poly <- list(Polygon = list(
#'    matrix(c(100, 101, 101, 100, 0.1, 0.2, 0.3, 0.1, 5, 6, 7, 8), ncol = 3),
#'    matrix(c(40, 41, 61, 40, 0.1, 0.2, 0.3, 0.1), ncol = 2)
#' ))
#' geojson2wkt(poly, fmt = 0)
#' # 4D and 2D
#' poly <- list(Polygon = list(
#'    matrix(c(100, 101, 101, 100, 0.1, 0.2, 0.3, 0.1, 5, 6, 7, 8, 1, 1, 1, 1), 
#'      ncol = 4),
#'    matrix(c(40, 41, 61, 40, 0.1, 0.2, 0.3, 0.1), ncol = 2)
#' ))
#' geojson2wkt(poly, fmt = 0)
#' # 5D and 2D - FAILS
#' # multist <- list(Polygon = list(
#' #    matrix(1:10, ncol = 5), matrix(1:8, ncol = 2)))
#' # geojson2wkt(poly, fmt = 0)
#' 
#' 
#' 
#' # multipolygon
#' ## new format
#' mpoly <- list(MultiPolygon = list(
#'   list(
#'     matrix(c(100, 101, 101, 100, 0.001, 0.001, 1.001, 0.001), ncol = 2),
#'     matrix(c(100.2, 100.8, 100.8, 100.2, 0.2, 0.2, 0.8, 0.2), ncol = 2)
#'   ),
#'   list(
#'     matrix(c(1.0, 2.0, 3.0, 4.0, 5.0, 6.0, 7.0, 8.0, 1.0), ncol = 2),
#'     matrix(c(9.0, 10.0, 11.0, 12.0, 1.0, 2.0, 3.0, 4.0, 9.0), ncol = 2)
#'   )
#' ))
#' geojson2wkt(mpoly, fmt=2)
#' ## 3D
#' mpoly <- list(MultiPolygon = list(
#'   list(
#'     matrix(c(100, 101, 101, 100, 0.001, 0.001, 1.001, 0.001, 1, 1, 1, 1), 
#'       ncol = 3),
#'     matrix(c(100.2, 100.8, 100.8, 100.2, 0.2, 0.2, 0.8, 0.2, 3, 4, 5, 6), 
#'       ncol = 3)
#'   ),
#'   list(
#'     matrix(c(1.0, 2.0, 3.0, 4.0, 5.0, 6.0, 7.0, 8.0, 1.0, 1, 1, 1, 1),
#'       ncol = 3),
#'     matrix(c(9.0, 10.0, 11.0, 12.0, 1.0, 2.0, 3.0, 4.0, 9.0, 9, 9, 9, 9),
#'       ncol = 3)
#'   )
#' ))
#' geojson2wkt(mpoly, fmt=2)
#' geojson2wkt(mpoly, fmt=2, third = "m")
#' ## old format, warns
#' mpoly <- list(
#'   type = 'MultiPolygon',
#'   coordinates = list(
#'     list(
#'       matrix(c(100, 101, 101, 100, 0.001, 0.001, 1.001, 0.001), ncol = 2),
#'       matrix(c(100.2, 100.8, 100.8, 100.2, 0.2, 0.2, 0.8, 0.2), ncol = 2)
#'     ),
#'     list(
#'       matrix(c(1.0, 2.0, 3.0, 4.0, 5.0, 6.0, 7.0, 8.0, 1.0), ncol = 3),
#'       matrix(c(9.0, 10.0, 11.0, 12.0, 1.0, 2.0, 3.0, 4.0, 9.0), ncol = 3)
#'     )
#'   )
#' )
#' geojson2wkt(mpoly, fmt=2)
#'
#' mpoly2 <- list(
#'   type = "MultiPolygon",
#'   coordinates = list(
#'     list(list(c(30, 20), c(45, 40), c(10, 40), c(30, 20))),
#'     list(list(c(15, 5), c(40, 10), c(10, 20), c(5 ,10), c(15, 5)))
#'   )
#' )
#'
#' mpoly2 <- list(
#'   type = "MultiPolygon",
#'   coordinates = list(
#'     list(
#'       matrix(c(30, 45, 10, 30, 20, 40, 40, 20), ncol = 2)
#'     ),
#'     list(
#'       matrix(c(15, 40, 10, 5, 15, 5, 10, 20, 10, 5), ncol = 2)
#'     )
#'   )
#' )
#' geojson2wkt(mpoly2, fmt=1)
#' 
#' ## points within MultiPolygon that differ 
#' ## -> use length of longest 
#' ## -> fill with zeros
#' # 3D and 2D
#' mpoly <- list(MultiPolygon = list(
#'   list(
#'     matrix(c(40, 130, 155, 40, 20, 34, 34, 20), ncol = 2),
#'     matrix(c(30, 40, 54, 30, 0.1, 42, 62, 0.1, 1, 1, 1, 1), ncol = 3)
#'   ),
#'   list(
#'     matrix(c(9, 49, 79, 9, 11, 35, 15, 11), ncol = 2),
#'     matrix(c(1, 33, 59, 1, 5, 16, 36, 5), ncol = 2)
#'   )
#' ))
#' geojson2wkt(mpoly, fmt = 0)
#' # 4D and 2D
#' mpoly <- list(MultiPolygon = list(
#'   list(
#'     matrix(c(40, 130, 155, 40, 20, 34, 34, 20), ncol = 2),
#'     matrix(c(30, 40, 54, 30, 0.1, 42, 62, 0.1, 1, 1, 1, 1, 0, 0, 0, 0), ncol = 4)
#'   ),
#'   list(
#'     matrix(c(9, 49, 79, 9, 11, 35, 15, 11), ncol = 2),
#'     matrix(c(1, 33, 59, 1, 5, 16, 36, 5), ncol = 2)
#'   )
#' ))
#' geojson2wkt(mpoly, fmt = 0)
#' # 5D and 2D - FAILS
#' mpoly <- list(MultiPolygon = list(
#'   list(
#'     matrix(c(40, 130, 155, 40, 20, 34, 34, 20), ncol = 2),
#'     matrix(c(30, 40, 54, 30, 
#'              0.1, 42, 62, 0.1, 
#'              1, 1, 1, 1, 
#'              0, 0, 0, 0,
#'              0, 0, 0, 0), ncol = 5)
#'   ),
#'   list(
#'     matrix(c(9, 49, 79, 9, 11, 35, 15, 11), ncol = 2),
#'     matrix(c(1, 33, 59, 1, 5, 16, 36, 5), ncol = 2)
#'   )
#' ))
#' # geojson2wkt(mpoly, fmt = 0)
#' 
#' 
#'
#' # geometrycollection
#' ## new format
#' gmcoll <- list(GeometryCollection = list(
#'  list(Point = c(0.0, 1.0)),
#'  list(LineString = matrix(c(0.0, 2.0, 4.0, 5.0,
#'                            0.0, 1.0, 2.0, 4.0),
#'                            ncol = 2)),
#'  list(Polygon = list(
#'    matrix(c(100.001, 101.1, 101.001, 100.001, 0.001, 0.001, 1.001, 0.001),
#'      ncol = 2),
#'    matrix(c(100.201, 100.801, 100.801, 100.201, 0.201, 0.201, 0.801, 0.201),
#'      ncol = 2)
#'   ))
#' ))
#' geojson2wkt(gmcoll, fmt=0)
#' ## old format, warns
#' gmcoll <- list(
#'  type = 'GeometryCollection',
#'  geometries = list(
#'    list(type = 'Point', coordinates = c(0.0, 1.0)),
#'    list(type = 'LineString', coordinates = matrix(c(0.0, 2.0, 4.0, 5.0,
#'                            0.0, 1.0, 2.0, 4.0),
#'                            ncol = 2)),
#'    list(type = 'Polygon', coordinates = list(
#'      matrix(c(100.001, 101.1, 101.001, 100.001, 0.001, 0.001, 1.001, 0.001),
#'        ncol = 2),
#'      matrix(c(100.201, 100.801, 100.801, 100.201, 0.201, 0.201, 0.801, 0.201),
#'        ncol = 2)
#'   ))
#'  )
#' )
#' geojson2wkt(gmcoll, fmt=0)
#'
#' # Convert geojson as character string to WKT
#' # new format
#' str <- '{
#'    "Point": [
#'        -105.01621,
#'        39.57422
#'    ]
#' }'
#' geojson2wkt(str)
#'
#' ## old format, warns
#' str <- '{
#'    "type": "Point",
#'    "coordinates": [
#'        -105.01621,
#'        39.57422
#'    ]
#' }'
#' geojson2wkt(str)
#'
#' ## new format
#' str <- '{"LineString":[[0,0,10],[2,1,20],[4,2,30],[5,4,40]]}'
#' geojson2wkt(str)
#' ## old format, warns
#' str <-
#' '{"type":"LineString","coordinates":[[0,0,10],[2,1,20],[4,2,30],[5,4,40]]}'
#' geojson2wkt(str)
#'
#' # From a jsonlite json object
#' library("jsonlite")
#' json <- toJSON(list(Point=c(-105,39)), auto_unbox=TRUE)
#' geojson2wkt(json)
#' ## old format, warns
#' json <- toJSON(list(type="Point", coordinates=c(-105,39)), auto_unbox=TRUE)
#' geojson2wkt(json)
