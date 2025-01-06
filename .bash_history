ls
/usr/sbin/sshd -D -E /var/log/sshd.log & tail -f /var/log/sshd.log
sleep 4
/usr/sbin/sshd -D -E /var/log/sshd.log & sleep 2 && tail -f /var/log/sshd.log
/usr/sbin/sshd -D -E /var/log/sshd.log & sleep 2 && tail -f /var/log/sshd.log
exi
exit
/usr/sbin/sshd -D -E /var/log/sshd.log & sleep 2 && tail -f /var/log/sshd.log
exit
