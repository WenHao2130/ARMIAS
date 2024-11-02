#!/bin/bash
sleep 10
ksud module uninstall "AuroraNasa_Installer"
apd module uninstall "AuroraNasa_Installer"
rm -rf "$SECURE_DIR/modules/AuroraNasa_Installer/"
touch "$SECURE_DIR/modules/remove"
