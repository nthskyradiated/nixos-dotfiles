{ config, lib, pkgs, ... }:

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

  # Localization
  time.timeZone = "Asia/Dubai";

  # Audio
  security.rtkit.enable = true; # Enable RealtimeKit for audio purposes

  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    # Uncomment the following line if you want to use JACK applications
    # jack.enable = true;
  };

  # Bluetooth
  hardware.bluetooth = {
    enable = true;
    powerOnBoot = true;
  };
  # Hyprland (system-level)
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
    vim
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
    brightnessctl
  ];

  # Fonts
  fonts.packages = with pkgs; [
    jetbrains-mono
    nerd-fonts.fira-code
    nerd-fonts.caskaydia-mono
    adwaita-fonts
    fira-code
    fira-code-symbols
  ];

  # Virtualization - simplified config
  virtualisation.libvirtd = {
    enable = true;
    qemu = {
       package = pkgs.qemu_kvm;  # Use KVM-only version
       runAsRoot = false;
       swtpm.enable = true;  # TPM emulation for Windows 11, etc.
     };
   };
   programs.virt-manager.enable = true;
   virtualisation.docker.enable = true;

  # Nix settings
  nix.settings.experimental-features = [ "nix-command" "flakes" ];

  system.stateVersion = "25.11";
}
