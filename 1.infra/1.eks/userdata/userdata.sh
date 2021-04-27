MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="//"

--//
Content-Type: text/x-shellscript; charset="us-ascii"
!/bin/bash
exec > /tmp/terraform_setup.log 2>&1

#--------------------------------------------------------------
# 1. Change Server Name
#--------------------------------------------------------------

export SERVERNAME=${server_name}

hostname $SERVERNAME
hostnamectl set-hostname $SERVERNAME

ENV=$(echo $SERVERNAME|cut -d"-" -f1)

#----------------------------------------------
# 2. vim colorset 
#----------------------------------------------


if grep "export PS1" /etc/bashrc > /dev/null
then
        echo "vim colorset already"
else
        wget https://raw.githubusercontent.com/huyz/dircolors-solarized/master/dircolors.ansi-light -O /usr/etc/.dircolors
        echo 'alias vi="vim"' >> /etc/bashrc
        echo 'eval `dircolors /usr/etc/.dircolors`' >> /etc/bashrc

    if  [ $ENV = "dev" ]
    then
        echo "Your Environment $ENV"
        echo 'export PS1="\[\e[36;1m\]\u@\[\e[31;1m\]\h:\[\e[37;1m\][\$PWD]\\$ "' >> /etc/bashrc
    else
        echo "Your Environment $ENV"
        echo 'export PS1="\[\e[36;1m\]\u@\[\e[32;1m\]\h:\[\e[37;1m\][\$PWD]\\$ "' >> /etc/bashrc
    fi
fi

--//--
