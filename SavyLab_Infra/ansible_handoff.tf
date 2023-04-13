// adjust ansible inventory and configure VM guest OS

resource "null_resource" "ansible_dynamic_inventory" {
  depends_on = [azurerm_public_ip.public_ip_server]

  provisioner "local-exec" {
    command = "sed -i '2s/.*/${azurerm_public_ip.public_ip_server.ip_address}/' hosts"
  }
}

resource "time_sleep" "ansible_delay" {
  depends_on = [azurerm_virtual_machine.vm]

  create_duration = "30s"
}

resource "null_resource" "ansible" {
  depends_on = [time_sleep.ansible_delay]

  provisioner "local-exec" {
    command = "ansible-playbook -i hosts playbook.yaml"
  }
}

resource "time_sleep" "domain_creation_delay" {
  depends_on = [null_resource.ansible]

  create_duration = "30s"
}

resource "null_resource" "ansible_organization" {
  depends_on = [time_sleep.domain_creation_delay]

  provisioner "local-exec" {
    command = "ansible-playbook -i hosts organization.yaml"
  }
}