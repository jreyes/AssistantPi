#!/bin/bash
echo ""
echo "Starting Quick Update..."
cd /opt/AlexaPi
sudo git checkout master
sudo git pull
cd /opt/AlexaPi/src/assistant-sdk-python
sudo git checkout master
sudo git pull
sudo /opt/AlexaPi/env/bin/python -m pip install --upgrade -e ".[samples]"
echo ""
echo "Finished Quick Update."
echo ""
