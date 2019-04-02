#!/bin/bash
##
## les't make some colourful 
yellow='\e[0;43m'
endColor='\e[0m'

# Display welcome message
echo -e "${yellow}Welcome $USER ${endColor}\n"
### -- 
##  ens assegurem que disposem de la darrera versió de les imatges
## --
#- totes
######docker-compose pull
#- individual
#docker pull docker.io/joaniznardo/ubuntum7http


## -- en cas de voler detall de què passa realment (màgia oculta)
## docker-compose --verbose -f docker-compose.yml up -d
docker-compose -f docker-compose.yml up  -d

##SOMOS LOS RECICLADORES DEFINITIVOS DE LABS. GRACIAS.
##export CONFIG_TFTPD=tftpd-hpa.lab24
##export DIR_TFTP=/var/lib/tftpboot/

#############################
###### webserver                ######
#############################
### -- 
##  -- etapa 1 - 
### -- 
## 
#docker-compose exec apache bash

# - acceptar les variables d'entorn per defecte
docker-compose exec apache1 bash /etc/apache2/envvars
docker-compose exec apache2 bash /etc/apache2/envvars
# - (re)iniciar el servei
docker-compose exec apache1 /usr/sbin/apache2ctl restart
docker-compose exec apache2 /usr/sbin/apache2ctl restart
# - comprovar que està en marxa
docker-compose exec apache1 netstat -atnp | grep :80 | wc -l
docker-compose exec apache2 netstat -atnp | grep :80 | wc -l

# etapes per crear una web:
### -- 
##  -- etapa 1 - preparar el servidor
### -- 

# - deshabilitar la que tenim per defecte
docker-compose exec apache1 /usr/sbin/a2dissite 000-default 
docker-compose exec apache2 /usr/sbin/a2dissite 000-default 

## # - partir de sites-available i generar una de nova (que acabe en conf)
## docker-compose exec apache cp /etc/apache2/sites-available/00{0-default,1-website01}.conf
## docker-compose exec apache sed  -i '/DocumentRoot/s/html/website01/' /etc/apache2/sites-available/001-website01.conf

docker-compose exec apache2 /bin/bash -c "sed -i '/Listen 80$/aListen 8086' /etc/apache2/ports.conf"
docker-compose exec apache2 /bin/bash -c "sed -i '/Listen 80$/aListen 8085' /etc/apache2/ports.conf"
docker-compose exec apache2 /bin/bash -c "sed -i '/Listen 80$/aListen 8084' /etc/apache2/ports.conf"
docker-compose exec apache1 /bin/bash -c "sed -i '/Listen 80$/aListen 8083' /etc/apache2/ports.conf"
docker-compose exec apache1 /bin/bash -c "sed -i '/Listen 80$/aListen 8082' /etc/apache2/ports.conf"
docker-compose exec apache1 /bin/bash -c "sed -i '/Listen 80$/aListen 8081' /etc/apache2/ports.conf"

#- habilitar les noves sites
docker-compose exec apache1 /usr/sbin/a2ensite  001-website01
docker-compose exec apache1 /usr/sbin/a2ensite  002-website02
docker-compose exec apache1 /usr/sbin/a2ensite  003-website03
docker-compose exec apache2 /usr/sbin/a2ensite  004-website04
docker-compose exec apache2 /usr/sbin/a2ensite  005-website05
docker-compose exec apache2 /usr/sbin/a2ensite  006-website06

#- refrescar i apuntar 
docker-compose exec apache /usr/sbin/apache2ctl restart

### -- 
##  -- etapa 2 - validar que ho hem aconseguit
### -- 

# accedint per ip
IP_SERVER=10.28.1.100
PORT_SERVER=8081
echo -e "\n${yellow}Validació: comprovació des del client (per port - $IP_SERVER:$PORT_SERVER ) ${endColor}\n"
docker-compose exec textclient curl $IP_SERVER:$PORT_SERVER

# accedint per ip
IP_SERVER=10.28.1.100
PORT_SERVER=8082
echo -e "\n${yellow}Validació: comprovació des del client (per port - $IP_SERVER:$PORT_SERVER ) ${endColor}\n"
docker-compose exec textclient curl $IP_SERVER:$PORT_SERVER

# accedint per ip
IP_SERVER=10.28.1.100
PORT_SERVER=8083
echo -e "\n${yellow}Validació: comprovació des del client (per port - $IP_SERVER:$PORT_SERVER ) ${endColor}\n"
docker-compose exec textclient curl $IP_SERVER:$PORT_SERVER

# accedint per ip
IP_SERVER=10.28.1.101
PORT_SERVER=8084
echo -e "\n${yellow}Validació: comprovació des del client (per port - $IP_SERVER:$PORT_SERVER ) ${endColor}\n"
docker-compose exec textclient curl $IP_SERVER:$PORT_SERVER

# accedint per ip
IP_SERVER=10.28.1.101
PORT_SERVER=8085
echo -e "\n${yellow}Validació: comprovació des del client (per port - $IP_SERVER:$PORT_SERVER ) ${endColor}\n"
docker-compose exec textclient curl $IP_SERVER:$PORT_SERVER

# accedint per ip
IP_SERVER=10.28.1.101
PORT_SERVER=8086
echo -e "\n${yellow}Validació: comprovació des del client (per port - $IP_SERVER:$PORT_SERVER ) ${endColor}\n"
docker-compose exec textclient curl $IP_SERVER:$PORT_SERVER

# comprovar fitxer /etc/hosts
echo -e "\n${yellow}Validació: comprovació del arxiu /etc/hosts ${endColor}\n"
docker-compose exec textclient cat /etc/hosts

# comprovar qui ha accedit
echo -e "\n${yellow}Validació: qui accedeix? (/var/log/apache2/access.log) ${endColor}\n"
docker-compose exec apache1 cat /var/log/apache2/access.log

docker-compose exec apache2 cat /var/log/apache2/access.log

