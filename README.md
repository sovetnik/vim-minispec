# Vim Minispec

The **Vim Minispec** plugin runs your Gem or [Hanami](http://hanamirb.org/) [Minitest](https://github.com/seattlerb/minitest) specs and displays the results in Vim quickfix. If no any errors or warnings, it echoes output last line, like: '23 tests, 42 assertions, 0 failures, 0 errors, 0 skips'

## Requirements

If you can run your minitest file like `ruby spec/awesome_spec.rb` or `rake test` you can use a plugin.
In your `spec/spec_helper.rb` must exist a line `require 'minitest/autorun'`or in `.hanamirc` must exist a line `test=minitest`.

## Installation

Get plugin and place `minispec.vim` in your Vim plugin directory.
When you have Vundle or Plug, add to your `~/.vimrc` or `~/.config/nvim/init.vim` something like:
```
Plug 'sovetnik/vim-minispec'
```
For Pathogen copy and paste:
```
cd ~/.vim/bundle
git clone 'git://github.com/sovetnik/vim-minispec.git'
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

## Troubleshooting
If you press `<Leader>r` or `<Leader>t`and shit and/or nothing happens, try direct commands:
- `:!ruby %`
- `rake` or `rake test`
This show you unfiltered console output.
Remember about rake  must be runned from project root.
Usually, plugin cd in your project root before each run, but we in troubleshoot section, so try `:pwd`. Output must be looks like your root.

## License
The Vim Minispec plugin is open-sourced software licensed under the [MIT license](http://opensource.org/licenses/MIT).
