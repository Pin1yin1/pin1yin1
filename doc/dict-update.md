# Update Pin1yin1.com Dictionary data

In the data directory, there are 11 files that contain the dictionary
data used by Pin1yin1, comprising of:
* bopomofo.dat - bopomofo pronunciation mappings
* cedict_ts.u8 - main dictionary definitions
* CJKRadicals.txt, Unihan_*.txt - unicode han character database

This document explains how to update them.

## bopomofo mappings

bopomofo.dat should not need to be updated, unless new pronunciation appears.

## CC-CEDict
CC-CEDict provides the main dictionary definitions used by Pin1yin1.

The database is updated frequently.

Simply download the new file from
https://www.mdbg.net/chinese/dictionary?page=cc-cedict
and overwrite cedict_ts.u8, ensuring you keep the utf encoding intact.

## Unicode han database
The Unicode Han database ("unihan") is the definitive reference for
Chinese characters in Unicode.

This database is updated generally only when a new version of unicode is
released, generally once a year. Information can be found at
http://www.unicode.org/reports/tr38/

The database is found in a file called "Unihan.zip", the location of which
changes based on the version. For unicode 9 it is at:
ftp://ftp.unicode.org/Public/9.0.0/ucd/Unihan.zip

CJKRadicals.txt, which provide the eg Kangxi radical information is found
outside of Unihan.zip, at ftp://ftp.unicode.org/Public/9.0.0/ucd/CJKRadicals.txt

## Re-Importing dictionary data

After updating any data, follow the steps in the install guide to
import the new data.

