#!/bin/sh

g++ -std=c++1y -Wall -I../include sha1sum.cpp -L../lib -lsha1 -o sha1sum
