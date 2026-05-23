#!/usr/bin/env bash
# SPDX-License-Identifier: CC0-1.0
# Script to prepare Bakery OS build environment
#
# This script sets up the build environment by:
# 1. Updating pacman database
# 2. Generating pacman.conf from template
# 3. Extracting and building Calamares installer
# 4. Creating a local package repository

set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Get script directory
SCRIPT_DIR=$(dirname "$(readlink -f "$0")")
PROJECT_DIR=$(pwd)

echo -e "${YELLOW}=== Bakery OS Preparation ===${NC}"
echo "Project directory: $PROJECT_DIR"
echo "Script directory: $SCRIPT_DIR"

# Check prerequisites
if ! command -v pacman &> /dev/null; then
    echo -e "${RED}Error: pacman not found. This script must run on Arch Linux.${NC}"
    exit 1
fi

if ! command -v makepkg &> /dev/null; then
    echo -e "${RED}Error: makepkg not found. Please install base-devel.${NC}"
    exit 1
fi

echo -e "${YELLOW}Updating pacman database...${NC}"
if ! sudo pacman -Syu --noconfirm; then
    echo -e "${RED}Error: Failed to update pacman database.${NC}"
    exit 1
fi
echo -e "${GREEN}✓ Pacman database updated${NC}"

# Create pacman config file
echo -e "${YELLOW}Creating pacman.conf from template...${NC}"
if [[ ! -f "$PROJECT_DIR/pacman.conf.template" ]]; then
    echo -e "${RED}Error: pacman.conf.template not found!${NC}"
    exit 1
fi

sed "s|__PROJECT_DIR__|$PROJECT_DIR|g" pacman.conf.template > pacman.conf
echo -e "${GREEN}✓ pacman.conf generated${NC}"

# Build Calamares
echo -e "${YELLOW}Building Calamares installer...${NC}"
source "$SCRIPT_DIR/calamares.sh"

if ! extract_calamares_snapshot; then
    echo -e "${RED}Error: Failed to extract Calamares snapshot.${NC}"
    exit 1
fi

if ! build_calamares; then
    echo -e "${RED}Error: Failed to build Calamares.${NC}"
    exit 1
fi
echo -e "${GREEN}✓ Calamares built successfully${NC}"

# Add local repo
echo -e "${YELLOW}Setting up local repository...${NC}"
mkdir -p ./local-repo

if ! cp ./calamares/calamares-*.pkg.tar.zst ./local-repo/ 2>/dev/null; then
    echo -e "${RED}Error: No Calamares package found!${NC}"
    exit 1
fi

if ! repo-add ./local-repo/custom.db.tar.gz ./local-repo/*.pkg.tar.zst; then
    echo -e "${RED}Error: Failed to add packages to local repository.${NC}"
    exit 1
fi
echo -e "${GREEN}✓ Local repository configured${NC}"

echo -e "${GREEN}=== Preparation Complete ===${NC}"
echo "Next step: Run 'bash scripts/build.sh' to build the ISO"

