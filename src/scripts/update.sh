#!/bin/bash
echo ""
echo "Starting AssistantPi Quick Update..."
read -r -p "This will backup your config.template.yaml and assistant.example.asoundrc but wipes all other changes you may have done to /opt/AlexaPi. Proceed? [Y/n]: " go

case $go in
    [Yy] )
		# Backup config files
		cd /opt
		sudo mkdir AlexaPi-bkp
		sudo cp /opt/AlexaPi/src/assistant.example.asoundrc /opt/AlexaPi-bkp/src/assistant.example.asoundrc
		sudo cp /opt/AlexaPi/src/config.template.yaml /opt/AlexaPi-bkp/src/config.template.yaml

		# Update AssistantPi Core
		cd /opt/AlexaPi
		sudo git checkout -- .
		sudo git checkout master
		sudo git pull

		# Update tweaked Google Assistant SDK
		cd /opt/AlexaPi/src/assistant-sdk-python
		sudo git checkout -- .
		sudo git checkout master
		sudo git pull
		sudo /opt/AlexaPi/env/bin/python -m pip install --upgrade -e ".[samples]"

		# Reinstall backed up files
		sudo mv /opt/AlexaPi-bkp/src/assistant.example.asoundrc /opt/AlexaPi/src/assistant.example.asoundrc
		sudo mv /opt/AlexaPi-bkp/src/config.template.yaml /opt/AlexaPi/src/config.template.yaml
		sudo rm -rf /opt/AlexaPi-bkp
		
		echo ""
		echo "Finished Quick Update."
		echo ""
	;;
    *)
		echo "Exiting..."
		exit
    ;;
esac
