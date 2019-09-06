data "ibm_resource_group" "resource_group" {
  name = "${var.resource_group}"
}

data "ibm_container_cluster" "cluster" {
    cluster_name_id     = "${var.cluster_name}"
    region              = "${var.region}"
    resource_group_id   = "${data.ibm_resource_group.resource_group.id}"
}


data "ibm_container_cluster_config" "cluster_config" {
  cluster_name_id   = "${data.ibm_container_cluster.cluster.id}"
  resource_group_id = "${data.ibm_resource_group.resource_group.id}"
  region            = "${var.region}"
  config_dir        = "/tmp"
}

resource "kubernetes_network_policy" "deny-all-allow-dns" {
  metadata {
    name      = "deny-all-allow-dns"
    namespace = "${var.namespace}"
  }

  spec {
    pod_selector {}

    ingress {
      from {
        pod_selector {}
      }
    }

    egress {
      to {
        pod_selector {}
      }
    }

    egress {
      ports {
          port        = "53"
          protocol    = "TCP"
      }
      ports {
          port        = "53"
          protocol    = "UDP"
      }
    }

    policy_types = ["Ingress", "Egress"]
  }
}