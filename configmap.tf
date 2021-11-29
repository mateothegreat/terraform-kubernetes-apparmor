resource "kubernetes_config_map" "apparmor" {

    metadata {

        name      = "apparmor-profiles"
        namespace = var.namespace

    }

    data = var.policies

}
