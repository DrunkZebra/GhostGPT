import os
import sys
import json
import utils

config_path = 'ghost' + os.sep + 'config.json'

command = sys.argv[1]

def config_keys(): 

    has_config = False
    old_config = {}
    #Get old options.
    try:
        with open (config_path) as config:
            old_config = json.load(config)
            has_config = True
    except FileNotFoundError:
        pass
    except json.decoder.JSONDecodeError:
        pass
    if (not has_config):
        os.system("pip install -r requirements.txt --upgrade > /dev/null")
        utils.blue_print('Installed required libraries. If no error, you are good')


    new_config = {}
    utils.blue_print("Press the 'return' or 'enter' key to skip a preference.\nEnter 'delete' to remove data.\n" )
    with open (config_path, 'w') as config:
        for option in utils.options:
            field = option[0]
            is_filled = False
            try:
                #See if field has been previously filled.
                old_val = old_config[option[0]]
                is_filled = True
            except KeyError:
                pass

            if not is_filled:
                #New value not in config file.
                opt = utils.prompt_key("INPUT NEW: ", option)

                if opt == "" or opt.lower() == "delete" or opt=="none" :
                    if opt == "none":
                        print("Preference set to none.\n")
                    else:
                        print("Value ignored.\n")
                else:
                    new_config[option[0]] = opt
                    print("New value registered!\n")
            else:
                #Value previously in config file.
                print("PREV VALUE: " + old_config[field])
                #opt = input("UPDATE " + option +  ": " )
                opt = utils.prompt_key("UPDATE: ", option)

                if opt == 'delete' or opt=="none":
                    #Field to not be included.
                    if opt=='delete':
                        print("Field deleted.\n")
                    else:
                        print("Preference set to none.\n")
                elif opt != "":
                    #Value updated.
                    new_config[field] = opt
                    print("Change successful!\n")
                else:
                    #No change wanted.
                    new_config[field] = old_config[field]
                    print("No change made.\n")
        json.dump(new_config, config, indent=6)
    os.chmod(config_path, 0o600)       

def print_options():

    try:
        with open (config_path) as config:
            config_dict = json.load(config)
            utils.fill_options_table(config_dict)
            utils.options_table_print()
    except (FileNotFoundError, json.decoder.JSONDecodeError):
        print("No config file found!")
        print(os.listdir())
        pass

def get_config():
    with open (config_path) as config:
        config_dict = json.load(config)
    return config_dict


def get_default_script():
    config = get_config()
    d = (config["DEFAULT_SCRIPT"])
    default = 0
    if d == "Shell":
        default = 1
    elif d == "Telegram":
        default = 2
    elif d == "Discord":
        default = 3
    sys.exit(default)

if command=="config":
        config_keys()
elif command=="print_options":
        print_options()
elif command == "get_default_script":
        get_default_script()