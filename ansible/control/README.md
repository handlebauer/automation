# Control Node

Sets up a VPS as an Ansible control node that can manage other VPSes.

## Prerequisites

- The target VPS must already be bootstrapped via `ansible/vps/`
- The automation repo must be hosted on a Git remote (e.g. GitHub)

## Setup

```sh
cd ansible/control
ansible-playbook playbooks/site.yml \
  -e 'automation_key_src=~/.ssh/id_automation' \
  -e 'repo_url=https://github.com/handlebauer/automation.git'
```

This installs Ansible, copies the `id_automation` private key, and clones the repo. After this, the control node can run playbooks against any VPS in `ansible/vps/inventory/hosts.yml` over Tailscale.

## Configurable variables

| Variable | Default | Used by |
|---|---|---|
| `automation_key_src` | *(required at runtime)* | `deploy_ssh_key` |
| `repo_url` | *(required at runtime)* | `setup_repo` |
| `control_user` | `hbauer` | All roles |
| `repo_branch` | `main` | `setup_repo` |
