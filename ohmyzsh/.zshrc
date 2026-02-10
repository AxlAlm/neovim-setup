export ZSH="$HOME/.oh-my-zsh"

ZSH_THEME=eastwood

plugins=(git zsh-autosuggestions zsh-syntax-highlighting)

export PATH="$HOME/.local/bin:$PATH"

source $ZSH/oh-my-zsh.sh

eval "$(mise activate zsh)"

export PATH="/opt/homebrew/opt/postgresql@16/bin:$PATH"


