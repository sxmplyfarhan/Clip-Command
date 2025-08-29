#!/usr/bin/env bash
set -e

# ===== CONFIG =====
SCRIPT_NAME="clip"
INSTALL_PATH="/usr/local/bin"
REPO_URL="https://github.com/sxmplyfarhan/Clip-Command.git"
INSTALL_DIR="$HOME/.clip-command"

# ===== DETECT PACKAGE MANAGER =====
PACKAGE_MANAGER=""
if command -v apt &>/dev/null; then PACKAGE_MANAGER="apt"
elif command -v dnf &>/dev/null; then PACKAGE_MANAGER="dnf"
elif command -v pacman &>/dev/null; then PACKAGE_MANAGER="pacman"; fi

if [ -z "$PACKAGE_MANAGER" ]; then
    echo "Unsupported Linux distro. Please install dependencies manually."
    exit 1
fi

# ===== INSTALL SYSTEM DEPENDENCIES =====
install_system_deps() {
    echo "Installing system dependencies..."
    case "$PACKAGE_MANAGER" in
        apt)
            sudo apt update
            sudo apt install -y python3 git ffmpeg curl make gcc pkg-config python3-venv
            ;;
        dnf)
            sudo dnf install -y python3 git ffmpeg curl make gcc pkg-config python3-venv
            ;;
        pacman)
            sudo pacman -Syu --noconfirm python git ffmpeg curl make gcc pkgconf
            # Install yay if missing
            if ! command -v yay &>/dev/null; then
                echo "Installing yay AUR helper..."
                cd /tmp
                git clone https://aur.archlinux.org/yay.git
                cd yay
                makepkg -si --noconfirm
            fi
            ;;
    esac
}

install_system_deps

# ===== INSTALL SPOTIPY AND YT-DLP =====
install_python_tools() {
    case "$PACKAGE_MANAGER" in
        pacman)
            # Arch: Spotipy via yay
            if ! pacman -Qs python-spotipy >/dev/null; then
                yay -S --noconfirm python-spotipy
            fi
            # yt-dlp already installed via pacman; skip if present
            if ! command -v yt-dlp &>/dev/null; then
                echo "yt-dlp not found! Install via pacman or yay."
                exit 1
            fi
            ;;
        apt)
            # Debian/Ubuntu
            if ! dpkg -s python3-spotipy >/dev/null 2>&1; then
                echo "python3-spotipy not found in repos. Installing from source..."
                cd /tmp
                git clone https://github.com/plamere/spotipy.git
                cd spotipy
                python3 setup.py install --user
            fi
            if ! command -v yt-dlp &>/dev/null; then
                echo "yt-dlp not found in repos. Installing standalone binary..."
                sudo curl -L https://github.com/yt-dlp/yt-dlp/releases/latest/download/yt-dlp -o /usr/local/bin/yt-dlp
                sudo chmod a+rx /usr/local/bin/yt-dlp
            fi
            ;;
        dnf)
            # Fedora
            if ! rpm -q python3-spotipy >/dev/null 2>&1; then
                echo "python3-spotipy not found in repos. Installing from source..."
                cd /tmp
                git clone https://github.com/plamere/spotipy.git
                cd spotipy
                python3 setup.py install --user
            fi
            if ! command -v yt-dlp &>/dev/null; then
                echo "yt-dlp not found in repos. Installing standalone binary..."
                sudo curl -L https://github.com/yt-dlp/yt-dlp/releases/latest/download/yt-dlp -o /usr/local/bin/yt-dlp
                sudo chmod a+rx /usr/local/bin/yt-dlp
            fi
            ;;
    esac
}

install_python_tools

# ===== INSTALL / UPDATE CLIP-COMMAND =====
if [ -d "$INSTALL_DIR" ]; then
    echo "Clip-Command already installed."
    read -p "Do you want to update it? [y/N]: " choice
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

echo "Clip-Command installation complete!"
echo "You can run it globally using:"
echo "   $ clip <link> [-a | -v] [-D <directory>]"
