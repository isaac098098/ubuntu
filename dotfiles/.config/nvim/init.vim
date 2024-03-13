" vim-plug

call plug#begin('~/.local/share/nvim/plugged')

Plug 'neoclide/coc.nvim', {'branch': 'release'}

Plug 'lervag/vimtex'

Plug 'nvim-lualine/lualine.nvim'

Plug 'sainnhe/everforest'

Plug 'nvim-tree/nvim-tree.lua'

Plug 'nvim-treesitter/nvim-treesitter', {'do': ':TSUpdate'}

Plug 'nvim-tree/nvim-web-devicons' 

Plug 'nvim-lua/plenary.nvim'

Plug 'nvim-telescope/telescope.nvim', { 'brach': '0.1.x' }

Plug 'nvim-lua/popup.nvim'

Plug 'nvim-telescope/telescope-media-files.nvim'

Plug 'SirVer/ultisnips'

call plug#end()

" Filetype plugins

filetype plugin on
filetype indent on

" everforest

if has('termguicolors')
	set termguicolors
endif

set background=dark

colorscheme everforest

let g:everforest_background = 'medium'

let g:everforest_better_performance = 1

" nvim-tree

nnoremap <leader>tt <cmd>NvimTreeToggle<cr>
nnoremap <leader>tf <cmd>NvimTreeFindFile<cr>

lua << END

-- nvim-tree

vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1

local function my_on_attach(bufnr)
	local api = require "nvim-tree.api"

	local function opts(desc)
		return { desc = "nvim-tree: " .. desc, buffer = bufnr, noremap = true, silent = true, nowait = true }
	end

	api.config.mappings.default_on_attach(bufnr)
end

require("nvim-tree").setup({
  sort_by = "case_sensitive",
  on_attach = my_on_attach,
  renderer = {
    group_empty = true,
  },
  filters = {
    dotfiles = false,
  },
})

vim.opt.termguicolors = true 

vim.g.nvim_tree_respect_buf_cwd = 1

-- statusline

require('lualine').setup {
	options = {
		theme = "everforest",
	    icons_enabled = true,
	    component_separators = { left = '', right = ''},
	    section_separators = { left = '', right = ''},
	    disabled_filetypes = {
          statusline = {},
	      winbar = {},
	      'NvimTree',
	    },
	    ignore_focus = {},
	    always_divide_middle = true,
	    globalstatus = false,
	    refresh = {
	      statusline = 1000,
	      tabline = 1000,
	      winbar = 1000,
	    }
	  },
        sections = {
	    lualine_a = {'mode'},
	    lualine_b = {'branch', 'diff', 'diagnostics'},
		lualine_c = {{'filename',path=1}},
	    lualine_x = {'encoding', 'fileformat', 'filetype'},
	    lualine_y = {'progress'},
	    lualine_z = {'location'}
	  },
	  inactive_sections = {
	    lualine_a = {},
	    lualine_b = {},
	    lualine_c = {},
	    lualine_x = {},
	    lualine_y = {},
	    lualine_z = {}
	  },
	  tabline = {},
	  winbar = {},
	  inactive_winbar = {},
	  extensions = {}
}

-- nvim-treesitter

require'nvim-treesitter.configs'.setup {
  -- A list of parser names, or "all" (the five listed parsers should always be installed)
  ensure_installed = { "c", "lua", "vim", "vimdoc" },

  -- Install parsers synchronously (only applied to `ensure_installed`)
  sync_install = false,

  -- Automatically install missing parsers when entering buffer
  -- Recommendation: set to false if you don't have `tree-sitter` CLI installed locally
  auto_install = true,

  -- List of parsers to ignore installing (or "all")
  -- ignore_install = { "javascript" },

  ---- If you need to change the installation directory of the parsers (see -> Advanced Setup)
  -- parser_install_dir = "/some/path/to/store/parsers", -- Remember to run vim.opt.runtimepath:append("/some/path/to/store/parsers")!

  highlight = {
    enable = true,

    -- NOTE: these are the names of the parsers and not the filetype. (for example if you want to
    -- disable highlighting for the `tex` filetype, you need to include `latex` in this list as this is
    -- the name of the parser)
    -- list of language that will be disabled
    disable = { },
    -- Or use a function for more flexibility, e.g. to disable slow treesitter highlight for large files
    --disable = function(lang, buf)
        --local max_filesize = 100 * 1024 -- 100 KB
        --local ok, stats = pcall(vim.loop.fs_stat, vim.api.nvim_buf_get_name(buf))
        --if ok and stats and stats.size > max_filesize then
            --return true
        --end
    --end,

    -- Setting this to true will run `:h syntax` and tree-sitter at the same time.
    -- Set this to `true` if you depend on 'syntax' being enabled (like for indentation).
    -- Using this option may slow down your editor, and you may see some duplicate highlights.
    -- Instead of true it can also be a list of languages
    additional_vim_regex_highlighting = {"latex"},
  },
}

END

lua << EOF

-- telescope-media-files.nvim

require('telescope').load_extension('media_files')
local builtin = require('telescope.builtin')
vim.keymap.set('n', '<leader>ff', builtin.find_files, {})
vim.keymap.set('n', '<leader>fg', builtin.live_grep, {})
vim.keymap.set('n', '<leader>fb', builtin.buffers, {})
vim.keymap.set('n', '<leader>fh', builtin.help_tags, {})

EOF

" coc-vim

inoremap <silent><expr> <C-d>
      \ coc#pum#visible() ? coc#pum#next(1) :
      \ CheckBackspace() ? "\<C-d>" :
      \ coc#refresh()
inoremap <expr><C-e> coc#pum#visible() ? coc#pum#prev(1) : "\<C-h>"

inoremap <silent><expr> <CR> coc#pum#visible() ? coc#pum#confirm()
                              \: "\<C-g>u\<CR>\<c-r>=coc#on_enter()\<CR>"

function! CheckBackspace() abort
  let col = col('.') - 1
  return !col || getline('.')[col - 1]  =~# '\s'
endfunction

" ulti-snippets

let g:UltiSnipsExpandTrigger="<tab>"
let g:UltiSnipsJumpForwardTrigger="<tab>"
let g:UltiSnipsJumpBackwardTrigger="<a-tab>"
"let g:UltiSnipsJumpOrExpandTrigger = "<tab>"

nnoremap <leader>u <Cmd>call UltiSnips#RefreshSnippets()<CR>

inoremap <silent> ( <Cmd>call UltiSnips#Anon('($1)','','i','',1)<cr>
inoremap <silent> { <Cmd>call UltiSnips#Anon('{$1}','','i','',1)<cr>
inoremap <silent> [ <Cmd>call UltiSnips#Anon('[$1]','','i','',1)<cr>
inoremap <silent> " <Cmd>call UltiSnips#Anon('"$1"','','i','',1)<cr>
inoremap <silent> \| <Cmd>call UltiSnips#Anon('\|$1\|','','i','',1)<cr>
"inoremap <silent> ' <Cmd>call UltiSnips#Anon("'$1'",'','i','',1)<cr>

inoremap kj <Esc>
map j gj
map k gk

augroup vimtex
	au!
	au User VimtexEventCompiling VimtexView
augroup END

" vim-snippets
"
"let g:UltiSnipsExpandTrigger       = '<Tab>'    " use Tab to expand snippets
"let g:UltiSnipsJumpForwardTrigger  = '<Tab>'    " use Tab to move forward through tabstops
"let g:UltiSnipsJumpBackwardTrigger = '<A-Tab>'  " use Shift-Tab to move backward through tabstops

" telescope.nvim

"nnoremap <leader>ff <cmd>Telescope find_files<cr>
"nnoremap <leader>fg <cmd>Telescope live_grep<cr>
"nnoremap <leader>fb <cmd>Telescope buffers<cr>
"nnoremap <leader>fh <cmd>Telescope help_tags<cr>

" no line wrap

"set wrap
"set linebreak
"set tw=160
"set wrapmargin=0

" Preservar identación al ajustar las líneas

set breakindent
set formatoptions=l
set lbr

" line number and indentation

set nu
set numberwidth=1

" Power symbol

" Tkransparent bg

hi normal guibg=NONE

" vimtex

let g:vimtex_compiler_method = 'latexmk'
let g:vimtex_view_method = 'zathura'
let g:vimtex_view_forward_search_on_start = 'false'
let g:vimtex_quickfix_mode = 0
let g:vimtex_view_automatic = 0

let g:vimtex_compiler_latexmk_engines = {
        \ '_'                : '-pdf',
        \ 'pdfdvi'           : '-pdfdvi',
        \ 'pdfps'            : '-pdfps',
        \ 'pdflatex'         : '-pdf',
        "\ '_'           : '-lualatex',
		"\ '_'          : '-xelatex',
        "\ 'context (pdftex)' : '-pdf -pdflatex=texexec',
        \ 'context (luatex)' : '-pdf -pdflatex=context',
        \ 'context (xetex)'  : '-pdf -pdflatex=''texexec --xtx''',
        \}

let g:vimtex_compiler_latexmk = {
        \ 'build_dir' : '',
        \ 'callback' : 1,
        \ 'continuous' : 1,
        \ 'executable' : 'latexmk',
        \ 'hooks' : [],
        \ 'options' : [
			\   '-xelatex',
			\   '-verbose',
			\   '-file-line-error',
			\   '-synctex=1',
			\   '-interaction=nonstopmode',
        \ ],
        \}

augroup vimtex
	au!
	au User VimtexEventCompiling VimtexView
augroup END


" Tab size

set tabstop=4
set shiftwidth=4

" Título de las pestañas 

function! Tabline() abort
    let l:line = ''
    let l:current = tabpagenr()

    for l:i in range(1, tabpagenr('$'))
        if l:i == l:current
            let l:line .= '%#TabLineSel#'
        else
            let l:line .= '%#TabLine#'
        endif

		let bufnrlist = tabpagebuflist(l:i)

		for bufnr in bufnrlist
			if getbufvar(bufnr, "&modified")
				let l:line .= ' [+]'
				break
			endif
		endfor

        let l:label = fnamemodify(
            \ bufname(tabpagebuflist(l:i)[tabpagewinnr(l:i) - 1]),
            \ ':t'
        \ )

        let l:line .= '%' . i . 'T' " Starts mouse click target region.
        let l:line .= ' ' . l:label . ' '
    endfor

    let l:line .= '%#TabLineFill#'
    let l:line .= '%T' " Ends mouse click target region(s).

    return l:line
endfunction

set tabline=%!Tabline()

" Copiar todo el documento al clipboard
nmap <C-d> ggVG"+y
