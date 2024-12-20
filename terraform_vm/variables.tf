variable "credentials_file" {
  description = "The GCP credentials file"
  type        = string
}

variable "project_id" {
  description = "The GCP project ID"
  type        = string
}

variable "region" {
  description = "The GCP region"
  type        = string
}

variable "zone" {
  description = "The GCP zone"
  type        = string
}

variable "instance_name" {
  description = "The instance name"
  type        = string
}

variable "machine_type" {
  description = "The machine type"
  type        = string
}

variable "disk_image" {
  description = "The disk image"
  type        = string
}

variable "ssh_user" {
  description = "The SSH username"
  type        = string
}

variable "ssh_public_key" {
  description = "The SSH public key file"
  type        = string
}

variable "ssh_private_key" {
  description = "The SSH private key file"
  type        = string
}