#include <Rcpp.h>
using namespace Rcpp;
#include "def.h"
#include "utils.h"
using namespace wkt_utils;

template <typename T>
void wkt_bounding_single_matrix(std::string wkt, T& obj, box_type& holding, unsigned int& i, NumericMatrix& output){

  try {
    boost::geometry::read_wkt(wkt, obj);
  } catch (boost::geometry::read_wkt_exception &e){
    output(i, 0) = NA_REAL;
    output(i, 1) = NA_REAL;
    output(i, 2) = NA_REAL;
    output(i, 3) = NA_REAL;
    return;
  }
  holding = boost::geometry::return_envelope<box_type>(obj);
  output(i, 0) = holding.min_corner().get<0>();
  output(i, 1) = holding.min_corner().get<1>();
  output(i, 2) = holding.max_corner().get<0>();
  output(i, 3) = holding.max_corner().get<1>();
}

NumericMatrix wkt_bounding_matrix(CharacterVector& wkt){

  unsigned int input_size = wkt.size();
  NumericMatrix output(input_size, 4);

  // Holding objects
  point_type pt;
  linestring_type ls;
  polygon_type poly;
  multipoint_type multip;
  multilinestring_type multil;
  multipolygon_type multipoly;
  box_type box_inst;
  std::string holding;

  for(unsigned int i = 0; i < input_size; i++){
    if((i % 10000) == 0){
      Rcpp::checkUserInterrupt();
    }
    if(wkt[i] == NA_STRING){
      output(i, 0) = NA_REAL;
      output(i, 1) = NA_REAL;
      output(i, 2) = NA_REAL;
      output(i, 3) = NA_REAL;
    } else {
      holding = Rcpp::as<std::string>(wkt[i]);
      switch(id_type(holding)){
        case point:
          wkt_bounding_single_matrix(holding, pt, box_inst, i, output);
          break;
        case line_string:
          wkt_bounding_single_matrix(holding, ls, box_inst, i, output);
          break;
        case polygon:
          wkt_bounding_single_matrix(holding, poly, box_inst, i, output);
          break;
        case multi_point:
          wkt_bounding_single_matrix(holding, multip, box_inst, i, output);
          break;
        case multi_line_string:
          wkt_bounding_single_matrix(holding, multil, box_inst, i, output);
          break;
        case multi_polygon:
          wkt_bounding_single_matrix(holding, multipoly, box_inst, i, output);
          break;
        default:
          output(i, 0) = NA_REAL;
          output(i, 1) = NA_REAL;
          output(i, 2) = NA_REAL;
          output(i, 3) = NA_REAL;
      }
    }
  }
  colnames(output) = CharacterVector::create("min_x", "min_y", "max_x", "max_y");
  return output;
}

template <typename T>
void wkt_bounding_single_df(std::string wkt, T& obj, box_type& holding, unsigned int& i,
                            NumericVector& min_x, NumericVector& max_x, NumericVector& min_y,
                            NumericVector& max_y){

  try {
    boost::geometry::read_wkt(wkt, obj);
  } catch (boost::geometry::read_wkt_exception &e){
    min_x[i] = NA_REAL;
    max_x[i] = NA_REAL;
    min_y[i] = NA_REAL;
    max_y[i] = NA_REAL;
    return;
  }
  holding = boost::geometry::return_envelope<box_type>(obj);
  min_x[i] = holding.min_corner().get<0>();
  max_x[i] = holding.max_corner().get<0>();
  min_y[i] = holding.min_corner().get<1>();
  max_y[i] = holding.max_corner().get<1>();

}

DataFrame wkt_bounding_df(CharacterVector& wkt){

  unsigned int input_size = wkt.size();
  NumericVector min_x(input_size);
  NumericVector max_x(input_size);
  NumericVector min_y(input_size);
  NumericVector max_y(input_size);

  // Holding objects
  point_type pt;
  linestring_type ls;
  polygon_type poly;
  multipoint_type multip;
  multilinestring_type multil;
  multipolygon_type multipoly;
  box_type box_inst;
  std::string holding;

  for(unsigned int i = 0; i < input_size; i++){
    if((i % 10000) == 0){
      Rcpp::checkUserInterrupt();
    }
    if(wkt[i] == NA_STRING){
      min_x[i] = NA_REAL;
      max_x[i] = NA_REAL;
      min_y[i] = NA_REAL;
      max_y[i] = NA_REAL;
    } else {
      holding = Rcpp::as<std::string>(wkt[i]);
      switch(id_type(holding)){
        case point:
          wkt_bounding_single_df(holding, pt, box_inst, i, min_x, max_x, min_y, max_y);
          break;
        case line_string:
          wkt_bounding_single_df(holding, ls, box_inst, i, min_x, max_x, min_y, max_y);
          break;
        case polygon:
          wkt_bounding_single_df(holding, poly, box_inst, i, min_x, max_x, min_y, max_y);
          break;
        case multi_point:
          wkt_bounding_single_df(holding, multip, box_inst, i, min_x, max_x, min_y, max_y);
          break;
        case multi_line_string:
          wkt_bounding_single_df(holding, multil, box_inst, i, min_x, max_x, min_y, max_y);
          break;
        case multi_polygon:
          wkt_bounding_single_df(holding, multipoly, box_inst, i, min_x, max_x, min_y, max_y);
          break;
        default:
          min_x[i] = NA_REAL;
          max_x[i] = NA_REAL;
          min_y[i] = NA_REAL;
          max_y[i] = NA_REAL;
      }
    }
  }

  return DataFrame::create(_["min_x"] = min_x,
                           _["min_y"] = min_y,
                           _["max_x"] = max_x,
                           _["max_y"] = max_y);
}

//' @title Convert WKT Objects into Bounding Boxes
//' @description \code{\link{wkt_bounding}} turns WKT objects
//' (specifically points, linestrings, polygons, and multi-points/linestrings/polygons)
//' into bounding boxes.
//' @export
//' @param wkt a character vector of WKT objects.
//' @param as_matrix whether to return the results as a matrix (TRUE) or data.frame (FALSE). Set
//' to FALSE by default.
//' @return either a data.frame or matrix, depending on the value of \code{as_matrix}, containing
//' four columns - \code{min_x}, \code{min_y}, \code{max_x} and \code{max_y} - representing the
//' various points of the bounding box. In the event that a valid bounding box cannot be generated
//' (due to the invalidity or incompatibility of the WKT object), NAs will be returned.
//' @seealso \code{\link{bounding_wkt}}, to turn R-size bounding boxes into WKT objects.
//' @examples
//' wkt_bounding("POLYGON ((30 10, 40 40, 20 40, 10 20, 30 10))")
// [[Rcpp::export]]
SEXP wkt_bounding(CharacterVector wkt, bool as_matrix = false){

  if(as_matrix){
    return Rcpp::wrap(wkt_bounding_matrix(wkt));
  }
  return Rcpp::wrap(wkt_bounding_df(wkt));
}
