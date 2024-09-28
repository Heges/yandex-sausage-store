#!/bin/sh

# Функция для проверки состояния контейнера

check_container_status() {
  local container_name=$1
  local status=$(docker --context remote inspect -f '{{.State.Health.Status}}' $container_name 2>/dev/null || echo "unknown")
  echo $status
}

# Функция для деплоя контейнера

deploy_container() {
  local container_name=$1
  echo "Запускаем контейнер с именем: " $container_name
  docker --context remote compose --env-file deploy.env up $container_name -d --pull "always" --force-recreate
}

# Функция для остановки контейнера

stop_container() {
  local container_name=$1
  echo "Останавливаем контейнер с именем: " $container_name
  docker --context remote stop $container_name
}

# Функция для получения списка контейнеров по шаблону имени

get_containers_by_pattern() {
  local pattern=$1
  docker --context remote ps --format "{{.Names}}" | grep "$pattern" | tr -d ' '
}

# Проверка состояния контейнеров backend-green
# grep_container_green_name="$(docker ps --format "{{.Names}}" | grep green | tr -d ' ')"
# grep_container_blue_name="$(docker ps --format "{{.Names}}" | grep blue | tr -d ' ')"

green_containers=$(get_containers_by_pattern "green")
green_healthy=false
echo "Проходимся по всем контейнерам проверяем их состояние"
for container in $green_containers; do
  green_status=$(check_container_status $container)
  echo "Статус контейнера: $green_status"
  if [ "$green_status" = "healthy" ]; then
    green_healthy=true
	echo "Выставляем green_healhty в true"
    break
  fi
done

echo "Подготавливаемся к запуску"
blue_containers=$(get_containers_by_pattern "blue")
if [ "$green_healthy" = true ]; then
  echo "Green_healty = true начинаем с синего"
  deploy_container $blue_containers

  # Ждем, пока backend-blue станет healthy

  while true; do
    blue_status=$(check_container_status $blue_containers)
	echo "Статус контейнера: $blue_status"
    if [ "$blue_status" = "healthy" ]; then
		echo "Выставляем blue_healhty в true"
      break
    fi
    echo 'Waiting for $blue_containers to become healthy...'
    sleep 10
  done

  echo "backend-blue is now healthy. Stopping backend-green..."
  stop_container $green_containers
else
  echo "No backend-green container is healthy. Deploying backend-green first..."
  deploy_container $blue_containers
  
  # Ждем, пока backend-green станет healthy

  while true; do
    green_status=$(check_container_status $grep_container_green_name)
	 echo "Статус контейнера: $green_status"
    if [ "$green_status" = "healthy" ]; then
      break
    fi
    echo 'Waiting for $grep_container_green_name to become healthy... '
    sleep 10
  done

  echo "backend-green is now healthy. Stopping backend-blue..."
  stop_container $blue_containers
fi
