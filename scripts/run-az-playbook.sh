#!/bin/bash
cd ~/python-venv
source ansible/bin/activate

if [ "$(az account list)" =~ "[]" ]; then
    az login
fi

ansible-playbook ~/homelab/ansible/playbooks/$1.yaml