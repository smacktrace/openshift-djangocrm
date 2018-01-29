#!/bin/bash
##  Docker Entrypoint for NETBOX on Openshift
##  MAINTAINER smacktrace <smacktrace942@gmail.com>

set -e

###################################################################################
###################### PREP POSTGRES CONFIG FILE  #################################
###################################################################################

#Insert DB_NAME
sed -i -e "s/DB_NAME/$(echo $DB_NAME)/g" /opt/crm/crm/crm/settings.py

#Insert DB_USER
sed -i -e "s/DB_USER/$(echo $DB_USER)/g" /opt/crm/crm/crm/settings.py

#Insert DB_PASSWORD
sed -i -e "s/DB_PASSWORD/$(echo $DB_PASSWORD)/g" /opt/crm/crm/crm/settings.py

#Insert DB_HOST
sed -i -e "s/DB_HOST/$(echo $DB_HOST)/g" /opt/crm/crm/crm/settings.py

#Insert DJANGO_SECRET_KEY
sed -i -e "s/DJANGO_SECRET_KEY/$(echo $DJAGNO_SECRET_KEY)/g" /opt/crm/crm/crm/settings.py

#Insert FQDN
sed -i -e "s/FQDN/$(echo $FQDN)/g" /opt/crm/crm/crm/settings.py

###################################################################################
##########################      PREP NGINX    #####################################
###################################################################################

sed -i -e "s/FQDN/$(echo $FQDN)/g" /opt/crm/nginx.conf


###################################################################################
##########################      Start UWSGI   #####################################
###################################################################################
uwsgi --ini /opt/crm/uwsgi.ini

###################################################################################
##########################      RUN CMD    ########################################
###################################################################################

exec "$@"
