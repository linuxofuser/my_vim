# neovim_vimrc



" request
"   1. nodejs
"   2. yarn
"   3. ccls  "not find;
"   4. cocconfig 
"




" ======================
" === Enhance Editor ===
" ======================


" 显示行号
set number
" 显示行号
set relativenumber
" tab转换为空格
set expandtab
" 设置tab为4空格
set tabstop=4
set shiftwidth=4
set softtabstop=4
" 忽略大小写
set ignorecase
" 智能大小写
set smartcase 
" 关闭命令输入超时
set notimeout
" 设置跳转方式为栈跳转
set jumpoptions=stack
" 设置leader键为空格
let mapleader="\<SPACE>"
" 
" ===
" === Auto load for first time uses
" ===
if empty(glob('~/.config/nvim/autoload/plug.vim'))
  :exe '!curl -fLo ~/.config/nvim/autoload/plug.vim --create-dirs
    \ https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim'
  autocmd VimEnter * PlugInstall --sync | source $MYVIMRC
endif
" 
" ======================
" === plugins begin ====
" ======================
call plug#begin('~/.config/nvim/plugged')
    " enhanceeditor
    Plug 'tomtom/tcomment_vim'

    "terminal
    Plug 'skywind3000/vim-terminal-help'
    
    " file explorer 
    Plug 'preservim/nerdtree'
    
    "file finder
    Plug 'Yggdroot/LeaderF',{'do': 'LeaderfInstallCExtension'}
    
    " high light
    Plug 'cateduo/vsdark.nvim'
    Plug 'jackguo380/vim-lsp-cxx-highlight'
    
    " lsp 
    Plug 'neoclide/coc.nvim', {'branch': 'release'}
    
    " debug
    Plug 'puremourning/vimspector', {'do': './install_gadget.py --enable-rust --enable-python'}


    Plug 'vim-airline/vim-airline'
call plug#end()
" ====tomtom/tcomment_vim====
let g:tcomment_textobject_inlinecomment = ''
nmap <LEADER>cn g>c
vmap <LEADER>cn g>
nmap <LEADER>cu g<c
vmap <LEADER>cu g<

" === preservim/nerdtree === 空格+e
nnoremap <LEADER>e :NERDTreeToggle<CR>

" ===Yggdroot/LeaderF ====
let g:Lf_windowPosition='right'
let g:Lf_PreviewInPopup=1
let g:Lf_CommandMap={
\  '<C-p>': ['<C-k>'],
\  '<C-k>': ['<C-p>'],
\  '<C-j>': ['<C-n>']
\  }
nmap <leader>f :Leaderf file<CR>
nmap <leader>b :Leaderf! buffer<CR>
nmap <leader>F :Leaderf rg<CR>
let g:Lf_DevIconsFont = "DroidSansMono Nerd Font Mono"

" === cateduo/vsdark.nvim ===
set termguicolors
let g:vsdark_style = "dark"
colorscheme vsdark

" ===jackguo380/vim-lsp-cxx-highlight==
hi default link LspCxxHlsymFunction cxxFunction
hi default link LspCxxHlsymFunctionParameter cxxParameter
hi default link LspCxxHlSymFileVariableStatic cxxFileVariableStatic
hi default link LspCxxHlsymstruct cxxstruct
hi default link LspCxxHlSymStructField cxxStructField
hi default link LspCxxHlSymFileTypeAlias cxxTypeAlias
hi default link LspCxxHlSymclassField cxxStructField
hi default link LspCxxHlSymEnum cxxEnum
hi default link LspCxxHlSymVariableExtern cxxFileVariableStatic
hi default link LspCxxHlSymVariable cxxVariable
hi default link LspCxxHlsymMacro cxxMacro
hi default link LspCxxHlSymEnumMember cxxEnumMember
hi default link LspCxxHlSymParameter cxxParameter
hi default link LspCxxHlSymClass cxxTypeAlias


" ==== neoclide/coc.nvim ====
" coc extensions
let g:coc_global_extensions = [
    \ 'coc-json',
    \ 'coc-tsserver',
    \ 'coc-css' ,
    \ 'coc-html',
    \ 'coc-vimlsp',
    \ 'coc-cmake',
    \ 'coc-highlight',
    \ 'coc-pyright'
    \ ]

set signcolumn=number
" <TAB> to select candidate forward or
" pump completion candidate
inoremap <silent><expr> <TAB>
    \ pumvisible() ? "\<C-n>" :
    \ <SID>check_back_space() ? "\<TAB>" :
    \ coc#refresh()
" <s-TAB> to select candidate backward
inoremap <expr><s-TAB> pumvisible() ? "\<C-p>" : "\<C-h>"
" function! s:check_back_space() abort
"    let col = col('.')-1
"    return !col || getline('.')[col - 1] =~# '\s'
" endfunction

"<CR>to comfirm selected candidate
" only when there's selected complete item
if exists('*complete_info')
inoremap <silent><expr> <CR> complete_info(['selected'])['selected'] != -1 ? "\<C-y>" : "\<C-g>u\<CR>"
endif

" show_help_documentation
nnoremap<silent> K :call <SID>show_documentation()<CR>
function! s:show_documentation()
    if(index(['vim', 'help'], &filetype) >= 0)
        execute 'h '.expand('<cword>')
    elseif(coc#rpc#ready())
        call CocActionAsync('doHover')
    else
        execute '!' . &keywordprg . " " . expand('<cword>')
    endif
endfunction

" highlight link CocHighlightText Visual
" autocmd CursorHold *silent call CocActionAsync('highlight')  " TODO

nmap <leader>rn <plug>(coc-rename)
xmap <leader>f <Plug>(coc-format-selected)
command! -nargs=0 Format :call CocAction('format')

augroup mygroup
autocmd!
autocmd FileType typescript,json setl formatexpr=CocAction('formatSelected')
autocmd User CocJumpPlaceholder call CocActionAsync('showSignatureHelp')
augroup end

" diagnostic info   //列出所有的错误信息
nnoremap <silent><nowait> <LEADER>d :CocList diagnostics<CR>
nmap <silent> <LEADER>- <Plug>(coc-diagnostic-prev)
nmap <silent> <LEADER>= <Plug>(coc-diagnostic-next)
nmap <LEADER>qf <Plug>(coc-fix-current)

" Remap <c-f> and <C-b> for scroll float windows/popups.    " 滚动浮窗
if has('nvim-0.4.0') || has('patch-8.2.0750')
    nnoremap <silent><nowait><expr> <C-f> coc#float#has_scroll() ? coc#float#scroll(1) : "\<C-f>"
    nnoremap <silent><nowait><expr> <C-b> coc#float#has_scroll() ? coc#float#scroll(0) : "\<C-b>"
    inoremap <silent><nowait><expr> <C-f> coc#float#has_scroll() ? "\<C-r>=coc#float#scroll(1)\<CR>" : "\<Right>"
    inoremap <silent><nowait><expr> <C-b> coc#float#has_scroll() ? "\<C-r>=coc#float#scroll(0)\<CR>" : "<Left>"
    vnoremap <silent><nowait><expr> <C-f> coc#float#has_scroll() ? coc#float#scroll(1) : "\<C-f>"
    vnoremap <silent><nowait><expr> <C-b> coc#float#has_scroll() ? coc#float#scroll(0) : "\<C-b>"
endif
" statusline support
" setstatusline^=%{coc#status()}%{get(b:,'coc_current_function','')}  " TODO

" GoTo code navigation.     " 代码跳转
nmap <silent> gd <Plug>(coc-definition)
nmap <silent> gD :tab sp<cR><plug>(coc-definition)
nmap <silent> gy <plug>(coc-type-definition)
nmap <silent> gi <Plug>(coc-implementation)
nmap <silent> gr <plug>(coc-references)

function! s:generate_compile_commands()
    if empty(glob('CMakeLists.txt'))
        echo "Can't find CMakeLists.txt"
        return
    endif
    if empty(glob('.vscode'))
        execute 'silent !mkdir .vscode'
    endif
    execute '!cmake -DCMAKE_BUILD_TYPE=debug
        \ -DCMAKE_EXPORT_COMPILE_COMMANDS=1 -S . -B .VSCode'
endfunction
command! -nargs=0 Gcmake :call s:generate_compile_commands()
" 
" 
" 































