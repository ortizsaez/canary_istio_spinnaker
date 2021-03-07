#!/bin/bash
# This script is used to deploy spinnaker in an existing GKE cluster
PROJECT="cicd-istio-spinnaker"
REGION="us-central1"
BUCKET=$PROJECT-spinnaker-config

# Set project
echo "$(date) - Setting project in gcloud"
gcloud config set project $PROJECT

# Configure kubectl to use the cluster
echo ".........................."
echo "$(date) - Configuring kubectl to manage the cluster ${PROJECT}-gke"
gcloud container clusters get-credentials ${PROJECT}-gke --region ${REGION}

# Create key for spinnaker
echo ".........................."
echo "$(date) - Creating key for spinnaker"
gcloud iam service-accounts keys create spinnaker-sa.json --iam-account spinnaker-account@${PROJECT}.iam.gserviceaccount.com

# Enable helm to modify the cluster
echo ".........................."
echo "$(date) - Enable helm to manage the cluster"
kubectl create clusterrolebinding user-admin-binding \
    --clusterrole=cluster-admin --user=$(gcloud config get-value account)

# Enable spinnaker to use the cluster
echo ".........................."
echo "$(date) - Enable spinnaker serviceaccount to manage the cluster"
kubectl create clusterrolebinding --clusterrole=cluster-admin \
    --serviceaccount=default:default spinnaker-admin

# Add repos to helm
echo ".........................."
echo "$(date) - Adding spinakker repo to helm"
helm repo add stable https://charts.helm.sh/stable
helm repo update

# Install Spinnaker in our cluster using helm
# NOTE: bucket is already created using terraform
echo ".........................."
echo "$(date) - Creating config for spinnaker"
export SA_JSON=$(cat spinnaker-sa.json)
cat > spinnaker-temp-config.yaml <<EOF
gcs:
  enabled: true
  bucket: $BUCKET
  project: $PROJECT
  jsonKey: '$SA_JSON'

dockerRegistries:
- name: gcr
  address: https://gcr.io
  username: _json_key
  password: '$SA_JSON'
  email: 1234@5678.com

# Disable minio as the default storage backend
minio:
  enabled: false

# Configure Spinnaker to enable GCP services
halyard:
  spinnakerVersion: 1.19.4
  image:
    repository: us-docker.pkg.dev/spinnaker-community/docker/halyard
    tag: 1.32.0
    pullSecrets: []
  additionalScripts:
    create: true
    data:
      enable_gcs_artifacts.sh: |-
        \$HAL_COMMAND config artifact gcs account add gcs-$PROJECT --json-path /opt/gcs/key.json
        \$HAL_COMMAND config artifact gcs enable
      enable_pubsub_triggers.sh: |-
        \$HAL_COMMAND config pubsub google enable
        \$HAL_COMMAND config pubsub google subscription add gcr-triggers \
          --subscription-name gcr-triggers \
          --json-path /opt/gcs/key.json \
          --project $PROJECT \
          --message-format GCR
EOF

echo ".........................."
echo "$(date) - Installing spinnaker using helm"
helm install -n default spinnaker stable/spinnaker -f spinnaker-temp-config.yaml \
           --version 2.0.0-rc9 --timeout 10m0s --wait


export DECK_POD=$(kubectl get pods --namespace default -l "cluster=spin-deck" -o jsonpath="{.items[0].metadata.name}")
kubectl port-forward --namespace default $DECK_POD 9000 &

export GATE_POD=$(kubectl get pods --namespace default -l "cluster=spin-gate" -o jsonpath="{.items[0].metadata.name}")
kubectl port-forward --namespace default $GATE_POD 8084 &