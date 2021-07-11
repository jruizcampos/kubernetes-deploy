#!/bin/bash

#ansible -i hosts -m ping all

# Ejecutamos el playbook de despliegue de Kubernetes
ansible-playbook -i hosts despliegue-kubernetes.yml


# Ejecutamos las configuraciones comunes a todos los nodos
#ansible-playbook -i hosts 01-configuraciones-comunes.yml
# Ejecutamos las configuraciones comunes a los masters y workers
#ansible-playbook -i hosts 02-configuraciones-master-worker.yml
# Ejecutamos las configuraciones correspondientes a los nodos Master
#ansible-playbook -i hosts 03-configurando-master.yml
# Ejecutamos las configuraciones correspondientes a los nodos NFS
#ansible-playbook -i hosts 04-configurando-nfs.yml
# Ejecutamos las configuraciones correspondientes a los nodos Worker
#ansible-playbook -i hosts 05-configurando-workers.yml
