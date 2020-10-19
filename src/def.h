#include <Rcpp.h>
//[[Rcpp::depends(BH)]]
#include <boost/geometry.hpp>
#include <boost/geometry/geometries/point_xy.hpp>

using namespace Rcpp;

typedef boost::geometry::model::point<double, 2, boost::geometry::cs::cartesian> point_type;
typedef boost::geometry::model::point<double, 2, boost::geometry::cs::spherical_equatorial<boost::geometry::degree> > s_point_type;


typedef boost::geometry::model::linestring<point_type> linestring_type;
typedef boost::geometry::model::polygon<point_type> polygon_type;
typedef boost::geometry::model::box<point_type> box_type;
typedef boost::geometry::model::multi_point<point_type> multipoint_type;
typedef boost::geometry::model::multi_linestring<linestring_type> multilinestring_type;
typedef boost::geometry::model::multi_polygon<polygon_type> multipolygon_type;

typedef boost::geometry::model::polygon<s_point_type> s_polygon_type;
