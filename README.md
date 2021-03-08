# canary_istio_spinnaker
POC to test canary deployments using istio

# TERRAFORM
gcloud init
gcloud auth application-default login


Una vez instalado el clúster configurar kubectl para manejarlo
gcloud config set project cicd-istio-spinnaker
gcloud container clusters get-credentials cicd-istio-spinnaker-gke --region us-central1
gcloud container clusters get-credentials $(terraform output -raw kubernetes_cluster_name) --region $(terraform output -raw region)

gcloud container clusters get-credentials spinnaker-tutorial --region us-central1f

spinnaker-tutorial
Mirar punto 6 para descargar la clave de spinnaker

Borrar el spinnaker-config.yaml una vez aplicado

-------
Crear app spinnaker
./spin application save --application-name webapp                         --owner-email "$(gcloud config get-value core/account)"      
                   --cloud-providers kubernetes                         --gate-endpoint http://localhost:8080/gate
