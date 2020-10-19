#include <Rcpp.h>
using namespace Rcpp;
#include "utils.h"
using namespace wkt_utils;
//[[Rcpp::depends(BH)]]

//[[Rcpp::export]]
CharacterVector bounding_wkt_points(NumericVector min_x, NumericVector max_x, NumericVector min_y, NumericVector max_y){

  unsigned int input_size = min_x.size();
  if(max_x.size() != input_size || min_y.size() != input_size || max_y.size() != input_size){
    Rcpp::stop("All input vectors must be the same length");
  }

  CharacterVector output(input_size);
  box_type bx;
  polygon_type poly;

  for(unsigned int i = 0; i < input_size; i++){
    if((i % 10000) == 0){
      Rcpp::checkUserInterrupt();
    }
    if(NumericVector::is_na(min_x[i]) || NumericVector::is_na(max_x[i]) ||
       NumericVector::is_na(min_y[i]) || NumericVector::is_na(max_y[i])){
      output[i] = NA_STRING;
    } else {
      bx = boost::geometry::make<box_type>(min_x[i], min_y[i], max_x[i], max_y[i]);
      boost::geometry::convert(bx, poly);
      output[i] = wkt_utils::make_wkt_poly(poly);
    }
  }
  return output;
}

//[[Rcpp::export]]
CharacterVector bounding_wkt_list(List x){

  unsigned int input_size = x.size();
  CharacterVector output(input_size);
  box_type bx;
  polygon_type poly;
  NumericVector holding;

  for(unsigned int i = 0; i < input_size; i++){
    if((i % 10000) == 0){
      Rcpp::checkUserInterrupt();
    }
    try {
      holding = Rcpp::as<NumericVector>(x[i]);
    } catch(...){
      output[i] = NA_STRING;
    }
    if(holding.size() != 4 || NumericVector::is_na(holding[0]) || NumericVector::is_na(holding[1]) ||
      NumericVector::is_na(holding[2]) || NumericVector::is_na(holding[3])){
      output[i] = NA_STRING;
    } else {
      bx = boost::geometry::make<box_type>(holding[0], holding[1], holding[2], holding[3]);
      boost::geometry::convert(bx, poly);
      std::stringstream ss;
      ss << boost::geometry::wkt(poly);
      output[i] = ss.str();
    }
  }
  return output;
}
