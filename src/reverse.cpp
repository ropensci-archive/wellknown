#include <Rcpp.h>
using namespace Rcpp;
#include "utils.h"
using namespace wkt_utils;

template <typename T>
std::string reverse_single(std::string wkt, T& obj){
  try{
    boost::geometry::read_wkt(wkt, obj);
    boost::geometry::reverse(obj);
  } catch (boost::geometry::read_wkt_exception &e){
    return wkt;
  }

  std::stringstream ss;
  ss << boost::geometry::wkt(obj);
  return ss.str();
}

//' @title Reverses the points within a geometry.
//' @description `wkt_reverse` reverses the points in any of
//' point, multipoint, linestring, multilinestring, polygon, or
//' multipolygon
//' @export
//' @param x a character vector of WKT objects, represented as strings
//' @return a string, same length as given
//' @details segment, box, and ring types not supported
//' @examples
//' wkt_reverse("POLYGON((42 -26,42 -13,52 -13,52 -26,42 -26))")
// [[Rcpp::export]]
CharacterVector wkt_reverse(CharacterVector x){

  // Create instances of each type
  point_type pt;
  linestring_type ls;
  polygon_type poly;
  multipoint_type multip;
  multilinestring_type multil;
  multipolygon_type multipoly;

  // Generate output objects
  unsigned int input_size = x.size();
  CharacterVector output(input_size);
  std::string holding;

  for(unsigned int i = 0; i < input_size; i++){
    if((i % 10000) == 0){
      Rcpp::checkUserInterrupt();
    }
    if(x[i] == NA_STRING){
      output[i] = NA_STRING;
    } else {
      holding = Rcpp::as<std::string>(x[i]);
      switch(id_type(holding)){
      case point:
        output[i] = reverse_single(holding, pt);
        break;
      case line_string:
        output[i] = reverse_single(holding, ls);
        break;
      case polygon:
        output[i] = reverse_single(holding, poly);
        break;
      case multi_point:
        output[i] = reverse_single(holding, multip);
        break;
      case multi_line_string:
        output[i] = reverse_single(holding, multil);
        break;
      case multi_polygon:
        output[i] = reverse_single(holding, multipoly);
        break;
      default:
        output[i] = x[i];
      }
    }
  }

  return output;
}
