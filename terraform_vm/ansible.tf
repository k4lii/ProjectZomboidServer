resource "null_resource" "ansible_trigger" {
  depends_on = [google_compute_instance.vm_instance]
  
  triggers = {
    timestamp = "333332433"
  }

  provisioner "local-exec" {
    command = "ansible-playbook -i '${google_compute_instance.vm_instance.network_interface.0.access_config.0.nat_ip},' -u ${var.ssh_user} -e 'ansible_ssh_private_key_file=${var.ssh_private_key}' ./playbook.yml"
    working_dir = "${path.module}" # Set to the directory where your playbook is located
  }
}