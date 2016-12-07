#!/bin/bash
ifconfig wlan0
iwconfig wlan0 essid local
dhclient
