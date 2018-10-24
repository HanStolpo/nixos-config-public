
set spelllang=en_gb

set gfn=Roboto\ Mono\ for\ Powerline:h14

set ffs=unix,mac,dos
set shiftwidth=2
set tabstop=2
set noautochdir


au BufEnter *.spec setfiletype coffee 

if has("gui_running")
  set guioptions-=T "Remove toolbar
  set guioptions-=r "Remove right-handed scrollbar
  set guioptions-=R "Remove right-handed scrollbar
  set guioptions-=l "??Remove right-handed scrollbar
  set guioptions-=L "??Remove right-handed scrollbar
endif

set ruler "Show the cursor position all the time.

set relativenumber "View the distance to the next line (useful with d commands). When this is set, number is reset.

set nowrap "Don't perform line wrapping.

set hidden " Don't close buffers, only hide them. Unwritten changes allowed.

" clear highlighting
nnoremap <leader>nh :noh<CR>
nnoremap <C-s> :w<CR>

" Navigation
nnoremap <C-t> <C-w><C-t>
nnoremap <C-b> <C-w><C-b>
nnoremap <C-p> <C-w><C-p>

" Move quick fix window to bottom
autocmd FileType qf wincmd J

" Open tag bar on the left
let g:tagbar_left = 1

"let g:ctrlp_root_markers = ['ch'] "add circuit hub root
let g:ctrlp_custom_ignore={
  \'dir': '\v(elm-stuff)|(dist-newstyle)|(dist-repl)|(node_modules)|(\..*)',
  \'file': '\v.*\.orig$'
  \}
" Session related
if ! exists("g:session_autoload")
  let g:session_autoload = 'no'
endif
let g:session_autosave = 'yes'
let g:session_default_to_last = 0
let g:session_persist_colors = 0
" Disable all session locking - I know what I'm doing :-).
let g:session_lock_enabled = 0

set wildignore+=*.o,*.obj,*.hi,*.dyn_hi,*.dyn_o,.cabal-sandbox/**/

function! DeleteHiddenBuffers()
  let tpbl=[]
  let closed = 0
  call map(range(1, tabpagenr('$')), 'extend(tpbl, tabpagebuflist(v:val))')
  for buf in filter(range(1, bufnr('$')), 'bufexists(v:val) && index(tpbl, v:val)==-1')
    if getbufvar(buf, '&mod') == 0
      silent execute 'bwipeout' buf
      let closed += 1
    endif
  endfor
  echo "Closed ".closed." hidden buffers"
endfunction

"system clipboard is default clipboard
set cb=unnamedplus
set cursorline

au InsertEnter * set nocursorline
au InsertEnter * set cursorcolumn
au InsertLeave * set cursorline
au InsertLeave * set nocursorcolumn


autocmd BufEnter *.hs set indentkeys=
autocmd BufEnter *.nix set indentkeys=
autocmd BufEnter *.elm set indentkeys=


"localvimrc settings
let g:localvimrc_persistent = 2
let g:localvimrc_whitelist=['.*/dev/circuithub/\(client\|projects\|api\)/\.lvimrc']

"elm-vim
let g:elm_syntastic_show_warnings = 0
let g:elm_jump_to_error = 0
let g:elm_make_output_file = "elm.js"
let g:elm_make_show_warnings = 1
let g:elm_browser_command = ""
let g:elm_detailed_complete = 1
"let g:elm_format_autosave = 1
let g:elm_format_fail_silently = 1
let g:elm_setup_keybindings = 0 " key bindings don't seem to work
au BufNewFile,BufRead *.elm set filetype=elm " for some reason this seems to be required by elm filetype - don't know why


function! Ale_linters_haskell_hlint_Command(buffer) abort

    let l:opts = ''
  if exists("g:ghcmod_hlint_options")
    let l:opts = '"' . join(g:ghcmod_hlint_options, '" "') . '"'
  endif
   return 'hlint '
    \   .  l:opts
    \   . ' --color=never --json -'
endfunction

function! Ale_linters_haskell_hlint_Handle(buffer, lines) abort
    let l:errors = json_decode(join(a:lines, ''))

    let l:output = []

    for l:error in l:errors
        " vcol is Needed to indicate that the column is a character.
        call add(l:output, {
        \   'bufnr': a:buffer,
        \   'lnum': l:error.startLine + 0,
        \   'vcol': 0,
        \   'col': l:error.startColumn + 0,
        \   'text': l:error.severity . ': ' . l:error.hint . '. Found: ' . l:error.from . ' Why not: ' . l:error.to,
        \   'type': l:error.severity ==# 'Error' ? 'E' : 'W',
        \})
    endfor

    return l:output
endfunction

call ale#linter#Define('haskell', {
\   'name': 'hlint2',
\   'executable': 'hlint',
\   'command_callback': 'Ale_linters_haskell_hlint_Command',
\   'callback': 'Ale_linters_haskell_hlint_Handle',
\})

call ale#Set('haskell_cabal_new_ghc_options', '-fno-code -v0')

function! Ale_linters_haskell_cabal_new_ghc_GetCommand(buffer) abort
    return 'cabal new-exec -- ghc '
    \   . ale#Var(a:buffer, 'haskell_cabal_new_ghc_options')
    \   . ' %t'
endfunction

call ale#linter#Define('haskell', {
\   'name': 'cabal_new_ghc',
\   'aliases': ['cabal-new-ghc'],
\   'output_stream': 'stderr',
\   'executable': 'cabal',
\   'command_callback': 'Ale_linters_haskell_cabal_new_ghc_GetCommand',
\   'callback': 'ale#handlers#haskell#HandleGHCFormat',
\})

let g:ale_linters =
  \ {'haskell': ['hlint2']
  \ }
let g:ale_fixers = {
  \   'elm': ['elm-format'],
  \   'haskell': ['ch-hs-format'],
  \}
let g:ale_sign_column_always = 1
let g:ale_sign_error = 'e'
let g:ale_sign_warning = 'w'
let g:ale_fix_on_save = 1
let g:ale_completion_enable = 1
let g:ale_lint_delay = 2000

nmap <leader>d <Plug>(ale_detail)
nmap <silent> <M-k> <Plug>(ale_previous_wrap)
nmap <silent> <M-j> <Plug>(ale_next_wrap)

set hidden
let g:LanguageClient_serverCommands = {
    \ 'haskell': ['hie', '--lsp', '--vomit', '-d'],
    \ 'reason': ['ocaml-language-server', '--stdio'],
    \ 'ocaml': ['ocaml-language-server', '--stdio']
    \ }

if filereadable(expand("~/.vimrc_background"))
  let base16colorspace=256
  source ~/.vimrc_background
endif
