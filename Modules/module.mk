# Common variables
SWIFTGEN ?= swiftgen
SWIFTFORMAT ?= swiftformat

# Get module name from directory
MODULE_NAME ?= $(shell basename $(CURDIR))

# Color codes
YELLOW := \033[0;33m
GREEN := \033[0;32m
CYAN := \033[0;36m
RESET := \033[0m

.DEFAULT_GOAL := generate

# Common targets
swiftgen:
	@if [ -f swiftgen.yml ]; then \
		printf "$(YELLOW)⠋ Generating code for $(MODULE_NAME)$(RESET)\r"; \
		$(SWIFTGEN) 2>/dev/null >/dev/null; \
		printf "$(GREEN)✓ Generated code for $(MODULE_NAME)  $(RESET)\n"; \
	fi

swiftformat:
	@printf "$(YELLOW)⠋ Formatting $(MODULE_NAME)$(RESET)\r"
	@$(SWIFTFORMAT) --quiet . 2>/dev/null >/dev/null
	@printf "$(GREEN)✓ Formatted $(MODULE_NAME)  $(RESET)\n"

open: generate
	@printf "$(GREEN)=> Opening $(MODULE_NAME)$(RESET)\n"
	@open "Package.swift"

generate: swiftgen swiftformat
	@printf "$(GREEN)✨ All tasks completed for $(MODULE_NAME)$(RESET)\n"

.PHONY: swiftgen swiftformat open generate
