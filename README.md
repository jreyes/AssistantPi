# AssistantPi

AssistantPi is basically a tweak of [AlexaPi](https://github.com/alexa-pi/AlexaPi) allowing you to run **Google Assistant** and **Amazon's Alexa** on a Raspberry Pi. It includes the [Google Assistant SDK](https://github.com/googlesamples/assistant-sdk-python) and uses AlexaPi's hotword recognition to activate either Assistant or Alexa. The installer provides an easy way to get everything set up in just under an hour.

This is just an experimental proof-of-concept without broad support.

Credits / Further Resources:
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
- Follow this [Google Guide](https://developers.google.com/assistant/sdk/prototype/getting-started-pi-python/config-dev-project-and-account) and place the Google Assistant Credentials JSON in `/home/pi/Downloads/client_secret.json`
- Prepare Amazon AVS Credentials as described in [Step 1 in AlexaPi Installation Guide](https://github.com/alexa-pi/AlexaPi/wiki/Installation), you'll need them during Installation. Even if you only want Google Assistant, this has to be done for AlexaPi to work properly.
- Connect your audio peripherals (i.e. USB-Mic and Speaker via Jack).
- Clone this repository to `/opt` directory and rename the folder to *AlexaPi* (both important, it will fail otherwise):
	```
    cd /opt
	sudo git clone https://github.com/xtools-at/AssistantPi.git AlexaPi
    ```
- Run the setup and go through all the steps. This will take a while, approx. 25min with a somewhat good Internet connection.
	```
    sudo /opt/AlexaPi/src/scripts/setup.sh
    ```
- If Authentication with Google Assistant API fails during setup, try to run it manually:
	```
    /opt/AlexaPi/env/bin/python -m googlesamples.assistant.auth_helpers --client-secrets /home/pi/Downloads/client_secret.json
    ```
- If you haven't opted for starting AssistantPi at boot, or the Installer threw an error during setup, start the script manually using `python /opt/AlexaPi/src/main.py`. Otherwise, it will be started automatically when the setup finishes.
- Trigger Assistant and Alexa with the hotwords *Google* and *Alexa*


## Audio problems

Make sure you've been to `sudo raspi-config`, *Advanced Options > Audio* and have set the desired audio output (i.e. 3.5mm Jack, not HDMI).

Please refer to the following guides if you encounter any audio problems:

[Configure Google Assistant Audio Output](https://developers.google.com/assistant/sdk/prototype/getting-started-pi-python/configure-audio)

[AlexaPi Audio Setup and Debugging](https://github.com/alexa-pi/AlexaPi/wiki/Audio-setup-&-debugging)


## Change Hotwords

To change the hotwords (currently Alexa and Google), change both these files before running the setup:

```
.../src/config.template.yaml 
```
    
(*phrase* and *phrase_assistant*) and
    
```
.../src/keyphrase.list
```
In the latter, you can also tweak the sensitivity of the hotword recognition. See [here for more information on this topic](http://cmusphinx.sourceforge.net/wiki/faq#qhow_to_implement_hot_word_listening).


## Change Hotword language

If you want to change the language for the hotword recognition (which might be necessary if your hotwords aren't recognized well), head over to [CMU Sphinx download](https://sourceforge.net/projects/cmusphinx/files/Acoustic%20and%20Language%20Models/) page and get the model files for your language.
In particular, you have to place the following files
- FILENAME.lm.bin
- FILENAME.dic
in `/usr/local/lib/python2.7/dist-packages/pocketsphinx/model/` and the contents of
- FILENAME.tar.gz
in `/usr/local/lib/python2.7/dist-packages/pocketsphinx/model/[lng-lng]` (where [lng-lng] is the language code of your imported language, e.g. 'de-de')

Afterwards, either
- change `/opt/AlexaPi/src/config.template.yaml`
..- find `language` and `dictionary` attributes in `pocketsphinx` configuration
..- change *language* to your language code (e.g. 'de-de', see above)
..- change *dictionary* to your FILENAME.dic (e.g. 'cmusphinx-voxforge-de.dic')
- run the Installer and create a new AlexaPi Profile

**OR**
- change `/etc/opt/AlexaPi/config.yaml` the same way as above

### Install German language package

For **German**, there's an language package coming with AssistantPi. During the installation steps, just after you've cloned the repository:
```
cd /opt
sudo git clone https://github.com/xtools-at/AssistantPi.git AlexaPi
```
- Change the branch to include the German language package and get the edited `config.yaml`:
```
sudo git checkout feature/german
```
- Install the language package, running as root (or copy the files in .../src/german manually as described above):
```
sudo bash /opt/AlexaPi/src/german/install.sh
```
- Proceed with Setup as above in the Installation instructions (i.e. run the AssistantPi installer script)
