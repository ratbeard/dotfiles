colorscheme railscat
set guifont=Menlo:h14
" Better line-height
set linespace=8

if has("gui_running")
  "colorscheme fruity
  "colorscheme lucius
  "colorscheme desertEx
  set guioptions=egmtc  " ?
  set showtabline=2 "2 enables tabs
  set antialias
  "set guifont=Inconsolata-dz\ For\ Powerline:h11
  set transp=0

  " Saving puts you in normal mode
  iunmenu File.Save 
  imenu <silent> File.Save <Esc>:if expand("%") == ""<Bar>browse confirm w<Bar>else<Bar>confirm w<Bar>endif<CR>

  " Fullscreen takes up entire screen
  set fuoptions=maxhorz,maxvert

  " Start without the toolbar
  set guioptions-=T
endif


if has("gui_macvim")
  " cmd+w closes the whole tab, not 1 pane
  macmenu &File.Close key=<nop>
  map <D-w> :tabc<CR>

  " Disable command+s - bad habbit
  "macmenu &File.Save key=<nop>
  "map <D-s> <ESC>
endif
