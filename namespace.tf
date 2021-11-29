resource "kubernetes_namespace" "apparmor" {

    count = var.create_namespace ? 1 : 0

    metadata {

        name = var.namespace

    }

}
