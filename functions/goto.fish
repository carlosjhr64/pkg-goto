# SYNOPSIS
#   goto <basename> [<basename>...]

function _reset_theme
  if test -e .theme
    set -l a (cat .theme)
    set -l b (fisher ls)
    if test "$a" != "$b"
      fisher "$a" -q
    end
  end
end

function _depth
  echo (echo "$argv[1]" | grep -o '/' | wc -l)
end

function _shallow_path
  set -l d $argv[1]
  set -l n (_depth $d)
  echo "#?$d" >&2
  for a in $argv[2..-1]
    echo "#?$a" >&2
    set -l m (_depth $a)
    if test $m -lt $n
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
      set d (_shallow_path $d)
    end
    if test -z "$d"
      break
    end
  end
  echo $d
end

function _cmdflags
  set -l n (count $argv)
  if test "$n" != '0'
    switch $argv[1]
      case '-v' '--version'
        echo '0.1.0'
        return 0
      case '-h' '--help'
        echo 'Usage: goto <basename>...'
        return 0
    end
  end
  return 1
end

function goto -d 'cd (find ~/ -type d -name "$argv[1]")'
  if _cmdflags $argv
    return
  end
  set -l d (_goto_finds $argv)
  if test -n "$d"
    if builtin cd $d[1]
      _reset_theme
      if test -e .greeting
        cat .greeting
      else
        echo "#" (pwd)
      end
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
