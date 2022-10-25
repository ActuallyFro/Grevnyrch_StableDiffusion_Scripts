#!/bin/bash
DATE=$(date -u +"%Y-%m-%dT%H_%M_%SZ")
BATFile="Generate_TXT_PCs_$DATE.bat"

TotalGenerateLoops=120
StepsNum=42
GuidanceScale=4.77
iterations=4
Strength=0.5
batchSize=3
SeedNum=$((RANDOM % 100000))

promptNeedsConversions=FALSE
negativePromptNeedsConversions=FALSE

artistsNeedConversions=FALSE
isArtistPrecidence=FALSE
areAllArtistsUsed=FALSE
themesNeedConversions=FALSE
isSeedRandom=FALSE
isNPCSet=FALSE

scriptPath="optimizedSD/optimized_txt2img.py"

IHeight=768
IWidth=512

isArtistPrecidence=FALSE

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

    -p|--prompt)
      prompt="$2"
      promptNeedsConversions=TRUE
      shift # past argument
      shift # past value
      ;;

    -N | --NPC)
      isNPCSet=TRUE
      shift # past argument
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
      echo "  -b | --batchSize <batchSize>            Batch size for generation ($batchSize)"      
      echo "  -g | --guidance|--scale <scale>         Guidance scale. ($GuidanceScale)"
      echo "  -G | --strength <strength>              Guidance strength. ($Strength)"
      echo "  -i | --iterations <iterations>          Number of iterations. ($iterations)"
      echo "  -p | --prompt \"<prompt>\"                Prompt to use. "
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

if [ "$artistsNeedConversions" = "FALSE" ] ; then
  #Artists v1.1.1
  artists=(eve_arnold mika_asai Tom_Bagshaw Banksy John_T._Biggers Elsa_Bleda Charlie_Bowater Aleski_Briclot David_Burdeny Saturno_Butto Mike_Campau Elizabeth_Catlett Nathan_Coley Andre_de_Dienes Roy_DeCarava Gariele_Dell\'otto Mandy_Disher Dave_Dorman Natalia_Drepina TJ_Drysdale Lori_Earley Micheal_Eastman Les_Edwards Bob_Eggleton Greg_Rutkowski Andreas_Rocha Magali_Villeneuve Natalie_Shau Anna_Dittmann Pino_Daeni Huang_Guangjian Allyssa_Monks Luis_Royo Daniel_F_Gerhartz Thomas_Kinkade Zdzislaw_Beksinski Atul_Kasbekar Dayanita_Singh Arjun_Mark Gautam_Rajadhyaksha)

else 
  artists=(${artists//,/ })
fi

if [[ "$promptNeedsConversions" = "FALSE" ]] ; then
  echo "[WARNING] No prompt given. Using default."
  prompt="fantasy RPG, jungle, darkness, ((night)), stars, moon, stone altar-and-path looking down a menacing-creepy stone pit to the left, (((Chiaroscuro))), a geyser errupting in the distance, metal objects fused in thorns to the right, stone creature statues litered around the ground, blue-grey pulsating portal in the background"
fi

if [[ "$negativePromptNeedsConversions" = "FALSE" ]] ; then
  echo "[WARNING] No negative prompt given. Using default."
  negative="(cartoon), ((anime)), cad, (disfigured), (bad art), (extra limbs), blurry, boring, sketch, (close up), lacklustre, repetitive, cropped, body out of frame, ((deformed)), (cross-eyed), (closed eyes), (bad anatomy), ugly, ((poorly drawn face)), child, baby"
fi

if [[ "$themesNeedConversions" = "FALSE" ]] ; then
  echo "[WARNING] No themes given. Using default."
  themes="((full body)) portrait, fantasy RPG, (hyperdetailed) intricate, 8k, intense, sharp focus, two arms, two legs, (hyperdetailed) intricate, 8k, intense, sharp focus, hyperrealism, DLSR, Photograph"
fi

#Artists v1.1.1
artists=(eve_arnold mika_asai Tom_Bagshaw Banksy John_T._Biggers Elsa_Bleda Charlie_Bowater Aleski_Briclot David_Burdeny Saturno_Butto Mike_Campau Elizabeth_Catlett Nathan_Coley Andre_de_Dienes Roy_DeCarava Gariele_Dell\'otto Mandy_Disher Dave_Dorman Natalia_Drepina TJ_Drysdale Lori_Earley Micheal_Eastman Les_Edwards Bob_Eggleton Greg_Rutkowski Andreas_Rocha Magali_Villeneuve Natalie_Shau Anna_Dittmann Pino_Daeni Huang_Guangjian Allyssa_Monks Luis_Royo Daniel_F_Gerhartz Thomas_Kinkade Zdzislaw_Beksinski Atul_Kasbekar Dayanita_Singh Arjun_Mark Gautam_Rajadhyaksha)
#Paul_Barson-oils, Nobuyoshi_Araki-anime, Yanjun_Cheng-oils, Piet_Hein_Eek-oils, Harold_Edgerton-anime, Bruce_Davidson-anime, Ernie_Barnes-cartoon, Walt_Disney-cartoon, Lise_Deharme-oils, Ilse_Bing-oils, Jody_Bergsma-oils, Jason_Edmiston-cartoon, Oalafur_Eliasson-oils, Noah_Bradley-oils, Dima_Dmitiev-oils, Maxfield_Parrish-oils, Terry_Moore-Cartoon, John_William_Waterhouse-oils, William_Adolphe_Bouguereau-oils

### BANNED COPILOT WORD(S) IN HERE: ----v
moods=(scared angry happy sad smirking laughing crying surprised shocked disgusted sleeping poisioned drunk shocked amused lazy jealous reflective confused thoughtful flirty frustrated bored tired relaxed enraged excited giddy nervous gloomy hungry hyper guilty hangry carefree cantankerous grumpy mysterious naughty aloof callous cold confident)
#PG-13 WORDS: 

descripts=(Well-dressed Elegant Good-looking Pretty Handsome Beautiful Gorgeous Slim Bald Dimples Skinny Chubby Ugly Bearded Cute Overweight Muscular Albino Chiaroscuro)
#PG-13 WORDS: Curvy

### BANNED COPILOT WORD(S) IN HERE: -----^

gend=(male female male female androgynous)

classes=(barbarian bard druid fighter rogue warlock wizard artificer)

#Credit: https://negatherium.com/npc-generator/joblist.html
npcs=(Academic cartographer judge scholar scribe Aristocrat duke marquess count viscount baron greatchief warchief chief elder architect bricklayer carpenter mason plasterer roofer Clergy acolyte priest shaman alchemist armorer baker basket_weaver blacksmith bookbinder bowyer brewer butcher chandler cobbler cook glass_blower goldsmith instrument_maker inventor jeweler leatherworker locksmith painter potter rope_maker rug_maker sculptor ship_builder silversmith skinner tailor tanner toymaker weaponsmith weaver wheelwright woodcarver Criminal bandit burglar pickpocket pirate raider Entertainer acrobat bather jester minstrel prostitute storyteller Farmer crop_farmer gatherer herder Financier banker pawnbroker tax_collector fence_merchant Healer herbalist midwife Hosteler brothel_keeper innkeeper restaurantier tavern_keeper Laborer day_laborer miner porter Merchant beer_merchant bookseller caravanner dairy_seller fishmonger florist grain_merchant grocer haberdasher hay_merchant livestock_merchant military_outfitter miller peddler slaver spice_merchant tobacco_merchant used_clothier warehouser wine_merchant woodseller wool_merchant bounty_hunter city_guard private_guard mercenary soldier village_guard fisher hunter sailor trapper traveler Public_servant diplomat official politician town_crier Servant barber carriage_driver domestic_servant gardener groom guide inn_server launderer page rat_catcher restaurant_server slave tavern_server Unemployed beggar housespouse)

characters=(elf orc human human half-elf half-orc tiefling halfling anthropomorphic_Dragon  gnome anthropomorphic_rabbit)

echo "===================="
echo "[NOTICE] Prompt: \"<TBD>\""
echo ""
echo "[NOTICE] Negative Prompt: \"$negative\""
echo ""
echo "[NOTICE] Artists: ${artists[@]}"
echo ""
echo "[NOTICE] Themes: ${themes[@]}"
echo ""
echo "[NOTICE] Moods: ${moods[@]}"
echo ""
echo "[NOTICE] Descriptions: ${descripts[@]}"
echo ""
if [[ "$isNPCSet" = "TRUE" ]] ; then
  echo "[NOTICE] Classes: ${classes[@]}"
else
  echo "[NOTICE] NPCs: ${npcs[@]}"
fi
echo "===================="

UsedArtists=()

for i in `seq 1 $TotalGenerateLoops`; do
  artist=${artists[$((RANDOM % ${#artists[@]}))]}
  tempSeed=""
  needRestoreSeed="FALSE"

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


  header="python $scriptPath --seed $SeedNum --ddim_steps $StepsNum --scale $GuidanceScale --H $IHeight --W $IWidth --prompt \""
  footer=", $themes\" --n_iter $iterations --negative_prompt \"$negative\" --n_samples $batchSize"

# for i in `seq 1 $TotalToGenerate`; do
  randNPC=${npcs[$((RANDOM % ${#npcs[@]}))]}
  randClass=${classes[$((RANDOM % ${#classes[@]}))]}

  randCharc=${characters[$((RANDOM % ${#characters[@]}))]}
  randGend=${gend[$((RANDOM % ${#gend[@]}))]}
  randMood=${moods[$((RANDOM % ${#moods[@]}))]}
  randDescription=${descripts[$((RANDOM % ${#descripts[@]}))]}

  artist=${artists[$((RANDOM % ${#artists[@]}))]}

  PCStr=""
  if [ $isArtistPrecidence = "FALSE" ]; then
    if [ $isNPCSet = "TRUE" ]; then
      PCStr="$randNPC $randCharc $randGend, created by $artist $randMood $randDescription"
    else
      PCStr="$randClass $randCharc $randGend, created by $artist $randMood $randDescription"
    fi
  else
    if [ $isNPCSet = "TRUE" ]; then
      PCStr="Created by $artist, $randNPC $randCharc $randGend $randMood $randDescription"
    else
      PCStr="Created by $artist, $randClass $randCharc $randGend $randMood $randDescription"
    fi
    
  fi
  PCStr=${PCStr//_/ }

  CmdStr="$header$PCStr$footer"

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

