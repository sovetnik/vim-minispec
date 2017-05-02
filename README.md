# Vim Minispec

The **Vim Hanami Minispec** plugin runs [Hanami](http://hanamirb.org/) [Minitest](https://github.com/seattlerb/minitest) specs and displays the results in Vim quickfix. If no any errors or warnings, it echoes output last line, like: '23 tests, 42 assertions, 0 failures, 0 errors, 0 skips'

## Requirements

If you can run your minitest file like `ruby spec/awesome_spec.rb` you can use a plugin.
In your `.hanamirc` must exist a line `test=minitest`.

## Installation

Obtain a copy of this plugin and place `minispec.vim` in your Vim plugin directory.
Add to your `~/.vimrc` or `~/.config/nvim/init.vim`:
```
Plug 'sovetnik/vim-minispec'
```
## Usage

The plugin registers `<Leader>r` and `<Leader>t` in normal mode for triggering it easily. 

You can use **Leader-r**(Run spec) to run some command in order:
- Run current spec if filename match `*_spec.rb` or have a related spec.
  Examples of supported files:
  - `apps/web/controllers/fragments/show.rb`
  - `apps/web/views/fragments/show.rb`
  - `lib/project/entities/awesome.rb`
  - `spec/project/entities/awesome_spec.rb`
  - and so on.
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
