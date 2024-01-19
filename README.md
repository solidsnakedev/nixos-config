# NixOS config

## HomeManager flake standalone
[Link](https://nix-community.github.io/home-manager/index.html#sec-flakes-standalone)

## Build NixOS

Clone this repo, then

```
git clone git@github.com:solidsnakedev/nixos-config.git
```

Go to `nixos-config` folder
```
cd nixos-config
```

For NixOS
```
sudo nixos-rebuild switch --flake .
```

For HomeManager

First time running home-manager
```
nix run home-manager/master -- switch --flake .

```

After the initial activation has completed successfully
```
home-manager switch --flake .
```


# MacOS only

## Install iTerm
https://iterm2.com/downloads.html
## Install homebrew
https://brew.sh/
## Install Nerdfont
```
brew tap homebrew/cask-fonts
brew install font-hack-nerd-font
```
## Install Yabai
https://github.com/koekeishiya/yabai/wiki/Installing-yabai-(latest-release)
## Install skhd
https://github.com/koekeishiya/skhd

## Configure Displays
- Configure MacOs Specific Settings
- Open Several Desktops (~7) on Your Machine
- Go To Keyboard Settings > Shortcuts > Mission Control
- Expand Mission Control and Turn On Shortcuts for Switching Spaces 1-7 with “Ctrl + # Of Space”
- Go to System Settings > Accessibility > Display
- Turn On Reduce Motion
- Go To System Settings > Desktop & Dock > Mission Control
- Turn off “Automatically Rearrange Spaces Based On Most Recent Use”
- Only keep “Displays Have Separate Spaces” turned on here

## Iterm colorscheme
- Open iTerm2
- Download my color profile by running the following command (will be added to Downloads folder):
```bash
curl https://raw.githubusercontent.com/mbadolato/iTerm2-Color-Schemes/master/schemes/kanagawabones.itermcolors --output ~/Downloads/kanagawabones.itermcolors
```
- Open iTerm2 preferences
- Go to Profiles > Colors
- Import the downloaded color profile
- Select the color profile

> reference https://www.josean.com/posts/terminal-setup


## Iterm set Fish shell
- Open iTerm2
- Open iTerm2 preferences
- Go to profiles
- Go to General
- Go to Command -> Custom Shell
- Insert `/Users/jonathan/.nix-profile/bin/fish`

## Iterm set Natural text editing
- Open iTerm2
- Open iTerm2 preferences
- Go to profiles
- Go to Keys
- Go to Key mappings
- Go to Presets -> select `Natural Text Editing`

## Iterm enable `Quit when all windows are closed`
- Open iTerm2
- Open iTerm2 preferences
- Go to General
- Go to Closing -> enable `Quit when all windows are closed`

## Install VSCode
- https://code.visualstudio.com/
- Sync VSCode with GitHub account


## VIM Vscode disable apple press and hold
https://marketplace.visualstudio.com/items?itemName=vscodevim.vim

- For VS Code
```bash
defaults write com.microsoft.VSCode ApplePressAndHoldEnabled -bool false 
```
- Restart laptop