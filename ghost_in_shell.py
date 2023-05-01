from ghost import imprint
import openai
imp = imprint.get()
try:
    openai.api_key = imp.config["OPENAI_KEY"]
except KeyError:
    print("No API key found! Run the [Config] option.")
    exit()
usr_input=input('\033[38;5;33m' +"YOU"+ '\033[0;0m: ')
while (usr_input!="eject"): 
    if(usr_input=="delete"):
        imp.delete()
    else:
        try:
            imp.chat(usr_input)
        except Exception as e:
            print(e)
    usr_input=input('\033[38;5;33m' +"YOU"+ '\033[0;0m: ')