{ config, pkgs, ... }:

{
  home.username = "andy";
  home.homeDirectory = "/home/andy";
  home.stateVersion = "25.11";

  # User-specific packages
  home.packages = with pkgs; [
    # Editors
    neovim
    
    # Shell utilities
    tealdeer
    bat
    eza
    ripgrep
    fzf
    btop
    shellcheck

    # Development tools
    go
    nodejs_24
    pnpm
    deno
    python314
    
    # Kubernetes tools
    kubectl
    kubeseal
    kubernetes-helm
    k9s
    
    # Data tools
    yq
    jq
    
    # Other utilities
    ansible
    nil
    nixpkgs-fmt 

(pkgs.writeShellScriptBin "ns" ''
  export PATH="${pkgs.lib.makeBinPath [ pkgs.fzf pkgs.nix-search-tv ]}:$PATH"
  ${builtins.readFile "${pkgs.nix-search-tv.src}/nixpkgs.sh"}
'')
];


  programs.git.enable = true;

  programs.bash = {
    enable = true;
    shellAliases = {
      cat = "bat";
      ls = "exa -l --icons";
      k = "kubectl";
      nrs = "sudo nixos-rebuild switch";
};
    profileExtra = ''
      if [ -z "$WAYLAND_DISPLAY" ] && [ "$(tty)" = "/dev/tty1" ]; then
        exec uwsm start hyprland-uwsm.desktop
      fi
    '';
    initExtra = ''
      # Colors
  GREEN="\[\e[32m\]"
  CYAN="\[\e[36m\]"
  BLUE="\[\e[34m\]"
  RESET="\[\e[0m\]"

  # Two-line prompt (note the ''${VAR} escaping trick)
  PS1="''${GREEN}\u@\h''${BLUE}:''${GREEN}\w''${CYAN}$\n=>''${RESET} "
  '';
  };

  wayland.windowManager.hyprland = {
    enable = true;
    systemd.enable = false;
  };

  home.file.".config/hypr".source = ./config/hypr;
  home.file.".config/waybar".source = ./config/waybar;
  home.file.".config/ghostty".source = ./config/ghostty;
}
