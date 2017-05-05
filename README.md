# AssistantPi

AssistantPi is basically a tweak of [AlexaPi](https://github.com/alexa-pi/AlexaPi), allowing you to run **Google Assistant** and Amazon's Alexa on a Raspberry Pi.
I piggy-backed AlexaPi's Installer to easily get the [Google Assistant SDK](https://github.com/googlesamples/assistant-sdk-python) ready on your device and utilize it's Hotword recognition to tap into Google's sample CLI interface.

This is just an experimental proof-of-concept without broad support. 

Further Resources:
- [AlexaPi on Github](https://github.com/alexa-pi/AlexaPi)
- [AlexaPi Installation Guide](https://github.com/alexa-pi/AlexaPi/wiki/Installation)
- [Google Assistant SDK on Github](https://github.com/googlesamples/assistant-sdk-python)
- [Google Assistant SDK Getting Started Guide](https://developers.google.com/assistant/sdk/prototype/getting-started-pi-python)

## Requirements

You will need:

1. A Raspberry Pi and an SD Card with a fresh install of Raspbian
2. Audio peripherals:
    - external speaker with 3.5mm Jack
    - USB microphone

## Installation

- Have your Raspberry Pi running Raspbian ready and connected to the Internet. I recommend to use a fresh install of *Raspbian Jessie Lite* without Pixel.
- Follow this [Google Guide](https://developers.google.com/assistant/sdk/prototype/getting-started-pi-python/config-dev-project-and-account) and place the Google Assistant Credentials JSON in 
	```
    /home/pi/Downloads/client_secret.json
    ```
- Prepare Amazon AVS Credentials as described in [Step 1 in AlexaPi Installation Guide](https://github.com/alexa-pi/AlexaPi/wiki/Installation), you'll need them during Installation. Even if you only want Google Assistant, this has to be done for AlexaPi to work properly.
- Connect your audio peripherals (i.e. USB-Mic and Speaker via Jack).
- Clone this repository to /opt directory (important, it will fail otherwise).
	```
    cd /opt
	sudo git clone https://github.com/xtools-at/AlexaPi.git
    ```
- Run the setup and go through all the steps:
	```
    sudo /opt/AlexaPi/src/scripts/setup.sh
    ```
- If Authentication with Google Assistant API fails during setup, try it manually running
	```
    /opt/AlexaPi/env/bin/python -m googlesamples.assistant.auth_helpers --client-secrets /home/pi/Downloads/client_secret.json
    ```


## Audio problems

If you're using HDMI, make sure to go to
```
sudo raspi-config
```
then *Advanced Options > Audio* and set the desired output (i.e. HDMI or 3.5mm Jack).

Please refer to the following guides if you encounter any audio problems:

[Configure Google Assistant Audio Output](https://developers.google.com/assistant/sdk/prototype/getting-started-pi-python/configure-audio)

[AlexaPi Audio Setup and Debugging](https://github.com/alexa-pi/AlexaPi/wiki/Audio-setup-&-debugging)

## Change Hotwords
To change the hotwords (currently Alexa and Google), change both these files before running the setup:

```
.../src/config.yaml 
```
    
(--> *phrase* and *phrase_assistant*) and
    
```
.../src/keyphrase.list
```
In the latter, you can also tweak the sensitivity of the hotword recognition. See [here for more information on this topic](http://cmusphinx.sourceforge.net/wiki/faq#qhow_to_implement_hot_word_listening).
