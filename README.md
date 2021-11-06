# Kubernetes Deploy
Proyecto de Ansible para la instalación automatizada de un clúster Kubernetes on-premise (bare-metal).

## Diagrama de Red del Proyecto a Desplegar
![diagrama de red](https://github.com/jruizcampos/kubernetes-deploy/blob/main/diagrama_de_red.jpg?raw=true)

## Arquitectura del Proyecto Ansible
![arquitectura ansible](https://github.com/jruizcampos/kubernetes-deploy/blob/main/esquema_playbooks_ansible.jpg?raw=true)

## Archivos a personalizar
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
