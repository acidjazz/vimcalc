
vnoremap ;c "ey:call vimcalc()<CR>

function! vimcalc()
  let has_equal = 0
  let has_replace = 0

  " remove newlines and trailing spaces
  let @e = substitute (@e, "\n", "", "g")
  let @e = substitute (@e, '\s*$', "", "g")

  " if we end with an equal or r, strip, and remember for output
  if @e =~ "=$"
    let @e = substitute (@e, '=$', "", "")
    let has_equal = 1
  endif

  " if we end with an equal, strip, and replace output
  if @e =~ "r$"
    let @e = substitute (@e, 'r$', "", "")
    let has_replace = 1
  endif

  " sub common func names for bc equivalent
  let @e = substitute (@e, '\csin\s*(', "s (", "")
  let @e = substitute (@e, '\ccos\s*(', "c (", "")
  let @e = substitute (@e, '\catan\s*(', "a (", "")
  let @e = substitute (@e, "\cln\s*(", "l (", "")

  " escape chars for shell
  let @e = escape (@e, '*()')

  " run bc, strip newline
  let answer = substitute (system ("echo " . @e . " \| bc -l"), "\n", "", "")

  " append, replace, or echo
  if has_equal == 1
    normal `>
    exec "normal a" . answer
  elseif has_replace == 1
    exec "normal " . strlen(@e) . "x"
    exec "normal i" . answer 
  else
    echo "answer = " . answer
  endif
endfunction

