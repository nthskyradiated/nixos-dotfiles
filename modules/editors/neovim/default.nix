# Main Neovim module - imports all submodules
{ config, pkgs, ... }:

let
  plugins = import ./plugins.nix { inherit pkgs; };
  options = import ./options.nix;
  keymaps = import ./keymaps.nix;
  ui = import ./ui.nix;
  lsp = import ./lsp.nix;
  completion = import ./completion.nix;
  navigation = import ./navigation.nix;
  treesitter = import ./treesitter.nix { inherit pkgs; };
in
{
  programs.neovim = {
    enable = true;
    defaultEditor = true;
    viAlias = true;
    vimAlias = false;
    vimdiffAlias = true;

    plugins = plugins;

    extraLuaConfig = ''
      -- Leader key must be set first
      vim.g.mapleader = ' '
      vim.g.maplocalleader = ' '

      -- Enable termguicolors FIRST before anything else
      if vim.fn.has('termguicolors') == 1 then
        vim.opt.termguicolors = true
      end

      ${options}
      ${ui}
      ${treesitter}
      ${lsp}
      ${completion}
      ${navigation}
      ${keymaps}
    '';
  };
}
