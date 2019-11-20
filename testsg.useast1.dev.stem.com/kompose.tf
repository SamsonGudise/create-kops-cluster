variable node_instance_type { default = "t2.medium" }
variable master_instance_type { default = "t2.small" }
variable cluster_name {}
variable lb_type { default = "Internal" }
variable owner { default = "Samson Gudise" }
variable team { default = "DevOps" }
variable kops_state_store {}
variable oidcClientID { default = "webapi-application-client-identity" }
variable oidcIssuerURL { default = "https://sts.windows.net/directory-tenant-identity" }
variable oidcUsernameClaim { default = "upn" }
variable k8sversion { default = "1.11.10" }
variable ami_id { default = "ami-0211df56ca498c334" }
variable apiaccess {
    type = "list"
    default = [ "0.0.0.0/0", "10.20.20.1/32" ]
}
variable sshaccess {
    type = "list"
    default = [ "0.0.0.0/0" ]
}

output "cluster_name" {
    value = "${var.cluster_name}"
}
output "lb_type" {
    value = "${var.lb_type}"
}
output "kops_state_store" {
    value = "${var.kops_state_store}"
}
output "owner" {
    value = "${var.owner}"
}
output "team" {
    value = "${var.team}"
}
output "ami_name" {
    value = "${var.ami_id}"
}
output "node_instance_type" {
    value = "${var.node_instance_type}"
}
output "master_instance_type" {
    value = "${var.master_instance_type}"
}
output "oidcClientID" {
    value = "${var.oidcClientID}"
}
output "oidcIssuerURL" {
    value = "${var.oidcIssuerURL}"
}
output "oidcUsernameClaim" {
    value = "${var.oidcUsernameClaim}"
}
output "k8sversion" {
    value = "${var.k8sversion}"
}
output "apiaccess" {
    value = "${var.apiaccess}"
}
output "sshaccess" {
    value = "${var.sshaccess}"
}