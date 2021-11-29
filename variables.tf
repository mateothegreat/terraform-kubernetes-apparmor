variable "name" {

    type        = string
    description = "name of the daeemonset and configmap"
    default     = "apparmor"

}

variable "namespace" {

    type        = string
    description = "namespace to install daemonset and configmap in to"
    default     = "default"

}

variable "create_namespace" {

    type        = bool
    description = "create namespace from var.namespace"
    default     = false

}

variable "image" {

    type        = string
    description = "docker image"
    default     = "gcr.io/google-containers/apparmor-loader:0.2"

}

variable "policies" {

    type        = map(string)
    description = "policies to add to the configmap"
    default     = {

        "lockdown" = <<POLICY

            #include <tunables/global>
            profile lockdown flags=(attach_disconnected,mediate_deleted) {

              #include <abstractions/base>

              network inet tcp,
              network inet udp,

              deny network raw,
              deny network packet,

              file,
              umount,

              deny /bin/** wl,
              deny /boot/** wl,
              deny /etc/** wl,
              deny /home/** wl,
              deny /lib/** wl,
              deny /lib64/** wl,
              deny /media/** wl,
              deny /mnt/** wl,
              deny /opt/** wl,
              deny /proc/** wl,
              deny /root/** wl,
              deny /sbin/** wl,
              deny /srv/** wl,
              deny /tmp/** wl,
              deny /sys/** wl,
              deny /usr/** wl,

              audit /** w,
              /app ixr,

              deny /bin/dash mrwklx,
              deny /bin/sh mrwklx,
              deny /usr/bin/top mrwklx,
              deny @{PROC}/* w,   # deny write for all files directly in /proc (not in a subdir)
              deny @{PROC}/{[^1-9],[^1-9][^0-9],[^1-9s][^0-9y][^0-9s],[^1-9][^0-9][^0-9][^0-9]*}/** w,
              deny @{PROC}/sys/[^k]** w,  # deny /proc/sys except /proc/sys/k* (effectively /proc/sys/kernel)
              deny @{PROC}/sys/kernel/{?,??,[^s][^h][^m]**} w,  # deny everything except shm* in /proc/sys/kernel/
              deny @{PROC}/sysrq-trigger rwklx,
              deny @{PROC}/mem rwklx,
              deny @{PROC}/kmem rwklx,
              deny @{PROC}/kcore rwklx,

              deny mount,

              deny /sys/[^f]*/** wklx,
              deny /sys/f[^s]*/** wklx,
              deny /sys/fs/[^c]*/** wklx,
              deny /sys/fs/c[^g]*/** wklx,
              deny /sys/fs/cg[^r]*/** wklx,
              deny /sys/firmware/efi/efivars/** rwklx,
              deny /sys/kernel/security/** rwklx,

              /dev/null rw,

            }

        POLICY

    }

}
