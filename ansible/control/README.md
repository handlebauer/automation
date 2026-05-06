# Control Node

Sets up a VPS as an Ansible control node that can manage other VPSes.

## Prerequisites

- The target VPS must already be bootstrapped via `ansible/node/`
- The repo must be pushed to GitHub

## Setup

```sh
cd ansible/control
ansible-playbook playbooks/site.yml
```

This installs Ansible, copies the `id_automation` private key, and clones the repo. After this, the control node can run playbooks against any VPS in `ansible/node/inventory/hosts.yml` over Tailscale.

## Configurable variables

All have sensible defaults. Override with `-e` if needed.

| Variable | Default | Used by |
|---|---|---|
| `automation_key_src` | `~/.ssh/id_automation` | `deploy_ssh_key` |
| `repo_url` | `https://github.com/handlebauer/automation.git` | `setup_repo` |
| `control_user` | `hbauer` | All roles |
| `repo_branch` | `main` | `setup_repo` |
