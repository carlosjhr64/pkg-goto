# SYNOPSIS
#   goto <basename> [<basename>...]

function _shift_bin
  if test "$PATH[1]" != "./bin"
    set -gx PATH ./bin $PATH
  end
end

function _unshift_bin
  if test "$PATH[1]" = "./bin"
    set -e PATH[1]
  end
end

function _shift_lib
  if test "$RUBYLIB[1]" != "./lib"
    set -gx RUBYLIB ./lib $RUBYLIB
  end
end

function _unshift_lib
  if test "$RUBYLIB[1]" = "./lib"
    set -e RUBYLIB[1]
  end
end

function _reset_theme
  if test -e .theme
    omf theme (cat .theme)
  else
    if test -z "$default_theme"
      omf theme default
    else
      omf theme "$default_theme"
    end
  end
end

function _goto_resets
  if test -e ./bin
    _shift_bin
    if test -e ./lib
      _shift_lib
    else
      _unshift_lib
    end
  else
    _unshift_bin
    _unshift_lib
  end
  _reset_theme
end

function _depth
  echo (echo "$argv[1]" | grep -o '/' | wc -l)
end

function _deepest_path
  set -l d ''
  set -l n 0
  for a in $argv
    echo "#?$a" >&2
    set -l m (_depth $a)
    if test $m -gt $n
      set n $m
      set d $a
    end
  end
  echo $d
end

function _goto_finds
  # vars
  set -l d ~/
  # loop
  for a in $argv
    set d (find $d -maxdepth 3 -type d -name "$a" ^ /dev/null)
    if test (count $d) -gt 1
      set d (_deepest_path $d)
    end
    if test -z "$d"
      break
    end
  end
  echo $d
end

function goto -d 'cd (find ~/ -type d -name "$argv[1]")'
  set -l d (_goto_finds $argv)
  if test -n "$d"
    if builtin cd $d[1]
      echo "#" (pwd)
      _goto_resets
      true
    else
      # Very unlikely, but maybe did not have permission to enter.
      echo "# $d[1]"
      echo "# Could not cd."
      false
    end
  else
    echo "# Directory not found."
    false
  end
end
