export ZSH="$HOME/.oh-my-zsh"

ZSH_THEME=eastwood

plugins=(git zsh-autosuggestions zsh-syntax-highlighting)

export PATH="$HOME/.local/bin:$PATH"

source $ZSH/oh-my-zsh.sh

eval "$(mise activate zsh)"


# psql and other commands
# export PATH="/opt/homebrew/opt/libpq/bin:$PATH"

# rust cargo
# . "$HOME/.cargo/env"

# elixir
# export PATH=$HOME//opt/homebrew/Cellar/erlang/27.3.3/lib/erlang/erts-15.2.6/bin:$PATH
# export PATH=$HOME//opt/homebrew/bin:$PATH

# bun completions
# [ -s "/Users/axelalmquist/.bun/_bun" ] && source "/Users/axelalmquist/.bun/_bun"

# bun
# export BUN_INSTALL="$HOME/.bun"
# export PATH="$BUN_INSTALL/bin:$PATH"
#
# export PATH=$PATH:$(go env GOPATH)/bin
