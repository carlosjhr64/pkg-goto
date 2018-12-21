function pkg-goto_trace
  if test -n "$pkg_goto_trace"
    echo "$argv[1]" >&2
  end
end

function pkg-goto_depth
  echo (echo "$argv[1]" | grep -o '/' | wc -l)
end

function pkg-goto_shallow_path
  set -l d $argv[1]
  set -l n (pkg-goto_depth $d)
  pkg-goto_trace "#?$d"
  for a in $argv[2..-1]
    pkg-goto_trace "#?$a"
    set -l m (pkg-goto_depth $a)
    if test $m -lt $n
      set n $m
      set d $a
    end
  end
  echo $d
end

function pkg-goto_goto_finds
  set -l d ~/
  for a in $argv
    set d (find $d -maxdepth 3 -type d -name "$a" ^ /dev/null)
    if test (count $d) -gt 1
      set d (pkg-goto_shallow_path $d)
    end
    if test -z "$d"
      break
    end
  end
  echo $d
end

function pkg-goto_found
  set -l d (pkg-goto_goto_finds $argv)
  if test -n "$d"
    if builtin cd $d[1]
      pkg-goto_trace "#"(pwd)
      if functions -q fish_greeting
        fish_greeting
      end
      return 0
    else
      # Very unlikely, but maybe did not have permission to enter.
      echo "# $d[1]" >&2
      echo "# Could not cd." >&2
      return 1
    end
  else
    echo "# Directory not found." >&2
    return 1
  end
end

function goto
  set -g pkg_goto_trace ''
  set -l error ''
  if argparse --name=goto 'h/help' 'v/version' 't/trace' -- $argv
    if test -n "$_flag_version"
      echo '1.0.0'
    else if test -n "$_flag_help"
      echo 'Usage: goto [-t --trace] <basename>...'
    else
      if test -n "$_flag_trace"
        set pkg_goto_trace '1'
      end
      if not pkg-goto_found $argv
        set error '1'
      end
    end
  else
    set error '1'
  end
  set -e pkg_goto_trace
  if test -n "$error"
    false
  else
    true
  end
end
