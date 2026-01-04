# Vim UI configuration (theme, statusline, etc.)
''
  " ============================================================================
  " Theme
  " ============================================================================
  set background=dark
  let g:tokyonight_style = 'night'
  let g:tokyonight_enable_italic = 1
  let g:tokyonight_transparent_background = 1
  colorscheme tokyonight

  highlight LineNr guifg=#e0af68 ctermfg=180
  highlight CursorLineNr guifg=#ff9e64 gui=bold cterm=bold ctermfg=215

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
  " GitGutter
  " ============================================================================
  let g:gitgutter_sign_added = '+'
  let g:gitgutter_sign_modified = '~'
  let g:gitgutter_sign_removed = '-'
  let g:gitgutter_sign_removed_first_line = '^'
  let g:gitgutter_sign_modified_removed = '~'
''
