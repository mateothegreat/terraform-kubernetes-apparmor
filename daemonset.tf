resource "kubernetes_daemonset" "apparmor" {

    metadata {

        name      = var.name
        namespace = var.namespace

    }

    spec {

        selector {

            match_labels = {

                app = var.name

            }

        }

        template {

            metadata {

                name = var.name

                labels = {

                    app = var.name

                }

            }

            spec {

                container {

                    name  = "apparmor"
                    image = var.image

                    args = [

                        "-poll",
                        "30s",
                        "/profiles"

                    ]

                    security_context {

                        privileged = true

                    }

                    volume_mount {

                        name       = "sys"
                        mount_path = "/sys"
                        read_only  = false

                    }

                    volume_mount {

                        name       = "apparmor-includes"
                        mount_path = "/etc/apparmor.d"
                        read_only  = true

                    }

                    volume_mount {

                        name       = "profiles"
                        mount_path = "/profiles"
                        read_only  = true

                    }

                }

                volume {

                    name = "sys"

                    host_path {

                        path = "/sys"

                    }

                }

                volume {

                    name = "apparmor-includes"

                    host_path {

                        path = "/etc/apparmor.d"

                    }

                }

                volume {

                    name = "profiles"

                    config_map {

                        name = "apparmor-profiles"

                    }

                }

            }

        }

    }

}
