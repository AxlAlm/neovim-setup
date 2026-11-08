CURRENT_DIR := $(shell pwd)
TIMESTAMP := $(shell date +%Y%m%d_%H%M%S)

.PHONY: setup install make_config_dir set_git_editor_neovim symlinking-nvim-config symlinking-ghostty-config symlinking-zsh-config symlinking-gitaliases-config symlinking-worktree-config

setup: install make_config_dir symlinking-nvim-config symlinking-ghostty-config symlinking-zsh-config symlinking-gitaliases-config symlinking-worktree-config set_git_editor_neovim
	@echo "Setup complete!"

install:
	brew install --cask ghostty
	brew install neovim
	brew install curl
	brew install gh
	brew install mise
	brew install ripgrep
	brew install tree
	brew install tree-sitter-cli
	brew install zsh
	@[ -d "$$HOME/.oh-my-zsh" ] || \
		sh -c "$$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
	@[ -d "$${ZSH_CUSTOM:-$$HOME/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting" ] || \
		git clone https://github.com/zsh-users/zsh-syntax-highlighting.git $${ZSH_CUSTOM:-$$HOME/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting
	@[ -d "$${ZSH_CUSTOM:-$$HOME/.oh-my-zsh/custom}/plugins/zsh-autosuggestions" ] || \
		git clone https://github.com/zsh-users/zsh-autosuggestions $${ZSH_CUSTOM:-$$HOME/.oh-my-zsh/custom}/plugins/zsh-autosuggestions
	mise trust "$(CURRENT_DIR)/.mise.toml"
	mise install

make_config_dir:
	@mkdir -p "$$HOME/.config"

set_git_editor_neovim:
	git config --global core.editor nvim

NVIM_CONFIG_PATH := ${HOME}/.config/nvim
BACKUP_PATH := ${HOME}/.config/nvim.backup.$(TIMESTAMP)
symlinking-nvim-config:
	@if [ -d "$(NVIM_CONFIG_PATH)" ] && [ ! -L "$(NVIM_CONFIG_PATH)" ]; then \
		echo "Backing up existing nvim config to $(BACKUP_PATH)"; \
		mv "$(NVIM_CONFIG_PATH)" "$(BACKUP_PATH)"; \
	fi
	@echo "Creating symlink from $(CURRENT_DIR)/nvim to $(NVIM_CONFIG_PATH)"
	@ln -sfn "$(CURRENT_DIR)/nvim" "$(NVIM_CONFIG_PATH)"


GHOSTTY_CONFIG_PATH := ${HOME}/.config/ghostty
symlinking-ghostty-config:
	@if [ ! -d "$(GHOSTTY_CONFIG_PATH)" ]; then \
		echo "creating new dir"; \
		mkdir -p "$(GHOSTTY_CONFIG_PATH)"; \
	fi
	@echo "Creating symlink from $(CURRENT_DIR)/ghostty to $(GHOSTTY_CONFIG_PATH)"
	@ln -sf "$(CURRENT_DIR)/ghostty/config" "$(GHOSTTY_CONFIG_PATH)"


ZSHRC_FILE_PATH := ${HOME}/.zshrc
ZSPROFILE_FILE_PATH := ${HOME}/.zprofile
symlinking-zsh-config:
	@for f in "$(ZSHRC_FILE_PATH)" "$(ZSPROFILE_FILE_PATH)"; do \
		if [ -f "$$f" ] && [ ! -L "$$f" ]; then \
			echo "Backing up existing $$f to $$f.backup.$(TIMESTAMP)"; \
			mv "$$f" "$$f.backup.$(TIMESTAMP)"; \
		fi; \
	done
	@echo "Creating symlink from $(CURRENT_DIR)/ohmyzsh/.zshrc to $(ZSHRC_FILE_PATH)"
	@ln -sf "$(CURRENT_DIR)/ohmyzsh/.zshrc" "$(ZSHRC_FILE_PATH)"
	@echo "Creating symlink from $(CURRENT_DIR)/ohmyzsh/.zprofile to $(ZSPROFILE_FILE_PATH)"
	@ln -sf "$(CURRENT_DIR)/ohmyzsh/.zprofile" "$(ZSPROFILE_FILE_PATH)"


GITALIAS_PATH := ${HOME}/.gitaliases
symlinking-gitaliases-config:
	@echo "Creating symlink from $(CURRENT_DIR)/.gitaliases to $(GITALIAS_PATH)"
	@ln -sf "$(CURRENT_DIR)/.gitaliases" "$(GITALIAS_PATH)"
	@git config --global --replace-all include.path '~/.gitaliases' '\.gitaliases$$'


WORKTREE_ZSH_DIR := $${ZSH_CUSTOM:-$$HOME/.oh-my-zsh/custom}
symlinking-worktree-config:
	@mkdir -p "$(WORKTREE_ZSH_DIR)"
	@echo "Creating symlink from $(CURRENT_DIR)/ohmyzsh/worktree.zsh to $(WORKTREE_ZSH_DIR)/worktree.zsh"
	@ln -sf "$(CURRENT_DIR)/ohmyzsh/worktree.zsh" "$(WORKTREE_ZSH_DIR)/worktree.zsh"
