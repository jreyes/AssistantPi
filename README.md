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

- Have your Raspberry Pi running Raspbian ready and connected to the Internet. I recommend to use a fresh install of *Raspbian Jessie Lite* without Pixel.
- Follow this [Google Guide](https://developers.google.com/assistant/sdk/prototype/getting-started-pi-python/config-dev-project-and-account) and place the Google Assistant Credentials JSON in `/home/pi/Downloads/client_secret.json`
- Prepare Amazon AVS Credentials as described in [Step 1 in AlexaPi Installation Guide](https://github.com/alexa-pi/AlexaPi/wiki/Installation), you'll need them during Installation. Even if you only want Google Assistant, this has to be done for AlexaPi to work properly.
- Connect your audio peripherals (i.e. USB-Mic and Speaker via Jack).
- Clone this repository to `/opt` directory and rename the folder to *AlexaPi* (both important, it will fail otherwise):
	```
    cd /opt
	sudo git clone https://github.com/xtools-at/AssistantPi.git AlexaPi
    ```
- Run the setup and go through all the steps. This will take a while, approx. 30min with a somewhat good Internet connection.
	```
    sudo /opt/AlexaPi/src/scripts/setup.sh
    ```
- If Authentication with Google Assistant API fails during setup, try to run it manually:
	```
    /opt/AlexaPi/env/bin/python -m googlesamples.assistant.auth_helpers --client-secrets /home/pi/Downloads/client_secret.json
    ```
- If you haven't opted for starting AssistantPi at boot, or the Installer threw an error during setup, start the script manually using `python /opt/AlexaPi/src/main.py`. Otherwise, it will be started automatically when the setup finishes.
- Trigger Assistant and Alexa with the hotwords *Google* and *Alexa*

### Setup problems
For some users, the setup fails with this error:

```
Could not import runpy module
Traceback (most recent call last):
File "", line 2237, in _find_and_load
File "", line 2222, in _find_and_load_unlocked
File "", line 2164, in _find_spec
File "", line 1940, in find_spec
File "", line 1911, in _get_spec
File "", line 1879, in _path_importer_cache
FileNotFoundError: [Errno 2] No such file or directory
```

This means there have been troubles setting up the Python virtual environment Google Assistant needs during installation. I haven't figured out yet what's causing this, but if you are encountering this issue, please do the following in the meantime:

- In the setup, don't install Google Assistant, but finish everything AlexaPi-related properly. The setup shouldn't have crashed now and AlexaPi should be running.
- Run `python3 -m venv /opt/AlexaPi/env` and check if there is a folder `env` in _/opt/AlexaPi_
- Run the steps of the Google Assistant setup manually:
```
sudo /opt/AlexaPi/env/bin/pip install pip setuptools --upgrade
cd /opt/AlexaPi/src
sudo rm -rf assistant-sdk-python
sudo git clone https://github.com/xtools-at/assistant-sdk-python.git
cd /opt/AlexaPi/src/assistant-sdk-python
sudo /opt/AlexaPi/env/bin/python -m pip install --upgrade -e ".[samples]"
cp /opt/AlexaPi/src/assistant.example.asoundrc /home/pi/.asoundrc
```
- Do the Authentication with Google API manually:
```
sudo /opt/AlexaPi/env/bin/python -m googlesamples.assistant.auth_helpers --client-secrets /home/pi/Downloads/client_secret.json
```


## Updating

Bringing your AssistantPi up-to-date is just one command away:
```
sudo /opt/AlexaPi/src/scripts/update.sh
```
This updates both AssistantPi and the [tweaked Assistant SDK](https://github.com/xtools-at/assistant-sdk-python) without having you to go through the installation process again.


## Audio problems

Make sure you've been to `sudo raspi-config`, *Advanced Options > Audio* and have set the desired audio output (i.e. 3.5mm Jack, not HDMI).

Please refer to the following guides if you encounter any audio problems:

- [Configure Google Assistant Audio Output](https://developers.google.com/assistant/sdk/prototype/getting-started-pi-python/configure-audio)
- [Google Assistant Troubleshooting](https://developers.google.com/assistant/sdk/prototype/getting-started-pi-python/troubleshooting)
- [AlexaPi Audio Setup and Debugging](https://github.com/alexa-pi/AlexaPi/wiki/Audio-setup-&-debugging)
- [AlexaPi Wiki](https://github.com/alexa-pi/AlexaPi/wiki/)


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

Afterwards, either
- change `/opt/AlexaPi/src/config.template.yaml`
  - find `language` and `dictionary` attributes in `pocketsphinx` configuration
  - change *language* to your language code (e.g. 'de-de', see above)
  - change *dictionary* to your FILENAME.dic (e.g. 'cmusphinx-voxforge-de.dic')
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
cd /opt/AlexaPi
sudo git checkout feature/german
```
- Install pocketsphinx. This is the responsible module for the hotword recognition.
```
pip install pocketsphinx
```
- Install the language package, running as root (or copy the files in .../src/german manually as described above):
```
sudo bash /opt/AlexaPi/src/german/install.sh
```
- Proceed with steps above in the Installation instructions (i.e. run the AssistantPi installer script)
```
sudo /opt/AlexaPi/src/scripts/setup.sh
```
