#!/bin/bash

cd ~/UTN-FRA_SO_Examenes/202406/docker/

vim html.index

sudo usermod -a -G docker Barbizan

cat << FIN > dockerfile
FROM nginx:latest
COPY index.html /usr/share/nginx/html/index.html
FIN

cat << FIN > run.sh
#!/bin/bash
docker run -d -p 8080:80 alejomiceli04/2doparcial:latest
FIN

docker login -u SirRulo
docker build -t web1-Barbizan .

docker tag web1-Barbizan SirRulo/2doparcial:latest

docker push SirRulo/2doparcial:latest

docker run -d -p 8080:80 SirRulo/2doparcial:latest
