" Use the excellent Railscat theme by Jeff Kreeftmeijer (gVim-only)
colorscheme railscat
" Use 14pt Menlo
set guifont=Menlo:h14
" Better line-height
set linespace=8

if has("gui_macvim")
<<<<<<< HEAD
  macmenu &File.Close key=<nop>
  map <D-w> :tabclose<CR>
=======
  " command+w closes the whole tab, not 1 pane
  macmenu &File.Close key=<nop>
  map <D-w> :tabc<CR>
>>>>>>> 05791a7291955a6ae1d4f3ddc5134ac88bbba952
endif
