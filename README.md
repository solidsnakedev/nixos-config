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

