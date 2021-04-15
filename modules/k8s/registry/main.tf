
#---------------------------------------------
# Rancher | Docker Registry 
#---------------------------------------------


resource "kubernetes_secret" "docker" {
  lifecycle { ignore_changes = [metadata] }
  count = length(var.registry_namepaces)
  metadata {
    name = "docker"
    namespace = element(var.registry_namepaces,count.index)
  }

  data = {
    ".dockerconfigjson" = <<DOCKER
{
  "auths": {
    "${var.registry_address}": {
      "auth": "${base64encode("${var.registry_user}:${var.registry_password}")}"
    }
  }
}
DOCKER
  }

  type = "kubernetes.io/dockerconfigjson"
}
