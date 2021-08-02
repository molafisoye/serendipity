variable "ingress_ports" {
  type    = list(number)
  default = [80, 443, 22]
}

variable "ssh_public_key_file" {
  description = "The path to your local pub file"
  type    = string
}

variable "init_script_path" {
  description = "The local path to the init script"
  type = string
}