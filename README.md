# Bakery OS

A custom Arch Linux distribution built on top of Arch Linux archiso, featuring GNOME desktop environment and Calamares installer for easy installation.

## Features

- **Base**: Arch Linux
- **Desktop Environment**: GNOME + GNOME Extra
- **Installation**: Calamares graphical installer
- **Boot Methods**: BIOS (syslinux) and UEFI (systemd-boot)
- **Architecture**: x86_64 (with x86 support)

## Requirements

- Arch Linux or compatible Linux distribution with pacman
- `base-devel` package group installed
- 4GB+ free disk space for building
- Internet connection for downloading packages
- `sudo` privileges

## Building Bakery OS

### Step 1: Prepare the Build Environment

```bash
bash scripts/prepare.sh
```

This script will:
- Update the pacman database
- Generate `pacman.conf` from template
- Extract and build the Calamares installer
- Set up the local package repository

### Step 2: Build the ISO Image

```bash
bash scripts/build.sh
```

This script will:
- Validate the build environment
- Run `mkarchiso` to build the ISO
- Create the bootable ISO in `out/` directory

### Output

The built ISO image will be located at:
```
out/bakeryos-YYYY.MM.DD-x86_64.iso
```

## File Structure

```
.
├── scripts/              # Build scripts
│   ├── prepare.sh       # Prepare build environment (install Calamares)
│   ├── build.sh         # Build ISO image
│   ├── calamares.sh     # Calamares extraction and build functions
│   └── calamares-build.sh # Standalone Calamares build script
├── airootfs/            # Files to include in the live environment
│   ├── etc/             # System configuration
│   │   └── calamares/   # Calamares installer configuration
│   └── root/            # Root user home directory
├── packages.x86_64      # Package list for x86_64 architecture
├── packages.x86_6       # Package list for x86 architecture
├── bootstrap_packages   # Bootstrap packages for initial environment
├── profiledef.sh        # Archiso profile configuration
├── pacman.conf.template # Template for pacman configuration (used by prepare.sh)
├── efiboot/             # EFI boot configuration
├── syslinux/            # BIOS boot configuration
├── grub/                # GRUB bootloader configuration
└── assets/              # Additional assets (logo, calamares.tar.gz)
```

## Build Process Overview

1. **prepare.sh**: Sets up the build environment
   - Updates pacman packages
   - Generates `pacman.conf` from template (replaces `__PROJECT_DIR__`)
   - Extracts Calamares source from `assets/calamares.tar.gz`
   - Builds and installs Calamares package to local repository

2. **build.sh**: Creates the ISO image
   - Validates that `prepare.sh` has been run
   - Runs `mkarchiso` to build the ISO image
   - Creates bootable image with configured boot loaders

## Troubleshooting

### "pacman.conf not found" error

Run the prepare script first:
```bash
bash scripts/prepare.sh
```

### "local-repo directory not found" error

The local repository is created by `prepare.sh`. Run it before `build.sh`.

### "Error preparing initial: Not found" during boot

This indicates the ISO was not built correctly. Ensure:
1. `prepare.sh` ran successfully
2. `pacman.conf` was generated without template placeholders
3. `build.sh` completed without errors
4. All required boot files are present in the ISO

## Configuration

### System Settings

Edit files in `profiledef.sh` to change:
- ISO name and version
- Boot modes (BIOS/UEFI)
- Compression settings
- File permissions

### Package Selection

Edit these files to customize packages:
- `packages.x86_64`: Packages for 64-bit systems
- `packages.x86_6`: Packages for 32-bit systems
- `bootstrap_packages`: Base packages for initial environment

### Calamares Configuration

Edit files in `airootfs/etc/calamares/`:
- `settings.conf`: Main installer configuration
- `modules/`: Individual installer module configurations
- `branding/`: Branding customization

## License

This project is licensed under CC0 1.0 Universal (Public Domain).

## References

- [Arch Linux archiso documentation](https://wiki.archlinux.org/title/Archiso)
- [Calamares installer](https://calamares.io/)
- [GNOME desktop environment](https://www.gnome.org/)
