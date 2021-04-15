#!/bin/bash
exec > /tmp/terraform_setup.log 2>&1
#--------------------------------------------------------------
# Amazon OS Filter
#--------------------------------------------------------------

    if [ $(cat /etc/system-release-cpe | grep -i amazon | grep -c "amazon:linux") -eq 1 ];then
			OS=AMAZON1
	elif [ $(cat /etc/system-release-cpe | grep -i amazon | grep -c "amazon_linux:2") -eq 1 ];then
			OS=AMAZON2
    fi

#--------------------------------------------------------------
# 1. Define Variable
#--------------------------------------------------------------

export SERVERNAME=${server_name}

#--------------------------------------------------------------
# 2. Change Host Name
#--------------------------------------------------------------

case $OS in
    AMAZON1)
    #Change Server Name
    hostname $SERVERNAME
    sed -i s/HOSTNAME=.*/HOSTNAME=$(hostname)/g /etc/sysconfig/network
    ;;
    AMAZON2)
    hostname $SERVERNAME
    hostnamectl set-hostname $(hostname)
    ;;
esac

#--------------------------------------------------------------
# 3. Use Chef [Join Chef]
#--------------------------------------------------------------
# Join Chef Node
    chef-client -r test

# Timezone (UTC)
    #kst 일 경우 timezone::kst
    chef-client -o timezone::utc
