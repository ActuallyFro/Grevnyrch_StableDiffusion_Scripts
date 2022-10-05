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

isArtistPrecidence=FALSE

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
footer=", ((full body)) portrait, fantasy RPG, (hyperdetailed) intricate, 8k, intense, sharp focus, two arms, two legs\" --n_iter 5 --negative_prompt \"(cartoon), ((anime)), cad, (disfigured), (bad art), (extra limbs), blurry, boring, sketch, (close up), lacklustre, repetitive, cropped, body out of frame, ((deformed)), (cross-eyed), (closed eyes), (bad anatomy), ugly, ((poorly drawn face)), child, baby\" --n_samples 1$UsePLMSModel"
 
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

characters=(elf orc human human half-elf half-orc tiefling halfling anthropomorphic_lokharic_Draconic  gnome anthropomorphic_rabbit)

for i in `seq 1 $TotalToGenerate`; do
  randClass=${classes[$((RANDOM % ${#classes[@]}))]}
  randCharc=${characters[$((RANDOM % ${#characters[@]}))]}
  randGend=${gend[$((RANDOM % ${#gend[@]}))]}
  randMood=${moods[$((RANDOM % ${#moods[@]}))]}
  randDescription=${descripts[$((RANDOM % ${#descripts[@]}))]}


  artist=${artists[$((RANDOM % ${#artists[@]}))]}

  PCStr=""
  if [ $isArtistPrecidence = FALSE ]; then
    PCStr="$randClass $randCharc $randGend $artist $randMood $randDescription"
  else
    PCStr="$artist $randClass $randCharc $randGend $randMood $randDescription"
  fi
  PCStr=${PCStr//_/ }

  CmdStr="$header$PCStr$footer"

  echo "$CmdStr" >> $BATFile
done



