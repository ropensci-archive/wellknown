#include <Rcpp.h>
using namespace Rcpp;
#include "utils.h"
using namespace wkt_utils;

template <typename T>
void centroid_single(std::string wkt, T& geom_obj,
                     unsigned int& outlength,
                     NumericVector& lat,
                     NumericVector& lng){

  point_type p;
  try{
    boost::geometry::read_wkt(wkt, geom_obj);
    boost::geometry::centroid(geom_obj, p);
  } catch(...){
    lat[outlength] = NA_REAL;
    lng[outlength] = NA_REAL;
    return;
  }

  lat[outlength]  = boost::geometry::get<1>(p);
  lng[outlength]  = boost::geometry::get<0>(p);
}

//' @title Extract Centroid
//' @description \code{get_centroid} identifies the 2D centroid
//' in a WKT object (or vector of WKT objects). Note that it assumes
//' cartesian values.
//' @export
//' @param wkt a character vector of WKT objects, represented as strings
//' @return a data.frame of two columns, \code{lat} and \code{lng},
//' with each row containing the centroid from the corresponding wkt
//' object. In the case that the object is NA (or cannot be decoded)
//' the resulting values will also be NA
//' @seealso \code{\link{wkt_coords}} to extract all coordinates, and
//' \code{\link{wkt_bounding}} to extract a bounding box.
//' @examples
//' wkt_centroid("POLYGON((2 1.3,2.4 1.7))")
//' #  lng lat
//' #1 2   1.3
// [[Rcpp::export]]
DataFrame wkt_centroid(CharacterVector wkt){

  point_type pt;
  linestring_type ls;
  polygon_type poly;
  multipoint_type multip;
  multilinestring_type multil;
  multipolygon_type multipoly;
  std::string holding;
  unsigned int input_size = wkt.size();
  NumericVector lat(input_size);
  NumericVector lng(input_size);

  for(unsigned int i = 0; i < input_size; i++){
    if((i % 10000) == 0){
      Rcpp::checkUserInterrupt();
    }
    if(wkt[i] == NA_STRING){
      lat[i] = NA_REAL;
      lng[i] = NA_REAL;
    } else {
      holding = as<std::string>(wkt[i]);
      switch(id_type(holding)){
      case point:
        centroid_single(holding, pt, i, lat, lng);
        break;
      case line_string:
        centroid_single(holding, ls, i, lat, lng);
        break;
      case polygon:
        centroid_single(holding, poly, i, lat, lng);
        break;
      case multi_point:
        centroid_single(holding, multip, i, lat, lng);
        break;
      case multi_line_string:
        centroid_single(holding, multil, i, lat, lng);
        break;
      case multi_polygon:
        centroid_single(holding, multipoly, i, lat, lng);
        break;
      default:
        lat[i] = NA_REAL;
        lng[i] = NA_REAL;
      }
    }
  }

  return DataFrame::create(_["lng"] = lng,
                           _["lat"] = lat);
}
