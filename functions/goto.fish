function pkg-goto_trace
  if test -n "$pkg_goto_trace"
    echo "$argv[1]" >&2
  end
end

function pkg-goto_env
  set -l d ''
  set -l base $argv[1]
  set -l key $argv[2]
  if string match --quiet --regex '^\w+$' "$key"
    for path in $$key
      if test -d "$base$path"
        set d "$base$path"
        break
      else
        if test "$base" = "$HOME/"
          if test -d "$path"
            set d "$path"
            break
          end
        end
      end
    end
  end
  echo $d
end

function pkg-goto_find
  set -l d ''
  set -l n 1
  while test $n -le 4
    set d (find $argv[1] -mindepth $n -maxdepth $n -type d -name "$argv[2]")
    if test (count $d) -gt 1
      set pkg_goto_trace '1'
      set d (ls -td $d | egrep -v '/\.' | head -1)
    end
    if test -n "$d"
      break
    end
    set n (math $n+1)
  end
  if test -z "$d"
    set d (pkg-goto_env $argv)
  end
  echo $d
end

function pkg-goto_finds
  set -l d ~/
  for a in $argv
    set d (pkg-goto_find $d $a)
    if test -z "$d"
      break
    end
  end
  echo $d
end

function pkg-goto_found
  set -l d (pkg-goto_finds $argv)
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
      echo '1.2.0'
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
