" python-mode: PyLint, Rope, Pydoc, breakpoints from box.
" https://github.com/python-mode/python-mode
NeoBundleLazy 'diraol/python-mode', { 'branch': 'fix_six_import', 'on_ft': 'python' }

colorscheme ulysses-koehler

if !exists('g:airline_symbols')
  let g:airline_symbols = {}
endif

let g:airline_theme = 'base16'
let g:airline_left_sep = ''
let g:airline_right_sep = ''
let g:airline_symbols.linenr = ''
let g:airline_symbols.maxlinenr = ''
