# devops_history

Консольная история команд с курса **OTUS DevOps-2018-09** — мой путь от Ansible до Kubernetes.

## 📊 Статистика

| Инструмент | Команд |
| --- | --- |
| Kubernetes (kubectl, minikube) | 86 |
| Git | 69 |
| Docker / Compose / Machine | 64 |
| Ansible (+playbook, galaxy, vault) | 44 |
| Helm | 23 |
| Terraform | 23 |
| GCloud | 21 |
| Packer | 12 |
| Python (pip, virtualenv) | 9 |
| Molecule | 8 |
| K8s The Hard Way (cfssl, openssl) | 7 |
| Ruby (gem) | 7 |
| Go | 7 |
| Travis CI | 4 |
| Hadolint | 2 |
| Прочее | 37 |
| **Итого** | **423** |

## 📁 Структура

- `history` — сырая консольная история (очищенная: склейки разбиты, опечатки исправлены, секреты заменены на `<placeholders>`)
- `CHEATSHEET.md` — команды, сгруппированные по темам с описаниями
- `Makefile` — переиспользуемые команды (docker, ansible, terraform, packer)
- `.github/workflows/` — CI-проверки

## 🚀 Быстрый старт

```bash
# Шпаргалка по командам
less CHEATSHEET.md

# Переиспользуемые цели
make help
make docker-build   # сборка образа
make tf-plan        # план terraform
```

## 🧹 Очистка

История приведена в порядок:

- разбиты склеенные команды (несколько команд в одной строке)
- исправлены опечатки (`terrafom` → `terraform`, `docer` → `docker` и др.)
- удалены дубликаты (458 → 423 уникальных)
- секреты и приватные ключи заменены на `<placeholders>`

> ⚠️ Если репозиторий публичный — проверьте git-историю: старые коммиты
> могли содержать чувствительные данные до очистки. При необходимости
> перепишите историю (`git filter-repo`).

## 📚 Что внутри (темы курса)

**Ansible** — управление конфигурацией: ad-hoc команды, плейбуки, роли, vault, molecule-тесты.
**Docker** — сборка образов, сети, тома, compose, docker-machine на GCP.
**Kubernetes** — kubectl повседневка: apply/delete, describe/get, logs, port-forward, secrets.
**K8s The Hard Way** — генерация сертификатов cfssl/openssl (собственный кластер).
**Helm** — пакетный менеджер: чарты (grafana, gitlab), tiller, upgrade.
**Terraform** — IaC для GCP: init/plan/apply, import, taint, fmt.
**Packer** — сборка образов VM (immutable инфраструктура).
**GCloud** — auth, compute instances, firewall, ssh.
**Travis CI** — интеграция, encrypt для Slack-уведомлений.
**Git** — повседневные операции, работа с gitlab, rebase, теги.
