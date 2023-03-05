#!/bin/bash
#echo ' ________  ___  ___  ________  ________  _________   
#|\   ____\|\  \|\  \|\   __  \|\   ____\|\___   ___\ 
#\ \  \___|\ \  \\\  \ \  \|\  \ \  \___|\|___ \  \_| 
# \ \  \  __\ \   __  \ \  \\\  \ \_____  \   \ \  \  
#  \ \  \|\  \ \  \ \  \ \  \\\  \|____|\  \   \ \  \ 
#   \ \_______\ \__\ \__\ \_______\____\_\  \   \ \__\
#    \|_______|\|__|\|__|\|_______|\_________\   \|__|
#                                 \|_________|   '
python3 ../title.py

if [ ! -d "IMPRINTS" ]; then
  echo "No directory for Neural Imprints exists. Automatically creating..."
  mkdir "IMPRINTS"
  read -p "Name your new imprint: " imprint_name
  touch IMPRINTS/${imprint_name}.ni
  echo -n '[]' > IMPRINTS/${imprint_name}.ni
fi

menu(){
echo "---------------------------Available imprints:-------------------------"
ls IMPRINTS/*.ni | xargs -n 1 basename | sed -e 's/\.ni$//'
echo "-----------------------------------------------------------------------"

options=("Create a clean imprint" "Inject an imprint" "Wipe an imprint" "Exit" "Configure")
select opt in "${options[@]}"
do
    case $opt in
        "Create a clean imprint")
            read -p "Name your new imprint: " imprint_name
            touch IMPRINTS/${imprint_name}.ni
            echo -n '[]' > IMPRINTS/${imprint_name}.ni
            menu;;

        "Inject an imprint")
            read -p "Inject imprint: " imprint_name
            python3 ghost.py $imprint_name
            menu;;

        "Wipe an imprint")   
            read -p "Wipe imprint: " imprint_name
            rm IMPRINTS/${imprint_name}.ni
            menu
            ;;

        "Exit")
            exit
            ;;
        "Configure")
            python3 ../config.py
            menu
            ;;
        *) echo "invalid option $REPLY";;
    esac
done
}

menu


