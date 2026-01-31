terraform {
  required_providers {
    local  = { source = "hashicorp/local" }
    random = { source = "hashicorp/random" }
    null   = { source = "hashicorp/null" }
    tls    = { source = "hashicorp/tls" }
  }
}

# Generate unique ID
resource "random_pet" "name" {}

# Create a file representing a VM
resource "local_file" "vm" {
  content  = "VM Name: ${random_pet.name.id}"
  filename = "vm.txt"
}

# Create a file representing a container
resource "local_file" "container" {
  content  = "Container running nginx"
  filename = "container.txt"
}

# Logical dependency demo
resource "null_resource" "setup" {
  depends_on = [local_file.vm]
}
