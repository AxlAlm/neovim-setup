
# Get the current directory where the Makefile is located
CURRENT_DIR := $(shell pwd)
NVIM_CONFIG_PATH := ${HOME}/.config/nvim
BACKUP_PATH := ${HOME}/.config/nvim.backup.$(shell date +%Y%m%d_%H%M%S)

.PHONY: setup
setup:
	@if [ -d "$(NVIM_CONFIG_PATH)" ] && [ ! -L "$(NVIM_CONFIG_PATH)" ]; then \
		echo "Backing up existing nvim config to $(BACKUP_PATH)"; \
		mv "$(NVIM_CONFIG_PATH)" "$(BACKUP_PATH)"; \
	fi
	@echo "Creating symlink from $(CURRENT_DIR)/nvim to $(NVIM_CONFIG_PATH)"
	@ln -sf "$(CURRENT_DIR)/nvim" "$(NVIM_CONFIG_PATH)"
	@echo "Setup complete!"
