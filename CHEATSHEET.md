# Шпаргалка по командам DevOps (курс OTUS DevOps-2018-09)

> Источник: консольная история из курса. Сгруппировано по темам,
> к каждой команде — пояснение, что она делает.

## Статистика

- Всего команд: **398** (многострочные объединены, дубликаты убраны)
- Тем: 17

---

## ANSIBLE — 44 команд

Управление конфигурацией: ad-hoc команды, плейбуки, роли, vault, lint.

```bash
# Найти все *.yml и проверить синтаксис ansible-playbook (обрывок find).
ansible ! -name "inventory*.yml" -name "*.yml" -type f -print0 | xargs -0 -n1 ansible-playbook --syntax-check
# Выполнить модуль command на localhost, аргументы: ping.
ansible -a ping localhost
# Выполнить модуль ping на all, инвентори inventory.json.
ansible all -i inventory.json -m ping
# Выполнить модуль command на all, аргументы: uptime, инвентори inventory.yml.
ansible all -i inventory.yml -m command -a uptime
# Выполнить модуль command на app, аргументы: uptime, инвентори inventory.
ansible app -i inventory -m command -a uptime
# Выполнить модуль command на app, аргументы: bundler -v, инвентори inventory.yml.
ansible app -i inventory.yml -m command -a 'bundler -v'
# Выполнить модуль shell на app, аргументы: ruby -v; bundler -v, инвентори inventory.yml.
ansible app -i inventory.yml -m shell  -a 'ruby -v; bundler -v'
# Выполнить модуль command на app, аргументы: rm -rf ~/reddit.
ansible app -m command -a 'rm -rf ~/reddit'
# Выполнить модуль git на app, аргументы: repo=https://github.com/express42/reddit.git dest=/home/appuser/reddit.
ansible app -m git -a 'repo=https://github.com/express42/reddit.git dest=/home/appuser/reddit'
# Выполнить модуль ping на appserver, инвентори inventory.
ansible appserver -i inventory -m ping
# Выполнить модуль command на appserver, аргументы: uptime, инвентори inventory.yml.
ansible appserver -i inventory.yml -m command -a uptime
# Выполнить модуль ping на site.yml, инвентори inventory, check mode (dry-run).
ansible -C -i inventory site.yml
# Выполнить модуль shell на db, аргументы: systemctl status mongod, инвентори inventory.yml.
ansible db -i inventory.yml -m shell  -a 'systemctl status mongod'
# Выполнить модуль service на db, аргументы: name=mongod.
ansible db -m service -a name=mongod
# Выполнить модуль command на dbserver, аргументы: uptime, инвентори inventory.
ansible dbserver -i inventory -m command -a uptime
# Выполнить модуль ping на dbserver, инвентори inventory.
ansible dbserver -i inventory -m ping
# Выполнить модуль free -m (обрывок: не указаны хосты).
ansible -i inventory -m 'free -m'
# Выполнить модуль localhost (обрывок: не указаны хосты).
ansible -m localhost
# Выполнить модуль ping (обрывок: не указаны хосты).
ansible -m ping
# Выполнить модуль free -m на servers, инвентори inventory.
ansible servers -i inventory -m  "free -m"
# Выполнить модуль raw на servers free -m, инвентори inventory, по SSH-ключу.
ansible servers -i inventory -m raw "free -m" --private-key=<path-to-key> -u root
# Справка по ansible-galaxy.
ansible-galaxy -h
# Создать каркас Ansible-роли.
ansible-galaxy init
# Создать каркас Ansible-роли.
ansible-galaxy init app
# Установить роли из requirements.yml.
ansible-galaxy install -r environments/stage/requirements.yml
# Проверить текущую роль линтером ansible-lint.
ansible-lint
# Проверить roles/db/tasks/config_mongo.yml линтером ansible-lint.
ansible-lint roles/db/tasks/config_mongo.yml
# Проверить roles/db/tasks/main.yml линтером ansible-lint.
ansible-lint roles/db/tasks/main.yml
# Справка ansible-playbook (команда без плейбука).
ansible-playbook
# Прогнать плейбук site.yml, инвентори inventory.yml, проверка синтаксиса.
ansible-playbook  -i inventory.yml --syntax-check  site.yml
# Прогнать плейбук site.yml.
ansible-playbook  site.yml
# Прогнать плейбук site.yml, проверка синтаксиса.
ansible-playbook  --syntax-check  site.yml
# Прогнать плейбук site.yml, инвентори inventory.yml, dry-run (--check).
ansible-playbook -C -i inventory.yml site.yml
# Прогнать плейбук reddit_app.yml, dry-run (--check).
ansible-playbook -C reddit_app.yml -L app -t pp-tag
# Прогнать плейбук reddit_app.yml, только хосты app, dry-run (--check).
ansible-playbook -C reddit_app.yml --limit app -t pp-tag
# Прогнать плейбук clone.yml, показывать диффы.
ansible-playbook -D clone.yml
# Прогнать плейбук reddit_app.yml, только хосты app, теги app-tag, показывать диффы.
ansible-playbook -D reddit_app.yml --limit app --tags app-tag
# Прогнать плейбук playbooks/site.yml, инвентори environments/stage/inventory, с vault-паролем из файла.
ansible-playbook -i environments/stage/inventory playbooks/site.yml --vault-password-file=~/.ansible/vault.key
# Справка ansible-playbook (команда без плейбука).
ansible-playbook -i inventory -m ping
# Прогнать плейбук deploy.yml, инвентори inventory, с SSH-ключом.
ansible-playbook -i inventory --private-key=<path-to-key> -u gitlab deploy.yml -v
# Прогнать плейбук reddit_app.yml, только хосты app, теги deploy-tag, dry-run (--check).
ansible-playbook reddit_app.yml --check --limit app --tags deploy-tag
# Прогнать плейбук reddit_app.yml, только хосты app, теги deploy-tag, показывать диффы.
ansible-playbook reddit_app.yml -D --limit app --tags deploy-tag
# Отредактировать зашифрованный vault-файл.
ansible-vault edit environments/prod/credentials.yml
# Отредактировать зашифрованный vault-файл (пароль из vault.key).
ansible-vault edit environments/prod/credentials.yml --vault-password-file=~/.ansible/vault.key
```

---

## DOCKER — 64 команд

Контейнеры: сборка, запуск, сети, тома, compose, docker-machine (GCP).

```bash
# Выполнить команду bash внутри контейнера bb387d0746f9.
docker exec -it bb387d0746f9 bash
# Собрать образ $USER_NAME/fluentd из Dockerfile (.).
docker build -t $USER_NAME/fluentd .
# Собрать образ ozyab/comment:1.0 из Dockerfile (./comment).
docker build -t ozyab/comment:1.0 ./comment
# Собрать образ ozyab/ui:2.1 из Dockerfile (./ui/Dockerfile.1).
docker build -t ozyab/ui:2.1 ./ui/Dockerfile.1
# Собрать образ reddit:latest из Dockerfile (.).
docker build -t reddit:latest .
# Сохранить контейнер a47012494398 как образ ozyab09/ubuntu-tmp-file.
docker commit a47012494398 ozyab09/ubuntu-tmp-file
# Детальная информация о контейнере (через docker container).
docker container inspect a47012494398
# Список контейнеров.
docker container ls
# Показать изменения файлов в контейнере.
docker diff reddit
# Выполнить команду /bin/sh внутри контейнера 2a9.
docker exec -it 2a9 /bin/sh
# Выполнить команду /bin/sh внутри контейнера ozyab/ui:2.1.
docker exec -it ozyab/ui:2.1 /bin/sh
# Принудительно удалить образы.
docker image rm -f ozyab09/ubuntu-tmp-file hello-world ubuntu nginx tehbilly/htop consol/centos-xfce-vnc
# Удалить образы.
docker image rm ozyab09/ubuntu-tmp-file hello-world ubuntu nginx tehbilly/htop consol/centos-xfce-vnc
# Информация о Docker-демоне (версии, драйверы, ресурсы).
docker info
# Детальная информация об объекте ozyab/otus-reddit:1.0.
docker inspect ozyab/otus-reddit:1.0
# Детальная информация об объекте ozyab/otus-reddit:1.0. (выборочные поля через -f)
docker inspect ozyab/otus-reddit:1.0  -f '{{.ContainerConfig.Cmd}}'
# Принудительно остановить все работающие контейнеры.
docker kill $(docker ps -q)
# Показать логи контейнера 492.
docker logs 492
# Следить за логами контейнера dockermicroservices_elasticsearch_1.
docker logs -f dockermicroservices_elasticsearch_1
# Выйти из Docker registry (docker hub).
docker logout
# Следить за логами контейнера f6f.
docker logs -f  f6f
# Следить за логами контейнера 75e2def22450.
docker logs -f 75e2def22450
# Создать сеть back_net с подсетью 10.0.2.0/24.
docker network create back_net --subnet=10.0.2.0/24
# Создать сеть front_net с подсетью 10.0.1.0/24.
docker network create front_net --subnet=10.0.1.0/24
# Создать сеть reddit.
docker network create reddit
# Список всех контейнеров (включая остановленные), таблицей.
docker ps -a --format "table {{.ID}}\t{{.Image}}\t{{.CreatedAt}}\t{{.Names}}"
# Скачать образ ozyab/prometheus:latest.
docker pull ozyab/prometheus:latest
# Скачать образ ubuntu-16.04.
docker pull ubuntu-16.04
# Загрузить образ $USER_NAME/ui:1.0 в registry.
docker push $USER_NAME/ui:1.0
# Загрузить образ ozyab/comment в registry.
docker push ozyab/comment
# Запустить контейнер в фоне из образа nginx.
docker run -d  nginx
# Запустить контейнер в фоне из образа ozyab/ui:1.0, имя ui, порт 9292:9292, сеть front_net.
docker run -d --network=front_net -p 9292:9292 --name ui ozyab/ui:1.0
# Запустить контейнер в фоне из образа ozyab/comment:1.0, имя comment, сеть back_net.
docker run -d --network=back_net --name comment ozyab/comment:1.0
# Запустить контейнер в фоне из образа ozyab/post:1.0, имя post, сеть back_net.
docker run -d --network=back_net --name post ozyab/post:1.0
# Запустить контейнер в фоне из образа mongo:latest, имя mongo_db, сеть back_net, с сетевыми алиасами.
docker run -d --network=back_net --name mongo_db --network-alias=post_db --network-alias=comment_db mongo:latest
# Запустить контейнер из образа ozyab/ui:2.1.
docker run -it ozyab/ui:2.1
# Запустить контейнер в фоне из образа reddit:latest, имя reddit, сеть host.
docker run --name reddit -d --network=host reddit:latest
# Запустить контейнер из образа joffotron/docker-net-tools, сеть none, автоудаление после остановки.
docker run -ti --rm --network none joffotron/docker-net-tools /bin/sh
# Запустить контейнер из образа joffotron/docker-net-tools, сеть none, автоудаление после остановки.
docker run -ti --rm --network none joffotron/docker-net-tools -c /bin/sh
# Остановить контейнер prometheus.
docker stop prometheus
# Показать занятость диска Docker (образы, контейнеры, кеш).
docker system df
# Добавить тег образу (копия ссылки image:tag).
docker tag ozyab/prometheus:1.0 ozyab/prometheus:latest
# Версия Docker (клиент и сервер).
docker version
# Создать Docker-том reddit_db (для данных).
docker volume create reddit_db
# Список Docker-томов.
docker volume ls
# Команда docker-compose (обрывок).
docker-compose
# Поднять все сервисы compose в фоне (docker-compose-monitoring.yml).
docker-compose up -d -f docker-compose-monitoring.yml
# Поднять все сервисы compose в фоне.
docker-compose up -d
# Остановить и удалить контейнеры compose.
docker-compose down -d
# Команда docker-compose (обрывок).
docker-compose -f docker-compose-monitoring.yml down
# Остановить и удалить контейнеры compose.
docker-compose down
# Команда docker-compose (обрывок).
docker-compose -f docker-compose-logging.yml down
# Команда docker-compose (обрывок).
docker-compose -f docker-compose-logging.yml down -d fluentd
# Команда docker-compose (обрывок).
docker-compose -f docker-compose-logging.yml start elasticsearch
# Показать логи сервисов compose (kibana) (kibana).
docker-compose logs -f kibana
# Показать логи сервисов compose (post) (post).
docker-compose logs -f post
# Запустить сервис post.
docker-compose start post
# Остановить сервис post.
docker-compose stop post
# Создать Docker-хост на GCP (docker-machine).
docker-machine create --driver google \ --google-machine-image https://www.googleapis.com/compute/v1/projects/ubuntu-os-cloud/global/images/family/ubuntu-1604-lts \ --google-machine-type n1-standard-1 \ --google-zone europe-west1-b \ docker-host
# Вывести переменные окружения для работы с docker-host.
docker-machine env docker-host
# Перегенерировать TLS-сертификаты docker-host.
docker-machine regenerate-certs docker-host
# Удалить Docker-хост docker-host.
docker-machine rm docker-host
# Подключиться по SSH к docker-host.
docker-machine ssh docker-host
# Подключиться по SSH к docker-host. (ifconfig)
docker-machine ssh docker-host ifconfig
```

---

## K8S — 86 команд

Kubernetes: apply/delete, describe/get, exec/logs, port-forward, secrets, ingress, minikube.

```bash
# Применить манифест(ы) comment-deployment.yml.
kubectl apply comment-deployment.yml
# Применить манифест(ы) ..
kubectl apply -f .
# Применить манифест(ы) ./kubernetes/reddit/ в namespace dev.
kubectl apply -f ./kubernetes/reddit/ -n dev
# Применить манифест(ы) ./kubernetes/reddit/dev-namespace.yml.
kubectl apply -f ./kubernetes/reddit/dev-namespace.yml
# Применить манифест(ы) https://storage.googleapis.com/kubernetes-the-hard-way/coredns.yaml.
kubectl apply -f https://storage.googleapis.com/kubernetes-the-hard-way/coredns.yaml
# Применить манифест(ы) kubernetes/reddit/tiller.yml.
kubectl apply -f kubernetes/reddit/tiller.yml
# Показать текущий контекст kubeconfig.
kubectl config current-context
# Показать содержимое kubeconfig.
kubectl config view
# Работа с контекстами (view — показать; alias команды config).
kubectl context
# Работа с контекстами (view — показать; alias команды config).
kubectl context view
# Создать секрет из literal-значения.
kubectl create secret generic kubernetes-the-hard-way \ --from-literal="mykey=mydata"
# Создать секрет (TLS).
kubectl create secret tls ui-ingress --key tls.key --cert tls.crt -n dev
# Удалить ресурс deploy в namespace dev.
kubectl delete deploy mongo -n dev
# Удалить ресурс deploy в namespace dev.
kubectl delete deploy ui -n dev
# Удалить ресурс все манифесты каталога.
kubectl delete -f .
# Удалить ресурс ui-ingress.yml в namespace dev.
kubectl delete -f ui-ingress.yml -n dev
# Удалить ресурс ingress в namespace dev.
kubectl delete ingress ui -n dev
# Удалить ресурс secret в namespace dev.
kubectl delete secret tls -n dev
# Удалить ресурс secret в namespace dev. (с ключом/сертом — неверный синтаксис)
kubectl delete secret tls ui-ingress --key tls.key --cert tls.crt -n dev
# Удалить ресурс ui-deployment.yml.
kubectl delete ui-deployment.yml
# Детальное описание nodes.
kubectl describe nodes
# Детальное описание pod.
kubectl describe pod reddit-test-mongodb-6b6bc97c58-zmq8j
# Детальное описание pod.
kubectl describe pod ui-1-ui-658b6fcc8d-km6n7
# Детальное описание secret в namespace dev.
kubectl describe secret ui-ingress -n dev
# Детальное описание service.
kubectl describe service comment | grep Endpoints
# Детальное описание storageclass в namespace dev.
kubectl describe storageclass standard -n dev
# Выполнить команду sh внутри пода grafana-bdc977fd4-lxscw.
kubectl exec -it grafana-bdc977fd4-lxscw sh
# Выполнить команду nginx -v внутри пода $POD_NAME.
kubectl exec -ti $POD_NAME -- nginx -v
# Выполнить команду nslookup kubernetes внутри пода $POD_NAME.
kubectl exec -ti $POD_NAME -- nslookup kubernetes
# Выполнить команду ping comment внутри пода post-8ff9c4cb9-h4zpq в namespace dev.
kubectl exec -ti -n dev post-8ff9c4cb9-h4zpq ping comment
# Создать Service (NodePort) для Deployment.
kubectl expose deployment nginx --port 80 --type NodePort
# Показать ресурсы deployment.
kubectl get deployment
# Показать ресурсы deployment в namespace default.
kubectl get deployment -n default
# Показать ресурсы ingress в namespace default.
kubectl get ingress -n default
# Показать ресурсы ingress в namespace dev.
kubectl get ingress -n dev
# Показать ресурсы nodes (расширенный вывод).
kubectl get nodes -o wide
# Показать ресурсы nodes.
kubectl get nodes
# Показать ресурсы persistentvolume в namespace dev.
kubectl get persistentvolume -n dev
# Показать ресурсы po.
kubectl get po
# Показать ресурсы pod в namespace dev.
kubectl get pod -n dev
# Показать ресурсы pods.
kubectl get pods
# Показать ресурсы pods в namespace kube-system с лейблом k8s-app=kube-dns.
kubectl get pods -l k8s-app=kube-dns -n kube-system
# Показать ресурсы pods с лейблом run=busybox с выборкой полей (jsonpath).
kubectl get pods -l run=busybox -o jsonpath
# Показать ресурсы pods с лейблом run=busybox с выборкой полей (jsonpath).
kubectl get pods -l run=busybox -o jsonpath="{.items[0].metadata.age}"
# Показать ресурсы pods с лейблом run=busybox с выборкой полей (jsonpath).
kubectl get pods -l run=busybox -o jsonpath="{.items[0].metadata.name}"
# Показать ресурсы pods с лейблом run=busybox с выборкой полей (jsonpath).
kubectl get pods -l run=busybox -o jsonpath="{.items[0].metadata.status}"
# Показать ресурсы pods в namespace dev.
kubectl get pods -n dev
# Показать ресурсы pods в namespace kube-system с лейблом app=helm.
kubectl get pods -n kube-system --selector app=helm
# Показать ресурсы pods (расширенный вывод).
kubectl get pods -o wide
# Показать ресурсы pods с лейблом component=mongo.
kubectl get pods --selector component=mongo
# Показать ресурсы pods с лейблом component=uo.
kubectl get pods --selector component=uo
# Показать ресурсы service.
kubectl get service
# Показать ресурсы service в namespace dev с лейблом component=ui.
kubectl get service -n dev --selector component=ui
# Показать ресурсы service в namespace nginx-ingress.
kubectl get service -n nginx-ingress nginx
# Показать ресурсы services.
kubectl get services
# Показать ресурсы services в namespace dev.
kubectl get services -n dev
# Показать ресурсы svc.
kubectl get svc
# Осмотреть ресурс (детали).
kubectl inspect gitlab-gitlab-runner-5df57b8848-7x8l7
# Осмотреть ресурс (детали).
kubectl inspect
# Осмотреть ресурс (детали).
kubectl inspect pod gitlab-gitlab-runner-5df57b8848-7x8l7
# Показать логи пода .
kubectl log -f grafana-bdc977fd4-gpr5d
# Показать логи пода $POD_NAME.
kubectl logs $POD_NAME
# Показать логи пода .
kubectl logs -f comment-559cc97f59-hnwsq
# Показать логи пода  в namespace dev.
kubectl logs -f comment-559cc97f59-hnwsq -n dev
# Показать логи пода .
kubectl logs -f post-57788c57f6-427cj
# Показать логи пода grafana-bdc977fd4-gpr5d.
kubectl logs grafana-bdc977fd4-gpr5d
# Показать логи пода reddit-test-ui-78664855d5-pvdpr.
kubectl logs reddit-test-ui-78664855d5-pvdpr
# Команда kubectl pod.
kubectl pod inspect gitlab-gitlab-runner-5df57b8848-7x8l7
# Пробросить порт 8080:80 к поду $POD_NAME (локально).
kubectl port-forward $POD_NAME 8080:80
# Пробросить порт 8080:9292 к поду comment-757c84f994-5w47f (локально).
kubectl port-forward comment-757c84f994-5w47f 8080:9292
# Пробросить порт 5000:5000 к поду post-5c45f6d5c8-5dpx7 (локально).
kubectl port-forward post-5c45f6d5c8-5dpx7 5000:5000
# Пробросить порт 9292:9292 к поду ui-5d69f5784f-85scd (локально).
kubectl port-forward ui-5d69f5784f-85scd 9292:9292
# Запустить под busybox из образа busybox:1.28. (в фоне sleep)
kubectl run busybox --image=busybox:1.28 --command -- sleep 3600
# Запустить под nginx из образа nginx.
kubectl run nginx --image=nginx
# Масштабировать Deployment kube-dns-autoscaler до 0 реплик в namespace kube-system.
kubectl scale deployment --replicas 0 -n kube-system kube-dns-autoscaler
# Масштабировать Deployment kube-dns-autoscaler до 1 реплик в namespace kube-system.
kubectl scale deployment --replicas 1 -n kube-system kube-dns-autoscaler
# Работа с сервисами (обрывки команд).
kubectl service
# Работа с сервисами (обрывки команд).
kubectl service delete
# Выполнить команду bash внутри пода grafana-bdc977fd4-lxscw.
kubectl exec -it grafana-bdc977fd4-lxscw bash
# Справка minikube.
minikube
# Включить аддон minikube.
minikube addons enable
# Включить аддон Kubernetes Dashboard.
minikube addons enable dashboard
# Список доступных аддонов minikube.
minikube addons list
# Показать ресурсы all в namespace kube-system с лейблом k8s-app=kubernetes-dashboard.
kubectl get all -n kube-system --selector k8s-app=kubernetes-dashboard
# Запустить локальный кластер minikube.
minikube start
# Остановить кластер minikube.
minikube stop
```

---

## HELM — 23 команд

Пакетный менеджер K8s: install/upgrade, чарты, репозитории, tiller (helm 2).

```bash
# Справка helm.
helm
# Удалить релиз grafana. полностью (--purge)
helm del --purge grafana
# Удалить релиз grafana.
helm delete grafana
# Обновить зависимости чарта (charts/*.tgz).
helm dep update
# Обновить зависимости чарта (charts/*.tgz).
helm dep update ./reddit
# Обновить зависимости чарта (charts/*.tgz).
helm dep update --debug
# Описать релиз test-ui-1.
helm describe test-ui-1
# Скачать чарт stable/prometheus.
helm fetch  stable/prometheus
# Скачать чарт 0.1.37 и распаковать (--untar).
helm fetch gitlab/gitlab-omnibus --version 0.1.37 --untar
# Скачать чарт stable/prometheus и распаковать (--untar).
helm fetch --untar stable/prometheus
# Установить Tiller в кластер (helm 2).
helm init --service-account tiller
# Показать информацию о чарте gitlab-gitlab-runner-5df57b8848-7x8l7.
helm inspect gitlab-gitlab-runner-5df57b8848-7x8l7
# Показать информацию о чарте ui.
helm inspect ui
# Установить чарт "ingress.hosts={reddit-grafana}" как релиз grafana (Grafana: пароль, NodePort, ingress).
helm install grafana stable/grafana --set "adminPassword=<your-password>" \ --set "service.type=NodePort" \ --set "ingress.enabled=true" \ --set "ingress.hosts={reddit-grafana}"
# Установить чарт values.yaml как релиз gitlab.
helm install --name gitlab . -f values.yaml
# Установить чарт reddit-test как релиз reddit-test.
helm install reddit --name reddit-test
# Установить чарт ui-3 как релиз ui-3.
helm install ui --name ui-3
# Добавить Helm-репозиторий gitlab (https://charts.gitlab.io).
helm repo add gitlab https://charts.gitlab.io
# Найти чарты по запросу "mongo".
helm search mongo
# Обновить релиз <release-name>.
helm upgrade <release-name> ./reddit
# Установить чарт "server.ingress.hosts={reddit-grafana}" как релиз grafana (Grafana: пароль, NodePort, ingress).
helm upgrade --install grafana stable/grafana --set "server.adminPassword=<your-password>" \ --set "server.service.type=NodePort" \ --set "server.ingress.enabled=true" \ --set "server.ingress.hosts={reddit-grafana}"
# Установить чарт —install как релиз ?.
helm upgrade staging --namespace staging ./reddit —install
# Обновить релиз ui-1.
helm upgrade ui-1 ui/
```

---

## K8S-THE-HARD-WAY — 7 команд

Kubernetes the Hard Way: генерация сертификатов (cfssl/openssl).

```bash
# Сгенерировать сертификат admin  (KTHW).
cfssl gencert \  -ca=ca.pem \  -ca-key=ca-key.pem \  -config=ca-config.json \  -profile=kubernetes \  admin-csr.json | cfssljson -bare admin
# Создать корневой CA-сертификат (Kubernetes The Hard Way).
cfssl gencert -initca ca-csr.json | cfssljson -bare ca
# Показать информацию о cfssl.
cfssl info
# Версия cfssl.
cfssl --version
# Версия cfssl.
cfssljson --version
# Создать самоподписанный TLS-сертификат (CN=35.201.126.86) для ingress.
openssl req -x509 -nodes -days 365 -newkey rsa:2048 -keyout tls.key -out tls.crt -subj "/CN=35.201.126.86"
# Создать самоподписанный TLS-сертификат (CN=35.201.67.17) для ingress.
openssl req -x509 -nodes -days 365 -newkey rsa:2048 -keyout tls.key -out tls.crt -subj "/CN=35.201.67.17"
```

---

## GCLOUD — 21 команд

Google Cloud: auth, compute instances, firewall, ssh, config.

```bash
# Создать VM RedditPuma.
gcloud  compute --project=infra instances create RedditPuma \ --zone=us-east1-b --machine-type=f1-micro --subnet=default --tags=puma-server \ --image=reddit-base --image-project=infra \ --boot-disk-size=10GB --boot-disk-type=pd-standard
# Войти в GCP для приложений (ADC-креды).
gcloud auth application-default login
# Список авторизованных аккаунтов.
gcloud auth list
# Войти в Google Cloud через браузер.
gcloud auth login
# Обновить кластер GKE (включить Network Policy).
gcloud beta container clusters update standard-cluster-1 --zone=us-central1-a  --enable-network-policy
# Обновить компоненты gcloud SDK.
gcloud components update
# Создать VM ?.
gcloud compute instances create
# Список VM-инстансов.
gcloud compute instances list
# Создать правило firewall default-puma-server.
gcloud compute --project=infra firewall-rules create default-puma-server --direction=INGRESS --priority=1000 --network=default --action=ALLOW --rules=tcp:9292 --source-ranges=0.0.0.0/0 --target-tags=puma-server
# Создать VM puma-service.
gcloud compute --project=infra instances create puma-service --zone=us-east1-b --machine-type=f1-micro --subnet=default --tags=puma-server --image=reddit-base --image-project=infra-219416 --boot-disk-size=10GB --boot-disk-type=pd-standard
# Подключиться по SSH к VM controller-0.
gcloud compute ssh controller-0
# Подключиться по SSH к VM controller-0. (выполнить команду)
gcloud compute ssh controller-0 \ --command "kubectl get nodes --kubeconfig admin.kubeconfig"
# Подключиться по SSH к VM worker-2.
gcloud compute ssh worker-2
# Управление конфигурацией gcloud.
gcloud config
# Показать значение настройки.
gcloud config get-value
# Показать конфигурацию gcloud.
gcloud config list
# Установить проект по умолчанию: Infra.
gcloud config set project Infra
# Установить проект по умолчанию: list.
gcloud config set project list
# Информация об установке gcloud.
gcloud info
# Инициализировать gcloud (вход, выбор проекта).
gcloud init
# Список проектов GCP.
gcloud projects list
```

---

## TERRAFORM — 23 команд

IaC: init/plan/apply/destroy, import, output, taint, fmt.

```bash
# Показать план изменений инфраструктуры.
terraform plan
# Показать текущее состояние инфраструктуры.
terraform show
# Применить изменения.
terraform apply
# Применить изменения (с ручным подтверждением).
terraform apply -auto-approve=false
# Уничтожить все управляемые ресурсы.
terraform destroy
# Уничтожить и пересоздать инфраструктуру (destroy + apply).
terraform destroy -auto-approve && terraform apply
# Уничтожить все управляемые ресурсы.
terraform destroy --help
# Отформатировать конфигурации Terraform (.tf).
terraform fmt
# Скачать модули, указанные в конфигурации.
terraform get
# Импортировать существующий ресурс GCP в state Terraform.
terraform import google_compute_firewall
# Импортировать существующий ресурс GCP в state Terraform.
terraform import google_compute_firewall.firewall_mongo
# Импортировать существующий ресурс GCP в state Terraform.
terraform import google_compute_firewall.firewall_ssh default-allow-ssh
# Инициализировать Terraform (провайдеры и модули).
terraform init
# Инициализировать Terraform без настройки backend (локально).
terraform init -backend=false
# Проверить корректность конфигураций Terraform.
terraform validate -var-file=terraform.tfvars.example
# Показать все выходные значения.
terraform output
# Показать выходное значение app_external_ip (внешний IP).
terraform output app_external_ip
# Показать план (play — опечатка от plan).
terraform play
# Обновить state в соответствии с реальным состоянием.
terraform refresh
# Показать текущее состояние инфраструктуры. (искать IP)
terraform show | grep assigned_nat_ip
# Пометить ресурс google_compute_instance.app для пересоздания при следующем apply.
terraform taint google_compute_instance.app
# Обновить Terraform (такой команды нет — обновление через пакетный менеджер).
terraform update
# Версия Terraform.
terraform -v
```

---

## PACKER — 12 команд

Сборка образов: build/validate с variables.json.

```bash
# Собрать образ по шаблону immutable.json с переменными из variables.json.
packer build  -var-file=variables.json immutable.json
# Собрать образ по шаблону ./ubuntu16.json.
packer build ./ubuntu16.json
# Собрать образ по шаблону app.json.
packer build app.json
# Собрать образ по шаблону packer/app.json.
packer build packer/app.json
# Собрать образ по шаблону ubuntu16.json.
packer build ubuntu16.json
# Собрать образ по шаблону ubuntu16.json с переменными из variables.json.
packer build --var-files=variables.json ubuntu16.json
# Проверить шаблон immutable.json с переменными variables.json.
packer validate  -var-file=variables.json immutable.json
# Проверить шаблон immutable.json с переменными variables.json.example.
packer validate  -var-file=variables.json.example immutable.json
# Проверить шаблон app.json.
packer validate app.json
# Проверить шаблон packer/app.json.
packer validate packer/app.json
# Проверить шаблон -var-file=variables.json с переменными variables.json.
packer validate ubuntu16.json -var-file=variables.json
# Версия Packer.
packer version
```

---

## MOLECULE — 8 команд

Тестирование Ansible-ролей: create/converge/verify/destroy.

```bash
# Справка molecule.
molecule
# Применить роль к тестовому окружению.
molecule converge
# Поднять тестовое окружение для роли (Vagrant).
molecule create
# Уничтожить тестовое окружение.
molecule destroy
# Справка molecule.
molecule init
# Создать сценарий тестирования для роли (драйвер vagrant).
molecule init scenario --scenario-name default -r db -d vagrant
# Список сценариев тестирования.
molecule list
# Проверить состояние окружения (тесты).
molecule verify
```

---

## TRAVIS — 4 команд

CI: login, encrypt (Slack-уведомления), token.

```bash
# Зашифровать секрет для .travis.yml (Slack-уведомления).
travis encrypt "org-slack:TOKEN#your-handle" --add notifications.slack.rooms --com  # замените TOKEN
# Зашифровать секрет для .travis.yml (Slack-уведомления).
travis encrypt "org-slack:TOKEN#your-handle" --add notifications.slack.rooms --pro -r Otus-DevOps-2018-09/ozyab_microservices  # замените TOKEN
# Войти в Travis CI (--com = travis-ci.com).
travis login --com
# Показать API-токен Travis.
travis token
```

---

## GIT — 69 команд

Повседневный git: commit/rebase/push/ветки/теги, remote gitlab.

```bash
# Добавить файлы в индекс: ..
git add .
# Добавить файлы в индекс: ; Создать коммит: (откроется редактор); Отправить ветку docker-2 в remote и запомнить upstream. (force).
git add . && git commit && git push -f --set-upstream origin docker-2
# Добавить файлы в индекс: ; Перезаписать последний коммит (amend); Отправить ветку docker-4 в remote и запомнить upstream. (force).
git add . && git commit --amend && git push -f --set-upstream origin docker-4
# Добавить файлы в индекс: ; Создать коммит: Commit 1.
git add . && git commit -m "Commit 1"
# Добавить файлы в индекс: ; Создать коммит: HW-9 Ansible-2.
git add . && git commit -m 'HW-9 Ansible-2'
# Добавить файлы в индекс: .gitignore README.md terraform/main.tf terraform/variables.tf.
git add .gitignore README.md terraform/main.tf terraform/variables.tf
# Добавить файлы в индекс: .gitlab-ci.yml.
git add .gitlab-ci.yml
# Создать коммит: add pipeline definition.
git commit -m 'add pipeline definition'
# Отправить ветку gitlab-ci-1 в remote.
git push gitlab gitlab-ci-1
# Применить патч к рабочему каталогу.
git apply
# Список веток.
git branch
# Создать ветку ansible-4.
git branch ansible-4
# Создать ветку terraform-2.
git branch terraform-2
# Переключиться на 58be23971db1a871f9e14b04e3489a5fa4c91717.
git checkout 58be23971db1a871f9e14b04e3489a5fa4c91717
# Переключиться на ansible-1.
git checkout ansible-1
# Переключиться на ansible-3. (создать ветку из origin)
git checkout -b ansible-3 origin/ansible-3
# Переключиться на bff762fb14ff73d84f13d9f2bfe910526d06ea55.
git checkout bff762fb14ff73d84f13d9f2bfe910526d06ea55
# Переключиться на branch2.
git checkout branch2
# Переключиться на master.
git checkout master
# Клонировать репозиторий (без URL).
git clone
# Клонировать репозиторий ozyab09_infra.
git clone git@github.com:Otus-DevOps-2018-09/ozyab09_infra.git
# Клонировать репозиторий server-deploy.
git clone git@gitlab.com:server/server-deploy.git -key ~/.ssh/gitlab-com
# Создать коммит: Fixed link to Travis repository in Readme.md file.
git commit  -m 'Fixed link to Travis repository in Readme.md file'
# Создать коммит: Renamed directory `vpn` to `VPN`.
git commit  -m 'Renamed directory `vpn` to `VPN`'
# Создать коммит: (откроется редактор).
git commit -am "Add review feature"
# Перезаписать последний коммит (amend).
git commit --amend -m 'Updated Readme'
# Создать коммит: (откроется редактор).
git commit --help
# Создать коммит: Firewall rules for tagged instanses.
git commit -m 'Firewall rules for tagged instanses'
# Показать изменения (незакоммиченные).
git diff
# Показать изменения относительно packer-base.
git diff packer-base
# Команда git -f.
git -f push -u --all
# Скачать изменения из remote без слияния.
git fetch
# Скачать изменения из remote без слияния.
git fetch origin
# Показать историю коммитов.
git log
# Слить ветку master в текущую.
git merge master
# Слить ветку ansible-3 в текущую. (без fast-forward)
git merge --no-ff ansible-3
# Справка по git (plan — несуществующая команда).
git plan
# Забрать изменения из remote.
git pull
# Забрать изменения из remote gitlab.
git pull gitlab
# Забрать изменения из remote gitlab.
git pull gitlab gitlab-ci-1
# Отправить ветку monitoring-1 в remote и запомнить upstream.
git push  --set-upstream origin monitoring-1
# Отправить коммиты в remote. (force)
git push -f
# Отправить ветку --all в remote и запомнить upstream. (force)
git push -f origin -u --all
# Отправить ветку ansible-1 в remote и запомнить upstream. (force)
git push -f --set-upstream origin ansible-1
# Отправить теги в remote.
git push gitlab2 gitlab-ci-2 --tags
# Отправить коммиты в remote.
git push --help
# Отправить ветку master в remote.
git push origin master
# Отправить ветку --all в remote и запомнить upstream.
git push origin -u --all
# Отправить ветку ansible-1 в remote и запомнить upstream.
git push --set-upstream origin ansible-1
# Отправить ветку -all в remote и запомнить upstream.
git push -u -all
# Перебазирование (rebase).
git rebase
# Перебазировать текущую ветку на 8dc460f60235fd3871bebc5c1e12bc662f579ce9.
git rebase 8dc460f60235fd3871bebc5c1e12bc662f579ce9
# Отменить текущее перебазирование.
git rebase --abort
# Продолжить перебазирование после разрешения конфликтов.
git rebase --continue
# Отредактировать план перебазирования.
git rebase --edit-todo
# Интерактивное перебазирование последних 3 коммитов.
git rebase -i HEAD~3
# Добавить remote: origin.
git remote add origin http://gitlab-gitlab/chromko/ui.git
# Удалить remote origin.
git remote delete origin
# Откатить коммит 7237d8498f35 новым коммитом.
git revert 7237d8498f3589faad4a57a50b4602d430bcbfd5
# Удалить файл(ы) из репозитория: terraform/terraform.tfstate.backup.
git rm         terraform/terraform.tfstate.backup
# Удалить файл(ы) из репозитория: ansible/roles/jdauphant.nginx/.
git rm ansible/roles/jdauphant.nginx/
# Убрать файл из индекса git (оставив на диске).
git rm --cached docker/.env
# Удалить файл(ы) из репозитория: deploy.retry.
git rm deploy.retry
# Показать содержимое коммита/объекта.
git show
# Показать состояние рабочего каталога.
git status
# Создать тег 2.4.10.
git tag 2.4.10
# Создать тег Homework-2.
git tag -a Homework-2
# Создать тег Travis.
git tag -a Travis
# Пометить файл исполняемым (chmod +x) в git.
git update-index --chmod=+x packer/config-scripts/create-reddit-vm.sh
```

---

## GO — 7 команд

Go: build, run, godoc.

```bash
# Команда Go.
go
# Скомпилировать Go-проект (бинарник).
go build
# Справка по Go.
go --help
# Запустить Go-программу.
go help run
# Версия Go.
go version
# Справка godoc.
godoc
# Показать документацию по Println (godoc).
godoc fmt Println
```

---

## RUBY — 7 команд

Ruby ecosystem: gem, ruby, rubygems (для Travis и reddit).

```bash
# Менеджер Ruby-гемов (обрывок).
gem
# Установить Ruby-гем travis.
gem install travis
# Список установленных гемов.
gem list
# Обновить RubyGems (менеджер гемов).
gem update --system
# Интерпретатор Ruby (обрывок).
ruby
# Версия Ruby.
ruby --version
# Интерпретатор Ruby (обрывок).
rubygems --version
```

---

## PYTHON — 9 команд

Python: pip, virtualenv (для molecule и инструментов).

```bash
# Менеджер Python-пакетов pip (обрывок).
pip
# Установить Python-пакет apache-libcloud.
pip install apache-libcloud
# Установить Python-пакет molecule.
pip install molecule
# Обновить сам pip.
pip install --upgrade pip
# Менеджер Python-пакетов pip (обрывок).
pip -v
# Версия pip.
pip --version
# Справка virtualenv.
virtualenv
# Создать виртуальное окружение Python pyenv.
virtualenv pyenv
# Версия virtualenv.
virtualenv --version
```

---

## HADOLINT — 2 команд

Линтер Dockerfile.

```bash
# Справка hadolint.
hadolint
# Проверить Dockerfile линтером hadolint.
hadolint Dockerfile
```

---

## BASH-ЦИКЛЫ — 4 команд

Циклы for из консольной истории.

```bash
# Цикл: создать директории для сервисов (comment, post, reddit, ui).
for i in {coment post reddit ui} do; mkdir ${i} done
# Цикл: создать директории для сервисов (comment, post, reddit, ui).
for i in {coment post reddit ui} do; mkdir $i done
# Цикл: создать 3 control-plane VM для Kubernetes The Hard Way.
for i in 0 1 2; do  gcloud compute instances create controller-${i} \ --async \ --boot-disk-size 200GB \ --can-ip-forward \ --image-family ubuntu-1804-lts \ --image-project ubuntu-os-cloud \ --machine-type n1-standard-1 \ --private-network-ip 10.240.0.1${i} \ --scopes compute-rw,storage-ro,service-management,service-control,logging-write,monitoring \ --subnet kubernetes \ --tags kubernetes-the-hard-way,controller
# Цикл: скопировать kubeconfig-файлы на все control-plane VM.
for instance in controller-0 controller-1 controller-2; do  gcloud compute scp admin.kubeconfig kube-controller-manager.kubeconfig kube-scheduler.kubeconfig ${instance}:~/ done
```

---

## ПРОЧЕЕ — 8 команд

Разное: tar, find, scp (обрывки команд).

```bash
# Найти все *.yml (кроме inventory) и проверить синтаксис ansible-playbook (обрывок).
find ansible ! -name "inventory*.yml" -name "*.yml" -type f -print0 | xargs -0 -n1 ansible-playbook --syntax-check
# Команда: done...
done
# Скопировать публичный SSH-ключ в буфер обмена (macOS).
pbcopy < ~/.ssh/id_rsa.pub
# Копировать файл по SSH (обрывок команды).
scp  mtproto/mtproto-proxy o
# Заметка про systemd unit (обрывок).
systemd unit
# Распаковать архив google-cloud-sdk-221.0.0-darwin-x86_64.tar.gz.
tar -xcf google-cloud-sdk-221.0.0-darwin-x86_64.tar.gz
# Распаковать архив google-cloud-sdk-221.0.0-darwin-x86_64.tar.gz.
tar -xf google-cloud-sdk-221.0.0-darwin-x86_64.tar.gz
# Распаковать архив terraform_0.11.10_darwin_amd64.zip.
tar -xvf terraform_0.11.10_darwin_amd64.zip
```

---
