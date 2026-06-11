# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, ... }:

{
  imports =
    [
      # Include the results of the hardware scan.
      ./hardware-configuration.nix
      #(fetchTarball "https://github.com/msteen/nixos-vscode-server/tarball/master")
    ];

  # Bootloader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.loader.efi.efiSysMountPoint = "/boot/efi";

  networking.hostName = "nixos"; # Define your hostname.
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  # Enable networking
  networking.networkmanager.enable = true;

  # Set your time zone.
  time.timeZone = "America/Toronto";

  # Select internationalisation properties.
  i18n.defaultLocale = "en_CA.UTF-8";

  # Enable the X11 windowing system.
  services.xserver.enable = true;

  # Enable the GNOME Desktop Environment.
  services.displayManager.gdm.enable = true;
  services.displayManager.gdm.autoSuspend = false;
  services.desktopManager.gnome.enable = true;

  # Configure keymap in X11
  services.xserver = {
    xkb.layout = "us";
    xkb.variant = "";
  };

  services.xserver.videoDrivers = [ "nvidia" ];
  # Enable CUPS to print documents.
  services.printing.enable = true;

  # Enable sound with pipewire.
  # sound.enable = true;
  services.pulseaudio.enable = false;
  hardware.nvidia.open = true;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    # If you want to use JACK applications, uncomment this
    #jack.enable = true;

    # use the example session manager (no others are packaged yet so this is enabled by default,
    # no need to redefine it in your config for now)
    #media-session.enable = true;
  };

  # Enable touchpad support (enabled default in most desktopManager).
  # services.xserver.libinput.enable = true;

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.homeserver = {
    isNormalUser = true;
    description = "home-server";
    extraGroups = [ "networkmanager" "wheel" "docker" ];
    packages = with pkgs; [
      firefox
      #  thunderbird
    ];
    shell = pkgs.zsh;
  };

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
    #  vim # Do not forget to add an editor to edit configuration.nix! The Nano editor is also installed by default.
    #  wget
    git
    # fishPlugins.done
    # fishPlugins.fzf-fish
    # fishPlugins.forgit
    # fishPlugins.pure
    fzf
    # fishPlugins.grc
    grc
    kubectl
    kubernetes-helm
    k9s
  ];

  programs.zsh.enable = true;

  # Stub loader for upstream dynamically-linked binaries (e.g. uv-downloaded
  # Python interpreters, used by `uv tool install marker-pdf` and similar
  # ML CLIs that can't be packaged in nixpkgs due to upstream dep
  # incompatibilities). Provides /lib64/ld-linux-x86-64.so.2 + a generic
  # glibc-flavored library path so non-Nix binaries can resolve their deps.
  # See https://nix.dev/permalink/stub-ld
  programs.nix-ld.enable = true;

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  programs.mtr.enable = true;
  programs.gnupg.agent = {
    enable = true;
    enableSSHSupport = true;
  };


  # List services that you want to enable:

  # Enable the OpenSSH daemon.
  services.openssh.enable = true;
  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  networking.firewall = {
    enable = true;
    allowedTCPPorts = [ 22 6443 80 443 8642 ];
    trustedInterfaces = [ "tailscale0" "cni0" "flannel.1" ];
  };

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "22.11"; # Did you read the comment?

  # services.vscode-server.enable = true;

  nix = {
    extraOptions = ''
      experimental-features = nix-command flakes ca-derivations
      substituters = https://cache.zw3rk.com https://cache.iog.io https://cache.nixos.org/
      trusted-public-keys = loony-tools:pr9m4BkM/5/eSTZlkQyRt57Jz7OMBxNSUiMC4FkcNfk= hydra.iohk.io:f/Ea+s+dFdN+3Y/G+FDgSq+a5NEWhJGzdjvKNGv0/EQ= cache.nixos.org-1:6NCHdD59X431o0gWypbMrAURkbJ16ZPMQFGspcDShjY=
    '';
  };
  nix.settings.trusted-users = [ "root" "homeserver" ];
  nix.settings.auto-optimise-store = true;

  fonts.packages = with pkgs; [
    fira-code
  ];

  # Docker
  virtualisation.docker = {
    enable = true;
  };

  # Enable tailscale. We manually authenticate when we want with
  # "sudo tailscale up". If you don't use tailscale, you should comment
  # out or delete all of this.
  services.tailscale.enable = true;

  # K3s
  services.k3s = {
    enable = true;
    role = "server";
    extraFlags = builtins.toString [
      "--tls-san=100.119.235.28"
      "--tls-san=nixos"
    ];
  };

  # ── Kata Containers for k3s ────────────────────────────────────────────────
  # Lets pods request VM-isolated execution via `runtimeClassName: kata-qemu`.
  # Each Kata pod gets its own Linux kernel via QEMU/KVM (hardware-virtualized
  # isolation), suitable for multi-tenant workloads.

  boot.kernelModules = [ "vhost_net" "vhost_vsock" ];

  systemd.services.k3s.path = [ pkgs.kata-runtime ];

  systemd.services.k3s.serviceConfig.DeviceAllow = [
    "/dev/kvm rwm"
    "/dev/kmsg rwm"
    "/dev/vhost-vsock rwm"
    "/dev/vhost-net rwm"
    "/dev/net/tun rwm"
  ];

  systemd.tmpfiles.settings."09-k3s"
    ."/var/lib/rancher/k3s/agent/etc/containerd/config-v3.toml.tmpl"."L+".argument =
    let template = ''
      {{ template "base" . }}

      [plugins.'io.containerd.cri.v1.runtime'.containerd.runtimes.'kata-qemu']
        runtime_type = "io.containerd.kata-qemu.v2"
        privileged_without_host_devices = true
        pod_annotations = ["io.katacontainers.*"]
        container_annotations = ["io.katacontainers.*"]
    ''; in "${pkgs.writeText "config-v3.toml.tmpl" template}";
}
