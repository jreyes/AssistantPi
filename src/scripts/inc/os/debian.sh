#!/bin/bash

function install_os {
    apt-get update
    apt-get install curl git build-essential python-dev python-setuptools swig libasound2-dev libpulse-dev vlc-nox sox libsox-fmt-mp3 -y
    apt-get -y remove python-pip
    run_python -m easy_install pip
}

function install_shairport-sync {

    apt-get install autoconf libdaemon-dev libasound2-dev libpopt-dev libconfig-dev avahi-daemon libavahi-client-dev libssl-dev libsoxr-dev -y

    install_shairport-sync_from_source
}

function install_assistant {
	# Prequisiteries
	apt-get install python3-dev python3-venv -y
	apt-get install portaudio19-dev libffi-dev libssl-dev -y

	# Setup Virtual Environment
	python3 -m venv /opt/AlexaPi/env
	/opt/AlexaPi/env/bin/pip install pip setuptools --upgrade

	#set +o nounset
	#source /home/pi/env/bin/activate
	#set -o nounset
	#python -m pip install google-assistant-sdk[samples]

	# Install forked Assistant SDK
	cd /opt/AlexaPi/src
	sudo git clone https://github.com/xtools-at/assistant-sdk-python.git
	cd assistant-sdk-python
	/opt/AlexaPi/env/bin/python -m pip install --upgrade -e ".[samples]"

	/opt/AlexaPi/env/pip install tenacity
}

function auth_assistant {
	sudo -u pi sh -c '/opt/AlexaPi/env/bin/python -m googlesamples.assistant.auth_helpers --client-secrets /home/pi/Downloads/client_secret.json'
}
