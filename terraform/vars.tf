
variable "vm_size" {
  type = string
  description = "Tamaño de la máquina virtual"
  default = "Standard_D1_v2" # 3.5 GB, 1 CPU 
}

#############################################
variable "vm_size_master" {
  type = string
  description = "Tipo de máquina virtual master"
  default = "Standard_D2_v3" # 2 vCPU, 8GB RAM, 50 GB SSD
}

variable "vm_size_worker" {
  type = string
  description = "Tipo de máquina virtual worker"
  default = "Standard_A2_v2" # 2 vCPU, 4GB RAM, 20 GB SSD
}

variable "masters" {
	type = list(string)
	description = "vms master"
	#default = ["master1", "master2", "master3"]
	default = ["master1"]
}

variable "workers" {
	type = list(string)
	description = "vms workers"
	#default = ["worker1", "worker2", "worker3"]
	default = ["worker1", "worker2"]
}
