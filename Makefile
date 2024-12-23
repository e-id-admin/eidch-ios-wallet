.DEFAULT_GOAL := generate

# Paths
XCODEGEN := xcodegen
SWIFTGEN := swiftgen
SWIFTFORMAT := swiftformat
PROJECT := swiyu.xcodeproj

# ANSI color codes for better readability in supported terminals
RESET_COLOR := \033[0m
GREEN_COLOR := \033[32m
RED_COLOR := \033[31m
YELLOW_COLOR := \033[33m
CYAN_COLOR := \033[36m

# SPM
SPM_DIRS := $(shell find Modules/Features Modules/Platforms -type d -mindepth 1 -maxdepth 1)

install:
	@echo "=> Installing tools"
	brew update
	brew bundle
	bundle install

generate-info-plist:
	@echo "=> Generating Info.plist using xcodegen"
	$(XCODEGEN) generate

generate-swiftgen:
	@echo "=> Generating Swift code using swiftgen"
	$(SWIFTGEN) && \
		$(XCODEGEN) generate

prepare-modules:
	@echo "$(CYAN_COLOR)=> Generation & Configuration of Modules$(RESET_COLOR)"
	for dir in $(SPM_DIRS); do \
		echo ""; \
		echo "$(YELLOW_COLOR)=> Generating module in $$dir$(RESET_COLOR)"; \
		if (cd "$$dir" && make); then \
			echo "$(GREEN_COLOR)=> Success: $$dir generated$(RESET_COLOR)"; \
		else \
			echo "$(RED_COLOR)=> Error: Failed to generate $$dir$(RESET_COLOR)"; \
		fi; \
		echo "-----------------------------------------"; \
	done

swiftformat:
	@echo "=> Formatting Swift code using swiftformat"
	$(SWIFTFORMAT) .

open-project:
	@echo "=> Opening Xcode project"
	open "$(PROJECT)"

generate: generate-info-plist generate-swiftgen swiftformat prepare-modules open-project

setup: install generate swiftformat open-project
	@echo "=> Done"
