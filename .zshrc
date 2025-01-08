export ZSH="$HOME/.oh-my-zsh"
ZSH_THEME="fino"

plugins=(
        git
    )

source $ZSH/oh-my-zsh.sh

export PATH=$PATH:$(go env GOPATH)/bin


