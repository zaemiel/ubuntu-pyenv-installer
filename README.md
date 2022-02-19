# Ubuntu Pyenv Installer

The Ubuntu Pyenv Installer is a 2-click installation script that will install on your Debian/Ubuntu/Mint Linux distribution:

 * Python build dependencies
 * Pyenv
 * The latest Python version (if needed)
 * Will set the latest Python version as the global version for the system (if needed)

## Installation / Uninstallation

You need `curl` to use this script. To install it (if it's not installed already) use this command:

```bash
sudo apt install curl
```

### Install Pyenv

To install Pyenv on your Ubuntu-based distro just execute this command in shell:

```bash
bash <(curl -sSL https://raw.githubusercontent.com/zaemiel/ubuntu-pyenv-installer/master/ubuntu-pyenv-installer.sh)
```

After the installation will be completed the script will automatically add these lines at the beginning of your `.bashrc` file, and will restart your shell:

```bash
export PYENV_ROOT="$HOME/.pyenv"
export PATH="$PYENV_ROOT/bin:$PATH"
eval "$(pyenv init --path)"
eval "$(pyenv virtualenv-init -)"
```

### Uninstall

To uninstall Pyenv you just need to delete the lines above from your `.bashrc`,
and then delete `~/.pyenv` directory

```bash
rm -rf ~/.pyenv
```

and restart your shell

```bash
source ~/.bashrc
```

or

```bash
exec $SHELL
```

## Screenshots
![Initial dialog](./screenshots/ubuntu_pyenv_installer_screenshot_1.png?raw=true)

## Links
* [`Pyenv` Page](https://github.com/pyenv/pyenv)
* [How to use `Pyenv`](https://github.com/pyenv/pyenv/blob/master/COMMANDS.md)
* [`Python` Build Dependencies](https://github.com/pyenv/pyenv/wiki#suggested-build-environment)


## License
[The MIT License](https://github.com/pyenv/pyenv/blob/master/LICENSE)
