#!/usr/bin/env bash
set -e

# ===== CONFIG =====
SCRIPT_NAME="clip"
INSTALL_PATH="/usr/local/bin"
REPO_URL="https://github.com/sxmplyfarhan/Clip-Command.git"
INSTALL_DIR="$HOME/.clip-command"

# ===== DETECT OS / PACKAGE MANAGER =====
PACKAGE_MANAGER=""
if command -v apt &>/dev/null; then
    PACKAGE_MANAGER="apt"
elif command -v dnf &>/dev/null; then
    PACKAGE_MANAGER="dnf"
elif command -v pacman &>/dev/null; then
    PACKAGE_MANAGER="pacman"
elif command -v zypper &>/dev/null; then
    PACKAGE_MANAGER="zypper"
elif command -v apk &>/dev/null; then
    PACKAGE_MANAGER="apk"
fi

# ===== SYSTEM DEPENDENCIES =====
SYSTEM_DEPS=(python3 git ffmpeg curl)

install_system_deps() {
    echo "Installing system dependencies: ${SYSTEM_DEPS[*]}"
    case "$PACKAGE_MANAGER" in
        apt)
            sudo apt update
            sudo apt install -y "${SYSTEM_DEPS[@]}" python3-pip
            ;;
        dnf)
            sudo dnf install -y "${SYSTEM_DEPS[@]}" python3-pip
            ;;
        pacman)
            sudo pacman -Syu --noconfirm "${SYSTEM_DEPS[@]}" python-pip
            ;;
        zypper)
            sudo zypper install -y "${SYSTEM_DEPS[@]}" python3-pip
            ;;
        apk)
            sudo apk add --no-cache "${SYSTEM_DEPS[@]}" py3-pip
            ;;
        *)
            echo "No supported package manager detected. Skipping system dependencies."
            ;;
    esac
}

# Install system deps if package manager exists
if [ -n "$PACKAGE_MANAGER" ]; then
    install_system_deps
else
    echo "Package manager not detected. System dependencies must be installed manually."
fi

# ===== INSTALL / UPDATE CLIP-COMMAND =====
if [ -d "$INSTALL_DIR" ]; then
    echo "Clip-Command is already installed."
    read -p "Do you want to update it to the latest version? [y/N]: " choice
    if [[ "$choice" =~ ^[Yy]$ ]]; then
        cd "$INSTALL_DIR"
        git pull origin main
        echo "Updated Clip-Command!"
    else
        echo "Update skipped."
    fi
else
    git clone "$REPO_URL" "$INSTALL_DIR"
    echo "Installed Clip-Command to $INSTALL_DIR"
fi

# ===== SYMLINK =====
sudo ln -sf "$INSTALL_DIR/$SCRIPT_NAME" "$INSTALL_PATH/$SCRIPT_NAME"

# ===== PYTHON DEPENDENCIES =====
echo "Installing Python dependencies..."
# Spotipy
if command -v yay &>/dev/null && [[ "$PACKAGE_MANAGER" == "pacman" ]]; then
    echo "Installing Spotipy via yay (Arch/Manjaro)..."
    yay -S --noconfirm python-spotipy
else
    echo "Installing Spotipy via pip3..."
    pip3 install --user spotipy yt-dlp
fi

# ===== FALLBACK FOR YT-DLP & FFMPEG IF MISSING =====
command -v yt-dlp >/dev/null 2>&1 || {
    echo "yt-dlp not found. Installing latest release..."
    curl -L https://github.com/yt-dlp/yt-dlp/releases/latest/download/yt-dlp -o "$HOME/.local/bin/yt-dlp"
    chmod +x "$HOME/.local/bin/yt-dlp"
}
command -v ffmpeg >/dev/null 2>&1 || {
    echo "ffmpeg not found. Installing static build..."
    FFMPEG_URL=$(curl -s https://johnvansickle.com/ffmpeg/releases/ | grep -o 'https://johnvansickle.com/ffmpeg/releases/ffmpeg-release-.*-amd64-static.tar.xz' | head -n1)
    curl -L "$FFMPEG_URL" -o "/tmp/ffmpeg.tar.xz"
    tar -xf /tmp/ffmpeg.tar.xz -C /tmp
    sudo cp /tmp/ffmpeg-*-amd64-static/ffmpeg /usr/local/bin/
    sudo cp /tmp/ffmpeg-*-amd64-static/ffprobe /usr/local/bin/
}

echo "✅ Clip-Command installation complete!"
echo "You can now run it anywhere using:"
echo "   $ clip <link> [-a | -v] [-D <directory>]"


