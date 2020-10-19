#include <Rcpp.h>
using namespace Rcpp;
#include "utils.h"
using namespace wkt_utils;
//[[Rcpp::depends(BH)]]

void get_coords_single(std::string& x,
                       std::list<s_polygon_type>& output,
                       unsigned int& out_size){

  s_polygon_type p;
  try {
    boost::geometry::read_wkt(x, p);
  } catch (...){
    output.push_back(p);
    out_size++;
    return;
  }
  output.push_back(p);
  if(p.outer().size()){
    out_size += p.outer().size();
  } else {
    out_size++;
  }
  for(unsigned int i = 0; i < p.inners().size(); i++){
    out_size += p.inners()[i].size();
  }
}


void extract_coords(s_polygon_type& p, unsigned int& outsize,
                    IntegerVector& object,
                    CharacterVector& ring, NumericVector& lat,
                    NumericVector& lng, unsigned int obj){
  if(p.outer().size() == 0){
    object[outsize] = obj;
    ring[outsize] = NA_STRING;
    lat[outsize] = NA_REAL;
    lng[outsize] = NA_REAL;
    outsize++;
    return;
  }
  std::vector < s_point_type > points = p.outer();
  for(unsigned int i = 0; i < points.size(); i++){
    object[outsize] = obj;
    ring[outsize] = "outer";
    lat[outsize]  = boost::geometry::get<1>(points[i]);
    lng[outsize]  = boost::geometry::get<0>(points[i]);
    outsize++;
  }

  if(p.inners().size()){
    std::string ring_id;
    s_polygon_type x;
    for(unsigned int i = 0; i < p.inners().size(); i++){
      boost::geometry::convert(p.inners()[i], x);
      ring_id = "inner " + make_string(i+1);
      for(unsigned int j = 0; j < x.outer().size(); j++){
        object[outsize] = obj;
        ring[outsize] = ring_id;
        lat[outsize]  = boost::geometry::get<1>(x.outer()[j]);
        lng[outsize]  = boost::geometry::get<0>(x.outer()[j]);
        outsize++;
      }
    }
  }

}

//' @title Extract Latitude and Longitude from WKT polygons
//' @description \code{wkt_coords} extracts lat/long values from WKT polygons,
//' specifically the outer shell of those polygons (working on the assumption that
//' said outer edge is what you want).
//' 
//' Because it assumes \emph{coordinates}, it also assumes a sphere - say, the earth -
//' and uses spherical coordinate values.
//' @export
//' @param wkt a character vector of WKT objects
//' @return a data.frame of four columns; \code{object} (containing which object
//' the row refers to), \code{ring} containing which layer of the object the row
//' refers to, \code{lng} and \code{lat}.
//' @seealso \code{\link{wkt_bounding}} to extract a bounding box,
//' and \code{\link{wkt_centroid}} to extract the centroid.
//' @examples
//' wkt_coords("POLYGON ((30 10, 40 40, 20 40, 10 20, 30 10))")
//' # object  ring lng lat
//' # 1    1 outer  30  10
//' # 2    1 outer  40  40
//' # 3    1 outer  20  40
//' # 4    1 outer  10  20
//' # 5    1 outer  30  10
// [[Rcpp::export]]
DataFrame wkt_coords(CharacterVector wkt){

  unsigned int input_size = wkt.size();
  std::list<s_polygon_type> holding;
  std::string str_holding;
  unsigned int n_size = 0;

  for(unsigned int i = 0; i < input_size; i++){
    if((i % 10000) == 0){
      Rcpp::checkUserInterrupt();
    }
    str_holding = Rcpp::as<std::string>(wkt[i]);
    get_coords_single(str_holding, holding, n_size);
  }

  IntegerVector   object(n_size);
  CharacterVector ring(n_size);
  NumericVector   lat(n_size);
  NumericVector   lng(n_size);
  s_polygon_type p;
  unsigned int outsize = 0;
  unsigned int obj = 1;
  for(std::list<s_polygon_type>::const_iterator it = holding.begin(), end = holding.end();
      it != end; ++it) {
    p = *it;
    extract_coords(p, outsize, object, ring, lat, lng, obj);
    obj++;
  }

  return DataFrame::create(_["object"] = object,
                           _["ring"] = ring,
                           _["lng"] = lng,
                           _["lat"] = lat,
                           _["stringsAsFactors"] = false);
}
