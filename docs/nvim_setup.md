# Basic info

nvim setup:
the init.vim (equivalent to vimrc) is at AppData/Local/nvim


# Different vimrc configs

There are 3 different vim environments I'm dealing with in total:
1) Vim
2) Neovim
3) VS Code Neovim

All three needs a different config file.

Managing different sets of plugins for both configs gets tricky, so some tips which helped manage that is in the link
https://github.com/junegunn/vim-plug/wiki/tips#conditional-activation

## New files/folders to make

New files:
in ~/AppData/Local/nvim:
init.vim (the equivalent of vimrc for neovim)
neoviminit.vim (my own specific vimrc for neovim)
vscodeinit.vim (my vimrc for vs code neovim)
ginit.vim (config for neovim-qt)

New folders:
~/AppData/Local/nvim/init_sources (For extra config data which is sourced by init.vim
~/AppData/Local/nvim-data/undo (For neovim undofiles)

## Setting up init.vim for VS Code

- [Neovim configuration.](https://github.com/vscode-neovim/vscode-neovim?tab=readme-ov-file#neovim-configuration)

- [Differences in VS Code to keep note of.](https://github.com/vscode-neovim/vscode-neovim?tab=readme-ov-file#vscode-specific-differences)

- [To source .lua files](https://neovim.io/doc/user/lua.html#%3Aluafile:~:text=Examples%3A-,%3Aluafile%20script.lua,-%3Aluafile%20%25) (configs for lua plugins).

## Which Neovim GUI to use

- The default installation of Neovim comes with [Neovim-qt](https://github.com/equalsraf/neovim-qt), a very minimalistic one. A slightly more faster minimalist alternative is [Nvy](https://github.com/RMichelsen/Nvy). A better GUI with more features is [Neovide](https://github.com/neovide/neovide).

## To add "Open with Neovim GUI" in context menu

Adding a custom context menu option for "Open with Neovim GUI" in Windows involves modifying the Windows Registry. Here's a step-by-step guide:

**Note: Modifying the Windows Registry can have serious consequences if not done correctly. Be sure to create a backup of your registry or create a system restore point before proceeding.**

1. **Open Registry Editor:**
   - Press `Win + R` to open the Run dialog.
   - Type `regedit` and press Enter to open the Registry Editor.

2. **Navigate to the Context Menu Section:**
   - In the Registry Editor, navigate to the following key:
     ```
     HKEY_CLASSES_ROOT\*\shell
     ```

3. **Create a new key for Neovim GUI:**
   - Right-click on the `shell` key, select `New` > `Key`.
   - Name the key something relevant like "Neovide" or the GUI name.
   - On the `(Default)` entry in this key, for value, put whatever you want your context menu entry to be, e.g., "Open with Neovim GUI"
   - In the above value entry, add an Ampersand (`&`) before the letter you want as the shortcut. For example, "Open with &Neovim GUI" will make the command get triggered by pressing `n`.

4. **Create a new key for the command:**
   - Right-click on the key you just created, select `New` > `Key`.
   - Name the new key `command`.

5. **Set the default value for the command:**
   - On the right-hand side, double-click on the `(Default)` entry in the `command` key.
   - Set the value data to the path of the Neovim GUI executable followed by `%1`. For example:
     ```
     "C:\Path\To\Neovim GUI.exe" "%1"
     ```
     Make sure to replace "C:\Path\To\Neovim GUI.exe" with the actual path to your Neovim GUI executable.

6. **Verify and Close Registry Editor:**
   - Double-check the entries you created to ensure they are correct.
   - Close the Registry Editor.

7. **Test the Context Menu:**
   - Right-click on a file, and you should see your custom context menu option ("Open with Neovim GUI").
   - Clicking on it should launch Neovim GUI with the selected file.

That's it! You have successfully added a custom context menu option for "Open with Neovim GUI" in Windows. Remember to be cautious when working with the Windows Registry, and make sure you have a backup before making changes.
