#!/bin/bash
source ~/python-venv/ansible/bin/activate

if az account show 2>&1 | grep -q "'az login'"; then
    az login
fi

export DEPLOYER_SUDO_PASSWORD=$(az keyvault secret show --name deployerSudoPassword --vault-name kv-homelab-westus | jq -r .value)

ansible-playbook ~/homelab/ansible/playbooks/$1.yaml -u deployer -i ~/homelab/ansible/inventory/hosts