#!/bin/bash

#current date and time as a single ISO string
DATE=$(date -u +"%Y-%m-%dT%H_%M_%SZ")
BATFile="Generate_FromPrompt_$DATE.bat"

TotalGenerateLoops=120
# StepsNum=50
StepsNum=42
SeedNum=$((1 + RANDOM % 1000000))
GuidanceScale=4.77
iterations=4

# IHeight=896
IHeight=512
IWidth=768

promptNeedsConversions=false
negativePromptNeedsConversions=false

artistsNeedConversions=false
isArtistPrecidence=FALSE
areAllArtistsUsed=FALSE

themesNeedConversions=false

while [[ $# -gt 0 ]]; do
  key="$1"

  case $key in
    -a | --artists)
      artists=""
      artists="$2"
      # artists=("$2")
      echo "[DEBUG] Passed artists: $artists"
      artistsNeedConversions=TRUE
      shift # past argument
      shift # past value
      ;;

    -A | --artistPrecidence)
      isArtistPrecidence=TRUE
      shift # past argument
      ;;

    -g|--guidance|--scale)
      GuidanceScale="$2"
      shift # past argument
      shift # past value
      ;;

    -i | --iterations)
      iterations="$2"
      shift # past argument
      shift # past value
      ;;

    -p|--prompt)
      prompt="$2"
      promptNeedsConversions=TRUE
      shift # past argument
      shift # past value
      ;;

    -n|--negative_prompt)
      negative="$2"
      negativePromptNeedsConversions=TRUE
      shift # past argument
      shift # past value
      ;;

    -t|--themes)
      themes="$2"
      themesNeedConversions=TRUE
      shift # past argument
      shift # past value
      ;;

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

    -H | --Height)
      IHeight="$2"
      shift # past argument
      shift # past value
      ;;

    -W | --Width)
      IWidth="$2"
      shift # past argument
      shift # past value
      ;;

    -h|--help)
      echo "GenerateFromPromptBat.sh [options]"
      echo "  -a | --artists <artists>                List of artists to use"
      echo "  -A | --artistPrecidence                 Use artist precidence before prompt ($isArtistPrecidence)"
      echo "  -g | --guidance|--scale <scale>         Guidance scale. ($GuidanceScale)"
      echo "  -i | --iterations <iterations>          Number of iterations. ($iterations)"
      echo "  -p | --prompt \"<prompt>\"                Prompt to use. "
      echo "  -n | --negative_prompt \"<negative>\"     Negative prompt to use."
      echo "  -s | --steps <steps>                    Number of steps to take. ($StepsNum)"
      echo "  -S | --seed <seed>                      Seed number. (Random)"
      echo "  -t | --themes <themes>                  List of themes to use."
      echo ""
      echo "  -H | --Height <height>                  Height of the image. ($IHeight)"
      echo "  -W | --Width <width>                    Width of the image. ($IWidth)"
      echo ""
      echo "  -h | --help                             Show this help"
      echo ""
      echo ""
      echo "Default artists: ${artists[@]}"
      echo ""
      echo "Default Prompt: \"$prompt\""
      echo ""
      echo "Default Negative Prompt: \"$negative\""
      echo ""
      exit 0
      ;;

    *)    # unknown option
      shift # past argument
      ;;
  esac
done
 

if [ "$artistsNeedConversions" = false ] ; then
  #Artists v1.1.1
  # artists=(eve_arnold mika_asai Tom_Bagshaw Banksy John_T._Biggers Elsa_Bleda Charlie_Bowater Aleski_Briclot David_Burdeny Saturno_Butto Mike_Campau Elizabeth_Catlett Nathan_Coley Andre_de_Dienes Roy_DeCarava Gariele_Dell\'otto Mandy_Disher Dave_Dorman Natalia_Drepina TJ_Drysdale Lori_Earley Micheal_Eastman Les_Edwards Bob_Eggleton Greg_Rutkowski Andreas_Rocha Magali_Villeneuve Natalie_Shau Anna_Dittmann Pino_Daeni Huang_Guangjian Allyssa_Monks Luis_Royo Daniel_F_Gerhartz Thomas_Kinkade Zdzislaw_Beksinski Atul_Kasbekar Dayanita_Singh Arjun_Mark Gautam_Rajadhyaksha)

  #Artist Notes:
  #Paul_Barson-oils, Nobuyoshi_Araki-anime, Yanjun_Cheng-oils, Piet_Hein_Eek-oils, Harold_Edgerton-anime, Bruce_Davidson-anime, Ernie_Barnes-cartoon, Walt_Disney-cartoon, Lise_Deharme-oils, Ilse_Bing-oils, Jody_Bergsma-oils, Jason_Edmiston-cartoon, Oalafur_Eliasson-oils, Noah_Bradley-oils, Dima_Dmitiev-oils, Maxfield_Parrish-oils, Terry_Moore-Cartoon, John_William_Waterhouse-oils, William_Adolphe_Bouguereau-oils
  artists=(Saturno_Butto Mike_Campau TJ_Drysdal Zdzislaw_Beksinski Andre_de_Dienes Luis_Royo)
else 
  artists=(${artists//,/ })
fi

if [[ "$promptNeedsConversions" = "false" ]] ; then
    echo "[WARNING] No prompt given. Using default."
  prompt="fantasy RPG a group of adventurers standing at a busy city portcullis gate"
fi

if [[ "$negativePromptNeedsConversions" = "false" ]] ; then
  echo "[WARNING] No negative prompt given. Using default."
  negative="((anime)), (bad art), (extra limbs), blurry, boring, sketch, (close up), lacklustre, repetitive, cropped, body out of frame, ((deformed)), (cross-eyed), (closed eyes), (bad anatomy), ugly, ((poorly drawn face)), child, baby"
fi

if [[ "$themesNeedConversions" = "false" ]] ; then
  echo "[WARNING] No themes given. Using default."
  themes="(hyperdetailed) intricate, 8k, intense, sharp focus, hyperrealism, DLSR, Photograph"
fi

echo "===================="
echo "[NOTICE] Prompt: \"$prompt\""
echo ""
echo "[NOTICE] Negative Prompt: \"$negative\""
echo ""
echo "[NOTICE] Artists: ${artists[@]}"
echo ""
echo "[NOTICE] Themes: $themes"
echo "===================="


## TODO for PC creator:
# gend=(male female male female androgynous)
# classes=(barbarian bard druid fighter rogue warlock wizard artificer)
# characters=(elf orc human human half-elf half-orc tiefling halfling anthropomorphic_lokharic_Draconic  gnome anthropomorphic_rabbit)


#used artist array
UsedArtists=()


for i in `seq 1 $TotalGenerateLoops`; do
  # randClass=${classes[$((RANDOM % ${#classes[@]}))]}
  # randCharc=${characters[$((RANDOM % ${#characters[@]}))]}
  # randGend=${gend[$((RANDOM % ${#gend[@]}))]}
  # randMood=${moods[$((RANDOM % ${#moods[@]}))]}
  # randDescription=${descripts[$((RANDOM % ${#descripts[@]}))]}

  ## TODO: Multiple Artists?
  artist=${artists[$((RANDOM % ${#artists[@]}))]}
  tempSeed=""
  needRestoreSeed="false"
  # Check if artist is in the UsedArtists array
  if [[ " ${UsedArtists[@]} " =~ " ${artist} " ]]; then
    # echo "[DEBUG] Duplicate artist found: $artist!"

    ##TODO: enforce at LEAST 1 occurence of artist:
    # if [[ $areAllArtistsUsed == "true" ]]; then
      tempSeed=$SeedNum
      SeedNum=$((RANDOM % 100000))
      needRestoreSeed="true"
    ##TODO: enforce at LEAST 1 occurence of artist:
    #  else 
    #   # loop through artists and determine if UsedArtists contains all of them
    #   for i in "${artists[@]}"; do
    #     if [[ " ${UsedArtists[@]} " =~ " ${i} " ]]; then
    #       areAllArtistsUsed="true"
    #     else
    #       areAllArtistsUsed="false"
    #       continue
    #     fi
    #   done

    # fi
  else 
    # If it isn't, then add it to the UsedArtists array
    UsedArtists+=($artist)
  fi



  header="python optimizedSD/optimized_txt2img.py --seed $SeedNum --ddim_steps $StepsNum --scale $GuidanceScale --H $IHeight --W $IWidth --prompt \""
  footer=", $themes\" --n_iter $iterations --negative_prompt \"$negative\" --n_samples 1"


  FromPromptStr=""
  if [ $isArtistPrecidence = FALSE ]; then
    # FromPromptStr="$randClass $randCharc $randGend $artist $randMood $randDescription"
    FromPromptStr="$prompt, by $artist"
  else
    # FromPromptStr="$artist $randClass $randCharc $randGend $randMood $randDescription"
    FromPromptStr="$artist $prompt"
  fi
  FromPromptStr=${FromPromptStr//_/ }

  CmdStr="$header$FromPromptStr$footer"

  echo "$CmdStr" >> $BATFile

  if [[ $needRestoreSeed == "true" ]]; then
    SeedNum=$tempSeed
  fi

done


#Summary of Prompt/
# cat Generate_FromPrompt_2022-10-07T17_33_34Z.bat | tr "\"" "\n" | tr "," "\n" | grep 40K | sort | uniq -c
#      33 Mike Campau Warhammer 40K Battle
#      42 Todd McFarlane Warhammer 40K Battle
#      45 Walt Disney Warhammer 40K Battle

