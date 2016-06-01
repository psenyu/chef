#!/bin/bash

echo "---------------------------------------------------"
echo "OS will be harden in 5 second. "
echo "Please press CRTL+C if you wish to QUIT"
echo "---------------------------------------------------"
sleep 1
echo " 5"
sleep 1
echo " 4"
sleep 1
echo " 3"
sleep 1
echo " 2"
sleep 1
echo " 1"
sleep 1
echo "Start"
sleep 1
echo " "
echo " "
echo " "
echo "Start to configure /etc/modprobe.d/CIS.conf"
sleep 1

echo "install cramfs /bin/true" >> /etc/modprobe.d/CIS.conf
echo "install freevxfs /bin/true" >> /etc/modprobe.d/CIS.conf
echo "install jffs2 /bin/true" >> /etc/modprobe.d/CIS.conf
echo "install hfs /bin/true" >> /etc/modprobe.d/CIS.conf
echo "install hfsplus /bin/true" >> /etc/modprobe.d/CIS.conf
echo "install squashfs /bin/true" >> /etc/modprobe.d/CIS.conf
echo "install udf /bin/true" >> /etc/modprobe.d/CIS.conf
echo "install dccp /bin/true" >> /etc/modprobe.d/CIS.conf

echo "Complete"
echo " "
echo "Start to YUM update and delete mcstrans"
sleep 1

yum update -y
yum erase mcstrans

echo "Complete"
echo " "
echo "Start to configure network-related"
sleep 1

echo "fs.suid_dumpable = 0" >> /etc/sysctl.conf
echo "kernel.randomize_va_space" >> /etc/sysctl.conf
echo "net.ipv6.conf.all.disable_ipv6" >> /etc/sysctl.conf
echo "restrict -6 default kod nomodify notrap nopeer noquery" >> /etc/ntp.conf
/sbin/sysctl net.ipv6.conf.all.disable_ipv6=1:wq

echo "Complete"
echo " "
echo "Start to configure audit rules"
sleep 1

echo "-a always,exit -F arch=b64 -S adjtimex -S settimeofday -k time-change" >> /etc/audit/audit.rules
echo "-a always,exit -F arch=b32 -S adjtimex -S settimeofday -S stime -k time-change" >> /etc/audit/audit.rules
echo "-a always,exit -F arch=b64 -S clock_settime -k time-change" >> /etc/audit/audit.rules
echo "-a always,exit -F arch=b32 -S clock_settime -k time-change" >> /etc/audit/audit.rules
echo "-w /etc/localtime -p wa -k time-change" >> /etc/audit/audit.rules
echo "-w /etc/group -p wa -k identity" >> /etc/audit/audit.rules
echo "-w /etc/passwd -p wa -k identity " >> /etc/audit/audit.rules
echo "-w /etc/gshadow -p wa -k identity " >> /etc/audit/audit.rules
echo "-w /etc/shadow -p wa -k identity " >> /etc/audit/audit.rules
echo "-w /etc/security/opasswd -p wa -k identity " >> /etc/audit/audit.rules
echo "-a always,exit -F arch=b64 -S sethostname -S setdomainname -k system-locale" >> /etc/audit/audit.rules
echo "-a always,exit -F arch=b32 -S sethostname -S setdomainname -k system-locale" >> /etc/audit/audit.rules
echo "-w /etc/issue -p wa -k system-locale" >> /etc/audit/audit.rules
echo "-w /etc/issue.net -p wa -k system-locale" >> /etc/audit/audit.rules
echo "-w /etc/hosts -p wa -k system-locale" >> /etc/audit/audit.rules
echo "-w /etc/sysconfig/network -p wa -k system-locale" >> /etc/audit/audit.rules
echo "-w /etc/selinux/ -p wa -k MAC-policy " >> /etc/audit/audit.rules
echo "-w /var/log/faillog -p wa -k logins " >> /etc/audit/audit.rules
echo "-w /var/log/lastlog -p wa -k logins " >> /etc/audit/audit.rules
echo "-w /var/log/tallylog -p wa -k logins " >> /etc/audit/audit.rules
echo "-w /var/run/utmp -p wa -k session" >> /etc/audit/audit.rules
echo "-w /var/log/wtmp -p wa -k session" >> /etc/audit/audit.rules
echo "-w /var/log/btmp -p wa -k session" >> /etc/audit/audit.rules
echo "-a always,exit -F arch=b64 -S chmod -S fchmod -S fchmodat -F auid>=500 \ " >> /etc/audit/audit.rules
echo "-F auid!=4294967295 -k perm_mod" >> /etc/audit/audit.rules
echo "-a always,exit -F arch=b32 -S chmod -S fchmod -S fchmodat -F auid>=500 \ " >> /etc/audit/audit.rules
echo "-F auid!=4294967295 -k perm_mod" >> /etc/audit/audit.rules
echo "-a always,exit -F arch=b64 -S chown -S fchown -S fchownat -S lchown -F auid>=500 \ " >> /etc/audit/audit.rules
echo "-F auid!=4294967295 -k perm_mod" >> /etc/audit/audit.rules
echo "-a always,exit -F arch=b32 -S chown -S fchown -S fchownat -S lchown -F auid>=500 \ " >> /etc/audit/audit.rules
echo "-F auid!=4294967295 -k perm_mod" >> /etc/audit/audit.rules
echo "-a always,exit -F arch=b64 -S setxattr -S lsetxattr -S fsetxattr -S removexattr -S \ lremovexattr -S fremovexattr -F auid>=500 -F auid!=4294967295 -k perm_mod" >> /etc/audit/audit.rules
echo "-a always,exit -F arch=b32 -S setxattr -S lsetxattr -S fsetxattr -S removexattr -S \ lremovexattr -S fremovexattr -F auid>=500 -F auid!=4294967295 -k perm_mod" >> /etc/audit/audit.rules
echo "-a always,exit -F arch=b64 -S creat -S open -S openat -S truncate -S ftruncate \ " >> /etc/audit/audit.rules
echo "-F exit=-EACCES -F auid>=500 -F auid!=4294967295 -k access" >> /etc/audit/audit.rules
echo "-a always,exit -F arch=b32 -S creat -S open -S openat -S truncate -S ftruncate \ " >> /etc/audit/audit.rules
echo "-F exit=-EACCES -F auid>=500 -F auid!=4294967295 -k access" >> /etc/audit/audit.rules
echo "-a always,exit -F arch=b64 -S creat -S open -S openat -S truncate -S ftruncate \ " >> /etc/audit/audit.rules
echo "-F exit=-EPERM -F auid>=500 -F auid!=4294967295 -k access" >> /etc/audit/audit.rules
echo "-a always,exit -F arch=b32 -S creat -S open -S openat -S truncate -S ftruncate \ " >> /etc/audit/audit.rules
echo "-F exit=-EPERM -F auid>=500 -F auid!=4294967295 -k access" >> /etc/audit/audit.rules
echo "-w /var/log/sudo.log -p wa -k actions" >> /etc/audit/audit.rules
echo "-w /sbin/insmod -p x -k modules " >> /etc/audit/audit.rules
echo "-w /sbin/rmmod -p x -k modules " >> /etc/audit/audit.rules
echo "-w /sbin/modprobe -p x -k modules " >> /etc/audit/audit.rules
echo "-a always,exit -F arch=b64 -S init_module -S delete_module -k modules" >> /etc/audit/audit.rules
echo "-e 2" >> /etc/audit/audit.rules
pkill -HUP auditd

echo "Complete"
echo " "
echo "Start to edit syslog"
sleep 1

sed -i '1 i\/var/log/secure' /etc/logrotate.d/syslog
sed -i '1 i\/var/log/boot.log' /etc/logrotate.d/syslog
sed -i '1 i\/var/log/cron' /etc/logrotate.d/syslog

echo "Complete"
echo " "
echo "Start to edit limits.conf"
sleep 1

sed -i '60 i\*                hard    core            0' /etc/security/limits.conf

echo "Complete"
echo " "
echo "Start to edit sshd_config"
sleep 1

sed -i '24 i\Protocol 2' /etc/ssh/sshd_config
sed -i '42 i\LogLevel INFO' /etc/ssh/sshd_config
sed -i '53 i\MaxAuthTries 4' /etc/ssh/sshd_config
sed -i '140 i\ClientAliveInterval 300' /etc/ssh/sshd_config
sed -i '141 i\ClientAliveCountMax 0' /etc/ssh/sshd_config
sed -i '145 i\Banner /etc/issue.net' /etc/ssh/sshd_config
sed -i '142 i\PermitUserEnvironment no' /etc/ssh/sshd_config
sed -i '143 i\X11Forwarding no' /etc/ssh/sshd_config
sed -i '120 s/^/#/' /etc/ssh/sshd_config
sed -i '9 s/$/ audit=1/' /etc/grub.conf

echo "Complete"
echo " "
echo "Start to edit permission on crontab"
sleep 1

chown root:root /etc/crontab
chmod og-rwx /etc/crontab
chmod og-rwx /etc/cron.hourly
chmod og-rwx /etc/cron.daily
chmod og-rwx /etc/cron.weekly
chmod og-rwx /etc/cron.monthly
chmod og-rwx /etc/cron.d

echo "Complete"
echo " "
echo "Start to edit permission on banner"
sleep 1

echo "THIS IS A PRIVATE COMPUTER SYSTEM. It is for authorized use only. Authorized users or unauthorized users have no explicit or implicit expectation of privacy. " > /etc/issue.net
echo "Unauthorized or improper use of this system may result in administrativedisciplinary action and civil and criminal penalties. " >> /etc/issue.net

touch /etc/motd
chown root:root /etc/motd
chmod 644 /etc/motd
chown root:root /etc/issue
chmod 644 /etc/issue
chown root:root /etc/issue.net #
chmod 644 /etc/issue.net


echo "Complete"
echo " "
echo "Configuration end with 3 second"
sleep 1
echo " 3"
sleep 1
echo " 2"
sleep 1
echo " 1"
sleep 1
echo " "
echo " -------------------------------------------- "
echo "         Configuration complete!"
echo " -------------------------------------------- "
