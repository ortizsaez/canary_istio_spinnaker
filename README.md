# canary_istio_spinnaker
POC to test canary deployments using istio

# TERRAFORM
gcloud init
gcloud auth application-default login


Una vez instalado el clúster configurar kubectl para manejarlo
gcloud config set project cicd-istio-spinnaker
gcloud container clusters get-credentials $(terraform output -raw kubernetes_cluster_name) --region $(terraform output -raw region)

Mirar punto 6 para descargar la clave de spinnaker

Borrar el spinnaker-config.yaml una vez aplicado

