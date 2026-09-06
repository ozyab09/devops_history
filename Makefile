# Переиспользуемые команды из курса DevOps-2018-09
# (источник: history — см. CHEATSHEET.md)

SHELL := /bin/bash
USER_NAME ?= ozyab

## ---------- Docker ----------

.PHONY: docker-build docker-push docker-ps docker-clean
docker-build:   ## Сборка образа reddit
	docker build -t $(USER_NAME)/reddit:latest .

docker-push:    ## Публикация образа в registry
	docker push $(USER_NAME)/reddit:latest

docker-ps:      ## Список контейнеров (таблица)
	docker ps -a --format "table {{.ID}}\t{{.Image}}\t{{.CreatedAt}}\t{{.Names}}"

docker-clean:   ## Удалить ВСЕ контейнеры
	docker kill $$(docker ps -q)

## ---------- Ansible ----------

.PHONY: ansible-check ansible-deploy ansible-lint
ansible-check:  ## Синтаксис-проверка всех плейбуков
	find . -name "*.yml" -not -name "inventory*.yml" -type f -print0 | xargs -0 -n1 ansible-playbook --syntax-check

ansible-deploy: ## Деплой reddit (тег deploy)
	ansible-playbook reddit_app.yml --check --limit app --tags deploy-tag

ansible-lint:   ## Линт ролей
	ansible-lint roles/db/tasks/main.yml

## ---------- Terraform ----------

.PHONY: tf-init tf-plan tf-apply tf-destroy tf-fmt
tf-init:        ## Инициализация терраформа
	terraform init

tf-plan:        ## План изменений
	terraform plan

tf-apply:       ## Применить изменения
	terraform apply -auto-approve=false

tf-destroy:     ## Уничтожить инфраструктуру
	terraform destroy

tf-fmt:         ## Форматирование конфигов
	terraform fmt

## ---------- Packer ----------

.PHONY: packer-validate packer-build
packer-validate: ## Проверка шаблона
	packer validate -var-file=variables.json ubuntu16.json

packer-build:    ## Сборка образа
	packer build -var-file=variables.json ubuntu16.json

## ---------- Качество ----------

.PHONY: lint
lint:           ## Проверки: markdownlint + hadolint
	@command -v markdownlint-cli2 >/dev/null || echo "markdownlint-cli2 не установлен"
	@command -v hadolint >/dev/null || echo "hadolint не установлен"

.PHONY: help
help:           ## Справка по целям
	@grep -hE '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | \
		awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-16s\033[0m %s\n", $$1, $$2}'