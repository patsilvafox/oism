CURRENT_DIR := $(shell pwd)

.PHONY: help
help: ## Display help message
	@grep -E '^[0-9a-zA-Z_-]+\.*[0-9a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | sort | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-30s\033[0m %s\n", $$1, $$2}'

.PHONY: start
start: ## Start Lab
	sudo clab deploy -t lab.yml

.PHONY: stop
stop: ## Stop Lab
	sudo clab destroy -t lab.yml --cleanup

.PHONY: inspect
inspect: ## Inspect Lab
	sudo clab inspect -a
