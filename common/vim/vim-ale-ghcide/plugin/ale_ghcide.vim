
function! s:GetProjectRoot(buffer) abort
    " Search for the stack file first
    let l:project_file = ale#path#FindNearestFile(a:buffer, 'hie.yaml')

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
\   'command_callback': {b -> 'ghcide --cwd ' . s:GetProjectRoot(b) .' --lsp'},
\   'executable': 'ghcide',
\   'project_root_callback': {b -> s:GetProjectRoot(b)},
\})
