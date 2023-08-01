# This script pulls the latest docker image for any number of docker compose projects in separate directories.
# Limitations:
# - The docker-compose file must be in the root directory of the project.
for var in "$@"
do
    cd $var
    echo "pulling latest image for" $var
    docker compose pull
    echo "recreating" $var "using latest image"
    docker compose down -v && docker compose up -d
    echo -e "new container running, returning to root directory\n"
    cd ..
done
