#!/bin/bash

#current date and time as a single ISO string
DATE=$(date -u +"%Y-%m-%dT%H_%M_%SZ")
BATFile="Generate_TXT_PCs_$DATE.bat"

TotalToGenerate=100
# StepsNum=50
StepsNum=42
SeedNum=$((1 + RANDOM % 1000000))
GuidanceScale=4.77

# IHeight=896
IHeight=768
IWidth=512

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

header="python optimizedSD/optimized_txt2img.py --seed $SeedNum --ddim_steps $StepsNum --scale $GuidanceScale --H $IHeight --W $IWidth --prompt \""
footer=", ((full body)) portrait, fantasy RPG, (hyperdetailed) intricate, 8k, intense, sharp focus, two arms, two legs\" --n_iter 5 --negative_prompt \"(disfigured), (bad art), (extra limbs), blurry, boring, sketch, (close up), lacklustre, repetitive, cropped, body out of frame, ((deformed)), (cross-eyed), (closed eyes), (bad anatomy), ugly, ((poorly drawn face))\" --n_samples 1$UsePLMSModel"
 
#Artists v1.0.0
artists=(Nobuyoshi_Araki eve_arnold mika_asai Tom_Bagshaw Banksy Ernie_Barnes Paul_Barson Jody_Bergsma John_T._Biggers Ilse_Bing Elsa_Bleda Charlie_Bowater Noah_Bradley Aleski_Briclot David_Burdeny Saturno_Butto Mike_Campau Elizabeth_Catlett Yanjun_Cheng Nathan_Coley Bruce_Davidson Andre_de_Dienes Roy_DeCarava Lise_Deharme Gariele_Dell\'otto Mandy_Disher Walt_Disney Dima_Dmitiev Dave_Dorman Natalia_Drepina TJ_Drysdale Lori_Earley Micheal_Eastman Harold_Edgerton Jason_Edmiston Les_Edwards Piet_Hein_Eek Bob_Eggleton Oalafur_Eliasson)


descripts=(scared angry happy sad gorgeous ugly handsome beautiful)
gend=(male female)
classes=(barbarian bard druid fighter rogue warlock wizard)
characters=(elf orc human human half-elf half-orc tiefling halfling anthropomorphic_dragon gnome anthropomorphic_rabbit anthropomorphic_demon)

# #loop over charcs array
# for charcter in ${characters[@]}; do
#   #loop over descriptions array
#   for description in ${descripts[@]}; do
#     for charclass in ${classes[@]}; do
#       if [ $((RANDOM % 3)) -eq 0 ]; then
#         if [ $((RANDOM % 2)) -eq 0 ]; then
#           # echo "$header$description ${gend[0]} $charclass $charcter$footer" 
#           echo "$header$description ${gend[0]} $charclass $charcter$footer" >> $BATFile
#         else
#           # echo "$header$description ${gend[1]} $charclass $charcter$footer" 
#           echo "$header$description ${gend[1]} $charclass $charcter$footer" >> $BATFile
#         fi
#       fi

#       # # ALL
#       # echo "$header$description ${gend[0]} $charclass $charcter$footer" 
#       # echo "$header$description ${gend[1]} $charclass $charcter$footer" 
#     done
#   done
# done


for i in `seq 1 $TotalToGenerate`; do
  randDescription=${descripts[$((RANDOM % ${#descripts[@]}))]}
  randGend=${gend[$((RANDOM % ${#gend[@]}))]}
  randClass=${classes[$((RANDOM % ${#classes[@]}))]}
  randCharc=${characters[$((RANDOM % ${#characters[@]}))]}


  artist=${artists[$((RANDOM % ${#artists[@]}))]}

  PCStr="$randDescription $randGend $randClass $randCharc, $artist"
  PCStr=${PCStr//_/ }

  CmdStr="$header$PCStr$footer"

  echo "$CmdStr" >> $BATFile
done
