# VPS Automation

Ansible playbooks for bootstrapping and configuring Ubuntu VPSes from scratch.

## Prerequisites

- Ansible installed on the local machine (`brew install ansible`)
- A freshly provisioned VPS with a username (usually `root`) and IP address from the provider
- The provider-assigned password or SSH key for initial access

## Bootstrapping a new VPS

### 1. Add the host to inventory

Edit `inventory/hosts.yml` and add the new VPS:

```yaml
all:
  hosts:
    my-vps:
      ansible_host: 203.0.113.10
      ansible_user: root
```

### 2. Run the bootstrap playbook

If the provider gave a root password:

```sh
ansible-playbook playbooks/site.yml --ask-pass -e 'hostname=my-vps'
```

If the provider set up an SSH key instead:

```sh
ansible-playbook playbooks/site.yml --private-key ~/.ssh/id_whatever -e 'hostname=my-vps'
```

This is the only time provider credentials are needed — the playbook creates a key-only user (`hbauer`) with YubiKey SSH keys, then disables password auth and root login entirely.

After bootstrap, SSH access is only possible as `hbauer` with a physical YubiKey.

### 3. Update the inventory for future runs

After bootstrap, update the host entry to use the new user (password auth is now disabled):

```yaml
all:
  hosts:
    my-vps:
      ansible_host: 203.0.113.10
      ansible_user: hbauer
```

## What the bootstrap does

The `site.yml` playbook runs roles defined in order. It creates a key-only SSH user, hardens access (disables password auth, enables firewall + fail2ban), then installs tooling and dotfiles. See `playbooks/site.yml` for the exact role list. All roles are idempotent — safe to re-run.

## Opt-in playbooks

Not every VPS needs these. Run them separately against specific hosts:

```sh
# Add an 'automation' user for future Ansible access without a YubiKey
ansible-playbook playbooks/add_automation.yml -u hbauer --limit my-vps

# Install Docker CE
ansible-playbook playbooks/add_docker.yml -u hbauer --limit my-vps

# Remove the automation user (and its home directory + sudo access)
ansible-playbook playbooks/remove_automation.yml -u hbauer --limit my-vps
```

## Configurable variables

All variables have sensible defaults. Override per-host in `host_vars/<hostname>.yml` or at runtime with `-e`.

| Variable | Default | Used by |
|---|---|---|
| `hostname` | *(required at runtime)* | `set_hostname` |
| `username` | `hbauer` | Most roles |
| `ssh_port` | `22` | `harden_ssh`, `setup_ufw` |
| `timezone` | `UTC` | `set_timezone` |
| `swap_size` | `1G` | `setup_swap` |
| `apt_packages` | see `roles/apt_packages/defaults/main.yml` | `apt_packages` |
| `ufw_allowed_ports` | SSH only | `setup_ufw` |
| `fail2ban_maxretry` | `3` | `setup_fail2ban` |
| `fail2ban_bantime` | `1h` | `setup_fail2ban` |
| `fail2ban_findtime` | `10m` | `setup_fail2ban` |

Example per-host override (`host_vars/my-vps.yml`):

```yaml
ufw_allowed_ports:
  - { port: "22", proto: "tcp" }
  - { port: "443", proto: "tcp" }
  - { port: "80", proto: "tcp" }
```

## Testing

An OrbStack-based test environment is available. It runs everything except user/SSH roles against a local Ubuntu VM:

```sh
ansible-playbook -i inventory/test.yml playbooks/test.yml
```

## Adding new playbooks

1. Create a new role in `roles/` if needed
2. Create a new playbook in `playbooks/`
3. The playbook references roles — all playbooks share the same `roles/` directory
