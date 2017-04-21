# Vim Minispec

The **Vim Minispec** plugin runs [Minitest](https://github.com/seattlerb/minitest) and displays the results in Vim quickfix.
If no any errors or warnings, it echoes output last line, like: '23 tests, 42 assertions, 0 failures, 0 errors, 0 skips'

## Requirements

If you can run your minitest file like `ruby spec/awesome_spec.rb` you can use a plugin.
Note: your current working directory must be a project root.
Use `:pwd` to ensure this.

## Installation

Obtain a copy of this plugin and place `minispec.vim` in your Vim plugin directory.
Add this to your `.vimrc` or `nvim/init.vim`:
```
Plug 'sovetnik/vim-minispec'
```
## Usage

The plugin registers `<Leader>r` and `<Leader>t` in normal mode for triggering it easily. 

You can use **Leader-r**(Run spec) to run some command in order:
- Run current spec if filename match `*_spec.rb`
- Run last runned spec if exists one.
- Run all tests by 'rake test'

or **Leader-t**(run Total) anywhere in project to run all tests.

Additionally, if you have installed Tim Pope's [vim-unimpaired](https://github.com/tpope/vim-unimpaired), you can use **[q** and **]q** to navigate through list of errors. 
Otherwise use `:cprevious` and `:cnext`.

In the quickfix window, you can use:

    o    to open (same as enter)
    q    to close the quickfix window


## License

The Vim Minispec plugin is open-sourced software licensed under the [MIT license](http://opensource.org/licenses/MIT).
