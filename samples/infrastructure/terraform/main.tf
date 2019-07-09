# Variable
variable "access_key" {}
variable "secret_key" {}
variable "region" {}
variable "ssh_key_name" {}
variable "ssh_key_local_path" {}
variable "prefix" {}
variable "suffix" {}
variable "k8s_ingress_ip" {}
variable "front_domain" {}
variable "front_subdomain" {}
variable "back_domain" {}
variable "back_subdomain" {}


# Provision
provider "alicloud" {
    access_key = "${var.access_key}"
    secret_key = "${var.secret_key}"
    region = "${var.region}"
}


# VPC
resource "alicloud_vpc" "vpc" {
    cidr_block = "192.168.0.0/16"
    name = "${var.prefix}vpc${var.suffix}"
}

# VSwitch
data "alicloud_zones" "zones" {
    available_resource_creation = "VSwitch"
}
resource "alicloud_vswitch" "vswitch" {
    vpc_id = "${alicloud_vpc.vpc.id}"
    availability_zone = "${data.alicloud_zones.zones.zones.0.id}"
    cidr_block = "192.168.0.0/24"
    name = "${var.prefix}vswitch${var.suffix}"
}

# SSH key pair
resource "alicloud_key_pair" "key_pair" {
    key_name = "${var.ssh_key_name}"
    key_file = "${var.ssh_key_local_path}"
}

# k8s
data "alicloud_instance_types" "type2c8g" {
    availability_zone = "${data.alicloud_zones.zones.zones.0.id}"
    cpu_core_count = 2
    memory_size = 8
    kubernetes_node_role = "Worker"
}
resource "alicloud_cs_kubernetes" "k8s" {
    name_prefix = "${var.prefix}k8s${var.suffix}"
    vswitch_ids = ["${alicloud_vswitch.vswitch.id}"]
    new_nat_gateway = true

    cluster_network_type = "flannel"
    pod_cidr = "10.0.0.0/16"
    service_cidr = "10.1.0.0/16"

    master_instance_types = ["${data.alicloud_instance_types.type2c8g.instance_types.0.id}"]
    worker_instance_types = ["${data.alicloud_instance_types.type2c8g.instance_types.0.id}"]
    worker_numbers = [2]

    enable_ssh = true
    key_name = "${alicloud_key_pair.key_pair.key_name}"
}

# DNS record
resource "alicloud_dns_record" "front_record" {
    name = "${var.front_domain}"
    host_record = "${var.front_subdomain}"
    type = "A"
    value = "${var.k8s_ingress_ip}"
}
resource "alicloud_dns_record" "back_record" {
    name = "${var.back_domain}"
    host_record = "${var.back_subdomain}"
    type = "A"
    value = "${var.k8s_ingress_ip}"
}


# Output
output "vpc__vpc_id" {
    value = "${alicloud_vpc.vpc.id}"
}
output "key_pair__key_name" {
    value = "${alicloud_key_pair.key_pair.key_name}"
}
output "k8s__master_public_ip" {
    value = "${lookup(alicloud_cs_kubernetes.k8s.connections, "master_public_ip", "unknown")}"
}
output "k8s__api_server_internet" {
    value = "${lookup(alicloud_cs_kubernetes.k8s.connections, "api_server_internet", "unknown")}"
}
output "k8s__api_server_intranet" {
    value = "${lookup(alicloud_cs_kubernetes.k8s.connections, "api_server_intranet", "unknown")}"
}
output "dns_record__front_record__ip" {
    value = "${alicloud_dns_record.front_record.value}"
}
output "dns_record__front_record__domain_name" {
    value = "${alicloud_dns_record.front_record.host_record}.${alicloud_dns_record.front_record.name}"
}
output "dns_record__back_record__ip" {
    value = "${alicloud_dns_record.back_record.value}"
}
output "dns_record__back_record__domain_name" {
    value = "${alicloud_dns_record.back_record.host_record}.${alicloud_dns_record.back_record.name}"
}
