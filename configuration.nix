{ config, pkgs, lib, ... }:

{
  imports = [
    ./hardware-configuration.nix
  ];

  # Boot configuration
  boot.loader.efi.efiSysMountPoint = "/boot/efi";
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  services.getty.autologinUser = "andy";

  # Networking
  networking.hostName = "nixos";
  networking.networkmanager.enable = true;

networking.hosts = {
  "192.168.100.200" = [ "loadbalancer" ];
  "192.168.100.211" = [ "controlplane01" ];
  "192.168.100.212" = [ "controlplane02" ];
  "192.168.100.213" = [ "controlplane03" ];
  "192.168.100.221" = [ "node01" ];
  "192.168.100.222" = [ "node02" ];
  "192.168.100.223" = [ "node03" ];
};

  # Localization
  time.timeZone = "Asia/Dubai";

  # Audio
  security.rtkit.enable = true; # RealtimeKit for audio
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
  };

  # Bluetooth
  hardware.bluetooth = {
    enable = true;
    powerOnBoot = true;
  };

  # Hyprland
  programs.hyprland = {
    enable = true;
    xwayland.enable = true;
    withUWSM = true;
  };

  # User configuration
  users.users.andy = {
    isNormalUser = true;
    extraGroups = [ "wheel" "docker" "libvirtd" "networkmanager" ];
  };

  # System packages
  environment.systemPackages = with pkgs; [
    tree
    wget
    ghostty                 # Main Terminal
    waybar                  # Wayland Bar
    kitty                   # Terminal
    wofi                    # Launcher
    librewolf               # Web Browser
    hyprpaper               # Wallpaper Manager
    kdePackages.dolphin     # File Browser
    vlc                     # Media Playeer
    pavucontrol             # PulseAudio Volume Control
    pamixer                 # Command-line mixer for PulseAudio
    bluez                   # Bluetooth support
    bluez-tools             # Bluetooth tool
    brightnessctl           # Brightness control
    swayosd                 # display for volume / brightness
    cdrkit                  # ISO creator for kubernetes VM

  (python313.withPackages (ps: with ps; [
    ansible-core
    libvirt
    lxml
    xmltodict
  ]))

  ];

  # Fonts
  fonts.packages = with pkgs; [
    jetbrains-mono
    nerd-fonts.fira-code
    nerd-fonts.caskaydia-mono
    adwaita-fonts
  ];

  # Virtualization
  virtualisation.libvirtd = {
    enable = true;
    qemu = {
      package = pkgs.qemu_kvm;
      runAsRoot = false;
      swtpm.enable = true;
    };
  };
  programs.virt-manager.enable = true;
  virtualisation.docker.enable = true;

  # Nix settings
  nix.settings.experimental-features = [ "nix-command" "flakes" ];

  # System version
  system.stateVersion = "25.11";
}

