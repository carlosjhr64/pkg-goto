# pkg-goto

A plugin for [Fisherman](http://fisherman.sh).

## Install

```fish
fisher install https://github.com/carlosjhr64/pkg-goto
```

## Usage

```fish
~> goto <basename> [<basename>...]
basename>
```

In a nutshell, it just runs the following command:

```fish
~> cd (find ~/ -maxdepth 3 -type d -name "$argv[1]")
```

But wait, there's more!  After it changes directory,
if it finds a ./bin directory, it prepends ./bin to PATH, else
it shifts out ./bin from PATH.
Likewise, if it finds a ./lib directory, it prepends ./lib to RUBYLIB, else
it shifts out ./lib from RUBYLIB.
Finally, if it finds a .theme file, it sets the fisherman theme to that specified in the file
(unless already set to it).

For directories deeper than depth 3, say ~/a/b/c/d/e/f, one can iterate down:

```fish
~>goto c f                           16:25:36
 # /home/user/a/b/c/d/f
~/a/b/c/d/f>                         16:25:38
```

If a given basename yields multiple directories,
"goto" will pick the first shallowest directory it finds.

Lastly, if a .greeting file is found, it will display it's content.

# Screenshot

<p align="center">
<img src="goto.png">
</p>

# License

[MIT](http://opensource.org/licenses/MIT) © CarlosJHR64
