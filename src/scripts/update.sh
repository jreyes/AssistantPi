#!/bin/bash
echo ""
echo "Starting AssistantPi Quick Update..."
read -r -p "This will wipe all changes you may have done to /opt/AlexaPi. Proceed? [Y/n]: " go

case $go in
    [Yy] )
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
		
		echo ""
		echo "Finished Quick Update."
		echo ""
	;;
    *)
		echo "Exiting..."
		exit
    ;;
esac
