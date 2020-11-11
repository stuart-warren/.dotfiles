echo "loading ~/.bash_profile"
GPG_TTY=$(tty)
export GPG_TTY
if [ ! -e "${HOME}/.gnupg/S.gpg-agent.ssh" ]; then
    echo "Starting gpg-agent daemon"
    eval $(gpg-agent --daemon)
fi
export SSH_AUTH_SOCK="${HOME}/.gnupg/S.gpg-agent.ssh"


HOMEBREW_PREFIX=$(brew --prefix)
if type brew &>/dev/null; then
  if [[ -r "${HOMEBREW_PREFIX}/etc/profile.d/bash_completion.sh" ]]; then
    source "${HOMEBREW_PREFIX}/etc/profile.d/bash_completion.sh"
  else
    for COMPLETION in "${HOMEBREW_PREFIX}/etc/bash_completion.d/"*; do
      [[ -r "$COMPLETION" ]] && source "$COMPLETION"
    done
  fi
fi
[[ -r "/usr/local/etc/profile.d/bash_completion.sh" ]] && . "/usr/local/etc/profile.d/bash_completion.sh"

