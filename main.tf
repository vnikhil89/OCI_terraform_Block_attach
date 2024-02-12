provider "oci" {
  tenancy_ocid     = var.tenancy_ocid
  user_ocid        = var.user_ocid
  fingerprint      = var.fingerprint
  private_key_path = var.private_key_path
  region           = var.region
}
data "oci_core_instances" "test_instances" {
    compartment_id = var.compartment_ocid
    availability_domain = var.ad_name
}
data "oci_core_volumes" "test_volumes" {
    compartment_id = var.compartment_ocid
    availability_domain = var.ad_name
}
locals {
 hostname = [for ins in data.oci_core_instances.test_instances.instances[*] : ins if startswith(ins.display_name,"test-")][*]
}

resource "oci_core_volume_attachment" "test_volume_attachment" {
      attachment_type = "iscsi"
      instance_id = lookup(local.hostname[0],"id")
      volume_id = lookup(data.oci_core_volumes.test_volumes.volumes[1],"id")
}


output "test1" {
  value = oci_core_volume_attachment.test_volume_attachment.ipv4
}