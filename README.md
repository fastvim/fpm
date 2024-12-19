# Fast Plugin Manager (FPM) for Vim

![Made With Vimscript](https://img.shields.io/badge/made_with-vimscript?style=for-the-badge&logo=vim&logoColor=%23000000&color=%2390ee90)

FPM is a Vim plugin manager that provides an interactive user interface for managing plugins, checking for updates, and installing missing plugins. It allows you to easily install, update, and manage your plugins with a progress indicator and minimal setup.

Features
- UI-driven plugin management: Provides a simple and intuitive user interface for managing plugins.
- Asynchronous plugin installation: Installs plugins in the background while updating the UI to show progress.
- Plugin status tracking: Tracks whether a plugin is installed and its current commit hash.
- Customizable: Easily extendable to fit your needs.
- Compatibility: Works with Vim without any external dependencies.

## Installation 

- 1. Clone the repository:

You can clone this plugin manager to your ~/.vim directory:

```git clone https://github.com/your-username/fpm.git ~/.vim/autoload```

- 2. Update your .vimrc:

Add the following lines to your .vimrc file to set up the plugin manager.

```vimscript 
" Initialize plugin manager on Vim startup
autocmd VimEnter * call fpm#check_and_install_plugins()
```

- 3. Define your plugins:

In your .vimrc, define the plugins you want to use in the following format:

``` vimscript
let g:plugins = {
      \ 'tpope/vim-sensible': {},
      \ 'junegunn/fzf.vim': {},
      \ 'neovim/nvim-lspconfig': {},
      \ }

```
The key should be the plugin repository in the user/repo format, and the value can hold any additional configuration (if needed).

### Then

- 1. Check and install missing plugins:
When Vim starts, fpm#check_and_install_plugins() will automatically check if the defined plugins are installed. If any plugins are missing, it will show the UI for installing them.

- 2. Plugin Manager UI:
Once you enter the plugin manager UI, you can perform the following actions:

[Q] - Quit the plugin manager UI.
[U] - Update all installed plugins.
[X] - Install any missing plugins.

- 3. Progress tracking:
While installing plugins, the UI will show the progress, and once the installation is complete, it will display a success message. You can exit the plugin manager by pressing [Q].

### Functions

`fpm#check_and_install_plugins()`
Checks if all plugins defined in g:plugins are installed. If any plugins are missing, it opens the UI for installation.

`fpm#ui()`
Opens the plugin management UI, displaying the plugin statuses and available actions.

`fpm#install_plugin(user_plugin)`
Installs a single plugin from GitHub using the user/repo format.

`fpm#ui_mappings(buf)`
Sets up key mappings for the UI buffer (e.g., for quitting, updating, and installing plugins).

`fpm#ui_key_handler()`
Handles key presses within the UI, responding to commands like quit, update, and install.

### Contributing
If you'd like to contribute to this project, feel free to fork the repository, make changes, and submit a pull request. Bug reports and feature requests are also welcome!
