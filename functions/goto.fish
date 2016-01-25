# SYNOPSIS
#   goto [options]
#
# USAGE
#   Options
#

function _goto_resets
  # Bin or Not
  if test -e ./bin
    if test "$PATH[1]" != "./bin"
      set -gx PATH ./bin $PATH
    end
    if test -e ./lib
      if test "$RUBYLIB[1]" != "./lib"
        set -gx RUBYLIB ./lib $RUBYLIB
      end
    end
  else
    if test "$PATH[1]" = "./bin"
      set -e PATH[1]
    end
    if test "$RUBYLIB[1]" = "./lib"
      set -e RUBYLIB[1]
    end
  end
  # Theme or Default
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

function goto -d 'cd (find ~/ -type d -name "$argv[1]")'
  # vars
  set -l d ~/
  set -l n 0
  # loop
  for a in $argv
    set d (find $d -maxdepth 3 -type d -name "$a" ^ /dev/null)
    set n (count $d)
    if test $n -gt 1
      break
    end
    if test -z "$d"
      break
    end
  end
  if test -n "$d"
    if test $n -gt 1
      echo "# $d[1]"
      echo "# $d[2]"
      if test $n -gt 2
        echo "# ..."
      end
      echo "# Multiple directories found."
      false
    else
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
    end
  else
    echo "# Directory not found."
    false
  end
end
