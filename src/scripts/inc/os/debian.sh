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
	apt-get install python3-dev python3-venv -y
	apt-get install portaudio19-dev libffi-dev libssl-dev -y
	
	python3 -m venv /home/pi/env
	/home/pi/env/bin/pip install pip setuptools --upgrade

	set +o nounset
	source /home/pi/env/bin/activate
	set -o nounset

	python -m pip install google-assistant-sdk[samples]
}

function auth_assistant {
	python -m googlesamples.assistant.auth_helpers --client-secrets /home/pi/Downloads/client_secret.json
}
