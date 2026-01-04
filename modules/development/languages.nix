# Shared language servers, formatters, and development tools
{ pkgs, ... }:

{
  home.packages = with pkgs; [
    # LSP Servers
    nodePackages.typescript-language-server
    nodePackages.vscode-langservers-extracted  # HTML, CSS, JSON, ESLint
    gopls
    terraform-ls
    yaml-language-server
    lua-language-server
    
    # Formatters
    nodePackages.prettier
    stylua
    
    # Search and navigation tools
    ripgrep
    fd
    fzf
    bat
  ];
}
