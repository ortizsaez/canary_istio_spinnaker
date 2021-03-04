#!/bin/sh
# Configure k8s environment using k3d. https://k3d.io/

if [ $# -lt 1 ]; then
    echo "USAGE: ./set_k8s_environment.sh create|stop|delete";
    exit 1;
fi

case $1 in
    # Prevent k3d from deploying traefik to avoid collisions with istio
    "create" ) k3d cluster create k8senv --servers 1 --agents 2 --port 9443:443@loadbalancer --port 9080:80@loadbalancer --api-port 6443 --k3s-server-arg '--no-deploy=traefik' ; ;;
    "stop" ) k3d cluster stop k8senv; ;;
    "delete" ) k3d cluster delete k8senv ; ;;
    * ) echo "USAGE: ./set_k8s_environment.sh create|stop|delete";
esac