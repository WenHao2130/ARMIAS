#!/bin/bash
sleep 10
ksud module uninstall "AuroraNasa_Installer"
apd module uninstall "AuroraNasa_Installer"
su -c touch "$SECURE_DIR/modules/AuroraNasa_Installer/remove"
