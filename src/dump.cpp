#include <Rcpp.h>

#include <cstdio>
#include <limits>
#include <cstdint>
#include <string>
#include <algorithm>
#include <cctype>
#include <iostream>
#include <clocale>
#include <iterator>

using namespace Rcpp;

// [[Rcpp::depends(BH)]]
// [[Rcpp::plugins(cpp11)]]

#include <boost/format.hpp>
#include <boost/algorithm/string/join.hpp>
#include <boost/algorithm/string.hpp>

std::string str_tolower(std::string s) {
  std::transform(s.begin(), s.end(), s.begin(),
                 [](unsigned char c){ return std::tolower(c); }
  );
  return s;
}

std::string pick_three(std::string x) {
  x = str_tolower(x);
  enum lets {m, z};
  static std::map<std::string, lets> s_map_string_values;
  switch(s_map_string_values[x]) {
  case m:
    return "M";
    break;
  case z:
    return "Z";
    break;
  default:
    throw("'third' must be one of 'm' or 'z'");
  }
};

std::string make_it(std::string geom, std::string x, int len, std::string third) {
  std::string out;
  if (len == 3) {
    out = str( boost::format("%s %s(%s)") % geom % pick_three(third) % x );
  } else if (len == 4) {
    out = str( boost::format("%s ZM(%s)") % geom % x );
  } else {
    out = str( boost::format("%s (%s)") % geom % x );
  };
  return out;
};

std::string make_str_fmt(int fmt) {
  std::string fmt_str_one = "%1." + std::to_string(fmt) + "f";
  std::string fmt_str = fmt_str_one + " " + fmt_str_one;
  return fmt_str;
};

std::string in_parens(std::string x) {
  std::string out;
  out = str( boost::format("(%s)") % x );
  return out;
};

std::string join_sep(std::vector<std::string> x) {
  const int w = x.size();
  std::string out = std::string("");
  for (int i=0; i < w; ++i) {
    std::string z;
    z = (i == w - 1) ? x[i] : x[i] + ", ";
    out = out + z;
  };
  return out;
};

// [[Rcpp::export]]
std::string wk_dump_point(List obj, int fmt, std::string third){
  NumericVector coords = obj["coordinates"];
  // FIXME: do checking if needed
  std::string coords_str;
  coords_str = boost::str( boost::format(make_str_fmt(fmt)) % coords[0] % coords[1] );
  return make_it("POINT", coords_str, coords.size(), third);
};

// [[Rcpp::export]]
std::string wk_dump_multipoint(List obj, int fmt, std::string third){
  NumericMatrix coords = obj["coordinates"];
  // FIXME: do checking if needed
  std::string str_formatter = make_str_fmt(fmt);
  const int n = coords.nrow();
  std::vector<std::string> y(n);
  for (int i=0; i < n; ++i) {
    std::string cs;
    cs = boost::str( boost::format(str_formatter) % coords(i, 0) % coords(i, 1) );
    y[i] = in_parens( cs );
  };
  std::string out = join_sep(y);
  return make_it("MULTIPOINT", out, coords.ncol(), third);
};

// [[Rcpp::export]]
std::string wk_dump_linestring(List obj, int fmt, std::string third){
  NumericMatrix coords = obj["coordinates"];
  // FIXME: do checking if needed
  std::string str_formatter = make_str_fmt(fmt);
  const int n = coords.nrow();
  std::vector<std::string> y(n);
  for (int i=0; i < n; ++i) {
    std::string cs;
    cs = boost::str( boost::format(str_formatter) % coords(i, 0) % coords(i, 1) );
    y[i] = cs;
  };
  std::string out = join_sep(y);
  return make_it("LINESTRING", out, coords.ncol(), third);
};

// [[Rcpp::export]]
std::string wk_dump_multilinestring(List obj, int fmt, std::string third){
  List coords = obj["coordinates"];
  // FIXME: do checking if needed
  std::string str_formatter = make_str_fmt(fmt);

  const int n = coords.size();
  // Rprintf("coords.size() = %u \n", n);
  std::vector<std::string> y(n);
  for (int i=0; i < n; ++i) {
    NumericMatrix mat = coords[i];
    const int m = mat.nrow();
    // Rprintf("mat.nrow() = %u \n", m);
    std::vector<std::string> w(m);
    for (int j=0; j < m; ++j) {
      std::string cs;
      cs = boost::str( boost::format(str_formatter) % mat(j, 0) % mat(j, 1) );
      w[j] = cs;
    };
    std::string res = in_parens( join_sep(w) );
    y[i] = res;
  };
  std::string out = join_sep(y);
  NumericMatrix matzero = coords[0];
  int len = matzero.ncol();
  return make_it("MULTILINESTRING", out, len, third);
};

// [[Rcpp::export]]
std::string wk_dump_polygon(List obj, int fmt, std::string third){
  List coords = obj["coordinates"];
  // FIXME: do checking if needed
  std::string str_formatter = make_str_fmt(fmt);

  const int n = coords.size();
  // Rprintf("coords.size() = %u \n", n);
  std::vector<std::string> y(n);
  for (int i=0; i < n; ++i) {
    NumericMatrix mat = coords[i];
    const int m = mat.nrow();
    // Rprintf("mat.nrow() = %u \n", m);
    std::vector<std::string> w(m);
    for (int j=0; j < m; ++j) {
      std::string cs;
      cs = boost::str( boost::format(str_formatter) % mat(j, 0) % mat(j, 1) );
      w[j] = cs;
    };
    std::string res = in_parens( join_sep(w) );
    y[i] = res;
  };
  std::string out = join_sep(y);
  NumericMatrix matzero = coords[0];
  int len = matzero.ncol();
  return make_it("POLYGON", out, len, third);
};
