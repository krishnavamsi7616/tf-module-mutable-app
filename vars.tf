variable "PRIVATE_SUBNET_IDS" {}
variable "VPC_ID" {}
variable "PORT" {}
variable "ALLOW_SG_CIDR" {}
variable "PROJECT" {}
variable "ENV" {}
variable "INSTANCE_TYPE" {}
variable "WORKSTATION_IP" {}
variable "COMPONENT" {}
variable "INSTANCE_COUNT" {}
variable "LB_ARN" {}
variable "LB_TYPE" {}
variable "PRIVATE_LB_DNS" {}
variable "PRIVATE_ZONE_ID" {}
variable "PRIVATE_LISTENER_ARN" {}
variable "DOCDB_ENDPOINT" {
  default = "null"
}
variable "REDIS_ENDPOINT" {
  default = "null"
}
variable "MYSQL_ENDPOINT" {
  default = "null"
}
variable "PROMETHEUS_IP" {}
