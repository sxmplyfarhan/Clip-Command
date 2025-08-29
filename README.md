# :musical_note: Clip-Command

Clip-Command is a command-line tool to **download music or videos** from YouTube and Spotify playlists.  
It bridges services: Spotify provides tracklists, YouTube provides the media, and `ffmpeg` converts it to MP3 or MP4.  
It’s interactive, flexible, and designed for personal use.

----

# ⚠️  Legal Notice

This tool is intended for personal use only. Downloading videos or music from YouTube or Spotify may violate their Terms of Service and/or copyright law in your country.

By using this tool, you agree to use it responsibly and not to distribute downloaded content.

The author is not responsible for any misuse or legal consequences.

---


## Screenshots:

<img width="900" height="188" alt="image" src="https://github.com/user-attachments/assets/460797d2-3600-46f1-810b-bb6b77da5902" />


## :zap: Features

- Download **YouTube videos** or playlists (audio MP3 or video MP4)
- Download **Spotify playlists** (converted via YouTube search, audio only)
- Interactive **YouTube search** if no URL is provided
- **Progress bar** for downloads
- Custom output directory support
- **Spotify login** with locally stored credentials for playlist access

---

## :package: Requirements

The installer (`install.sh`) handles most dependencies automatically. If installing manually:

**Core:**
- Python 3.6+
- Git
- curl
- make, gcc, pkg-config
- ffmpeg (for audio/video)

**Python Libraries:**
- Spotipy
- yt-dlp

**Platform specifics:**
- Debian/Ubuntu → `apt`
- Fedora → `dnf`
- Arch Linux → `pacman` + `yay` for Spotipy
- Windows/macOS → manual dependency setup for Python libraries and ffmpeg

---

## :zap: Installation

``` bash 
# Git clone the repository
git clone https://github.com/sxmplyfarhan/Clip-Command.git

# Go in the cloned repository
cd Clip-Command

# And now you can verify is the installation script has the perms it needs.
chmod +x install.sh

# And than execute the script.!
./install.sh
```

Boom its installed!

# Usage: clip <link> [options]

```
Commands:
  login           Log in to Spotify (required for Spotify playlists)

Options:
  -a             Audio only (MP3)  (ignored for Spotify playlists)
  -v             Video (MP4)       (ignored for Spotify playlists)
  -D <dir>       Output directory
  -h, --help     Show this help message.
```
Notes:
- YouTube links can be single videos or playlists.
- Spotify playlists require a login:
  1. Go to https://developer.spotify.com/dashboard/
  2. Create an app and get Client ID & Secret
  3. Run: clip login
- Spotify playlists will be downloaded via YouTube search (audio only)
- Example usage:
  ```
    clip https://youtu.be/LgPEyGlUQH8 -a
    clip https://open.spotify.com/playlist/XXXXXXXX -D ~/Music
  ```
