

#!/usr/bin/env bash
# SPDX-License-Identifier: CC0-1.0
# Calamares extraction and build functions
#
# This script provides functions to extract and build the Calamares installer.

set -e

extract_calamares_snapshot(){
    mkdir -p ./calamares
    echo "Extracting Calamares Snapshot..."
    
    if [[ ! -f ./assets/calamares.tar.gz ]]; then
        echo "Error: calamares.tar.gz not found in assets directory!" >&2
        return 1
    fi
    
    if ! tar -xzvf ./assets/calamares.tar.gz --strip-components=1 -C ./calamares; then
        echo "Error: Failed to extract Calamares snapshot!" >&2
        return 1
    fi
    
    echo "Calamares snapshot extracted successfully."
}

build_calamares(){
    echo "Building Calamares..."
    
    if [[ ! -d ./calamares ]]; then
        echo "Error: calamares directory not found! Run extract_calamares_snapshot first." >&2
        return 1
    fi
    
    cd ./calamares
    
    if ! makepkg -si --noconfirm; then
        echo "Error: makepkg failed!" >&2
        cd ../
        return 1
    fi

    cd ../
    echo "Calamares built successfully."
}

