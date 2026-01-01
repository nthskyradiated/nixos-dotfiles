# Vim module (vim.nix)
# Save this file as: ~/nixos-config/modules/vim.nix
# Then import it in your home.nix with: imports = [ ./modules/vim.nix ];

{ config, pkgs, ... }:

let
  # Build tokyonight-vim from GitHub since it's not in nixpkgs
  tokyonight-vim = pkgs.vimUtils.buildVimPlugin {
    name = "tokyonight-vim";
    src = pkgs.fetchFromGitHub {
      owner = "ghifarit53";
      repo = "tokyonight-vim";
      rev = "master";  # Use master branch instead of a tag
      sha256 = "sha256-ui/6xv8PH6KuQ4hG1FNMf6EUdF2wfWPNgG/GMXYvn/8=";
    };
  };
in
{
  # Add required packages to home.packages instead
  home.packages = with pkgs; [
    # FZF and search tools
    fzf
    ripgrep
    fd
    bat
    
    # LSP servers (same as nvim)
    nodePackages.typescript-language-server
    # Note: vscode-langservers-extracted already in neovim module
    gopls
    terraform-ls
    yaml-language-server
    
    # Formatters
    nodePackages.prettier
  ];

  programs.vim = {
    enable = true;
    defaultEditor = false; # Set to true if you want vim as default instead of nvim
    
    plugins = with pkgs.vimPlugins; [
      # Theme - fetched from GitHub
      tokyonight-vim
      
      # Fuzzy finding
      fzf-vim
      
      # LSP and completion
      vim-lsp
      vim-lsp-settings
      asyncomplete-vim
      asyncomplete-lsp-vim
      
      # Status line
      lightline-vim
      
      # File navigation (harpoon alternative)
      vim-startify  # Quick access to recently used files
      
      # Useful utilities
      vim-commentary
      vim-surround
      vim-repeat
      auto-pairs
      vim-gitgutter
      
      # Language support
      vim-terraform
      vim-go
      typescript-vim
      vim-javascript
    ];

    settings = {
      number = true;
      relativenumber = true;
      expandtab = true;
      tabstop = 2;
      shiftwidth = 2;
      ignorecase = true;
      smartcase = true;
      mouse = "a";
    };

    extraConfig = ''
      " ============================================================================
      " Leader key
      " ============================================================================
      let mapleader = " "
      let maplocalleader = " "

      " ============================================================================
      " Basic settings
      " ============================================================================
      set nocompatible
      set hidden
      set updatetime=300
      set signcolumn=yes
      set cmdheight=2
      set shortmess+=c
      set completeopt=menu,menuone,noselect
      
      " Transparency/opacity
      if has('termguicolors')
        set termguicolors
      endif
      
      " Window transparency (works in terminals that support it)
      highlight Normal guibg=NONE ctermbg=NONE
      highlight NonText guibg=NONE ctermbg=NONE
      highlight LineNr guibg=NONE ctermbg=NONE
      highlight SignColumn guibg=NONE ctermbg=NONE
      highlight EndOfBuffer guibg=NONE ctermbg=NONE

      " ============================================================================
      " Theme
      " ============================================================================
      set background=dark
      " Tokyonight configuration
      let g:tokyonight_style = 'night'
      let g:tokyonight_enable_italic = 1
      let g:tokyonight_transparent_background = 1
      colorscheme tokyonight

      " ============================================================================
      " Lightline
      " ============================================================================
      let g:lightline = {
        \ 'colorscheme': 'tokyonight',
        \ 'active': {
        \   'left': [ [ 'mode', 'paste' ],
        \             [ 'readonly', 'filename', 'modified' ] ],
        \   'right': [ [ 'lineinfo' ],
        \              [ 'percent' ],
        \              [ 'fileformat', 'fileencoding', 'filetype' ] ]
        \ },
        \ }
      set laststatus=2
      set noshowmode

      " ============================================================================
      " FZF Configuration
      " ============================================================================
      " Use ripgrep for FZF if available
      if executable('rg')
        let $FZF_DEFAULT_COMMAND = 'rg --files --hidden --follow --glob "!.git/*"'
      endif

      " FZF window settings
      let g:fzf_layout = { 'down': '40%' }
      let g:fzf_preview_window = ['right:50%', 'ctrl-/']

      " Customize fzf colors to match tokyonight
      let g:fzf_colors = {
        \ 'fg':      ['fg', 'Normal'],
        \ 'bg':      ['bg', 'Normal'],
        \ 'hl':      ['fg', 'Comment'],
        \ 'fg+':     ['fg', 'CursorLine', 'CursorColumn', 'Normal'],
        \ 'bg+':     ['bg', 'CursorLine', 'CursorColumn'],
        \ 'hl+':     ['fg', 'Statement'],
        \ 'info':    ['fg', 'PreProc'],
        \ 'border':  ['fg', 'Ignore'],
        \ 'prompt':  ['fg', 'Conditional'],
        \ 'pointer': ['fg', 'Exception'],
        \ 'marker':  ['fg', 'Keyword'],
        \ 'spinner': ['fg', 'Label'],
        \ 'header':  ['fg', 'Comment']
        \ }

      " ============================================================================
      " LSP Configuration
      " ============================================================================
      let g:lsp_diagnostics_enabled = 1
      let g:lsp_signs_enabled = 1
      let g:lsp_diagnostics_echo_cursor = 1
      let g:lsp_highlights_enabled = 1
      let g:lsp_textprop_enabled = 1
      let g:lsp_signs_error = {'text': '✗'}
      let g:lsp_signs_warning = {'text': '⚠'}
      let g:lsp_signs_hint = {'text': '💡'}

      " Auto-configure LSP servers
      function! s:on_lsp_buffer_enabled() abort
        setlocal omnifunc=lsp#complete
        setlocal signcolumn=yes
        
        " LSP keymaps
        nmap <buffer> gd <plug>(lsp-definition)
        nmap <buffer> gr <plug>(lsp-references)
        nmap <buffer> gi <plug>(lsp-implementation)
        nmap <buffer> K <plug>(lsp-hover)
        nmap <buffer> <leader>rn <plug>(lsp-rename)
        nmap <buffer> <leader>ca <plug>(lsp-code-action)
        nmap <buffer> [d <plug>(lsp-previous-diagnostic)
        nmap <buffer> ]d <plug>(lsp-next-diagnostic)
        nmap <buffer> <leader>f :LspDocumentFormat<CR>
      endfunction

      augroup lsp_install
        au!
        autocmd User lsp_buffer_enabled call s:on_lsp_buffer_enabled()
      augroup END

      " Register LSP servers manually
      if executable('typescript-language-server')
        au User lsp_setup call lsp#register_server({
          \ 'name': 'typescript-language-server',
          \ 'cmd': {server_info->['typescript-language-server', '--stdio']},
          \ 'root_uri':{server_info->lsp#utils#path_to_uri(lsp#utils#find_nearest_parent_file_directory(lsp#utils#get_buffer_path(), 'tsconfig.json'))},
          \ 'whitelist': ['typescript', 'javascript', 'javascriptreact', 'typescriptreact'],
          \ })
      endif

      if executable('gopls')
        au User lsp_setup call lsp#register_server({
          \ 'name': 'gopls',
          \ 'cmd': {server_info->['gopls']},
          \ 'allowlist': ['go', 'gomod'],
          \ })
      endif

      if executable('terraform-ls')
        au User lsp_setup call lsp#register_server({
          \ 'name': 'terraform-ls',
          \ 'cmd': {server_info->['terraform-ls', 'serve']},
          \ 'allowlist': ['terraform', 'tf'],
          \ })
      endif

      if executable('yaml-language-server')
        au User lsp_setup call lsp#register_server({
          \ 'name': 'yaml-language-server',
          \ 'cmd': {server_info->['yaml-language-server', '--stdio']},
          \ 'allowlist': ['yaml', 'yml'],
          \ })
      endif

      if executable('vscode-json-language-server')
        au User lsp_setup call lsp#register_server({
          \ 'name': 'json-language-server',
          \ 'cmd': {server_info->['vscode-json-language-server', '--stdio']},
          \ 'allowlist': ['json', 'jsonc'],
          \ })
      endif

      " ============================================================================
      " Asyncomplete (autocompletion)
      " ============================================================================
      let g:asyncomplete_auto_popup = 1
      let g:asyncomplete_auto_completeopt = 0
      
      inoremap <expr> <Tab>   pumvisible() ? "\<C-n>" : "\<Tab>"
      inoremap <expr> <S-Tab> pumvisible() ? "\<C-p>" : "\<S-Tab>"
      inoremap <expr> <cr>    pumvisible() ? asyncomplete#close_popup() : "\<cr>"

      " ============================================================================
      " Keybindings
      " ============================================================================
      
      " General
      nnoremap <leader>w :w<CR>
      nnoremap <leader>q :q<CR>
      nnoremap <leader>cd :Ex<CR>

      " FZF - File finding
      nnoremap <leader>ff :Files<CR>
      nnoremap <leader>fo :History<CR>
      nnoremap <leader>rg :Rg<CR>
      nnoremap <leader>fb :Buffers<CR>
      nnoremap <leader>fh :Helptags<CR>

      " Window navigation
      nnoremap <C-Left> <C-w>h
      nnoremap <C-Down> <C-w>j
      nnoremap <C-Up> <C-w>k
      nnoremap <C-Right> <C-w>l

      " Better indenting
      vnoremap < <gv
      vnoremap > >gv

      " Move lines
      nnoremap <A-j> :m .+1<CR>==
      nnoremap <A-k> :m .-2<CR>==
      vnoremap <A-j> :m '>+1<CR>gv=gv
      vnoremap <A-k> :m '<-2<CR>gv=gv

      " Clear search highlight
      nnoremap <leader>h :nohlsearch<CR>

      " ============================================================================
      " Startify (Harpoon alternative - quick file access)
      " ============================================================================
      let g:startify_lists = [
        \ { 'type': 'files',     'header': ['   Recent Files']            },
        \ { 'type': 'dir',       'header': ['   Recent Files in '. getcwd()] },
        \ { 'type': 'sessions',  'header': ['   Sessions']       },
        \ { 'type': 'bookmarks', 'header': ['   Bookmarks']      },
        \ ]
      
      let g:startify_bookmarks = [
        \ { 'c': '~/.config' },
        \ { 'n': '~/.config/nixos' },
        \ ]
      
      let g:startify_session_autoload = 1
      let g:startify_session_persistence = 1
      let g:startify_change_to_vcs_root = 1
      
      " Quick access to startify
      nnoremap <leader>s :Startify<CR>

      " ============================================================================
      " GitGutter
      " ============================================================================
      let g:gitgutter_sign_added = '+'
      let g:gitgutter_sign_modified = '~'
      let g:gitgutter_sign_removed = '-'
      let g:gitgutter_sign_removed_first_line = '^'
      let g:gitgutter_sign_modified_removed = '~'

      " ============================================================================
      " Auto-format on save for specific file types
      " ============================================================================
      augroup AutoFormat
        autocmd!
        autocmd BufWritePre *.go :LspDocumentFormatSync
        autocmd BufWritePre *.tf,*.terraform :LspDocumentFormatSync
        autocmd BufWritePre *.js,*.jsx,*.ts,*.tsx :LspDocumentFormatSync
        autocmd BufWritePre *.json,*.yaml,*.yml :LspDocumentFormatSync
      augroup END

      " ============================================================================
      " File type specific settings
      " ============================================================================
      augroup FileTypeSettings
        autocmd!
        autocmd FileType go setlocal tabstop=4 shiftwidth=4 noexpandtab
        autocmd FileType python setlocal tabstop=4 shiftwidth=4
        autocmd FileType javascript,typescript,json,yaml setlocal tabstop=2 shiftwidth=2
      augroup END
    '';
  };
}
