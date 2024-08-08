
.PHONY: help run

## Display this help message
help:
	@echo "Available commands:"
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | sort | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-30s\033[0m %s\n", $$1, $$2}'

run: ## Run the Phoenix server with aws-vault credentials
	aws-vault exec pento-dev -- iex -S mix phx.server

# Set the default target to help
.DEFAULT_GOAL := help
