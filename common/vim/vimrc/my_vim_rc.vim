
set spelllang=en_gb
"set gfn=Monaco:h14
"Roboto Mono for Powerline

set gfn=Roboto\ Mono\ for\ Powerline:h14
if has("gui_running")
  try
    colorscheme solarized
  catch
  endtry
endif
try
  colorscheme termschool
catch
endtry

set ffs=unix,mac,dos
" 1 tab == 2 spaces
set shiftwidth=2
set tabstop=2
set noautochdir
"set autochdir
"autocmd BufEnter * silent! lcd %:p:h


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

" Bind Fufbuffer short cut
nnoremap <leader>nh :noh<CR>
nnoremap <leader>fb :FufBuffer<CR>
nnoremap <leader>ff :FufFile<CR>
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

"autocmd BufWritePost *.hs GhcModCheckAsync

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

set cb=unnamedplus

"syntax enable
"set background=dark
"colorscheme solarized

set cursorline

au InsertEnter * set nocursorline
au InsertEnter * set cursorcolumn
au InsertLeave * set cursorline
au InsertLeave * set nocursorcolumn


autocmd BufEnter *.hs set indentkeys=

"intero vim
autocmd FileType haskell setlocal omnifunc=intero#omnifunc
autocmd FileType haskell vnoremap <buffer> <Leader>g :InteroGoto<CR>
autocmd FileType haskell vnoremap <buffer> <Leader>t :InteroType<CR>
autocmd FileType haskell vnoremap <buffer> <Leader>u :InteroUses<CR>
"autocmd FileType haskell nnoremap <buffer> <Leader>m :call intero#ensurebufmodule()<CR>:call VimuxSendText(":m + ".b:intero_module."\n:reload\n")<CR>

let g:ycm_key_list_select_completion = ['<TAB>', '<Down>']
let g:ycm_key_list_previous_completion = ['<S-TAB>', '<Up>']

"localvimrc settings
let g:localvimrc_persistent = 2
let g:localvimrc_whitelist=['.*/dev/circuithub/\(client\|projects\|api\)/\.lvimrc']

"elm-vim
"let g:elm_make_show_warnings = 0
"let g:elm_syntastic_show_warnings = 0
"let g:elm_setup_keybindings = 0
"au FileType elm nmap <leader>m <Plug>(elm-make)

"map <Backspace> λ
" let maplocalleader = "<Backspace>"
let g:elm_syntastic_show_warnings = 0
let g:elm_jump_to_error = 0
let g:elm_make_output_file = "elm.js"
let g:elm_make_show_warnings = 1
let g:elm_browser_command = ""
let g:elm_detailed_complete = 1
let g:elm_format_autosave = 1
let g:elm_format_fail_silently = 1
let g:elm_setup_keybindings = 0 " key bindings don't seem to work
au BufNewFile,BufRead *.elm set filetype=elm " for some reason this seems to be required by elm filetype - don't know why
au FileType elm nmap <leader>m <Plug>(elm-make)
au FileType elm nmap <leader>n <Plug>(elm-error-detail)
au FileType elm nmap <leader>d <Plug>(elm-show-docs)

"set statusline+=%#warningmsg#
"set statusline+=%{SyntasticStatuslineFlag()}
"set statusline+=%*

let g:syntastic_always_populate_loc_list = 1
let g:syntastic_auto_loc_list = 1
let g:syntastic_check_on_open = 1
let g:syntastic_check_on_wq = 0
let g:syntastic_elm_checkers = ["elm_make"]
let g:syntastic_mode_map = {
    \ "mode": "active",
    \ "active_filetypes": ["elm", "coffee"],
    \ "passive_filetypes": ["haskell"] }

function! Ale_linters_haskell_hdevtools2_GetCommand(buffer) abort
   return 'hdevtools check -g -Wall '
    \   .  get(g:, 'hdevtools_options', '')
    \   . ' -p %s %t'
endfunction

call ale#linter#Define('haskell', {
\   'name': 'hdevtools2',
\   'executable': 'hdevtools',
\   'command_callback': 'Ale_linters_haskell_hdevtools2_GetCommand',
\   'callback': 'ale#handlers#HandleGhcFormat',
\})

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

let g:ale_linters =
  \ {'haskell': ['hlint2','hdevtools2']
  \ ,'Elm': ['elm-make']
  \ }
let g:ale_sign_column_always = 1
"set statusline+=%#warningmsg#
"set statusline+=%{ALEGetStatusLine()}
"set statusline+=%*
"let g:ale_statusline_format = ['⨉ %d', '⚠ %d', '⬥ ok']
let g:ale_sign_error = 'e'
let g:ale_sign_warning = 'w'
