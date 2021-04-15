
#---------------------------------------------
# Rancher | Create Project
#---------------------------------------------

resource "rancher2_project" "project" {
  name       = var.project_name
  cluster_id = var.cluster_id
}

#---------------------------------------------
# Kubernetes | Create Namespaces
#---------------------------------------------

resource "kubernetes_namespace" "ns" {
  lifecycle {ignore_changes = [metadata]}
  count = length(var.namespaces)
  metadata {
    annotations = {
      terraform = "true"
    }
    name = element(var.namespaces,count.index)
  }
}

#---------------------------------------------
# Rancher | AWS Load Balanacer Controller
#---------------------------------------------

resource "rancher2_catalog_v2" "eks" { 
  cluster_id = var.cluster_id
  name       = "eks"
  url        = "https://aws.github.io/eks-charts"

}

#Create Namespace
resource "kubernetes_namespace" "aws-load-balancer-controller" {
  lifecycle {ignore_changes = [metadata]}
  metadata {
    name = "aws-load-balancer-controller"
  }
}

#chart install
resource "rancher2_app_v2" "aws-load-balancer-controller" {
  lifecycle {
    ignore_changes = [values]
  }
  cluster_id = var.cluster_id
  name = "aws-load-balancer-controller"
  namespace = kubernetes_namespace.aws-load-balancer-controller.id
  repo_name = "eks"
  chart_name = "aws-load-balancer-controller"
  values = data.template_file.aws-load-balancer-controller.rendered
}

#yaml rendering (Cluster Name)
data "template_file" "aws-load-balancer-controller" {
  template = var.alb_yaml
  vars = {
    clustername  = var.cluster_name
  }
}

#---------------------------------------------
# Rancher | Monitoring
#---------------------------------------------
#Create Namespace
resource "kubernetes_namespace" "monitoring" {
   lifecycle {ignore_changes = [metadata]}
 metadata {
  name = "cattle-monitoring-system"
 }
}

#chart install
resource "rancher2_app_v2" "monitoring" {
  lifecycle { ignore_changes = [name,labels,annotations] }
  cluster_id = var.cluster_id
  name = "Monitoring"
  namespace = kubernetes_namespace.monitoring.id
  repo_name = "rancher-charts"
  chart_name = "rancher-monitoring"
}

#---------------------------------------------
# Rancher | Logging
#---------------------------------------------
#Create Namespace
resource "kubernetes_namespace" "logging" {
  lifecycle {ignore_changes = [metadata]}
  metadata {
    name = "cattle-logging-system"
  }
}

#chart install
resource "rancher2_app_v2" "logging" {
  lifecycle { ignore_changes = [name,labels,annotations] }
  cluster_id = var.cluster_id
  name = "Logging"
  namespace = kubernetes_namespace.logging.id
  repo_name = "rancher-charts"
  chart_name = "rancher-logging"
}


#---------------------------------------------
# Kubernetes | Create Sample Pod
#---------------------------------------------


resource "kubernetes_pod" "sample" {
  depends_on = [kubernetes_namespace.ns]
  count = length(kubernetes_namespace.ns.*.id)
  metadata {
    name =  "${element(kubernetes_namespace.ns.*.id,count.index)}-sample"
    namespace = element(kubernetes_namespace.ns.*.id,count.index)
    labels = {
      app = "sample"
    }
  }
  spec {
    restart_policy   = "Always"
    container {
      image = "docker.test.com/hello-world:latest"
      name  = "hello-world"
    port {
        container_port = 8000
        protocol       = "TCP"
      }
    }
    image_pull_secrets  {
        name = "docker"
    }
  }
}


#---------------------------------------------
# Kubernetes | Create Sample Service
#---------------------------------------------

resource "kubernetes_service" "sample" {
  depends_on = [kubernetes_namespace.ns]
  lifecycle { ignore_changes = [metadata] }
  count = length(kubernetes_namespace.ns.*.id)
  metadata {
    name = "${element(kubernetes_namespace.ns.*.id,count.index)}-sample-service"
    namespace = element(kubernetes_namespace.ns.*.id,count.index)
  }
  spec {
    selector = {
      app = element(kubernetes_pod.sample.*.metadata.0.labels.app,count.index)
    }
    port {
      port        = 8000
      target_port = 8000
    }
    type = "NodePort"
  }
}


#---------------------------------------------
# Create AWS Load Balanacer Controller
#---------------------------------------------


resource "kubernetes_ingress" "test" {
  metadata {
    name      = "${var.cluster_name}-pub-lb"
    namespace = kubernetes_namespace.ns.0.id
    annotations = {
      "kubernetes.io/ingress.class": "alb"
      "alb.ingress.kubernetes.io/certificate-arn"  = "${var.dot_com_acm},${var.dot_net_acm}"
      "alb.ingress.kubernetes.io/actions.ssl-redirect" = <<JSON
          
         {"Type": "redirect", "RedirectConfig": { "Protocol": "HTTPS", "Port": "443", "StatusCode": "HTTP_301"}}
          
     JSON
      "alb.ingress.kubernetes.io/healthcheck-path" = "/_/health"
      "alb.ingress.kubernetes.io/listen-ports"     = <<JSON
          [
            {"HTTP": 80},
            {"HTTPS": 443}
          ]
     JSON

      "alb.ingress.kubernetes.io/scheme"           = "internet-facing"
      "alb.ingress.kubernetes.io/subnets"          = var.alb_subnet
      "alb.ingress.kubernetes.io/security-groups"  = var.alb_sg
      "alb.ingress.kubernetes.io/target-type"      = "instance"
      "alb.ingress.kubernetes.io/success-codes"    = "200,404,301,302"
    }
  }
  spec {
    rule {
        host = "maxwell.test.net"
      http {
        path {
          backend {
            service_name = kubernetes_service.sample.0.metadata.0.name
            service_port = 8000
          }
        }
      }
    }
  }
}

