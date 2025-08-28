# Clip - A command to easily download Youtube videos across the terminal.

# Screenshots:

<img width="900" height="188" alt="image" src="https://github.com/user-attachments/assets/460797d2-3600-46f1-810b-bb6b77da5902" />



# Update 1.1
-  Improved install.sh so it autodetects distros, mind you if it isnt besides Arch, Ubuntu or fedora it will will not work.
- added search
-  fixed a few bugs.
  
Currently Available for:
Arch linux, Ubuntu and Fedora. -- Note if your distro uses any of these package managers you can install to.

## Installation?

Well you can start by git cloning this repo.

```
git clone https://github.com/sxmplyfarhan/Clip-Command.git
```

Next you can go in the downloaded directory.

```
cd ~/Clip-Command
```

And now you can verify is the installation script has the perms it needs.

```
chmod +x install.sh
```

And than execute the script.!

```
./install.sh
```

And boom its installed in ur system!!!


## Usage?!

Well this command is fairly simple.

`
clip <YouTube link> [options]
`

Where it says "<YouTube link>" you must put your desired youtube video.
Meanwhile for options you can do many things.

```
  -a             Download audio only (MP3)
  -v             Download video (MP4)
  -D <dir>       Set output directory (default: current directory)
  -h, --help     Shows a help message.
```

Examples:

```
  clip 'https://youtu.be/LgPEyGlUQH8' -a
  clip 'https://youtu.be/LgPEyGlUQH8' -v -D ~/Videos
```
