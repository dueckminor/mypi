#!/bin/sh
if [ -z ${PASSWORD} ]; then
  PASSWORD=$(< /dev/urandom tr -dc A-Za-z0-9 | head -c${1:-8};echo;)
  echo "Generated password for user 'files': ${PASSWORD}"
fi
# set ftp user password
echo "files:${PASSWORD}" |/usr/sbin/chpasswd
chown files:files /home/files/ -R

if [ -e /etc/vsftpd.in/vsftpd.conf ]; then
  echo "Copying /etc/vsftpd.in/vsftpd.conf to /etc/vsftpd/"
  mkdir -p /etc/vsftpd
  cp /etc/vsftpd.in/vsftpd.conf /etc/vsftpd/vsftpd.conf
fi

if [ -z "${1}" ]; then
  echo "Starting: /usr/sbin/vsftpd /etc/vsftpd/vsftpd.conf"
  /usr/sbin/vsftpd /etc/vsftpd/vsftpd.conf
else
  echo "Starting:" "$@"
  "$@"
fi
