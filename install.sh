#!/usr/bin/env bash
set -e

SCRIPT_NAME="clip"
INSTALL_PATH="/usr/local/bin"

echo "Which distro are you using?"
echo "1) Arch / Manjaro"
echo "2) Ubuntu / Debian"
echo "3) Fedora / RHEL"
read -rp "Enter number [1-3]: " distro

# Function to install dependencies per distro
install_deps() {
    case $1 in
        1) # Arch
            sudo pacman -S --noconfirm python yt-dlp ffmpeg
            ;;
        2) # Debian/Ubuntu
            sudo apt update
            sudo apt install -y python3 python3-pip yt-dlp ffmpeg
            ;;
        3) # Fedora
            sudo dnf install -y python3 python3-pip yt-dlp ffmpeg
            ;;
        *)
            echo "❌ Invalid option."
            exit 1
            ;;
    esac
}

echo "Installing dependencies..."
install_deps "$distro"

# Make sure script exists
if [ ! -f "./$SCRIPT_NAME" ]; then
    echo "❌ $SCRIPT_NAME not found in current directory."
    exit 1
fi

chmod +x "./$SCRIPT_NAME"

# Make executable and install
chmod +x "./$SCRIPT_NAME"
sudo cp "./$SCRIPT_NAME" "$INSTALL_PATH/$SCRIPT_NAME"

echo "Installation complete!"
echo "You can now run it from anywhere:"
echo "   $ $SCRIPT_NAME 'youtube_link' -a | -v"
