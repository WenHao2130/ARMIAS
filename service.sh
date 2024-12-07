#!/bin/bash
sleep 10
#模块名称
name="AuroraNasa_Installer"

ksud module uninstall $name
apd module uninstall $name
touch "/data/adb/modules/$name/remove"
