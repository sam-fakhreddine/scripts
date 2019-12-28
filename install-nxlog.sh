
 #!/bin/bash
 export LANG=en_US.UTF-8
 export NXLOG_USER=nxlog
 export NXLOG_GROUP=nxlog
 
 
 logger INFO !!!!!!!!!!!!  Creating rsyslog nxlog.conf
 mkdir -p /etc/rsyslog.d/ && touch /etc/rsyslog.d/nxlog.conf
 SSM_VALUE=`aws ssm get-parameters --with-decryption --names "/etc/rsyslog.d/nxlog.conf"  --query 'Parameters[*].Value' --output text --region us-west-2`
 echo "$SSM_VALUE" > /etc/rsyslog.d/nxlog.conf
 
 
 logger INFO !!!!!!!!!!!! Creating Nxlog.conf
 mkdir -p /opt/nxlog/etc && touch /opt/nxlog/etc/nxlog.conf
 SSM_VALUE=`aws ssm get-parameters --with-decryption --names "/opt/nxlog/etc/nxlog.conf"  --query 'Parameters[*].Value' --output text --region us-west-2`
 echo "$SSM_VALUE" > /opt/nxlog/etc/nxlog.conf
 
 logger INFO !!!!!!!!!!!! Installing Nxlog from S3
 SSM_VALUE=`aws ssm get-parameters --with-decryption --names "/nxlog/install_url"  --query 'Parameters[*].Value' --output text --region us-west-2`
 yum localinstall $SSM_VALUE -y
 logger INFO !!!!!!!!!!!! Done Installing NxLog
 
 sleep 9
 logger INFO !!!!!!!!!!!! Adding nxlog to adm usergroup
 usermod -a -G adm nxlog
 logger INFO !!!!!!!!!!!! Changing permission on /var/log/messages
 chgrp adm /var/log/messages
 chmod g+r /var/log/messages
 
 logger INFO !!!!!!!!!!!! Attempting to start nxlog
 service nxlog start
