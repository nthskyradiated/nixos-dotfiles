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

  # System-wide programs
  programs.firefox.enable = true;

  # System packages
  environment.systemPackages = with pkgs; [
    vim
    wget
    ghostty
    waybar
    kitty
    wofi
    librewolf
    hyprpaper
    # Optional: if you want virt-manager GUI
    virt-manager
  ];

  # Fonts
  fonts.packages = with pkgs; [
    jetbrains-mono
    nerd-fonts.fira-code
    nerd-fonts.caskaydia-mono
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
  
  virtualisation.docker.enable = true;

  # Nix settings
  nix.settings.experimental-features = [ "nix-command" "flakes" ];

  system.stateVersion = "25.11";
}
