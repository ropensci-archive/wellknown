#include <Rcpp.h>
#include "utils.h"

using namespace Rcpp;
using namespace wkt_utils;

template <typename T>
std::string wkt_correct_single(std::string& x, T& poly){
  boost::geometry::validity_failure_type failure;
  try {
    boost::geometry::read_wkt(x, poly);
    boost::geometry::is_valid(poly, failure);
  } catch (boost::geometry::read_wkt_exception &e){
    return x;
  }
  if(failure == boost::geometry::failure_wrong_orientation){
    boost::geometry::correct(poly);
    std::stringstream ss;
    ss << boost::geometry::wkt(poly);
    return ss.str();
  }
  return x;
}

//' @title Correct Incorrectly Oriented WKT Objects
//' @description \code{wkt_correct} does precisely what it says on the tin,
//' correcting the orientation of WKT objects that are improperly oriented
//' (say, back to front). It can be applied to WKT objects that,
//' when validated with \code{\link{validate_wkt}}, fail for that reason.
//' @export
//' @param x a character vector of WKT objects to correct
//' @return a character vector, the same length as \code{x}, containing
//' either the original value (if there was no correction to make, or if
//' the object was invalid for other reasons) or the corrected WKT
//' value.
//' @examples
//' # A WKT object
//' wkt <- "POLYGON((30 20, 10 40, 45 40, 30 20), (15 5, 5 10, 10 20, 40 10, 15 5))"
//' 
//' # That's invalid due to a non-default orientation
//' validate_wkt(wkt)
//' 
//' # And suddenly isn't!
//' wkt_correct(wkt)
// [[Rcpp::export]]
CharacterVector wkt_correct(CharacterVector x){

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
        output[i] = wkt_correct_single(holding, pt);
        break;
      case line_string:
        output[i] = wkt_correct_single(holding, ls);
        break;
      case polygon:
        output[i] = wkt_correct_single(holding, poly);
        break;
      case multi_point:
        output[i] = wkt_correct_single(holding, multip);
        break;
      case multi_line_string:
        output[i] = wkt_correct_single(holding, multil);
        break;
      case multi_polygon:
        output[i] = wkt_correct_single(holding, multipoly);
        break;
      default:
        output[i] = x[i];
      }
    }
  }

  return output;
}
