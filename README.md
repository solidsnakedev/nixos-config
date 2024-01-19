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
