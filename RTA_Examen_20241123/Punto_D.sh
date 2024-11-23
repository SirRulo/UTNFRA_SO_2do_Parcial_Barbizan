#!/bin/bash

sudo mkdir -p ~/UTN-FRA_SO_Examenes/202406/ansible/roles/2do_parcial/templates

sudo tee ~/UTN-FRA_SO_Examenes/202406/ansible/roles/2do_parcial/templates/datos_alumno.txt.j2 << FIN
Nombre: {{ nombre_alumno }}
Apellido: {{ apellido_alumno }}
Division: {{ division_alumno }}
FIN

sudo tee ~/UTN-FRA_SO_Examenes/202406/ansible/roles/2do_parcial/templates/datos_equipo.txt.j2 << FIN
Ip: {{ pc_ip }}
Descripción: {{ pc_distribution }}
Cantidad_de_cores: {{ pc_cores }}
FIN

sudo tee -a ~/UTN-FRA_SO_Examenes/202406/ansible/roles/2do_parcial/tasks/main.yml << FIN
# tasks file for 2do_parcial

- debug:
    msg: "Tareas del 2do Parcial"

- name: crear estructura de directorios
  file:
   path: "{{ item }}"
   state: directory
   mode: '0755'
  with_items:
   - /tmp/2do_parcial/alumno
   - /tmp/2do_parcial/equipo

- name: crear archivo con datos alumno
  template:
   src: datos_alumno.txt.j2
   dest: /tmp/2do_parcial/alumno/datos_alumno.txt
  vars:
   nombre_alumno: "Franco"
   apellido_alumno: "Barbizan"
   division_alumno: "113 turno mañana"

- name: obtener información del equipo
  set_fact:
    pc_ip: "{{ lookup('pipe', 'curl -s ifconfig.me') }}"
    pc_distribution: "{{ lookup('pipe', 'lsb_release -d | cut -f2') }}"
    pc_cores: "{{ lookup('pipe', 'nproc') }}"

- name: crear archivo con datos de la PC
  template:
    src: datos_equipo.txt.j2
    dest: /tmp/2do_parcial/equipo/datos_equipo.txt



- name: darle permisos a 2PSupervisores
  lineinfile:
   path: /etc/sudoers
   state: present
   regexp: '^%2PSupervisores'
   line: '%2PSupervisores ALL=(ALL) NOPASSWD: ALL'
   validate: 'visudo -cf %s'

FIN

cd ~/UTN-FRA_SO_Examenes/202406/ansible

sudo ansible-playbook -i inventory/hosts playbook.yml
