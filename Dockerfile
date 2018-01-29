###############################################################
# NAME: netbox-openshift
# Purpose:  An Openshift implimentation of netbox
# Notes: This is a fully contained version of Netbox that has
#        been prepared for the Openshift platform
# Netbox Documentation: http://netbox.readthedocs.io/en/stable/
###############################################################

# Using Centos 7 as base
FROM centos:7

# Maintained be
MAINTAINER smacktrace <smacktrace942@gmail.com>

#Dependencies
RUN yum install -y epel-release
RUN yum install -y gcc \
        git \
        python34 \
        python34-devel \
        python34-setuptools \
        openldap-devel \
      	nginx \
      	uwsgi \
      	uwsgi-plugin-python3 \
      	&& yum clean all -y


#Contents of netbox
ADD /crm /opt/crm/crm

#Pip install files
ADD /pip /opt/pip

COPY nginx.conf /etc/nginx/nginx.conf
COPY appconfig/nginx.conf /opt/crm/nginx.conf
COPY appconfig/uwsgi.ini /opt/crm/uwsgi.ini

#Install PIP3 (PYTHON) dependencies
RUN python3 /opt/pip/get-pip.py \
	&& pip3 install -r /opt/crm/crm/requirements.txt \
	&& pip3 install napalm django-auth-ldap uwsgi

#RUN python3 /opt/crm/manage.py collectstatic --no-input

#TEMP ENV VARS    ### REMOVE for openshift
ENV DB_NAME crm
ENV DB_USER crm
ENV DB_PASSWORD crm
ENV DB_HOST crmb
ENV DJAGNO_SECRET_KEY j8m06GIBSh&dD1z*c5Cq$i9RyE47@H#ub^nKV_(LN+-f=w!agx
ENV FQDN localhost


#Create and prepare docker entrypoint
ADD docker-entrypoint.sh /sbin
RUN chmod +x /sbin/docker-entrypoint.sh \
        && mkdir -p /var/log/crm \
        && usermod -a -G root nginx


#MAKE SURE TO ADD LDAP STUFF http://netbox.readthedocs.io/en/stable/installation/ldap/
ENTRYPOINT [ "docker-entrypoint.sh" ]
CMD ["nginx", "-g", "daemon off;"]
