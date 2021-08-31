
function! s:GetProjectRoot(buffer) abort
    " Search for the hie.yaml first
    let l:project_file = ale#path#FindNearestFile(a:buffer, 'hie.yaml')

    " If it's empty, search for the cable.project
    if empty(l:project_file)
        " Search all of the paths except for the root filesystem path.
      let l:project_file = ale#path#FindNearestFile(a:buffer, 'cabal.project')
    endif

    " If it's empty, search for the stack.yaml
    if empty(l:project_file)
        " Search all of the paths except for the root filesystem path.
      let l:project_file = ale#path#FindNearestFile(a:buffer, 'stack.yaml')
    endif

    " If it's empty, search for the cabal file
    if empty(l:project_file)
        " Search all of the paths except for the root filesystem path.
      let l:project_file = ale#path#FindNearestFile(a:buffer, '*.cabal')
    endif

    " If it's empty, search for the git directory
    if empty(l:project_file)
        " Search all of the paths except for the root filesystem path.
      let l:project_file = ale#path#FindNearestFile(a:buffer, '.git')
    endif

    " If we still can't find one, use the current file.
    if empty(l:project_file)
        let l:project_file = expand('#' . a:buffer . ':p')
    endif

    return fnamemodify(l:project_file, ':h')
endfunction

call ale#linter#Define('haskell', {
\   'name': 'ghcide',
\   'lsp': 'stdio',
\   'command': {b -> 'haskell-language-server --cwd ' . s:GetProjectRoot(b) . ' --lsp'},
\   'executable': 'haskell-language-server',
\   'project_root': {b -> s:GetProjectRoot(b)},
\})
