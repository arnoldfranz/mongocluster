#!/bin/bash

# $1 : Action target
# $2 : Replicaset instance name

REPLICA_SET_NAME="mrs"
NETWORK_NAME=${REPLICA_SET_NAME}_"$2"_net
NODE_ROOT_NAME=${REPLICA_SET_NAME}_"$2"
SC_NODE_ROOT_NAME=sc_${REPLICA_SET_NAME}_"$2"

echo REPLICA_SET_NAME= $REPLICA_SET_NAME
echo NETWORK_NAME= $NETWORK_NAME
echo NODE_ROOT_NAME= $NODE_ROOT_NAME
echo SC_NODE_ROOT_NAME=$SC_NODE_ROOT_NAME

case "$1" in --help)
	echo "Usage:  ./clusterctl.sh TARGET PARAMETERS"
	echo "Targets: "
	echo "build string	builds 2 mongod containers on the same bridge"
	echo "start string	starts "
	echo "stop  string	stops and destroys the containers, bridge and images"
	echo "The parameter is always the same : the name of the image of the mongod server"
	;;
esac

case "$1" in build)
	# Build the sidecar image
	docker build -f ../mgodserver-sdcr/Dockerfile --tag $SC_NODE_ROOT_NAME .
	# Build the replica set network bridge
	docker network create --driver bridge ${NETWORK_NAME}
	# Build the mongod image
	docker build --tag $NODE_ROOT_NAME .
	;;
esac 

case "$1" in run)
	# Firstly, start the side car container
	docker run -di --name ${SC_NODE_ROOT_NAME} ${SC_NODE_ROOT_NAME}
	# Secondly, start the mongo container
	docker run -di -p 27017:27017 --network ${NETWORK_NAME} --name ${NODE_ROOT_NAME}_1 --volumes-from ${SC_NODE_ROOT_NAME} ${NODE_ROOT_NAME} "--bind_ip_all" "--port 27017"
	;;
esac

case "$1" in start)
        # Firstly, start the side car container
        docker start ${SC_NODE_ROOT_NAME}
        # Secondly, start the mongo container
        docker start ${NODE_ROOT_NAME}_1
        ;;
esac

case "$1" in stop)
        # Firstly, start the side car container
        docker stop ${SC_NODE_ROOT_NAME}
        # Secondly, start the mongo container
        docker stop ${NODE_ROOT_NAME}_1
        ;;
esac

case "$1" in cleanup)
	docker stop ${NODE_ROOT_NAME}_1 ${NODE_ROOT_NAME}_2 ${SC_NODE_ROOT_NAME}
	docker rm ${NODE_ROOT_NAME}_1 ${NODE_ROOT_NAME}_2 ${SC_NODE_ROOT_NAME}
	docker rmi ${NODE_ROOT_NAME} ${SC_NODE_ROOT_NAME}
	docker network rm ${NETWORK_NAME}
	;;
esac
