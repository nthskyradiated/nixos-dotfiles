# Vim editor options
''
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
  " File type specific settings
  " ============================================================================
  augroup FileTypeSettings
    autocmd!
    autocmd FileType go setlocal tabstop=4 shiftwidth=4 noexpandtab
    autocmd FileType python setlocal tabstop=4 shiftwidth=4
    autocmd FileType javascript,typescript,json,yaml setlocal tabstop=2 shiftwidth=2
  augroup END
''
