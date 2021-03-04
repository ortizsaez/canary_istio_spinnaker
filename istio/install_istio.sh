#!/bin/sh
# Configure k8s environment using k3d. https://k3d.io/

function install_istio {
    # We can download an specific version with 
    curl -L https://istio.io/downloadIstio | ISTIO_VERSION=1.9.1
    cd istio-1.9.1
    echo "$(date) - Checking if namespace istio-system exists, creating it otherwise"
    kubectl get namespace istio-system || kubectl create namespace istio-system 
    echo ".................................."
    echo "$(date) - Installing istio base"
    helm upgrade --install istio-base manifests/charts/base -n istio-system
    echo ".................................."
    echo "$(date) - Installing istio discovery"
    helm upgrade --install istiod manifests/charts/istio-control/istio-discovery -n istio-system
    echo ".................................."
    echo "$(date) - Installing istio ingress"
    helm upgrade --install istio-ingress manifests/charts/gateways/istio-ingress -n istio-system
    # Uncomment if needed
    #echo "$(date) - Installing istio egress"
    #helm upgrade --install istio-egress manifests/charts/gateways/istio-ingress -n istio-system

}

function uninstall_istio {
    echo "$(date) - The following components are going to be deinstalled"
    helm ls -n istio-system

    echo ".................................."
    echo "$(date) - Deleting components"
    helm ls -n istio-system|grep -v NAME |awk {'print $1'} |xargs -n1 helm delete -n istio-system

    echo ".................................."
    echo "$(date) - Deleting istio namespace"
    kubectl delete namespace istio-system
}

if [ $# -lt 1 ]; then
    echo "USAGE: ./install_istio.sh install|uninstall";
    exit 1;
fi

case $1 in
    # Prevent k3d from deploying traefik to avoid collisions with istio
    "install" ) install_istio ; ;;
    "uninstall" ) uninstall_istio; ;;

    * ) echo "USAGE: ./install_istio.sh install|uninstall";
esac

