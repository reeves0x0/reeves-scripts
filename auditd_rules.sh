#!/bin/bash

# Правила для изменений файла /etc/hosts
cat > /etc/audit/rules.d/custom_hosts.rules << EOF
-w /etc/hosts -p wa -k hosts_file_change
EOF

# правила журнала перезагрузки
cat > /etc/audit/rules.d/custom_reboot.rules << EOF
-a exit,always -F arch=b64 -S execve -F path=/sbin/reboot -k reboot
-a exit,always -F arch=b64 -S execve -F path=/sbin/init -k reboot
-a exit,always -F arch=b64 -S execve -F path=/sbin/poweroff -k reboot
-a exit,always -F arch=b64 -S execve -F path=/sbin/shutdow -k reboot
EOF

# правила параметров ядра
cat > /etc/audit/rules.d/custom_kernel_config.rules << EOF
-w /etc/sysctl.conf -p wa -k sysctl
-w /etc/sysctl.d -p wa -k sysctl
EOF

# правила модулей ядра (загрузка\выгрузка)
cat > /etc/audit/rules.d/custom_kernel_modules.rules << EOF
-a always,exit -F perm=x -F auid!=-1 -F path=/sbin/insmod -k modules
-a always,exit -F perm=x -F auid!=-1 -F path=/sbin/modprobe -k modules
-a always,exit -F perm=x -F auid!=-1 -F path=/sbin/rmmod -k modules
-a always,exit -F arch=b64 -S finit_module -S init_module -S delete_module -F auid!=-1 -k modules
-a always,exit -F arch=b32 -S finit_module -S init_module -S delete_module -F auid!=-1 -k modules
EOF

# правила для kernel exec
cat > /etc/audit/rules.d/custom_kernel_execute.rules << EOF
-a always,exit -F arch=b64 -S kexec_load -k KEXEC
-a always,exit -F arch=b32 -S sys_kexec_load -k KEXEC
EOF

# правил монтиорвания
cat > /etc/audit/rules.d/custom_mount.rules << EOF
-a always,exit -F arch=b64 -S mount -S umount2 -F auid!=-1 -k mount
-a always,exit -F arch=b32 -S mount -S umount -S umount2 -F auid!=-1 -k mount
EOF

# правила изменения swap
cat > /etc/audit/rules.d/custom_swap.rules << EOF
-a always,exit -F arch=b64 -S swapon -S swapoff -F auid!=-1 -k swap
-a always,exit -F arch=b32 -S swapon -S swapoff -F auid!=-1 -k swap
EOF

# правила stunnel
cat > /etc/audit/rules.d/custom_Stunnel.rules << EOF
-w /usr/sbin/stunnel -p x -k stunnel
-w /usr/bin/stunnel -p x -k stunnel
EOF

# правила cron.rules
cat > /etc/audit/rules.d/custom_cron.rules << EOF
-w /etc/cron.allow -p wa -k cron
-w /etc/cron.deny -p wa -k cron
-w /etc/cron.d/ -p wa -k cron
-w /etc/cron.daily/ -p wa -k cron
-w /etc/cron.hourly/ -p wa -k cron
-w /etc/cron.monthly/ -p wa -k cron
-w /etc/cron.weekly/ -p wa -k cron
-w /etc/crontab -p wa -k cron
-w /var/spool/cron/ -k cron
EOF

# Создание файла правил custom_user_groups_password.rules и добавление содержимого
cat > /etc/audit/rules.d/custom_user_groups_password.rules << EOF
-w /etc/group -p wa -k etcgroup
-w /etc/passwd -p wa -k etcpasswd
-w /etc/gshadow -k etcgroup
-w /etc/shadow -k etcpasswd
-w /etc/security/opasswd -k opasswd
EOF

# правила /etc/sudoers
cat > /etc/audit/rules.d/custom_sudoers.rules << EOF
-w /etc/sudoers -p wa -k actions
-w /etc/sudoers.d/ -p wa -k actions
EOF

# правила смены пассворда
cat > /etc/audit/rules.d/custom_change_pass.rules << EOF
-w /usr/bin/passwd -p x -k passwd_modification
EOF

# правил смены id группа пользователям
cat > /etc/audit/rules.d/custom_group_id.rules << EOF
-w /usr/sbin/groupadd -p x -k group_modification
-w /usr/sbin/groupmod -p x -k group_modification
-w /usr/sbin/addgroup -p x -k group_modification
-w /usr/sbin/useradd -p x -k user_modification
-w /usr/sbin/userdel -p x -k user_modification
-w /usr/sbin/usermod -p x -k user_modification
-w /usr/sbin/adduser -p x -k user_modification
EOF

# правила логина
cat > /etc/audit/rules.d/custom_login.rules << EOF
-w /etc/login.defs -p wa -k login
-w /etc/securetty -p wa -k login
-w /var/log/faillog -p wa -k login
-w /var/log/lastlog -p wa -k login
-w /var/log/tallylog -p wa -k login
EOF

# правил для сессий 
cat > /etc/audit/rules.d/custom_session.rules << EOF
-w /var/run/utmp -p wa -k session
-w /var/log/btmp -p wa -k session
-w /var/log/wtmp -p wa -k session
EOF

# правила хостнамесов)))
cat > /etc/audit/rules.d/custom_hostname.rules  << EOF
-a always,exit -F arch=b32 -S sethostname -S setdomainname -k network_modifications
-a always,exit -F arch=b64 -S sethostname -S setdomainname -k network_modifications
EOF

# правила ип4
cat > /etc/audit/rules.d/custom_ipV4.rules  << EOF
-a always,exit -F arch=b64 -S connect -F a2=16 -F success=1 -F key=network_connect_4
-a always,exit -F arch=b32 -S connect -F a2=16 -F success=1 -F key=network_connect_4
EOF

# правила ип6
cat > /etc/audit/rules.d/custom_ipV6.rules  << EOF
-a always,exit -F arch=b64 -S connect -F a2=28 -F success=1 -F key=network_connect_6
-a always,exit -F arch=b32 -S connect -F a2=28 -F success=1 -F key=network_connect_6
EOF

# правила init d скриптов
cat > /etc/audit/rules.d/custom_initD_scripts.rules  << EOF
-w /etc/inittab -p wa -k init
-w /etc/init.d/ -p wa -k init
-w /etc/init/ -p wa -k init
EOF

# правила PAM модулей
cat > /etc/audit/rules.d/custom_PAM_modules.rules  << EOF
-w /etc/pam.d/ -p wa -k pam
-w /etc/security/limits.conf -p wa -k pam
-w /etc/security/limits.d -p wa -k pam
-w /etc/security/pam_env.conf -p wa -k pam
-w /etc/security/namespace.conf -p wa -k pam
-w /etc/security/namespace.d -p wa -k pam
-w /etc/security/namespace.init -p wa -k pam
EOF

# правила почт
cat > /etc/audit/rules.d/custom_mail.rules  << EOF
-w /etc/aliases -p wa -k mail
-w /etc/postfix/ -p wa -k mail
-w /etc/exim4/ -p wa -k mail
EOF

# правила для ssh
cat > /etc/audit/rules.d/custom_ssh.rules  << EOF
-w /etc/ssh/sshd_config -k sshd
-w /etc/ssh/sshd_config.d -k sshd
EOF

# правила для system d
cat > /etc/audit/rules.d/custom_systemD.rules  << EOF
-w /bin/systemctl -p x -k systemd
-w /etc/systemd/ -p wa -k systemd
-w /usr/lib/systemd -p wa -k systemd
EOF

# правила важных папок
cat > /etc/audit/rules.d/custom_critical_directory.rules  << EOF
-a always,exit -F arch=b64 -S open -F dir=/etc -F success=0 -k unauthedfileaccess
-a always,exit -F arch=b64 -S open -F dir=/bin -F success=0 -k unauthedfileaccess
-a always,exit -F arch=b64 -S open -F dir=/sbin -F success=0 -k unauthedfileaccess
-a always,exit -F arch=b64 -S open -F dir=/usr/bin -F success=0 -k unauthedfileaccess
-a always,exit -F arch=b64 -S open -F dir=/usr/sbin -F success=0 -k unauthedfileaccess
-a always,exit -F arch=b64 -S open -F dir=/var -F success=0 -k unauthedfileaccess
-a always,exit -F arch=b64 -S open -F dir=/home -F success=0 -k unauthedfileaccess
-a always,exit -F arch=b64 -S open -F dir=/srv -F success=0 -k unauthedfileaccess
EOF

# правила скалации привелегий\поднятие id процесса
cat > /etc/audit/rules.d/custom_privilege_escalation_id_proc.rules  << EOF
-w /bin/su -p x -k priv_esc
-w /usr/bin/sudo -p x -k priv_esc
-w /etc/sudoers -p rw -k priv_esc
-w /etc/sudoers.d -p rw -k priv_esc
EOF

# правила инъекций  в  код
cat > /etc/audit/rules.d/custom_code_injection.rules  << EOF
-a always,exit -F arch=b32 -S ptrace -F a0=0x4 -k code_injection
-a always,exit -F arch=b64 -S ptrace -F a0=0x4 -k code_injection
-a always,exit -F arch=b32 -S ptrace -F a0=0x5 -k data_injection
-a always,exit -F arch=b64 -S ptrace -F a0=0x5 -k data_injection
-a always,exit -F arch=b32 -S ptrace -F a0=0x6 -k register_injection
-a always,exit -F arch=b64 -S ptrace -F a0=0x6 -k register_injection
-a always,exit -F arch=b32 -S ptrace -k tracing
-a always,exit -F arch=b64 -S ptrace -k tracing
EOF

# правила для центоса yum\rpm
cat > /etc/audit/rules.d/custom_software_centos.rules  << EOF
-w /usr/bin/rpm -p x -k software_mgmt
-w /usr/bin/yum -p x -k software_mgmt
EOF

# правила питона
cat > /etc/audit/rules.d/custom_software_python.rules  << EOF
-w /usr/bin/pip -p x -k software_mgmt
-w /usr/bin/pip3 -p x -k software_mgmt
EOF

# правила для docker
cat > /etc/audit/rules.d/custom_docker.rules  << EOF
-w /usr/bin/dockerd -k docker
-w /usr/bin/docker -k docker
-w /usr/bin/docker-containerd -k docker
-w /usr/bin/docker-runc -k docker
-w /var/lib/docker -k docker
-w /etc/docker -k docker
-w /etc/sysconfig/docker -k docker
-w /etc/sysconfig/docker-storage -k docker
-w /usr/lib/systemd/system/docker.service -k docker
-w /usr/lib/systemd/system/docker.socket -k docker
EOF

#для рестарта аудита заменить строку
sed -i 's/RefuseManualStop=yes/RefuseManualStop=no/' /usr/lib/systemd/system/auditd.service

#ребутаем настроеки службы
systemctl daemon-reload

#ребутаем аудит
systemctl restart auditd.service
