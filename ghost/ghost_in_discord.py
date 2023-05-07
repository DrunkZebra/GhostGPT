import discord
import openai
import ghost
intents = discord.Intents(messages=True, message_content = True)
client = discord.Client(command_prefix='!',intents=intents)

imp = ghost.imprint.get()
openai.api_key = imp.config["OPENAI_KEY"]
@client.event
async def on_message(message):
    if message.content.startswith("!ghost"):
        msg = message.content[6:]
        if msg == "eject":
            exit()
        else:
            await message.channel.send(imp.chat(msg))
try:
    client.run(imp.config["DISCORD_TOKEN"])
except KeyError:
    print("No Discord key has been set!")