.PHONY: help
help: ## help
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-20s\033[0m %s\n", $$1, $$2}'

.PHONY: up
up: volume ## up
	@docker-compose up -d

.PHONY: reup
reup: volume ## up
	@docker-compose up -d --build

.PHONY: down
down: ## down
	@docker-compose down

.PHONY: ps
ps: volume ## ps
	@docker-compose ps

.PHONY: password
password: ## password
	@docker-compose exec gitlab cat /etc/gitlab/initial_root_password | grep "Password:" | awk '{ print $$2 }'

volume: ## volume
	@mkdir -p volume/gitlab-runner/config
	@mkdir -p volume/gitlab/config
	@mkdir -p volume/gitlab/logs
	@mkdir -p volume/gitlab/data

.PHONY: register
register: ## register
	@docker run --rm -t -i -v ${PWD}/volume/gitlab-runner/config:/etc/gitlab-runner --name gitlab-runner-tmp gitlab/gitlab-runner register
	@sudo sed -i -e 's/url = \"http:\/\/host.docker.internal:9080\"/url = \"http:\/\/host.docker.internal:9080\"\n  clone = \"http:\/\/host.docker.internal:9080\"/g' ./volume/gitlab-runner/config/config.toml
	@sudo sed -i -e 's/privileged = false/privileged = true/g' ./volume/gitlab-runner/config/config.toml
	@docker-compose restart

.PHONY: keygen
keygen: ## keygen
	@mkdir -p ~/.ssh && cd ~/.ssh && ssh-keygen -t ed25519 -f id_ed25519_gitlab
	@echo "set public key to your clipboard"
	@pbcopy < ~/.ssh/id_ed25519_gitlab.pub
