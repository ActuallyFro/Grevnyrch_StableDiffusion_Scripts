#!/bin/bash

location="."

counter=0

#read in arguments for Location, OutfileName, ResumeCounting with "--" and flag
while [[ $# -gt 0 ]]; do
  key="$1"

  case $key in
    -l|--location)
      location="$2"
      shift # past argument
      shift # past value
      ;;
    -c|--counter)
      counter="$2"
      shift # past argument
      shift # past value
      ;;
    *)    # unknown option
      shift # past argument
      ;;
  esac
done


#loop over all folders that contain string "fantasy RPG"
for folder in $(find $location -type d -name "*fantasy RPG*"); do

  echo "[DEBUG] Looking at folder: $folder"

  # #loop over all files in folder
  # for file in $folder/*; do


  #   if [[ $file == *.png ]]; then
  #     #copy file to current directory
  #     cp $file .
  #   fi

  # done
  counter=$((counter+1))
done

#warning if no folders found
if [ $counter -eq 0 ]; then
  echo "[WARNING] No folders found with string \"fantasy RPG\""
fi