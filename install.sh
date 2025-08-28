# clip - YouTube downloader wrapper
# Copyright (c) 2025 Fy
# Licensed under the Creative Commons Attribution-NonCommercial-ShareAlike 4.0 International License
# See LICENSE or https://creativecommons.org/licenses/by-nc-sa/4.0/legalcode



#!/usr/bin/env bash
set -e

SCRIPT_NAME="clip"
INSTALL_PATH="/usr/local/bin"

# Detect distro
if [ -f /etc/os-release ]; then
    . /etc/os-release
    DISTRO_ID=$ID
else
    echo "Cannot detect OS."
    exit 1
fi

# Check for existing dependencies
NEED_PYTHON=0
NEED_YTDLP=0
NEED_FFMPEG=0

command -v python3 >/dev/null 2>&1 || NEED_PYTHON=1
command -v yt-dlp >/dev/null 2>&1 || NEED_YTDLP=1
command -v ffmpeg >/dev/null 2>&1 || NEED_FFMPEG=1

install_deps() {
    echo "Installing missing dependencies..."
    case "$DISTRO_ID" in
        arch|manjaro)
            sudo pacman -Syu --noconfirm $( [ $NEED_PYTHON -eq 1 ] && echo python ) \
                                   $( [ $NEED_YTDLP -eq 1 ] && echo yt-dlp ) \
                                   $( [ $NEED_FFMPEG -eq 1 ] && echo ffmpeg )
            ;;
        ubuntu|debian)
            sudo apt update
            sudo apt install -y $( [ $NEED_PYTHON -eq 1 ] && echo python3 python3-pip ) \
                                $( [ $NEED_YTDLP -eq 1 ] && echo yt-dlp ) \
                                $( [ $NEED_FFMPEG -eq 1 ] && echo ffmpeg )
            ;;
        fedora|rhel|centos)
            sudo dnf install -y $( [ $NEED_PYTHON -eq 1 ] && echo python3 python3-pip ) \
                                $( [ $NEED_YTDLP -eq 1 ] && echo yt-dlp ) \
                                $( [ $NEED_FFMPEG -eq 1 ] && echo ffmpeg )
            ;;
        *)
            echo "Unsupported OS: $DISTRO_ID"
            exit 1
            ;;
    esac
}

if [ $NEED_PYTHON -eq 1 ] || [ $NEED_YTDLP -eq 1 ] || [ $NEED_FFMPEG -eq 1 ]; then
    install_deps
else
    echo "All dependencies are already installed."
fi

# Check if the script exists in current directory
if [ ! -f "./$SCRIPT_NAME" ]; then
    echo "$SCRIPT_NAME not found in current directory."
    exit 1
fi

# Make executable and copy to /usr/local/bin
chmod +x "./$SCRIPT_NAME"
sudo cp "./$SCRIPT_NAME" "$INSTALL_PATH/$SCRIPT_NAME"

echo "Installation complete!"
echo "You can now run it from anywhere:"
echo "   $ $SCRIPT_NAME 'youtube_link' -a | -v -D <dir>"
