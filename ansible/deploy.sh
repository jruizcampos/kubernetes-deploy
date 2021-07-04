#!/bin/bash

#ansible -i hosts -m ping all

# Ejecutamos las configuraciones comunes a todos los nodos
ansible-playbook -i hosts 01-configuraciones-comunes.yml
# Ejecutamos las configuraciones correspondientes a los nodos Master
ansible-playbook -i hosts 02-configurando-master.yml
# Ejecutamos las configuraciones correspondientes a los nodos NFS
ansible-playbook -i hosts 03-configurando-nfs.yml
# Ejecutamos las configuraciones correspondientes a los nodos Worker
ansible-playbook -i hosts 04-configurando-workers.yml
