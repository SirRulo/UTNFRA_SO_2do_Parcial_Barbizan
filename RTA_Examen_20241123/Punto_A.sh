#!/bin/bash

sudo fdisk /dev/sdd
add a new partition=n

Default=p
Default=1
Enter
Espacio=+5M
change a partition type=t
Linux LVM=8e

Guardar=wq

sudo pvcreate /dev/sdd1
sudo vgcreate vg_datos /dev/sdd1


sudo fdisk /dev/sdc
add a new partition=n
Default=p
Default=1
Enter
Espacio=+1.5G
change a partition type=t
Linux LVM=8e

Guardar=wq

sudo pvcreate /dev/sdc1
sudo vgextend vg_datos /dev/sdc1


sudo fdisk /dev/sdc
add a new partition=n
Default=p
Default=1
Enter
Espacio=Enter
change a partition type=t
2
Linux LVM=8e

Guardar=wq

sudo pvcreate /dev/sdc2
sudo vgcreate vg_temp /dev/sdc2

sudo vgs

sudo lvcreate -L +4M vg_datos -n lv_docker
sudo lvcreate -l +100%FREE vg_datos -n lv_workareas
sudo lvcreate -l +100%FREE vg_temp -n lv_swap

sudo lvs

sudo mkfs.ext4 /dev/mapper/vg_datos-lv_docker
sudo mkfs.ext4 /dev/mapper/vg_datos-lv_workareas

sudo mkswap /dev/mapper/vg_temp-lv_swap

sudo mount /dev/mapper/vg_datos-lv_docker /var/lib/docker
sudo mount /dev/mapper/vg_datos-lv_workareas /work/

sudo swapon /dev/vg_temp/lv_swap
