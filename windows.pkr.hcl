source "googlecompute" "wingcpgoldenimage" {
  service_account_email = var.service_account_email
  project_id            = var.project_id
  subnetwork            = var.subnetwork
  zone                  = var.zone
  disk_size             = var.disk_size
  machine_type          = var.machine_type
  use_iap               = var.use_iap
  iap_localhost_port    = var.iap_localhost_port
  use_internal_ip       = var.use_internal_ip
  omit_external_ip      = var.omit_external_ip
  source_image_family   = var.win_source_image_family
  image_name            = var.win_image_name
  image_family          = var.win_image_family
  image_labels          = var.win_image_labels
  communicator          = var.win_communicator
  winrm_username        = var.win_username
  winrm_insecure        = var.win_insecure
  winrm_use_ssl         = var.win_use_ssl
  metadata = {
    windows-startup-script-cmd = "winrm quickconfig -quiet & net user /add packer & net localgroup administrators packer /add & winrm set winrm/config/service/auth @{Basic=\"true\"}"
  }
}

build {
  name    = "wingoldimg"
  sources = ["source.googlecompute.wingcpgoldenimage"]

  provisioner "powershell" {
    script = "./files/windows/bootstrap.ps1"

    environment_vars = [
      "domain_join_username=${var.domain_join_username}",
      "additional_rdp_users=${var.additional_rdp_users}",
      "secrets_project_name=${var.secrets_project_name}",
      "zone=${var.zone}",
      "vm_size=${var.machine_type}",
      "project_name=${var.project_id}",
    ]
  }

  provisioner "powershell" {
    script = "./files/windows/installables.ps1"
    }

  provisioner "powershell" {
    script = "./files/windows/hardening-os.ps1"
   }

provisioner "file" {
    sources = [
      "./files/windows/final-configuration.ps1"
    ]
    destination = "C:/"
  }


  provisioner "powershell" {
    script = "./files/windows/prepare-startup-scripts.ps1"

  }

provisioner "powershell" {
    script = "./files/windows/sysprep.ps1"
    }


}
