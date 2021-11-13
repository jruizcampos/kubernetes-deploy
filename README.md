# Kubernetes Deploy
Proyecto Ansible para la instalación automatizada de un clúster Kubernetes on-premise (bare-metal) sobre Linux.

Los playbooks han sido probados en sistemas operativos de la familia Red Hat: Centos 7/8, [Rocky Linux 8](https://rockylinux.org/), RHEL 7/8

## Requerimientos Iniciales
Para poder ejecutar el proyecto es necesario tener como mínimo los siguientes hosts con Linux ya instalado:
- Un servidor de administración: Debe tener Terraform, Ansible y GIT preinstalado. 2 GB RAM, 2 CPU 2.3 Ghz (mínimo)
- Un servidor master: 2 GB RAM, 2 CPU 2.3 Ghz (mínimo)
- Uno o más servidores worker: 2 GB RAM, 2 CPU 2.3 Ghz (mínimo)
- **(Opcional)** Un servidor NFS: Puede utilizar el servidor master para esta función.

En caso de requerir el despliegue de las máquinas en la nube de Azure, puede utilizar el siguiente proyecto [Terraform-Azure-VMs](https://github.com/jruizcampos/terraform-azure-vms) que automatiza el despliegue. También puede utilizar dicho proyecto para guiarse en la configuración inicial de los hosts.

## Diagrama de Red de la Infraestructura Kubernetes
![diagrama de red](https://johnruizcampos.com/wp-content/uploads/red_kubernetes_ansible.jpg?raw=true)

## Estructura del Proyecto Ansible
![arquitectura ansible](https://johnruizcampos.com/wp-content/uploads/proyecto_ansible_kubernetes-1024x391.jpg?raw=true)
- **despliegue-kubernetes.yml**: Es el playbook que realiza el despliegue de Kubernetes en sí. 
- **despliegue-aplicacion.yml**: Este playbook despliega un par de aplicaciones de ejemplo sobre el clúster de Kubernetes ya instalado.

Puede ejecutar los playbooks de manera separada, en orden o ejecutar ambos ejecutando el archivo bash **deploy.sh**.

## Archivos a personalizar
### Archivo **ansible/hosts**

```yaml
[all:vars]
# Usuario linux para conectarse a los hosts
ansible_user=adminUsername 

# Definimos el host master y su ip
[master]
master1 ansible_host=10.0.1.21

# Definimos los hosts worker y sus ips
[workers]
worker1 ansible_host=10.0.1.51
# worker2 ansible_host=10.0.1.52
# .
# .
# .
# worker[n] ansible_host=10.0.1.n

# Definimos el host NFS y su ip
[nfs]
nfs1 ansible_host=10.0.1.21
```
- Variable **ansible_user**: Usuario Linux con el cual Ansible se conectará a los servidores master, workers y nfs.
- **master1 ansible_host=10.0.1.21**: En esta línea reemplazaremos **10.0.1.21** por la dirección ip del servidor que nosotros usaremos como Kubernetes master.
- **worker1 ansible_host=10.0.1.51**: En esta línea reemplazaremos **10.0.1.51** por la dirección ip del servidor que nosotros usaremos como Kubernetes worker. En caso querramos configurar más workers, sólo debemos agregarlos como woker2, worker3, etc.
- **nfs1 ansible_host=10.0.1.21**: En esta línea reemplazaremos **10.0.1.21** por la dirección ip del servidor que nosotros usaremos como servidor NFS.

### Archivo **ansible/group_vars/master.yaml**

```yaml
# Red de Docker configurada en el master. La obtenemos a través de los facts
docker_network: "{{ ansible_docker0.ipv4.network }}/16"

# Aquí definimos la red por defecto para los pods. Podemos cambiarla si así lo deseamos.
pod_network: "10.255.0.0/16"

# Aquí definimos que tipo de SDN queremos desplegar Calico o Flannel
sdn: flannel
# sdn: calico
```
- Variable **pod_network**: Segmento de red para los pods. Podemos dejarla como está o configurarla con un valor personalizado. 
- Variable **sdn**: Tipo de SDN que se instalará: calico o flannel. La elección de una u otra depende del tipo de infraestructura sobre la cual se está realizando la instalación:
- Si la instalación de Kubernetes es on-premise: Puede usar [calico](https://docs.projectcalico.org/getting-started/kubernetes/quickstart) o [flannel](https://docs.projectcalico.org/getting-started/kubernetes/flannel/flannel), aunque se recomienda **Calico** por ser más completo y personalizable.
- Si la instalación de Kubernetes es sobre maquinas virtuales en la nube de Azure: Debe usar **flannel**, dado que a nivel de red Calico usa ciertos puertos y protocolos que están bloqueados por defecto en Azure.

## Despliegue
Realizar los siguientes pasos en el host Ansible:
- Clonar el proyecto: `git clone https://github.com/jruizcampos/kubernetes-deploy`
- Ingresar a la carpeta ansible `cd ansible`
- Copiar las llaves de autenticación **ssh** del host Ansible a los hosts master, workers y nfs para que pueda conectarse a ellos sin necesidad de usar usuario y clave:
```bash
ssh-copy-id -i ~/.ssh/id_rsa.pub adminUsername@10.0.1.21
ssh-copy-id -i ~/.ssh/id_rsa.pub adminUsername@10.0.1.51
```
- Para los hosts master, workers y nfs, el usuario Linux a usar (en este caso **adminUsername**) debe estar configurado para realizar el escalado de privilegios **sudo** sin necesidad de ingresar contraseña. Para ello podemos ejecutar **visudo** y agregar las siguientes líneas al final:
```bash
## Same thing without a password
adminUsername    ALL=(ALL)       NOPASSWD: ALL
```
- Personalizar los archivos **hosts** y **master.yaml** de acuerdo a lo indicado en la sección anterior.
- Ejecutar el playbook de despliegue de Kubernetes:
```bash
ansible-playbook -i hosts despliegue-kubernetes.yml
```
- **(Opcional)** Ejecutar el playbook de despliegue de las aplicaciones de ejemplo:
```bash
ansible-playbook -i hosts despliegue-aplicacion.yml`
```
- También se pueden lanzar ambos playbooks ejecutando el archivo bash **deploy.sh**.

**&copy; 2021 [John Ruiz Campos](https://johnruizcampos.com "John Ruiz Campos")**

