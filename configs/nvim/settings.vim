if (empty($TMUX))
    if (has("nvim"))
        let $NVIM_TUI_ENABLE_TRUE_COLOR=1
    endif

	if (has("termguicolors"))
		set termguicolors
    endif
endif

" Themes and color
set background=dark
colorscheme one
let g:airline_theme = 'one'
hi Normal guibg=NONE ctermbg=NONE

set tabstop=2 softtabstop=2
set smartindent
set ruler
set number

set mouse=a

let g:chadtree_settings = { "theme.text_colour_set" : "nord" }

" temp here
autocmd VimEnter * CHADopen

lua << EOF
require("bufferline").setup { 
				offsets = {{ 
								filetype = "NvimTree", 
								text = "File System",
								text_align = "left" 
								}}
				}
EOF
