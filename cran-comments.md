## Test environments

* local OS X install, R 4.0.3
* ubuntu 16.04 (on travis-ci), R 4.0.3
* win-builder (devel and release)

## R CMD check results

0 errors | 0 warnings | 0 notes

## Reverse dependencies

* I have run R CMD check on the 2 reverse dependencies. No problems were
found. Summary at <https://github.com/ropensci/wellknown/tree/master/revdep>

--------

This version changes some package imports and adds some new functions.

There are some remaining compiler warnings and notes on installation. I have inspected them and as far as I can tell they are all unrelated to this package's code; most are from Boost and the rest form bits/unique_ptr.h.

Thanks!
Scott Chamberlain
