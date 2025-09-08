
install:
	brew install --cask ghostty
	brew install golang 
	brew install rust 
	brew install python
	brew install npm
	sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
	git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting
	git clone https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions


CURRENT_DIR := $(shell pwd)
setup: symlinking-nvim-config symlinking-ghostty-config symlinking-zsh-config symlinking-gitaliases-config:
	@echo "Setup complete!"

NVIM_CONFIG_PATH := ${HOME}/.config/nvim
BACKUP_PATH := ${HOME}/.config/nvim.backup.$(shell date +%Y%m%d_%H%M%S)
symlinking-nvim-config:
	@if [ -d "$(NVIM_CONFIG_PATH)" ] && [ ! -L "$(NVIM_CONFIG_PATH)" ]; then \
		echo "Backing up existing nvim config to $(BACKUP_PATH)"; \
		mv "$(NVIM_CONFIG_PATH)" "$(BACKUP_PATH)"; \
	fi
	@echo "Creating symlink from $(CURRENT_DIR)/nvim to $(NVIM_CONFIG_PATH)"
	@ln -sf "$(CURRENT_DIR)/nvim" "$(NVIM_CONFIG_PATH)"


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
	@echo "Creating symlink from $(CURRENT_DIR)/ohmyzsh/.zshrc to $(ZSHRC_FILE_PATH)"
	@ln -sf "$(CURRENT_DIR)/ohmyzsh/.zshrc" "$(ZSHRC_FILE_PATH)"
	@echo "Creating symlink from $(CURRENT_DIR)/ohmyzsh/.zprofile to $(ZSPROFILE_FILE_PATH)"
	@ln -sf "$(CURRENT_DIR)/ohmyzsh/.zprofile" "$(ZSPROFILE_FILE_PATH)"


GITALIAS_PATH := ${HOME}/.gitaliases
symlinking-gitaliases-config:
	@echo "Creating symlink from $(CURRENT_DIR)/.gitaliases to $(GITALIAS_PATH)"
	@ln -sf "$(CURRENT_DIR)/.gitaliases" "$(GITALIAS_PATH)"



