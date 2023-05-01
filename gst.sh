#!/bin/bash
create_imprint(){
    read -p "Name your new imprint: " imprint_name
    if [ ${#imprint_name} != 0 ]; then
        touch IMPRINTS/${imprint_name}.ni
        echo -n '[]' > IMPRINTS/${imprint_name}.ni
    fi
}
if [ ! -d "IMPRINTS" ]; then
  echo "No directory for Neural Imprints exists. Automatically creating..."
  mkdir "IMPRINTS"
  create_imprint
fi

choose_platform(){
    SCRIPT=${DEFAULT_SCRIPT-0}
    if [ $SCRIPT == 0 ]; then
        echo "Inject to platform:"
        options=("Shell" "Telegram" "Discord" "Back" )

        select opt in "${options[@]}"
        do
            case $opt in
                "Shell")
                    read -p "[Inject] imprint: " imprint_name
                    python3 ghost_in_shell.py $imprint_name $FORGET
                    refresh
                    ;;

                "Telegram")
                    read -p "[Inject] imprint: " imprint_name
                    python3 ghost_in_telegram.py $imprint_name $FORGET > /dev/null &
                    refresh
                    ;;
                "Discord")
                    read -p "[Inject] imprint: " imprint_name
                    python3 ghost_in_discord.py $imprint_name $FORGET > /dev/null & 
                    refresh
                    ;;
                "Back")
                    refresh
                    ;;
                *) echo "invalid option $REPLY";;
            esac
        done
    else case $SCRIPT in
        1)
            read -p "[Inject] imprint: " imprint_name
            python3 ghost_in_shell.py $imprint_name $FORGET
            refresh
            ;;

        2)
            read -p "[Inject] imprint: " imprint_name
            python3 ghost_in_telegram.py $imprint_name $FORGET > /dev/null &
            refresh
            ;;
        3)
            read -p "[Inject] imprint: " imprint_name
            python3 ghost_in_discord.py $imprint_name $FORGET > /dev/null & 
            refresh
            ;;
    esac

    fi

}
refresh(){
    clear
    if [ ! -e config/config.json ];
    then echo -e "##############|First-Timer? Start with the \033[38;5;33m[Config]\033[0m option|##############"
    fi
    python3 logo.py
    python3 config.py print_options
    menu
}
config(){
    options=("[Install] Required Libs" "[Config] Keys" "[Back]" )
    echo -e "\033[38;5;33mGhost Version Beta 6.0\033[0m"
    select opt in "${options[@]}"
        do
            case $opt in
                "[Install] Required Libs")
                    pip install -r requirements.txt --upgrade
                    echo -e "\033[38;5;33m done.\033[0m - if no error, you are good"
                    config
                    ;;

                "[Config] Keys")
                    python3 config/config.py config
                    config
                    ;;

                "[Back]")
                    refresh
                    ;;

                *) echo "invalid option $REPLY";;
            esac
        done
    }

menu(){
options=("[Inject] an imprint" "[Train] an imprint" "[Ignore] default script" "[Wipe] an imprint" "[Config]" "[Exit]" )
select opt in "${options[@]}"
do
    case $opt in
        "[Train] an imprint")
            FORGET=False
            choose_platform
            ;;

        "[Inject] an imprint")
            FORGET=True
            choose_platform
            ;;
        "[Ignore] default script")
            DEFAULT_SCRIPT=0
            refresh
            ;;
        "[Wipe] an imprint")   
            read -p "Wipe imprint: " imprint_name
            rm IMPRINTS/${imprint_name}.ni
            refresh
            ;;
        "[Config]")
            config
            ;;
        "[Exit]")
            exit
            ;;
        *) echo "invalid option $REPLY";;


    esac
done
}
python config.py "get_default_script"
DEFAULT_SCRIPT=$?
echo $DEFAULT_SCRIPT
refresh