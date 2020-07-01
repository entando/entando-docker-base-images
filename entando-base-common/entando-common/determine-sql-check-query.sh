#!/usr/bin/env bash
#NB!!! This file is copied from common/s2i in the Docker build hook. Only modify the original file!
#Returns the appropriate Java JDBC Driver class a given DBMS vendor
case "$1" in
    oracle )
      echo "SELECT 1 FROM dual"
      ;;
    * )
      echo "SELECT 1"
esac