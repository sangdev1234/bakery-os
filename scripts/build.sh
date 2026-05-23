#!/usr/bin/env bash
# SPDX-License-Identifier: CC0-1.0
# Script to build Bakery OS ISO
#
# This script builds the ISO image for Bakery OS.
# Prerequisites: prepare.sh must be run first to set up dependencies.

set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Get script directory
SCRIPT_DIR="$(dirname "$(readlink -f "$0")")"
PROJECT_DIR="$(cd "$SCRIPT_DIR/.." && pwd)"

echo -e "${YELLOW}=== Bakery OS ISO Build ===${NC}"
echo "Project directory: $PROJECT_DIR"

# Check if prepare.sh has been run
if [[ ! -f "$PROJECT_DIR/pacman.conf" ]]; then
    echo -e "${RED}Error: pacman.conf not found!${NC}"
    echo "Please run 'bash scripts/prepare.sh' first to prepare the build environment."
    exit 1
fi

if [[ ! -d "$PROJECT_DIR/local-repo" ]]; then
    echo -e "${RED}Error: local-repo directory not found!${NC}"
    echo "Please run 'bash scripts/prepare.sh' first to build Calamares and set up the local repository."
    exit 1
fi

# Check if pacman.conf is valid
if ! grep -q "__PROJECT_DIR__" "$PROJECT_DIR/pacman.conf"; then
    echo -e "${GREEN}✓ pacman.conf is properly configured${NC}"
else
    echo -e "${RED}Error: pacman.conf still contains template placeholders!${NC}"
    exit 1
fi

echo -e "${YELLOW}Building ISO image...${NC}"
cd "$PROJECT_DIR"

# Run mkarchiso to build the ISO
if sudo mkarchiso -C ./pacman.conf -v -w work/ -o out/ .; then
    echo -e "${GREEN}✓ ISO build completed successfully!${NC}"
    echo "ISO image location: $PROJECT_DIR/out/"
    ls -lh out/*.iso
else
    echo -e "${RED}Error: ISO build failed!${NC}"
    exit 1
fi
