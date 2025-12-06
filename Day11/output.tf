output "project_name" {
  value = local.formatted_name
}

output "s3_bucket_name" {
  value = local.bucket_name
}

output "port_list" {
  value = local.allowed_ports
}

output "security_group_rules" {
  value = local.sg_rules
}

output "instance_size" {
  value = local.instance_size
}