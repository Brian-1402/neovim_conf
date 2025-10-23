# Where to Download

- As mentioned in the [Vim fandom download guide](https://vim.fandom.com/wiki/Where_to_download_Vim), I prefer downloading from the [vim-win32-installer repository](https://github.com/vim/vim-win32-installer/releases/tag/v9.0.0000), instead of the original [vim.org](https://www.vim.org/download.php) webpage, because the repo contains vim compiled with python support and other extra features, which are sometimes required by certain plugins such as [YouCompleteMe](https://github.com/ycm-core/YouCompleteMe?tab=readme-ov-file#supported-python-runtime).

# Terminal setup

Terminal app: PowerShell 7

## Font setup

- Set it in terminal settings > default profile > appearance.

- Font1: My own custom patched "Consolas Nerd Font". [Instructions to patch your own Nerd Font](https://github.com/ryanoasis/nerd-fonts/tree/master?tab=readme-ov-file#font-patcher). Original font file found in `C:\Windows\Fonts`.

- Font2: [CaskaydiaMono Nerd Font](https://github.com/ryanoasis/nerd-fonts/tree/master/patched-fonts/CascadiaMono). Use this to avoid coding ligature like ≠, otherwise use [CascadiaCode](https://github.com/ryanoasis/nerd-fonts/tree/master/patched-fonts/CascadiaCode).

- Font3: [Inconsolata Nerd Font](https://github.com/ryanoasis/nerd-fonts/tree/master/patched-fonts/Inconsolata).

## Registry edits:

### "Open with Vim" context menu option

- When installing Vim GUI on windows, you get such a context menu option. But it opens gvim instead of terminal vim. To change it to terminal vim: 

- `HKEY_LOCAL_MACHINE\SOFTWARE\Vim\Gvim` in path string, changed gvim.exe to vim.exe. 
Example value:- `C:\Program Files (x86)\Vim\vim90\vim.exe`

- This makes sure "open with vim" option in context menu uses terminal vim instead of gvim.

### "Open with" context menu option

- `Computer\HKEY_CLASSES_ROOT\Applications\gvim.exe\shell\edit\command`, change `gvim.exe` to `vim.exe`.
- This changes the "Open with" app list menu in the context menu to open vim instead of gvim.

- `HKEY_LOCAL_MACHINE\SOFTWARE\Classes\Applications\gvim.exe\shell\edit\command`, also needs to be changed, although I don't think it'll affect much.

## To fix Ctrl+Bksp in Terminal Vim

- In Windows terminal settings.json,
- location: `%LOCALAPPDATA%\Packages\Microsoft.WindowsTerminal_8wekyb3d8bbwe\LocalState\settings.json`,

- Add change to fix ctrl+backspace in Windows Terminal:
```
{
  "actions": [
    {
      "keys": "ctrl+backspace",
      "command": { "action": "sendInput", "input": "\u0017" }
    }
  ]
}
```
- The above is from [link](https://github.com/microsoft/terminal/issues/755#issuecomment-1399035090).

# vimrc

## Backup and Undo files

- I had to put specific folders for them in vimfiles directory, and mention them in vimrc. Another separate folder for neovim undofiles since they're a different format.

## vimrc_sources folder

- I made an additional folder in home directory incase I have multiple big configs for individual plugins and I source these files from the main \_vimrc, so that the vimrc won't get cluttered with all those config data.
