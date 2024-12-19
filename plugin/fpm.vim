" Fast Plugin Manager (FPM)
" This script manages plugins, with a UI interface for easier visualization and management.
" Author: BrunoCiccarino
" Written in: 12/18/2024
"
" let g:plugins = {
"    \ 'junegunn/fzf': {},
"    \ 'tpope/vim-surround': {}
"\ }
"
"call fpm#check_and_install_plugins() 
"


let s:hash_file = expand('~/.vim/.fast.toml')

function! fpm#ui()
    if !exists('g:plugins') || type(g:plugins) != v:t_dict
        echoerr "Error: g:plugins is not defined or is not a valid dictionary."
        return
    endif

    let plugin_dir_root = expand('~/.vim/plugged')
    if !isdirectory(plugin_dir_root)
        call mkdir(plugin_dir_root, 'p')
    endif

    let hashes = fpm#read_hash_file()

    let opts = {
        \ 'line': 5,
        \ 'col': 10,
        \ 'minwidth': 60,
        \ 'minheight': 20,
        \ 'border': [],
        \ 'title': 'Fast Plugin Manager'
    \ }

    let lines = ['=== Fast Plugin Manager ===', '']

    for [user_plugin, options] in items(g:plugins)
        let plugin_name = split(user_plugin, '/')
        if len(plugin_name) != 2
            echoerr 'Invalid plugin name: ' . user_plugin
            continue
        endif

        let plugin_dir = expand(plugin_dir_root . '/' . plugin_name[1])
        let status = isdirectory(plugin_dir) ? 'Installed' : 'Not installed'
        let hash = get(hashes, user_plugin, 'Unknown')
        let line = printf('%-40s %-15s %s', user_plugin, status, hash)
        call add(lines, line)
    endfor

    call add(lines, '')
    call add(lines, 'Commands:')
    call add(lines, ' [Q] Quit [U] Update plugins [X] Install missing plugins')

    let popup_buf = popup_create(lines, opts)
    call fpm#ui_mappings(popup_buf)
endfunction

function! fpm#initialize_ui()
    if !exists('g:plugins') || empty(g:plugins)
        echom "No plugins defined in g:plugins"
        return
    endif

    let missing_plugins = 0
    for user_plugin in keys(g:plugins)
        let plugin_name = split(user_plugin, '/')
        if len(plugin_name) != 2
            continue
        endif
        let plugin_dir = expand('~/.vim/plugged/' . plugin_name[1])
        if !isdirectory(plugin_dir)
            let missing_plugins += 1
        endif
    endfor

    if missing_plugins > 0
        call fpm#ui_install()
    else
        call fpm#ui()
    endif
endfunction

function! fpm#check_and_install_plugins()
    if !exists('g:plugins') || empty(g:plugins)
        return
    endif

    let hashes = fpm#read_hash_file()

    for user_plugin in keys(g:plugins)
        let plugin_name = split(user_plugin, '/')
        if len(plugin_name) != 2
            echoerr 'Invalid plugin name: ' . user_plugin
            continue
        endif

        let plugin_dir = expand('~/.vim/plugged/' . plugin_name[1])
        if !isdirectory(plugin_dir)
            call fpm#install_plugin(user_plugin)
        endif
    endfor
endfunction

function! fpm#install_plugin(user_plugin)
    let plugin_name = split(a:user_plugin, '/')
    if len(plugin_name) != 2
        echoerr 'Invalid plugin format: ' . a:user_plugin . '. Expected "user/repo".'
        return
    endif

    let plugin_dir_root = expand('~/.vim/plugged')

    if !isdirectory(plugin_dir_root)
        call mkdir(plugin_dir_root, 'p')
    endif

    let plugin_dir = plugin_dir_root . '/' . plugin_name[1]
    let full_repo = 'https://github.com/' . a:user_plugin

    if !isdirectory(plugin_dir)
        let output = system('git clone --depth=1 ' . shellescape(full_repo) . ' ' . shellescape(plugin_dir))
        if v:shell_error
            echoerr 'Error installing plugin ' . a:user_plugin
            return
        endif
        call fpm#ui_install_complete()
    else
        echom 'Plugin ' . a:user_plugin . ' already installed.'
    endif
endfunction

function! fpm#ui_install_complete()
    let lines = ['=== Fast Plugin Manager ===', '', 'Installation complete.']
    let popup_buf = popup_create(lines, {
        \ 'line': 5,
        \ 'col': 10,
        \ 'minwidth': 60,
        \ 'minheight': 20,
        \ 'border': [],
        \ 'title': 'Installation Complete'
    \ })
    call popup_setoptions(popup_buf, {
        \ 'mapping': 1,
        \ 'filter': function('fpm#ui_key_handler'),
        \ 'mappings': {'q': ''} 
    \ })
endfunction

function! fpm#ui_key_handler(...)
    let args = a:000
    let event = get(args, 0, {})

    if type(event) != v:t_dict || !has_key(event, 'char')
        return 0 
    endif

    let char = event.char

    if char ==# 'q' || char ==# 'Q'
        call fpm#ui_close()
    else
        return 0
    endif

    return 1 
endfunction

function! fpm#ui_close()
    call popup_close(popup_getcurwin())
endfunction

function! fpm#read_hash_file()
    if filereadable(s:hash_file)
        try
            return json_decode(join(readfile(s:hash_file), ''))
        catch
            return {}
        endtry
    endif
    return {}
endfunction

function! fpm#write_hash_file(hashes)
    let toml_content = json_encode(a:hashes)
    call writefile(split(toml_content, '\n'), s:hash_file)
endfunction

autocmd VimEnter * call fpm#check_and_install_plugins()

