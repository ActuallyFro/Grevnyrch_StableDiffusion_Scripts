#!/bin/bash

#take two input strings, error if not
if [ $# -ne 2 ]; then
  echo "File Merger"
  echo "-----------"
  echo "Usage: $0 <string1> <string2>"
  echo "$0 Generate_FromPrompt_2022-10-15T16_20_39Z.bat Generate_FromPrompt_2022-10-15T16_22_51Z.bat"
  exit 1
fi

#check if the strings are the same
if [ "$1" = "$2" ]; then
    echo "[ERROR] The strings are the same"
    exit 0
fi

#merge the two files into a new file
DATE=$(date -u +"%Y-%m-%dT%H_%M_%SZ")
BATFile="Generate_MERGED_$DATE.bat"
cat $1 $2 > $BATFile

#randomly shuffle all lines in the file
shuf $BATFile > $BATFile.tmp && mv $BATFile.tmp $BATFile

echo ""
echo "[FIN] see $BATFile for commands"