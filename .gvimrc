" Use the excellent Railscat theme by Jeff Kreeftmeijer (gVim-only)
colorscheme railscat
" Use 14pt Menlo
set guifont=Menlo:h14
" Better line-height
set linespace=8

if has("gui_macvim")
  macmenu &File.Close key=<nop>
  map <D-w> :tabclose<CR>
endif
