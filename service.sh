#!/bin/bash
    if [ "$KSU" = true ]; then
        ksud module uninstall "AuroraNasa_Installer"
    elif [ "$APATCH" = true ]; then
        apd module uninstall "AuroraNasa_Installer"
    elif [ -z "$KSU" ] && [ -z "$APATCH" ] && [ -n "$MAGISK_VER_CODE" ]; then
    rm -rf "$SECURE_DIR/modules/AuroraNasa_Installer/"
fi