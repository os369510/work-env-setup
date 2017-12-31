# Bazel.vim

Syntax highlighting for [Bazel](http://bazel.io) `BUILD` and `WORKSPACE` files.

This plugin does support the official skylark extensions for the following languages:

* Closure
* Docker
* Groovy
* Java App Engine
* D
* Rust
* Jsonnet
* Scala

## Installation

### Pathogen

If you're using [Pathogen](https://github.com/tpope/vim-pathogen) follow the
following instructions.

	cd ~/.vim/bundle && \
	git clone https://github.com/durandj/bazel.vim.git

### Vundle

If you're using [Vundle](https://github.com/VundleVim/Vundle.vim) then all you
have to do is add the following to your `~/.vimrc` file.

	Plugin 'durandj/bazel.vim'

### Old School/Classic Plugin Management

If you're "hardcore" and you don't use any plugin manager for your Vim
environment then you will need to do the following.

1. Download/Clone/Checkout the [source](https://github.com/durandj/bazel.vim)
2. Copy the contents of `bazel.vim/ftdetect` to `~/.vim/ftdetect`
3. Copy the contents of `bazel.vim/ftplugin` to `~/.vim/ftplugin`
4. Copy the contents of `bazel.vim/syntax` to `~/.vim/syntax`

## Alternatives

It is worth noting that there is an alternative plugin to this one. davidzchen
wrote [vim-bazel](https://github.com/davidzchen/vim-bazel) which works fine
but I decided to make my own version because I didn't like how his plugin did
not highlight the arguments to the standard build rules. While this is a small
thing I really like having a visual confirmation that I'm writing the right
thing and that there's not a typo that I'm going to find when I try to build.

The `bazel.vim` plugin also supports the official Skylark extensions which
the `vim-bazel` plugin does not at present.

## TODO

1. Split up support for the build rules based on if a `WORKSPACE` or a `BUILD` file is being edited

