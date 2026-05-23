#!/usr/bin/env bash
# SPDX-License-Identifier: CC0-1.0
# Script to build Calamares installer separately
#
# This script extracts and builds the Calamares installer.
# Used by prepare.sh during the ISO preparation phase.

set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Get script directory
SCRIPT_DIR="$(dirname "$(readlink -f "$0")")"

# Source the calamares functions
source "$SCRIPT_DIR/calamares.sh"

echo -e "${YELLOW}Building Calamares installer...${NC}"

if ! extract_calamares_snapshot; then
    echo -e "${RED}Error: Failed to extract Calamares snapshot${NC}"
    exit 1
fi

if ! build_calamares; then
    echo -e "${RED}Error: Failed to build Calamares${NC}"
    exit 1
fi

echo -e "${GREEN}✓ Calamares build completed successfully${NC}"
