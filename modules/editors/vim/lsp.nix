# Vim LSP configuration
''
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
  " Auto-format on save for specific file types
  " ============================================================================
  augroup AutoFormat
    autocmd!
    autocmd BufWritePre *.go :LspDocumentFormatSync
    autocmd BufWritePre *.tf,*.terraform :LspDocumentFormatSync
    autocmd BufWritePre *.js,*.jsx,*.ts,*.tsx :LspDocumentFormatSync
    autocmd BufWritePre *.json,*.yaml,*.yml :LspDocumentFormatSync
  augroup END
''
