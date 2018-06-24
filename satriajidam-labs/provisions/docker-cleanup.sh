# Delete all docker containers
docker ps -a
docker rm -f $(docker ps -qa --no-trunc)

# Delete all docker images
docker images
docker rmi -f $(docker images -q --no-trunc)

# Delete all docker volumes
docker volume ls
docker volume rm $(docker volume ls -q)
