#!/bin/bash
DATE=$(date -u +"%Y-%m-%dT%H_%M_%SZ")
BATFile="Generate_TXT_Locations_$DATE.bat"

scriptPath="optimizedSD/optimized_txt2img.py"


TotalToGenerate=100
StepsNum=42
IHeight=512
IWidth=896

iterations=4
Strength=0.5
batchSize=3
SeedNum=$((1 + RANDOM % 1000000))

# promptNeedsConversions=false
negativePromptNeedsConversions=false


artistsNeedConversions=false
isArtistPrecidence=false
areAllArtistsUsed=false

themesNeedConversions=false
isSeedRandom=false

GuidanceScale=6.13

while [[ $# -gt 0 ]]; do
  key="$1"

  case $key in
    -a | --artists)
      artists=""
      artists="$2"
      # artists=("$2")
      echo "[DEBUG] Passed artists: $artists"
      artistsNeedConversions=true
      shift # past argument
      shift # past value
      ;;

    -A | --artistPrecidence)
      isArtistPrecidence=true
      shift # past argument
      ;;

    -b | --batchSize)
      batchSize="$2"
      shift # past argument
      shift # past value
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

    -N | --NPC)
      isNPCSet=true
      shift # past argument
      ;;

    -n|--negative_prompt)
      negative="$2"
      negativePromptNeedsConversions=true
      shift # past argument
      shift # past value
      ;;

    -t|--themes)
      themes="$2"
      themesNeedConversions=true
      shift # past argument
      shift # past value
      ;;

    -R | --random)
      SeedNum=$((1 + RANDOM % 1000000))
      isSeedRandom=true
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
      echo "  -b | --batchSize <batchSize>            Batch size for generation ($batchSize)"
      # echo "  -B | --Basic                            Use basic characters"
      echo "  -g | --guidance|--scale <scale>         Guidance scale. ($GuidanceScale)"
      # echo "  -G | --strength <strength>              Guidance strength. ($Strength)"
      echo "  -i | --iterations <iterations>          Number of iterations. ($iterations)"
      # echo "  -p | --prompt \"<prompt>\"                Prompt to use. " --- is auto-generated
      echo "  -N | --NPC                              Use NPC list over PC list"
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
      # echo ""
      # echo "Default Prompt: \"$prompt\""
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

  #Artist Notes:
  #Paul_Barson-oils, Nobuyoshi_Araki-anime, Yanjun_Cheng-oils, Piet_Hein_Eek-oils, Harold_Edgerton-anime, Bruce_Davidson-anime, Ernie_Barnes-cartoon, Walt_Disney-cartoon, Lise_Deharme-oils, Ilse_Bing-oils, Jody_Bergsma-oils, Jason_Edmiston-cartoon, Oalafur_Eliasson-oils, Noah_Bradley-oils, Dima_Dmitiev-oils, Maxfield_Parrish-oils, Terry_Moore-Cartoon, John_William_Waterhouse-oils, William_Adolphe_Bouguereau-oils
  # artists=(Saturno_Butto Mike_Campau TJ_Drysdal Zdzislaw_Beksinski Andre_de_Dienes Luis_Royo)
else 
  artists=(${artists//,/ })
fi

if [[ "$negativePromptNeedsConversions" = "false" ]] ; then
  echo "[WARNING] No negative prompt given. Using default."
  negative="((anime)), (bad art), sketch, (close up), lacklustre, repetitive, cartoon, anime, boring, cropped, (mutation), ((HUD)), ((video game)), dull, vague, (blurry), distorted, framed"
fi

if [[ "$themesNeedConversions" = "false" ]] ; then
  echo "[WARNING] No themes given. Using default."
  themes="(hyperdetailed) intricate, 8k, intense, sharp focus, hyperrealism, DLSR, Photograph"
fi

echo "===================="
# echo "[NOTICE] Prompt: \"$prompt\""
# echo ""
echo "[NOTICE] Negative Prompt: \"$negative\""
echo ""
echo "[NOTICE] Artists: ${artists[@]}"
echo ""
echo "[NOTICE] Themes: $themes"
echo "===================="

locations=(City_Street back_alley city_sewers bazaar city_overlook city_square tavern tailor blacksmith inn guildhall gemcutter Alchemist_Shop Bookstore Leather_Worker_Shop General_Store Apothecary_Shop)
timeOfDay=(morning mid-day night afternoon twilight high-noon sunset dawn)
features_outdoors=(foggy rainy snowy blue-glow red-glow green-glow orange-glow yellow-glow purple-glow clear hdr cloudy_skies clear_skies stormy_skies thunderstorm aurora_borealis stars)
addins_outdoors=(people animals monsters crowd city-guard bandits guards necromancers wizards marauders priests thieves clergy)

features_indoors=(empty busy crowded dimly_lit brightly_lit darkly_lit blue-glow red-glow green-glow orange-glow yellow-glow purple-glow smokey)
addins_indoors=(people clerks workers crowd cityguard bandit adventurers)

UsedArtists=()

for i in `seq 1 $TotalToGenerate`; do
  # echo "[DEBUG] Loop: $i / $TotalToGenerate]"
  PreString=""
  ExtraString=""
  addChoice=""
  isOutdoors=true
  feature=""
  

  ## TODO: Multiple Artists?
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

  if [ "$isSeedRandom" = true ] ; then
    SeedNum=$((1 + RANDOM % 1000000)) 
  fi

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

  LocationStr="$PreString $location at $currentTime, $feature$ExtraString"
  LocationStr=${LocationStr//_/ }
  
  header="python $scriptPath --seed $SeedNum --ddim_steps $StepsNum --scale $GuidanceScale --H $IHeight --W $IWidth --prompt \""

  fantasyTag=""
  if [ $((RANDOM % 2)) -eq 0 ]; then
    fantasyTag="Fantasy RPG"
  else
    fantasyTag="Dark Fantasy RPG"
  fi

  footer=", (($fantasyTag)), $themes\" --n_iter $iterations --negative_prompt \"$negative\" --n_samples $batchSize"

  LocationPromptStr=""
  if [ $isArtistPrecidence = false ]; then
    LocationPromptStr="$LocationStr, created by $artist"
  else
    LocationPromptStr="Created by $artist,$LocationStr"
  fi
  LocationPromptStr=${LocationPromptStr//_/ }

  CmdStr="$header$LocationPromptStr$footer"

  echo "$CmdStr" >> $BATFile
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

