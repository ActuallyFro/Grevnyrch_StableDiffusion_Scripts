#!/bin/bash

#current date and time as a single ISO string
DATE=$(date -u +"%Y-%m-%dT%H_%M_%SZ")
BATFile="Generate_TXT_PCs_$DATE.bat"
StepsNum=50
# SeedNum=42
SeedNum=$((1 + RANDOM % 1000000))
GuidanceScale=4.77

UsePLMSModel=""
#vs: UsePLMSModel=" --plms"

while [[ $# -gt 0 ]]; do
  key="$1"

  case $key in
    -s|--steps)
      StepsNum="$2"
      shift # past argument
      shift # past value
      ;;

    -S|--seed)
      SeedNum="$2"
      shift # past argument
      shift # past value
      ;;

    -g|--guidance|--scale)
      GuidanceScale="$2"
      shift # past argument
      shift # past value
      ;;

    -p|--plms)
      UsePLMSModel=" --plms"
      shift # past argument
      ;;
    *)    # unknown option
      shift # past argument
      ;;
  esac
done

header="python optimizedSD/optimized_txt2img.py --seed $SeedNum --ddim_steps $StepsNum --scale $GuidanceScale --prompt \"fantasy RPG, "
footer=", anthropomorphic, hyperdetailed, hyperrealism, photorealism\" --n_iter 5 --negative_prompt \"(disfigured), (bad art), (deformed), (poorly drawn), (extra limbs), blurry, boring, sketch, lacklustre, repetitive, cropped\" --n_samples 1$UsePLMSModel"

characters=(elf orc human human half-elf half-orc tiefling halfling half-dragon gnome rabbit half-demon)
gend=(male female)

# class=(barbarian bard cleric druid fighter monk paladin ranger rogue sorcerer warlock wizard)
classes=(barbarian bard druid fighter rogue warlock wizard)

#array descriptions for facial features
descripts=(scared angry happy sad gorgeous ugly handsome beautiful)

#loop over charcs array
for charcter in ${characters[@]}; do
  #loop over descriptions array
  for description in ${descripts[@]}; do
    for charclass in ${classes[@]}; do
      if [ $((RANDOM % 3)) -eq 0 ]; then
        if [ $((RANDOM % 2)) -eq 0 ]; then
          # echo "$header$description ${gend[0]} $charclass $charcter$footer" 
          echo "$header$description ${gend[0]} $charclass $charcter$footer" >> $BATFile
        else
          # echo "$header$description ${gend[1]} $charclass $charcter$footer" 
          echo "$header$description ${gend[1]} $charclass $charcter$footer" >> $BATFile
        fi
      fi

      # # ALL
      # echo "$header$description ${gend[0]} $charclass $charcter$footer" 
      # echo "$header$description ${gend[1]} $charclass $charcter$footer" 
    done
  done
done

