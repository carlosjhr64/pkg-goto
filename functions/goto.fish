function pkg-goto_trace
  if test -n "$pkg_goto_trace"
    echo "$argv[1]" >&2
  end
end

function pkg-goto_env
  set --local d ''
  set --local base $argv[1]
  set --local key $argv[2]
  # Check if key might be an environment variable.
  if string match --quiet --regex '^\w+$' "$key"
    # If so, then check if it is set.
    for path in $$key
      # If set, then check if base/path is a directory.
      if test -d "$base$path"
        set d "$base$path"
        break
      else
        # Else if base is HOME, then maybe path is giving the full path and
        # base is not needed.
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
  set --local d ''
  set --local n 1
  while test $n -le 4 # Limit mindepth to 4.
    set d (find -L $argv[1] -mindepth $n -maxdepth $n -type d -name "$argv[2]")
    if test (count $d) -gt 1
      # If more than one result, then find the most recently modified.
      set d (ls -td $d | egrep -v '/\.' | head -1)
      set pkg_goto_trace '1' # Due to ambiguity, report the path selected.
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
  set --local d ~/
  for a in $argv # For each argument, find a path to it...
    set d (pkg-goto_find $d $a) # ...appending to the previous path found.
    if test -z "$d" # Break out if no path found.
      break
    end
  end
  echo $d
end

function pkg-goto_found
  set --local d (pkg-goto_finds $argv) # Set to found path.
  if test -n "$d" # If path found, then cd to it.
    if builtin cd $d[1]
      pkg-goto_trace "#"(pwd)
      if functions --query fish_greeting
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
  set --global pkg_goto_trace '' # Set to '1' to trace.
  set --local error '' # Set to '1' to indicate error.
  if argparse --name=goto 'h/help' 'v/version' 't/trace' -- $argv
    if test -n "$_flag_version"
      echo '1.2.1'
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
  set --erase pkg_goto_trace
  if test -n "$error"
    false
  else
    true
  end
end
