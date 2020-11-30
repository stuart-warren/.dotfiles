# If you come from bash you might have to change your $PATH.
# export PATH=$HOME/bin:/usr/local/bin:$PATH

# Path to your oh-my-zsh installation.
export ZSH="$HOME/.oh-my-zsh"
export EDITOR="nvim"
alias vim="nvim"
alias vi="nvim"
alias watch='watch '
alias wiki='$EDITOR ~/Google\ Drive\ File\ Stream/My\ Drive/Wiki/index.md'

# Set name of the theme to load --- if set to "random", it will
# load a random theme each time oh-my-zsh is loaded, in which case,
# to know which specific one was loaded, run: echo $RANDOM_THEME
# See https://github.com/robbyrussell/oh-my-zsh/wiki/Themes
ZSH_THEME="powerlevel10k/powerlevel10k"

# Set list of themes to pick from when loading at random
# Setting this variable when ZSH_THEME=random will cause zsh to load
# a theme from this variable instead of looking in ~/.oh-my-zsh/themes/
# If set to an empty array, this variable will have no effect.
# ZSH_THEME_RANDOM_CANDIDATES=( "robbyrussell" "agnoster" )

# Uncomment the following line to use case-sensitive completion.
# CASE_SENSITIVE="true"

# Uncomment the following line to use hyphen-insensitive completion.
# Case-sensitive completion must be off. _ and - will be interchangeable.
# HYPHEN_INSENSITIVE="true"

# Uncomment the following line to disable bi-weekly auto-update checks.
# DISABLE_AUTO_UPDATE="true"

# Uncomment the following line to automatically update without prompting.
# DISABLE_UPDATE_PROMPT="true"

# Uncomment the following line to change how often to auto-update (in days).
# export UPDATE_ZSH_DAYS=13

# Uncomment the following line if pasting URLs and other text is messed up.
# DISABLE_MAGIC_FUNCTIONS=true

# Uncomment the following line to disable colors in ls.
# DISABLE_LS_COLORS="true"

# Uncomment the following line to disable auto-setting terminal title.
# DISABLE_AUTO_TITLE="true"

# Uncomment the following line to enable command auto-correction.
# ENABLE_CORRECTION="true"

# Uncomment the following line to display red dots whilst waiting for completion.
# COMPLETION_WAITING_DOTS="true"

# Uncomment the following line if you want to disable marking untracked files
# under VCS as dirty. This makes repository status check for large repositories
# much, much faster.
# DISABLE_UNTRACKED_FILES_DIRTY="true"

# Uncomment the following line if you want to change the command execution time
# stamp shown in the history command output.
# You can set one of the optional three formats:
# "mm/dd/yyyy"|"dd.mm.yyyy"|"yyyy-mm-dd"
# or set a custom format using the strftime function format specifications,
# see 'man strftime' for details.
# HIST_STAMPS="mm/dd/yyyy"

# Would you like to use another custom folder than $ZSH/custom?
# ZSH_CUSTOM=/path/to/new-custom-folder

# Which plugins would you like to load?
# Standard plugins can be found in ~/.oh-my-zsh/plugins/*
# Custom plugins may be added to ~/.oh-my-zsh/custom/plugins/
# Example format: plugins=(rails git textmate ruby lighthouse)
# Add wisely, as too many plugins slow down shell startup.
plugins=(
    git
    dotenv
)

export GOPATH="$HOME"
export GITROOT="$HOME/src"
mkdir -p "${GITROOT}"
export KUBECONFIG="${HOME}/.kube/config:${HOME}/.kube/kind-config-kind:${GITROOT}/gitlab.tech.lastmile.com/kubernetes/overview-docs/files/kubeconfig:${HOME}/.kube/panda-agent-config"

export BREW_PREFIX="$(brew --prefix)"

path=(
  "${BREW_PREFIX}/opt/coreutils/libexec/gnubin"
  "${BREW_PREFIX}/opt/curl/bin"
  "${BREW_PREFIX}/opt/findutils/libexec/gnubin"
  "${BREW_PREFIX}/opt/gnu-getopt/bin"
  "${BREW_PREFIX}/opt/gnu-sed/libexec/gnubin"
  "${BREW_PREFIX}/opt/gnu-tar/libexec/gnubin"
  "${BREW_PREFIX}/opt/grep/libexec/gnubin"
  "${BREW_PREFIX}/opt/ncurses/bin"
  "${BREW_PREFIX}/opt/openssl@1.1/bin"
  "${BREW_PREFIX}/opt/sqlite/bin"
  "${BREW_PREFIX}/opt/unzip/bin"
  "$GOPATH/bin"
  "$HOME/bin"
  "${HOME}/.local/bin"
  "${GITROOT}/gitlab.ocado.tech/kamil.kafara/k8s-utils"
  $path
  "/Applications/Visual Studio Code.app/Contents/Resources/app/bin"
  "/Applications/Sublime Text 2.app/Contents/SharedSupport/bin"
)

source $ZSH/oh-my-zsh.sh

alias k="kubectl"
alias describe="k describe"
alias get="k get"
alias delete="k delete"
alias logs="k logs"

[[ -f $HOME/.k8sh_extensions ]] && source $HOME/.k8sh_extensions
# User configuration

# export MANPATH="/usr/local/man:$MANPATH"

# You may need to manually set your language environment
# export LANG=en_US.UTF-8

# Preferred editor for local and remote sessions
# if [[ -n $SSH_CONNECTION ]]; then
#   export EDITOR='vim'
# else
#   export EDITOR='mvim'
# fi

# Compilation flags
# export ARCHFLAGS="-arch x86_64"

# Set personal aliases, overriding those provided by oh-my-zsh libs,
# plugins, and themes. Aliases can be placed here, though oh-my-zsh
# users are encouraged to define aliases within the ZSH_CUSTOM folder.
# For a full list of active aliases, run `alias`.
#
# Example aliases
# alias zshconfig="mate ~/.zshrc"
# alias ohmyzsh="mate ~/.oh-my-zsh"

GPG_TTY=$(tty)
export GPG_TTY
if [ ! -e "${HOME}/.gnupg/S.gpg-agent.ssh" ]; then
    echo "Starting gpg-agent daemon"
    eval $(gpg-agent --daemon)
fi
export SSH_AUTH_SOCK="${HOME}/.gnupg/S.gpg-agent.ssh"

if type brew &>/dev/null; then
  FPATH=${BREW_PREFIX}/share/zsh/site-functions:$FPATH
fi
fpath=(${BREW_PREFIX}/share/zsh-completions $fpath)


# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh
if command -v pyenv 1>/dev/null 2>&1; then
  eval "$(pyenv init -)"
fi
if which pyenv-virtualenv-init > /dev/null; then 
  eval "$(pyenv virtualenv-init -)"
fi
alias mkvenv="pyenv virtualenv"

[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh

# source openstack-deploy config file for user with openstack-cli
source-config() {
  local config=$1
  export "OS_AUTH_URL=https://api-cloud.$(cat ${config} | yq '.ROOT_DOMAIN_NAME' -r):5000/v3"
  source <(cat ${config} | yq '.OPENSTACK' | jq -r 'to_entries | map("export OS_\(.key)=\(.value)") | .[]')
}

rm-known-host() {
  local lineno=$1
  sed -i'' "${lineno}d" ${HOME}/.ssh/known_hosts
}

clone() {
    repo="${1}"
    d="${repo#'https://'}"
    d="${d#'git@'}"
    d="${d%'.git'}"
    d="${d//://}"
    git clone "${repo}" "${GITROOT}/${d}"
    pushd "${GITROOT}/${d}"
}

notepad() {
  pad="$HOME/notes/$(date --rfc-3339=date).md"
  mkdir -p "$(dirname $pad)"
  $EDITOR $pad
}
alias np="notepad"

alias dotfiles="${HOME}/.dotfiles/install"

# Use fd (https://github.com/sharkdp/fd) instead of the default find
# command for listing path candidates.
# - The first argument to the function ($1) is the base path to start traversal
# - See the source code (completion.{bash,zsh}) for the details.
_fzf_compgen_path() {
  fd --hidden --follow --exclude ".pyenv" --exclude ".git"  --exclude ".virtualenvs" --exclude "vendor" --exclude "node_modules" --exclude "Library" --exclude "pkg" --exclude "go/pkg" . "$1"
}

# Use fd to generate the list for directory completion
_fzf_compgen_dir() {
  fd --type d --hidden --follow --exclude ".pyenv" --exclude ".git" --exclude ".virtualenvs" --exclude "vendor" --exclude "node_modules" --exclude "Library" --exclude "pkg" --exclude "go/pkg" . "$1" "$HOME"
}

alias fd='fd --exclude vendor --exclude node_modules --exclude Library --exclude site-packages --exclude "pkg" --exclude "go/pkg"'

# alias backlog-create='gitlab issue create 10210 >/dev/null'
# alias todo='gitlab issue create 30298 >/dev/null'

alias pywatch="reflex -d none -R '^.mypy_cache/' -r '\.py$' --"
alias gowatch="reflex -d none -r '\.go$' --"

export WORKON_HOME=$HOME/.virtualenvs
export PROJECT_HOME=$GITROOT
export VIRTUAL_ENV_DISABLE_PROMPT=0
# export VIRTUALENVWRAPPER_PYTHON=$HOME/.pyenv/shims/python3
export PANDA_USERNAME="stuart.warren"
# [[ -f /usr/local/bin/virtualenvwrapper.sh ]] && source /usr/local/bin/virtualenvwrapper.sh
