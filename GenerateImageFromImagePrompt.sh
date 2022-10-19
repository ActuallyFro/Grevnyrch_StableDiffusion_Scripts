#!/bin/bash
#less than or equal to 1
if [ "$#" -le 1 ]; then
  echo "[ERROR] No arguments supplied! (need at least \$prompt \$image-file)"
  echo "Run with --help"
  exit 1
fi

passedArgsTotal=$#
argOne=$1
argTwo=$2

DATE=$(date -u +"%Y-%m-%dT%H_%M_%SZ")
BATFile="Generate_IMG_$DATE.bat"

TotalGenerateLoops=120
# StepsNum=50
StepsNum=42
# SeedNum=$((1 + RANDOM % 1000000))
GuidanceScale=25.0
iterations=4
Strength=0.5

promptNeedsConversions=false
negativePromptNeedsConversions=false

artistsNeedConversions=false
isArtistPrecidence=FALSE
areAllArtistsUsed=FALSE
# useCUDAModel=FALSE
themesNeedConversions=false
imageFileNeedsConversions=false
isSeedRandom=FALSE

scriptPath="optimizedSD/optimized_img2img.py"

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

    -G|--strength)
      Strength="$2"
      shift # past argument
      shift # past value
      ;;

    -i | --iterations)
      iterations="$2"
      shift # past argument
      shift # past value
      ;;

    -I | --image)
      imgFile="$2"
      imageFileNeedsConversions=true
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

    -R | --random)
      SeedNum=$((1 + RANDOM % 1000000))
      isSeedRandom=TRUE
      shift # past argument
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

    -h|--help)
      echo "GenerateFromPromptBat.sh [options]"
      echo "  -a | --artists <artists>                List of artists to use"
      echo "  -A | --artistPrecidence                 Use artist precidence before prompt ($isArtistPrecidence)"
      echo "  -g | --guidance|--scale <scale>         Guidance scale. ($GuidanceScale)"
      echo "  -G | --strength <strength>              Guidance strength. ($Strength)"
      echo "  -i | --iterations <iterations>          Number of iterations. ($iterations)"
      echo "  -I | --image <image>                    Image file to use."
      echo "  -p | --prompt \"<prompt>\"                Prompt to use. "
      echo "  -n | --negative_prompt \"<negative>\"     Negative prompt to use."
      echo "  -R | --random                           Randomize the seed."
      echo "  -s | --steps <steps>                    Number of steps to take. ($StepsNum)"
      echo "  -S | --seed <seed>                      Seed number. (Random)"
      echo "  -t | --themes <themes>                  List of themes to use."
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
  artists=(eve_arnold mika_asai Tom_Bagshaw Banksy John_T._Biggers Elsa_Bleda Charlie_Bowater Aleski_Briclot David_Burdeny Saturno_Butto Mike_Campau Elizabeth_Catlett Nathan_Coley Andre_de_Dienes Roy_DeCarava Gariele_Dell\'otto Mandy_Disher Dave_Dorman Natalia_Drepina TJ_Drysdale Lori_Earley Micheal_Eastman Les_Edwards Bob_Eggleton Greg_Rutkowski Andreas_Rocha Magali_Villeneuve Natalie_Shau Anna_Dittmann Pino_Daeni Huang_Guangjian Allyssa_Monks Luis_Royo Daniel_F_Gerhartz Thomas_Kinkade Zdzislaw_Beksinski Atul_Kasbekar Dayanita_Singh Arjun_Mark Gautam_Rajadhyaksha)

else 
  artists=(${artists//,/ })
fi

if [[ "$promptNeedsConversions" = "false" ]] ; then
  echo "[WARNING] No prompt given. Using default."
  prompt="fantasy RPG, jungle, darkness, ((night)), stars, moon, stone altar-and-path looking down a menacing-creepy stone pit to the left, (((Chiaroscuro))), a geyser errupting in the distance, metal objects fused in thorns to the right, stone creature statues litered around the ground, blue-grey pulsating portal in the background"
fi

if [[ "$negativePromptNeedsConversions" = "false" ]] ; then
  echo "[WARNING] No negative prompt given. Using default."
  # negative="((anime)), (bad art), (extra limbs), blurry, boring, sketch, (close up), lacklustre, repetitive, cropped, body out of frame, ((deformed)), (cross-eyed), (closed eyes), (bad anatomy), ugly, ((poorly drawn face)), child, baby"
  negative="((anime)), (bad art), ((cartoon)), blurry, boring, sketch, lackluster"
fi

if [[ "$themesNeedConversions" = "false" ]] ; then
  echo "[WARNING] No themes given. Using default."
  themes="(hyperdetailed) intricate, 8k, intense, sharp focus, hyperrealism, DLSR, Photograph"
fi

if [[ "$imageFileNeedsConversions" = "false" ]] ; then
  echo "[WARNING] No image file given. Using default."
  imgFile="Init-Image.png"
fi
 
if [ $passedArgsTotal -eq 2 ]; then
  promptStr="$1"
  imgFile="$2"
  promptNeedsConversions=true
  negativePromptNeedsConversions=true
  prompt="$argOne"
  echo "[DEBUG] Passed prompt: $prompt"
  imgFile="$argTwo"
  echo "[DEBUG] Passed image: $imgFile"
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

UsedArtists=()

for i in `seq 1 $TotalGenerateLoops`; do
  artist=${artists[$((RANDOM % ${#artists[@]}))]}
  tempSeed=""
  needRestoreSeed="false"

  if [[ " ${UsedArtists[@]} " =~ " ${artist} " ]]; then
      tempSeed=$SeedNum
      SeedNum=$((RANDOM % 100000))
      needRestoreSeed="true"
  else 
    UsedArtists+=($artist)
  fi

  if [ "$isSeedRandom" = TRUE ] ; then
    SeedNum=$((1 + RANDOM % 1000000)) 
    # echo "[NOTICE] Randomizing seed."
  fi


  header="python $scriptPath --seed $SeedNum --ddim_steps $StepsNum --scale $GuidanceScale --prompt \""
  footer=", $themes\" --n_iter $iterations --negative_prompt \"$negative\" --n_samples 1  --strength $Strength --init-img $imgFile"

  ImgPromptStr=""
  if [ $isArtistPrecidence = FALSE ]; then
    ImgPromptStr="$prompt, created by $artist"
  else
    ImgPromptStr="Created by $artist, $prompt"
  fi
  ImgPromptStr=${ImgPromptStr//_/ }

  CmdStr="$header$ImgPromptStr$footer"

  echo "$CmdStr" >> $BATFile

  if [[ $needRestoreSeed == "true" ]]; then
    SeedNum=$tempSeed
  fi

done

#Summary of Prompt by Artist
echo "=-----------------------="
echo "Summary of Prompt by Artist:"
echo ""
for i in "${artists[@]}"; do
  tempArtistName=${i//_/ }
  count=$(cat $BATFile | grep "$tempArtistName" | wc -l)
  echo "$i: $count"
done
echo "=-----------------------="

echo ""
echo "[FIN] see $BATFile for commands"

