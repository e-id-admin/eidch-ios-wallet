.DEFAULT_GOAL := generate

SWIFTGEN := swiftgen
SWIFTFORMAT := swiftformat

swiftgen:
	@if [ -f swiftgen.yml ]; then \
		echo "=> Generating Swift code using swiftgen"; \
		$(SWIFTGEN); \
	else \
		echo "=> No swiftgen config for this module"; \
	fi

swiftformat:
	@echo "=> Formatting Swift code using swiftformat"
	$(SWIFTFORMAT) .

open: generate
	@echo "=> Opening SPM"
	open "Package.swift"

generate: swiftgen swiftformat
