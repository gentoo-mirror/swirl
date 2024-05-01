#!/bin/sh
find -name "*.ebuild" -exec ebuild {} manifest \;
