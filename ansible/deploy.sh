#!/bin/bash

#ansible -i hosts -m ping all

# Ejecutamos el playbook de despliegue de Kubernetes
ansible-playbook -i hosts despliegue-kubernetes.yml

# Ejecutamos el playbook de despliegue de la aplicación
ansible-playbook -i hosts despliegue-aplicacion.yml
