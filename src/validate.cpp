#include <Rcpp.h>
#include "utils.h"
using namespace wkt_utils;
using namespace Rcpp;

String validity_comments(boost::geometry::validity_failure_type x){
  if(x == boost::geometry::no_failure){
    return NA_STRING;
  }
  if(x == boost::geometry::failure_few_points){
    return "The WKT object has too few points for its type";
  }
  if(x == boost::geometry::failure_wrong_topological_dimension){
    return "The WKT object has a topological dimension too small for its dimensions";
  }
  if(x == boost::geometry::failure_spikes){
    return "The WKT object contains spikes";
  }
  if(x == boost::geometry::failure_duplicate_points){
    return "The WKT object has consecutive duplicate points";
  }
  if(x == boost::geometry::failure_not_closed){
    return "The WKT object is closed but does not have matching start/end points";
  }
  if(x == boost::geometry::failure_self_intersections){
    return "The WKT object has invalid self-intersections";
  }
  if(x == boost::geometry::failure_wrong_orientation){
    return "The WKT object has a different orientation from the default. Use ?wkt_correct to fix.";
  }
  if(x == boost::geometry::failure_interior_rings_outside){
    return "The WKT object has interior rings sitting outside its exterior ring";
  }
  if(x == boost::geometry::failure_nested_interior_rings){
    return "The WKT object has nested interior rings";
  }
  if(x == boost::geometry::failure_disconnected_interior){
    return "The interior of the WKT object is disconnected";
  }
  if(x == boost::geometry::failure_intersecting_interiors){
    return "The WKT object has interior rings that intersect";
  }
  if(x == boost::geometry::failure_wrong_corner_order){
    return "The WKT object, a box, has corners in the wrong order";
  }
  return NA_STRING;
}

template <typename T>
inline void validate_single(std::string& x, unsigned int& i, CharacterVector& com, LogicalVector& valid, T& p){
  boost::geometry::validity_failure_type failure;
  try {
    boost::geometry::read_wkt(x, p);
    valid[i] = boost::geometry::is_valid(p, failure);
    com[i] = validity_comments(failure);
  } catch (boost::geometry::read_wkt_exception &e){
    com[i] = e.what();
    valid[i] = false;
  }
}

void validate_gc(std::string& x, unsigned int& i_sup, CharacterVector& com, LogicalVector& valid, std::deque <std::string>& gc){

  bool has_failed = false;

  clean_wkt(x);
  split_gc(x, gc);

  if(!gc.size()){
    com[i_sup] = "No valid objects could be extracted from this GeometryCollection";
    valid[i_sup] = false;
    return;
  }

  // Create instances of each type
  point_type pt;
  linestring_type ls;
  polygon_type poly;
  multipoint_type multip;
  multilinestring_type multil;
  multipolygon_type multipoly;

  for(unsigned int i = 0; i < gc.size(); i++){
    if(has_failed){
      break;
    }

    switch(id_type(gc[i])){
    case point:
      validate_single(gc[i], i_sup, com, valid, pt);
      if(!valid[i]){
        has_failed = true;
      }
      break;
    case line_string:
      validate_single(gc[i], i_sup, com, valid, ls);

      if(!valid[i]){
        has_failed = true;
      }
      break;
    case polygon:
      validate_single(gc[i], i_sup, com, valid, poly);
      if(!valid[i]){
        has_failed = true;
      }
      break;
    case multi_point:
      validate_single(gc[i], i_sup, com, valid, multip);
      if(!valid[i]){
        has_failed = true;
      }
      break;
    case multi_line_string:
      validate_single(gc[i], i_sup, com, valid, multil);
      if(!valid[i]){
        has_failed = true;
      }
      break;
    case multi_polygon:
      validate_single(gc[i], i_sup, com, valid, multipoly);
      if(!valid[i]){
        has_failed = true;
      }
      break;
    case geometry_collection:
      valid[i_sup] = false;
      com[i_sup] = "GeometryCollections cannot be nested";
      has_failed = true;
      break;
    default:
      valid[i_sup] = false;
      com[i_sup] = "A GeometryCollection member could not be recognised as a supported WKT type";
      has_failed = true;

    }
  }
}

//' @title Validate WKT objects
//' @description \code{validate_wkt} takes a vector of WKT objects and validates them,
//' returning a data.frame containing the status of each entry and
//' (in the case it cannot be parsed) any comments as to what, in particular, may be
//' wrong with it. It does not, unfortunately, check whether the object meets the WKT
//' spec - merely that it is formatted correctly.
//' @export
//' @param x a character vector of WKT objects.
//' @return a data.frame of two columns, \code{is_valid} (containing TRUE or FALSE values
//' for whether the WKT object is parseable and valid) and \code{comments} (containing any error messages
//' in the case that the WKT object is not). If the objects are simply NA,
//' both fields will contain NA.
//' @seealso \code{\link{wkt_correct}} for correcting WKT objects
//' that fail validity checks due to having a non-default orientation.
//' @examples
//' wkt <- c("POLYGON ((30 10, 40 40, 20 40, 10 20, 30 10))",
//'          "ARGHLEFLARFDFG",
//'          "LINESTRING (30 10, 10 90, 40 out of cheese error redo universe from start)")
//' validate_wkt(wkt)
// [[Rcpp::export]]
DataFrame validate_wkt(CharacterVector x){

  // Create instances of each type
  point_type pt;
  linestring_type ls;
  polygon_type poly;
  multipoint_type multip;
  multilinestring_type multil;
  multipolygon_type multipoly;

  // Generate output objects
  unsigned int input_size = x.size();
  CharacterVector comments(input_size, NA_STRING);
  LogicalVector is_valid(input_size, true);
  std::string holding;
  std::deque < std::string > gc_holding;

  for(unsigned int i = 0; i < input_size; i++){
    if((i % 10000) == 0){
      Rcpp::checkUserInterrupt();
    }
    if(x[i] == NA_STRING){
      is_valid[i] = NA_LOGICAL;
    } else {
      holding = Rcpp::as<std::string>(x[i]);
      switch(id_type(holding)){
        case point:
          validate_single(holding, i, comments, is_valid, pt);
          break;
        case line_string:
          validate_single(holding, i, comments, is_valid, ls);
          break;
        case polygon:
          validate_single(holding, i, comments, is_valid, poly);
          break;
        case multi_point:
          validate_single(holding, i, comments, is_valid, multip);
          break;
        case multi_line_string:
          validate_single(holding, i, comments, is_valid, multil);
          break;
        case multi_polygon:
          validate_single(holding, i, comments, is_valid, multipoly);
          break;
        case geometry_collection:
          validate_gc(holding, i, comments, is_valid, gc_holding);
          gc_holding.clear();
          break;
        default:
          is_valid[i] = false;
          comments[i] = "Object could not be recognised as a supported WKT type";
      }
    }
  }

  return DataFrame::create(_["is_valid"] = is_valid,
                           _["comments"] = comments,
                           _["stringsAsFactors"] = false);
}
