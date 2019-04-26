#!/bin/bash
#
# Disable cups-browsed (fixes reboot hang)

sudo systemctl stop cups-browsed.service
sudo systemctl disable cups-browsed.service
