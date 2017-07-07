#!/bin/sh

# ***********************************************
# KIE Server Showcase - Docker image start script
# ************************************************

# Program arguments
#
# -c | --container-name:    The name for the created container.
#                           If not specified, defaults to "kie-server-unmanaged-showcase"
# -h | --help;              Show the script usage
#

CONTAINER_NAME="kie-server-unmanaged-showcase"
IMAGE_NAME="jboss/kie-server-unmanaged-showcase"
IMAGE_TAG="latest"
LOCAL_REPO="${HOME}/.m2/repository"

function usage
{
     echo "usage: start.sh [ [-c <container_name> ] ] [-h]]"
}

while [ "$1" != "" ]; do
    case $1 in
        -c | --container-name ) shift
                                CONTAINER_NAME=$1
                                ;;
        -h | --help )           usage
                                exit
                                ;;
        * )                     usage
                                exit 1
    esac
    shift
done

# Check if container is already started
if [ -f ${CONTAINER_NAME}.cid ]; then
    echo "Container is already started"
    container_id=$(cat ${CONTAINER_NAME}.cid)
    echo "Stoping container $container_id..."
    docker rm -f $container_id
    rm -f ${CONTAINER_NAME}.cid
fi

# Start the docker container
echo "Starting $CONTAINER_NAME docker container using:"
echo "** Container name: $CONTAINER_NAME"
cid_kie_server_unmanaged=$(docker run -p 8280:8080 -d --name $CONTAINER_NAME -v ${LOCAL_REPO}:/opt/jboss/.m2/repository $IMAGE_NAME:$IMAGE_TAG)
ip_kie_server_unmanaged=$(docker inspect --format='{{ .NetworkSettings.IPAddress }}' $cid_kie_server_unmanaged )
echo ${cid_kie_server_unmanaged} > ${CONTAINER_NAME}.cid

# End
echo " ************************************* "
echo "${CONTAINER_NAME} starting with ID: ${cid_kie_server_unmanaged:0:5}"
echo "JBoss KIE Server is running at http://$ip_kie_server_unmanaged:8280/kie-server"
echo "You can find info by ,"
echo "  curl -u kieserver:kieserver1! http://${ip_kie_server_unmanaged}:8280/kie-server/services/rest/server "
echo "You display server log by ,"
echo "  docker logs -f ${cid_kie_server_unmanaged:0:5} "
echo " ************************************* "

exit 0
