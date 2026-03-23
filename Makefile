.PHONY: help tf-format tf-lint-fix tf-validate

TF_DIR := src/tf

help:
	@echo "Module commands:"
	@echo "  Format check: make tf-format"
	@echo "  Format fix:   make tf-lint-fix"
	@echo "  Validate:     make tf-validate"

tf-format:
	@cd $(TF_DIR) && tofu fmt -check -recursive

tf-lint-fix:
	@cd $(TF_DIR) && tofu fmt -recursive

tf-validate:
	@for dir in $(TF_DIR)/modules/*/; do \
		echo "Validating $$dir"; \
		cd "$$dir" && tofu init -backend=false && tofu validate && cd - > /dev/null; \
	done
