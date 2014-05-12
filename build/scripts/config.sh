#!/bin/sh

CXX=g++
CXXFLAGS="-Wall -std=c++1y"
LDFLAGS=""
TARGET_FILE=libsha1.a

TEST_CXX=${CXX}
TEST_CXXFLAGS="${CXXFLAGS}"
TEST_LDFLAGS=`echo ${TARGET_FILE} | sed -e 's/\(^lib\)\(.*\)\(.a$\)/-l\2/g'`

AR=ar
ARFLAGS="rsv"

SED=sed
