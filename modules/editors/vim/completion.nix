# Vim autocompletion configuration
''
  " ============================================================================
  " Asyncomplete (autocompletion)
  " ============================================================================
  let g:asyncomplete_auto_popup = 1
  let g:asyncomplete_auto_completeopt = 0
  
  inoremap <expr> <Tab>   pumvisible() ? "\<C-n>" : "\<Tab>"
  inoremap <expr> <S-Tab> pumvisible() ? "\<C-p>" : "\<S-Tab>"
  inoremap <expr> <cr>    pumvisible() ? asyncomplete#close_popup() : "\<cr>"
''
