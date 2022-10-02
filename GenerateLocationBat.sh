#!/bin/bash

#current date and time as a single ISO string
DATE=$(date -u +"%Y-%m-%dT%H_%M_%SZ")
BATFile="Generate_TXT_Locations_$DATE.bat"

TotalToGenerate=100
StepsNum=50

#Random maxint for seed
SeedNum=$((1 + RANDOM % 1000000))

GuidanceScale=9.7
artists=(Nobuyoshi_Araki eve_arnold mika_asai Tom_Bagshaw Banksy Ernie_Barnes Paul_Barson Jody_Bergsma John_T._Biggers Ilse_Bing Elsa_Bleda Charlie_Bowater Noah_Bradley Aleski_Briclot David_Burdeny Saturno_Butto Mike_Campau Elizabeth_Catlett Yanjun_Cheng Nathan_Coley Bruce_Davidson Andre_de_Dienes Roy_DeCarava Lise_Deharme Gariele_Dell\'otto Mandy_Disher Walt_Disney Dima_Dmitiev Dave_Dorman Natalia_Drepina TJ_Drysdale Lori_Earley Micheal_Eastman Harold_Edgerton Jason_Edmiston Les_Edwards Piet_Hein_Eek Bob_Eggleton Oalafur_Eliasson)

header="python optimizedSD/optimized_txt2img.py --seed $SeedNum --ddim_steps $StepsNum --scale $GuidanceScale --prompt \"fantasy RPG, "
footer=", anthropomorphic, hyperdetailed, hyperrealism, photorealism\" --n_iter 5 --negative_prompt \"cartoon, 3d, anime, (disfigured), (deformed), boring, cropped, (cross-eyed), (closed eyes), (bad anatomy), (mutation), (mutated), (extra limbs), HUD, video game, dull, vague, (blurry), distorted, random, clashing, watermark, stock image, framed\" --n_samples 1"

locations=(tavern tailor blacksmith inn guildhall gemcutter Alchemist_Shop Bookstore Leather_Worker_Shop General_Store Apothecary_Shop)
timeOfDay=(morning mid-day night twilight)
features=(foggy rainy snowy blue-glow red-glow green-glow purple-glow clear)
addins=(people animals monsters crowd cityguard bandits guards necromancers wizards marauders priests thieves clergy)

for i in `seq 1 $TotalToGenerate`; do
  # echo "[DEBUG] Loop: $i / $TotalToGenerate]"
  PreString=""
  ExtraString=""
  addChoice=""

  if [ $((RANDOM % 5)) -eq 0 ]; then
    PreString=" inside"
  fi

  location=${locations[$((RANDOM % ${#locations[@]}))]}
  currentTime=${timeOfDay[$((RANDOM % ${#timeOfDay[@]}))]}
  feature=${features[$((RANDOM % ${#features[@]}))]}

  LoopCount=$((1 + RANDOM % 8))
  for j in {1..$LoopCount}; do
    ExtraString="$ExtraString, ${addins[$((RANDOM % ${#addins[@]}))]}"
  done

  artist=${artists[$((RANDOM % ${#artists[@]}))]}

  LocationStr="$PreString $location at $currentTime, $feature$ExtraString, in the style of $artist"
  LocationStr=${LocationStr//_/ }

  CmdStr="$header$LocationStr$footer"

  # CmdStr=${CmdStr//_/ }
  # CmdStr=${CmdStr//optimized txt2img/optimized_txt2img}
  # CmdStr=${CmdStr//ddim steps/ddim_steps}
  # CmdStr=${CmdStr//negative prompt/negative_prompt}
  # CmdStr=${CmdStr//n samples/n_samples}
  # CmdStr=${CmdStr//n iter/n_iter}
  
  echo $CmdStr >> $BATFile

  # echo "[DEBUG] $CmdStr >> $BATFile"

done


