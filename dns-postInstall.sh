#!/bin/bash
echo "firewall-cmd" || exit 1
firewall-cmd --remove-service=cockpit --permanent || exit 1
echo "firewall-cmd" || exit 1
firewall-cmd --remove-service=dhcpv6-client --permanent || exit 1
echo "firewall-cmd" || exit 1
firewall-cmd --zone=public --permanent --add-port=7722/tcp || exit 1
echo "firewall-cmd" || exit 1
firewall-cmd --zone=public --permanent --add-service=dns || exit 1
echo "firewall-cmd" || exit 1
firewall-cmd --zone=public --permanent --add-port=53/tcp || exit 1
echo "firewall-cmd" || exit 1
firewall-cmd --zone=public --permanent --add-port=53/udp || exit 1
echo "firewall-cmd" || exit 1
firewall-cmd --reload #optional if rebooting at the end || exit 1
echo "yum update, may take 5 minutes or so" || exit 1
yum update -y #5 minutes give or take || exit 1
echo "yum installs" || exit 1
yum remove NetworkManager -y && yum install httpd policycoreutils-python-utils mlocate mailx sendmail network-scripts net-tools git bind-utils bind-chroot -y && systemctl enable network && systemctl start network && yum autoremove -y && echo "Successful completion!" || exit 1
echo "dns stuff" || exit 1
/usr/libexec/setup-named-chroot.sh /var/named/chroot on || exit 1
systemctl disable --now named || exit 1
systemctl enable --now named-chroot || exit 1
echo “fix sshd” || exit 1
sed -i 's/^#Port 22/Port 7722/' /etc/ssh/sshd_config || exit 1
sed -i 's/^PermitRootLogin yes/PermitRootLogin no/' /etc/ssh/sshd_config || exit 1
echo "semanage" || exit 1
semanage port -a -t ssh_port_t -p tcp 7722 || exit 1
echo “Done - Time to reboot!” || exit 1
exit 0
