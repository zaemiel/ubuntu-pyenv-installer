#!/usr/bin/env bash

colorize() {
    if [ -t 1 ]; then
        printf "\e[%sm%s\e[m\n\n" "$1" "$2"
    else
        echo -n "$2"
    fi
}

echo
colorize 33 "Ubuntu Pyenv Installer"

current_version=`python3 -V | grep -Eo '([0-9]{1,3}[\.]){2}[0-9]{1,3}'`
echo "  The current Python version is: ${current_version} (system)"

python_version=`curl --silent https://www.python.org/downloads/ \
                | grep https://www.python.org/ftp/python/ \
                | grep -Eo '([0-9]{1,3}[\.]){2}[0-9]{1,3}' \
                | head -1`

echo "  The latest Python version is: ${python_version}"
echo

colorize 33 "What should I do?"

echo "  1. Install Pyenv only"
echo "  2. Install Pyenv, and the latest Python version ($python_version)"
echo "  3. Install Pyenv, the latest Python ($python_version), and set it as the global version"
echo

read -p "Make your choice (1, 2 or 3): " answer
echo

apt_update(){
    colorize 92 "Updating system packages lists"
    sudo apt update
    echo
}

create_symlink_to_python3(){
    sudo ln -s /usr/bin/python3 /usr/bin/python
}

install_python_dependencies() {
    colorize 92 "Installing Python build dependencies"
    sudo apt install -y \
        make \
        build-essential \
        libssl-dev \
        zlib1g-dev \
        libbz2-dev \
        libreadline-dev \
        libsqlite3-dev \
        wget \
        curl \
        llvm \
        libncursesw5-dev \
        xz-utils \
        tk-dev \
        libxml2-dev \
        libxmlsec1-dev \
        libffi-dev \
        liblzma-dev
    echo
}

install_git(){
    colorize 92 "Installing Git"
    sudo apt install -y git
    echo
}

install_pyenv(){
    colorize 92 'Installing Pyenv'
    curl -L https://github.com/pyenv/pyenv-installer/raw/master/bin/pyenv-installer | bash
    echo

    colorize 92 'Writing Pyenv config to ./bashrc file'

    sed -Ei -e '/^([^#]|$)/ {a \
    export PYENV_ROOT="$HOME/.pyenv"
    a \
    export PATH="$PYENV_ROOT/shims:$PATH"
    a \
    export PATH="$PYENV_ROOT/bin:$PATH"
    a \
    eval "$(pyenv init -)"
    a \
    eval "$(pyenv virtualenv-init -)"
    a \
    \n
    ' -e ':a' -e '$!{n;ba};}' ~/.bashrc
    echo

    colorize 92 "Reloading ./bashrc"
    source ~/.bashrc
    echo
}

install_python(){
    colorize 92 "Installing Python $python_version"
    pyenv install $python_version
}

set_python_global(){
    colorize 92 "Setting Python $python_version as global version"
    pyenv global $python_version
}

restart_current_shell(){
    exec $SHELL
}

done_message(){
    echo

    colorize 93 "At the beginning of the ${HOME}/.bashrc file were added these lines:"
    echo '    export PYENV_ROOT="$HOME/.pyenv"'
    echo '    export PATH="$PYENV_ROOT/shims:$PATH"'
    echo '    export PATH="$PYENV_ROOT/bin:$PATH"'
    echo '    eval "$(pyenv init -)"'
    echo '    eval "$(pyenv virtualenv-init -)"'
    echo

    echo "To uninstall Pyenv just delete them from ${HOME}/.bashrc file, and"
    echo "then delete ${PYENV_ROOT} directory"
    echo

    echo 'Done!'
}

install_minimum(){
    apt_update
    install_python_dependencies
    install_git
    install_pyenv
    create_symlink_to_python3
}

if [[ $answer == '1' ]]; then
    install_minimum
    done_message
    restart_current_shell
elif [[ $answer == '2' ]]; then
    install_minimum
    install_python
    done_message
    restart_current_shell
elif [[ $answer == '3' ]]; then
    install_minimum
    install_python
    set_python_global
    done_message
    restart_current_shell
else
    echo "Invalid input. Try again"
    exit 0
fi
