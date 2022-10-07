#!/bin/bash

#current date and time as a single ISO string
DATE=$(date -u +"%Y-%m-%dT%H_%M_%SZ")
BATFile="Generate_TXT_Locations_$DATE.bat"

TotalToGenerate=100
StepsNum=42
IHeight=512
IWidth=896

#Random maxint for seed
SeedNum=$((1 + RANDOM % 1000000))

GuidanceScale=6.13
#Artists v1.1.1
artists=(eve_arnold mika_asai Tom_Bagshaw Banksy John_T._Biggers Elsa_Bleda Charlie_Bowater Aleski_Briclot David_Burdeny Saturno_Butto Mike_Campau Elizabeth_Catlett Nathan_Coley Andre_de_Dienes Roy_DeCarava Gariele_Dell\'otto Mandy_Disher Dave_Dorman Natalia_Drepina TJ_Drysdale Lori_Earley Micheal_Eastman Les_Edwards Bob_Eggleton Greg_Rutkowski Andreas_Rocha Magali_Villeneuve Natalie_Shau Anna_Dittmann Pino_Daeni Huang_Guangjian Allyssa_Monks Luis_Royo Daniel_F_Gerhartz Thomas_Kinkade Zdzislaw_Beksinski Atul_Kasbekar Dayanita_Singh Arjun_Mark Gautam_Rajadhyaksha)

#Paul_Barson-oils, Nobuyoshi_Araki-anime, Yanjun_Cheng-oils, Piet_Hein_Eek-oils, Harold_Edgerton-anime, Bruce_Davidson-anime, Ernie_Barnes-cartoon, Walt_Disney-cartoon, Lise_Deharme-oils, Ilse_Bing-oils, Jody_Bergsma-oils, Jason_Edmiston-cartoon, Oalafur_Eliasson-oils, Noah_Bradley-oils, Dima_Dmitiev-oils, Maxfield_Parrish-oils, Terry_Moore-Cartoon, John_William_Waterhouse-oils, William_Adolphe_Bouguereau-oils

header="python optimizedSD/optimized_txt2img.py --seed $SeedNum --ddim_steps $StepsNum --scale $GuidanceScale --H $IHeight --W $IWidth --prompt \"fantasy RPG, "
footer=", hyperdetailed, photorealism\" --n_iter 5 --negative_prompt \"cartoon, anime, boring, cropped, (mutation), ((HUD)), ((video game)), dull, vague, (blurry), distorted, framed\" --n_samples 1"

locations=(City_Street back_alley city_sewers bazaar city_overlook city_square tavern tailor blacksmith inn guildhall gemcutter Alchemist_Shop Bookstore Leather_Worker_Shop General_Store Apothecary_Shop)
timeOfDay=(morning mid-day night afternoon twilight high-noon sunset dawn)
features_outdoors=(foggy rainy snowy blue-glow red-glow green-glow orange-glow yellow-glow purple-glow clear hdr cloudy_skies clear_skies stormy_skies thunderstorm aurora_borealis stars)
addins_outdoors=(people animals monsters crowd city-guard bandits guards necromancers wizards marauders priests thieves clergy)

features_indoors=(empty busy crowded dimly_lit brightly_lit darkly_lit blue-glow red-glow green-glow orange-glow yellow-glow purple-glow smokey)
addins_indoors=(people clerks workers crowd cityguard bandit adventurers)

for i in `seq 1 $TotalToGenerate`; do
  # echo "[DEBUG] Loop: $i / $TotalToGenerate]"
  PreString=""
  ExtraString=""
  addChoice=""
  isOutdoors=true
  feature=""

  if [ $((RANDOM % 5)) -eq 0 ]; then
    PreString=" inside"
    isOutdoors=false
  fi

  location=${locations[$((RANDOM % ${#locations[@]}))]}
  currentTime=${timeOfDay[$((RANDOM % ${#timeOfDay[@]}))]}

  if [ $isOutdoors = true ]; then
    feature=${features_outdoors[$((RANDOM % ${#features_outdoors[@]}))]}
  else 
    feature=${features_indoors[$((RANDOM % ${#features_indoors[@]}))]}
  fi

  LoopCount=$((1 + RANDOM % 8))
  for j in {1..$LoopCount}; do
    if [ $isOutdoors = true ]; then
      ExtraString="$ExtraString, ${addins_outdoors[$((RANDOM % ${#addins_outdoors[@]}))]}"
    else
      ExtraString="$ExtraString, ${addins_indoors[$((RANDOM % ${#addins_indoors[@]}))]}"
    fi
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


