# Kubernetes Deploy
Proyecto de Scripts Terraform y Ansible para el despliegue automatizado de infraestructura en Microsoft Azure, Kubernetes como PaaS y aplicaciones.

## Organización del Proyecto
- **Carpeta Terraform:** Scripts para el despliegue de la infraestructura en Azure.
- **Carpeta Ansible:** Scripts para el despliegue de Kubernetes y una aplicación web sobre la infraestructura anteriormente desplegada.

## Diagrama de Red del Proyecto a Desplegar
![diagrama de red](https://github.com/jruizcampos/kubernetes-deploy/blob/main/diagrama_de_red.jpg?raw=true)

## Proyecto Terraform:
### Archivos a personalizar:
- Archivo **correccion-vars.tf**

```yaml
variable "location" {
  type = string
  description = "Región de Azure donde crearemos la infraestructura"
  default = "East US" 
}

variable "storage_account" {
  type = string
  description = "Nombre para la storage account"
  default = "kubernetesstacc"
}

variable "public_key_path" {
  type = string
  description = "Ruta para la clave pública de acceso a las instancias"
  default = "~/.ssh/id_rsa.pub" # o la ruta correspondiente
}

variable "ssh_user" {
  type = string
  description = "Usuario para hacer ssh"
  default = "adminUsername"
}
```

- Archivo **vars.tf**: 

```yaml
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
```

## Proyecto Ansible
### Arquitectura del Proyecto Ansible
![arquitectura ansible](https://github.com/jruizcampos/kubernetes-deploy/blob/main/esquema_playbooks_ansible.jpg?raw=true)

### Archivos a personalizar
- Archivo **hosts**

```yaml
[all:vars]
ansible_user=adminUsername

[master]
master1 ansible_host=192.168.56.108
#master1 ansible_host=23.96.43.136

[workers]
#worker1 ansible_host=23.96.41.146
worker1 ansible_host=192.168.56.109

[nfs]
nfs1 ansible_host=192.168.56.108
#nfs1 ansible_host=23.96.43.136
```
- Archivo **ansible/group_vars/master.yaml**

```yaml
# Red de Docker configurada en el master. La obtenemos a través de los facts
docker_network: "{{ ansible_docker0.ipv4.network }}/16"
#docker_network: "{{ ansible_docker0.ipv4.network }}/{{ ansible_docker0.ipv4.netmask }}"

# Aquí definimos la red por defecto para los pods. Podemos cambiarla si así lo deseamos.
pod_network: "10.255.0.0/16"
# Aquí definimos que tipo de SDN queremos desplegar Calico o Flannel
sdn: calico
```
