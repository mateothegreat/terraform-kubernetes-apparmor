provider "kubernetes" {

    config_path = "~/.kube/config"

}

module "test" {

    source = "../"

    name             = "apparmor"
    namespace        = "apparmor"
    create_namespace = true

}

resource "kubernetes_deployment" "deployment" {

    metadata {

        name      = "nginx-test"
        namespace = "apparmor"

        annotations = {

            "container.apparmor.security.beta.kubernetes.io/nginx-test" = "localhost/lockdown"

        }

        labels = {

            app = "nginx-test"

        }

    }

    spec {

        replicas = 1

        selector {

            match_labels = {

                app = "nginx-test"

            }

        }

        template {

            metadata {

                name = "nginx-test"

                annotations = {

                    "container.apparmor.security.beta.kubernetes.io/nginx-test" = "localhost/lockdown"

                }

                labels = {

                    app = "nginx-test"

                }

            }

            spec {

                container {

                    name  = "nginx-test"
                    image = "nginx:alpine"

                    resources {

                        requests = {

                            cpu    = "50m"
                            memory = "50Mi"

                        }

                    }

                }

            }

        }

    }

}
