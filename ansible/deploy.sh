#!/bin/bash

# Ejecutamos el playbook de despliegue de Kubernetes
ansible-playbook -i hosts despliegue-kubernetes.yml

# Ejecutamos el playbook de despliegue de la aplicación
ansible-playbook -i hosts despliegue-aplicacion.yml
