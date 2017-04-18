# Vim Minispec

The **Vim Minispec** plugin runs [Minitest](https://github.com/seattlerb/minitest) and displays the results in Vim quickfix.

## Requirements

If you can run you minitest file like `ruby spec/awesome_spec.rb` you can use a plugin.
Note: you current working directory must be a project root.
Use `:pwd` to ensure this.

## Installation

Obtain a copy of this plugin and place `minispec.vim` in your Vim plugin directory.
Add this to your `.vimrc` or `nvim/init.vim`:
```
Plug 'sovetnik/vim-minispec'
```
## Usage

The plugin registers `<Leader>r` and `<Leader>t` in normal mode for triggering it easily. You can **<Leader>r**(run single file) while you are in buffer with spec or **<Leader>t**(run Total) anywhere in project while pwd is project root.

Additionally, if you have installed Tim Pope's [vim-unimpaired](https://github.com/tpope/vim-unimpaired), you can use **[q** and **]q** to navigate through list of errors. Otherwise use `:cprevious` and `:cnext`.

In the quickfix window, you can use:

    o    to open (same as enter)
    q    to close the quickfix window


## License

The Vim Minispec plugin is open-sourced software licensed under the [MIT license](http://opensource.org/licenses/MIT).
