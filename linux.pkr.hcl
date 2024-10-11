source "googlecompute" "linux" {
  service_account_email = var.service_account_email
  project_id            = var.project_id
  zone                  = var.zone
  
  disk_size             = var.disk_size
  machine_type          = var.machine_type

  use_iap                 = var.use_iap
  iap_localhost_port      = var.iap_localhost_port
  use_internal_ip         = var.use_internal_ip
  omit_external_ip        = var.omit_external_ip
  network                 = var.network
  subnetwork              = var.subnetwork

  # source_image            = var.linux_source_image
  source_image_family     = var.linux_source_image_family
  source_image_project_id = var.linux_source_image_project_id
  image_name              = var.linux_image_name
  image_family            = var.linux_image_family
  image_labels            = var.linux_image_labels

  ssh_username            = var.linux_ssh_username
  ssh_password            = var.linux_ssh_password
  wait_to_add_ssh_keys    = var.linux_wait_to_add_ssh_keys

  metadata                = {
    enable-oslogin        = false
  }

}

build {
  name          = "lnxgoldimg"
  sources       = ["source.googlecompute.linux"]

  provisioner "file" {
    source      = "./files/linux/"
    destination = "/tmp"
  }

  provisioner "shell" {
    inline      = [
                    "chmod 755 /tmp/Linux_RHEL_PostProv.bsh",
                    "vi +':w ++ff=unix' +':q' /tmp/Linux_RHEL_PostProv.bsh"
                  ]
  }
}
