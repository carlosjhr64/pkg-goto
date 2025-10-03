function pkg-goto_ruby_code
  echo 'if ARGV.empty?
  puts ENV["HOME"]
  exit
end

if ARGV.length == 1 && (pth = ENV[ARGV[0]]) && File.directory?(pth)
  puts pth
  exit
end

# Set dir:
if File.directory?(_ = "#{dir = ENV["HOME"]}/#{ARGV[0]}")
  dir = _
  unless ARGV[1]
    puts dir
    exit
  end
end

flags   = ARGV.any? { /^\./.match?(it) } ? IO::FNM_DOTMATCH : 0
pattern = ARGV.map{ it.gsub(".", "[.]") }.join(".*")
regexp  = %r(#{pattern}/$)

puts Dir.glob("#{dir}/**/*/", sort: false, flags: flags)
        .select{ regexp.match? it }
        .sort.sort_by{ it.length }
        .first&.chomp("/")'
end

function pkg-goto_finds
  set output (pkg-goto_ruby_code | ruby - $argv)
  echo $output
end

function pkg-goto_found
  set --local d (pkg-goto_finds $argv) # Set to found path.
  if test -n "$d" # If path found, then cd to it.
    if builtin cd $d[1]
      if functions --query fish_greeting
        fish_greeting
      end
      return 0
    else
      echo "# Could not cd: $d" >&2
      return 1
    end
  else
    echo "# Directory not found." >&2
    return 1
  end
end

function goto
  set --local error '' # Set to '1' to indicate error.
  if argparse --name=goto 'h/help' 'v/version' -- $argv
    if test -n "$_flag_version"
      echo '2.1.1'
    else if test -n "$_flag_help"
      echo 'Usage: goto <basename>...'
    else
      if not pkg-goto_found $argv
        set error '1'
      end
    end
  else
    set error '1'
  end
  if test -n "$error"
    false
  else
    true
  end
end
