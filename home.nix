{ config, pkgs, ... }:

{
    imports = [
    ./modules/neovim.nix  # Just import the module
    ./modules/vim.nix  # Just import the module
  ];

  home.username = "andy";
  home.homeDirectory = "/home/andy";
  home.stateVersion = "25.11";

  # User-specific packages
  home.packages = with pkgs; [
    # Shell utilities
    tealdeer
    bat
    eza
    ripgrep
    fd
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
    libnotify
    gnome-themes-extra
    papirus-icon-theme

    #Neovim packages
    gopls
    typescript-language-server
    svelte-language-server
    yaml-language-server
    terraform-ls
    docker-ls
    lua-language-server
    vscode-json-languageserver

    (pkgs.writeShellScriptBin "ns" ''
      export PATH="${pkgs.lib.makeBinPath [ pkgs.fzf pkgs.nix-search-tv ]}:$PATH"
      ${builtins.readFile "${pkgs.nix-search-tv.src}/nixpkgs.sh"}
    '')
  ];
  
  gtk = {
  enable = true;

  font = {
    name = "Adwaita";
    size = 11;
  };

  iconTheme = {
    name = "Papirus-Dark";  # Use dark variant
    package = pkgs.papirus-icon-theme;
  };

  theme = {
    name = "Adwaita-dark";
    package = pkgs.gnome-themes-extra;
  };

  gtk3.extraConfig = {
    gtk-application-prefer-dark-theme = true;
  };

  gtk4.extraConfig = {
    gtk-application-prefer-dark-theme = true;
  };
};

qt = {
  enable = true;
  platformTheme.name = "gtk3";
  style.name = "adwaita-dark";
};

  # Git
  programs.git.enable = true;

  # Bash with bold, colored prompt
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
      # Colors and bold
      BOLD="\[\e[1m\]"
      GREEN="\[\e[32m\]"
      CYAN="\[\e[36m\]"
      BLUE="\[\e[34m\]"
      RESET="\[\e[0m\]"

      # Two-line bold prompt
      PS1="''${BOLD}''${GREEN}\u@\h''${BLUE}:''${GREEN}\w''${CYAN}$\n=>''${RESET} "
    '';
  };

  # Hyprland
  wayland.windowManager.hyprland = {
    enable = true;
    systemd.enable = false;
  };

  # Config files managed by Home Manager
  home.file.".config/hypr".source    = ./config/hypr;
  home.file.".config/dolphinrc".source    = ./config/dolphin/dolphinrc;
  home.file.".config/wofi".source    = ./config/wofi;
  home.file.".config/waybar".source  = ./config/waybar;
  home.file.".config/ghostty".source = ./config/ghostty;
  home.file.".config/hypr/scripts/toggle-audio.sh" = {
  source = ./config/hypr/scripts/toggle-audio.sh;
  executable = true;
};

}

