#!/bin/bash
echo "Setting up agent forwarding..."
mkdir -p /root/.ssh
chmod 0700 /root/.ssh
printf "Host \n    StrictHostKeyChecking no\n" > /root/.ssh/config
chmod 0600 /root/.ssh/config
ppid=$PPID
found_auth_sock=""
while [[ $SSH_AUTH_SOCK == "" && $ppid != "1" ]]; do
    f=`ls /tmp/ssh*/agent.$ppid 2>/dev/null`
    if [[ -z "$f" ]]; then
        ppid=`cat /proc/$ppid/status | grep PPid | awk '{print $2}'`
    else
        export SSH_AUTH_SOCK="$f"
        echo "SSH_AUTH_SOCK=$SSH_AUTH_SOCK"
    fi
done
if [[ -z "$SSH_AUTH_SOCK" ]]; then
    echo "Could not find running ssh agent.\n" 1>&2
    exit 1
fi
echo "Updating root_ssh_agents"
agent_file="/etc/sudoers.d/root_ssh_agent"
agent_contents="Defaults    env_keep += \"SSH_AUTH_SOCK\""
touch $agent_file && chmod 0440 $agent_file && echo $agent_contents > $agent_file
echo "Testing git connection"
ssh -T git@github.com

echo "Updating ssh config for vagrant user"
sudo su vagrant -c "mkdir -p /home/vagrant/.ssh"
sudo su vagrant -c "printf \"Host github.com\n    StrictHostKeyChecking no\n\" > /home/vagrant/.ssh/config"
sudo su vagrant -c "sudo chmod 0700 /home/vagrant/.ssh"
sudo su vagrant -c "sudo chmod 0600 /home/vagrant/.ssh/config"

exit 0
