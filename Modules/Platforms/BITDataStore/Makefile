.DEFAULT_GOAL := generate

SWIFTFORMAT := swiftformat

swiftformat:
	@echo "=> Formatting Swift code using swiftformat"
	$(SWIFTFORMAT) .

open: generate
	@echo "=> Opening SPM"
	open "Package.swift"

generate: swiftformat

