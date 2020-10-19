#include <Rcpp.h>
#include "def.h"
using namespace Rcpp;

#ifndef __WKT_UTILS__
#define __WKT_UTILS__
namespace wkt_utils {

  /**
   * A function for lower-casing a string
   *
   * @param x a reference to a string to lower-case
   *
   * @return nothing; x is modified directly
   */
  void lower_case(std::string& x);

  /**
   * A function for cleaning a WKT object - specifically, removing trailing and tailing
   * spaces.
   *
   * @param x a reference to a string to clean
   *
   * @return nothing; x is modified directly
   */
  void clean_wkt(std::string& x);

  /**
   * An enum of supported types: exists to make switch statements easier
   */
  enum supported_types {
    point               = 1,
    multi_point         = 2,
    line_string         = 3,
    multi_line_string   = 4,
    polygon             = 5,
    geometry_collection = 6,
    multi_polygon       = 7,
    unsupported_type    = 8
  };

  /**
   * A function for generating a type enum. Used in switch statements.
   *
   * @param type a string containing the suspected type of the WKT object
   *
   * @return a value from the supported_types enum
   */
  supported_types hash_type(std::string type);

  /**
   * A function for extracting the type from a WKT object and identifying it
   * as an enum value
   *
   * @param wkt_obj a reference to a string to extract the type from
   *
   * @return a value from the supported_types enum
   */
  supported_types id_type(std::string& wkt_obj);

  /**
   * A function to split a GeometryCollection into its component parts
   *
   * @param wkt_obj: a reference to a string containing a GeometryCollection
   *
   * @param output: a reference to a deque of strings to put the GeometryCollection's contents
   * into
   *
   * @return nothing; output is modified
   */
  void split_gc(std::string& wkt_obj, std::deque < std::string >& output);

  /**
   * A function for making a string WKT representation of a boost::geometry polygon
   *
   * @param p: a boost::geometry polygon
   *
   * @return a string containing a WKT representation of p
   */
  std::string make_wkt_poly(polygon_type p);

  /**
   * A function for making a string WKT representation of a boost::geometry multipolygon
   *
   * @param p: a boost::geometry multipolygon
   *
   * @return a string containing a WKT representation of p
   */
  std::string make_wkt_multipoly(multipolygon_type p);

  std::string make_string(int x);
};
#endif
