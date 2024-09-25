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
  echo "try to start container name {$container_name}"
  docker --context remote compose --env-file deploy.env up $container_name -d --pull "always" --force-recreate
}

# Функция для остановки контейнера

stop_container() {
  local container_name=$1
  echo "try to stop container name {$container_name}"
  docker --context remote stop $container_name
}

# Функция для получения списка контейнеров по шаблону имени

get_containers_by_pattern() {
  local pattern=$1
  docker --context remote ps --format "{{.Names}}" | grep "$pattern" | tr -d ' '
}

# Проверка состояния контейнеров backend-green

green_containers=$(get_containers_by_pattern "backend-green")
green_healthy=false

for container in $green_containers; do
  green_status=$(check_container_status $container)
  if [ "$green_status" = "healthy" ]; then
    green_healthy=true
    break
  fi
done

echo $green_healthy

if [ "$green_healthy" = true ]; then
  echo "At least one backend-green container is healthy. Deploying backend-blue..."
  deploy_container "backend-blue"

  # Ждем, пока backend-blue станет healthy

  while true; do
    blue_status=$(check_container_status "backend-blue")
    if [ "$blue_status" = "healthy" ]; then
      break
    fi
    echo "Waiting for backend-blue to become healthy..."
    sleep 10
  done

  echo "backend-blue is now healthy. Stopping backend-green..."
  stop_container "backend-green"
else
  echo "No backend-green container is healthy. Deploying backend-green first..."
  deploy_container "backend-green"
  
  # Ждем, пока backend-green станет healthy

  while true; do
    green_status=$(check_container_status "backend-green")
    if [ "$green_status" = "healthy" ]; then
      break
    fi
    echo "Waiting for backend-green to become healthy... "
    sleep 10
  done

  echo "backend-green is now healthy. Stopping backend-blue..."
  stop_container "backend-blue"
fi
