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

1. A Raspberry Pi and an SD Card with a fresh install of [Raspbian Jessie Lite](https://www.raspberrypi.org/downloads/raspbian/)
2. Audio peripherals:
    - external speaker with 3.5mm Jack
    - USB microphone


## Installation

- Have your Raspberry Pi running Raspbian ready and connected to the Internet. Use a fresh install of *Raspbian Jessie Lite* without Pixel.
- Follow this [Google Guide](https://developers.google.com/assistant/sdk/prototype/getting-started-pi-python/config-dev-project-and-account) and place the Google Assistant Credentials JSON in `/home/pi/Downloads/client_secret.json`
- Prepare Amazon AVS Credentials as described in [Step 1 of AlexaPi Installation Guide](https://github.com/alexa-pi/AlexaPi/wiki/Installation), you'll need them during Installation. Even if you only want Google Assistant, this has to be done for AlexaPi to work properly.
- Connect your audio peripherals (i.e. USB-Mic and Speaker via Jack).
- Clone this repository to `/opt` directory and rename the folder to *AlexaPi* (both important, it will fail otherwise). These commands will do that for you:
```
cd /opt
sudo git clone https://github.com/xtools-at/AssistantPi.git AlexaPi
```
- Run the setup and go through all the steps. This will take a while, approx. 35min with a somewhat good Internet connection.
```
sudo /opt/AlexaPi/src/scripts/setup.sh
```
- If Authentication with Google Assistant API fails during setup, try to run it manually with `sudo bash /opt/AlexaPi/src/scripts/auth_assistant.sh`
- If Google Assistant setup crashes, do what the Error message says and restart with `sudo bash /opt/AlexaPi/src/scripts/install_assistant.sh`
- Proceed with [Step 3 of AlexaPi Installation Guide](https://github.com/alexa-pi/AlexaPi/wiki/Installation).
- Make sure to check [Configure Google Assistant Audio Output](https://developers.google.com/assistant/sdk/prototype/getting-started-pi-python/configure-audio) too. The config file is already in place for you (`/home/pi/.asoundrc` and `/var/lib/AlexaPi/.asoundrc` for the bootup-service), but you might have to adjust the *card*- and *device*-ids according to the output of `aplay -l && arecord -l` on your Pi.
- Trigger Assistant and Alexa with the hotwords *Google* and *Alexa*.


## Updating

Bringing your AssistantPi up-to-date is just one command away:
```
sudo bash /opt/AlexaPi/src/scripts/update.sh
```
This updates both AssistantPi and the [tweaked Assistant SDK](https://github.com/xtools-at/assistant-sdk-python) without having you to go through the installation process again.

### Important Notice: If installed before May 13th 2017 for the first time, please run the setup again after the update and do the Authentication with both Google and Amazon again.


## Audio Settings

Make sure you've been to `sudo raspi-config`, *Advanced Options > Audio* and have set the desired audio output (i.e. 3.5mm Jack, not HDMI).

The base audio config is done for you in the setup for both AlexaPi and Assistant. However, if encountering any audio issues in playback or recording, make sure to check by here:
- [Configure Google Assistant Audio Output](https://developers.google.com/assistant/sdk/prototype/getting-started-pi-python/configure-audio)
- [AlexaPi Audio Setup and Debugging](https://github.com/alexa-pi/AlexaPi/wiki/Audio-setup-&-debugging)
- [AlexaPi Wiki](https://github.com/alexa-pi/AlexaPi/wiki/)

If Google Assistant audio output is choppy or truncated, check the following. Make sure to run `source /opt/AlexaPi/env/bin/activate` before running the samples there, to target AssistantPi's Python environment.
- [Google Assistant Audio Troubleshooting](https://developers.google.com/assistant/sdk/prototype/getting-started-pi-python/troubleshooting#audio-issues)

You can set the values for the Block- and Flush size in the AssistantPi config, either before Installation in `/opt/AlexaPi/src/config.template.yaml` or afterwards in `/etc/opt/AlexaPi/config.yaml`. Go find the attribute `sound > assistant` and use your values for `block_size` and `flush_size`.



## Change Hotwords

To change the hotwords (currently Alexa and Google), change both these files before running the setup:

`.../src/config.template.yaml` (*phrase* and *phrase_assistant*) and `.../src/keyphrase.list`

In the latter, you can also tweak the sensitivity of the hotword recognition. See [here for more information on this topic](http://cmusphinx.sourceforge.net/wiki/faq#qhow_to_implement_hot_word_listening).

Also make sure that your new hotwords are included in the language model. Check the following directory for a file with `.dict` or `.dic` extension and add your hotwords if not already there: `/usr/local/lib/python2.7/dist-packages/pocketsphinx/model/`


## Change Hotword language

If you want to change the language for the hotword recognition (which might be necessary if your hotwords aren't recognized well), head over to [CMU Sphinx download](https://sourceforge.net/projects/cmusphinx/files/Acoustic%20and%20Language%20Models/) page and get the model files for your language.
In particular, you have to place the following files
- FILENAME.lm.bin
- FILENAME.dic

in `/usr/local/lib/python2.7/dist-packages/pocketsphinx/model/` and the contents of

- FILENAME.tar.gz

in `/usr/local/lib/python2.7/dist-packages/pocketsphinx/model/[lng-lng]` (where [lng-lng] is the language code of your imported language, e.g. 'de-de')

Make sure, that `FILENAME.dic` contains your desired hotwords (i.e. *Alexa* and *Google* for default settings), if not, add them.

Afterwards,
- change `/etc/opt/AlexaPi/config.yaml`
  - find `language` and `dictionary` attributes in `pocketsphinx` configuration
  - change *language* to your language code (e.g. 'de-de', see above)
  - change *dictionary* to your FILENAME.dic (e.g. 'cmusphinx-voxforge-de.dic')


### Install German language package

- [Download package from here](http://dl.xtools.at/pocketsphinx-german.zip) and unzip.
- Move contents to `/usr/local/lib/python2.7/dist-packages/pocketsphinx/model/`
- Edit your _config.yaml_ and include new values
```
sudo nano /etc/opt/AlexaPi.config.yaml

#...
# find pocketsphinx > language, change to 'de-de'
# find pocketsphinx > dictionary, change to 'cmusphinx-voxforge-de.dic'
```
