## Install Steps

```
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install.sh)
brew install bash bash-completion@2 coreutils curl fd findutils fzf git gnu-getopt gnu-sed gnu-tar gnupg gnutls go grep jq ncdu neovim openssh pinentry pyenv readline shellcheck snapcraft tmux unzip watch wget xz zsh
brew link --overwrite gnupg
```

### PATH env
```
PATH="/usr/local/opt/coreutils/libexec/gnubin:$PATH"
PATH="/usr/local/opt/curl/bin:$PATH"
PATH="/usr/local/opt/findutils/libexec/gnubin:$PATH"
PATH="/usr/local/opt/gnu-getopt/bin:$PATH"
PATH="/usr/local/opt/gnu-sed/libexec/gnubin:$PATH"
PATH="/usr/local/opt/gnu-tar/libexec/gnubin:$PATH"
PATH="/usr/local/opt/grep/libexec/gnubin:$PATH"
PATH="/usr/local/opt/ncurses/bin:$PATH"
PATH="/usr/local/opt/openssl@1.1/bin:$PATH"
PATH="/usr/local/opt/sqlite/bin:$PATH"
PATH="/usr/local/opt/unzip/bin:$PATH"

PATH="$PATH:/Applications/Visual Studio Code.app/Contents/Resources/app/bin"
PATH="$PATH:/Applications/Sublime Text 2.app/Contents/SharedSupport/bin"
```

```
git clone https://github.com/stuart-warren/.dotfiles.git ${HOME}/.dotfiles
${HOME}/.dotfiles/install
```