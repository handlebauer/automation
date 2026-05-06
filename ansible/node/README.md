# VPS Automation

Ansible playbooks for bootstrapping and configuring Ubuntu VPSes from scratch.

## Prerequisites

- Ansible installed on the local machine (`brew install ansible`)
- Tailscale installed on the local machine and connected to your tailnet
- A freshly provisioned VPS with a username (usually `root`) and IP address from the provider
- The provider-assigned password or SSH key for initial access
- A Tailscale auth key (generate at https://login.tailscale.com/admin/settings/keys — check **Reusable**)

## Bootstrapping a new VPS

### 1. Add the host to bootstrap inventory

Edit `inventory/bootstrap.yml` and add the new VPS with its public IP:

```yaml
all:
  hosts:
    my-vps:
      ansible_host: 203.0.113.10
```

### 2. Run the bootstrap playbook

If the provider gave a root password:

```sh
ansible-playbook playbooks/site.yml -i inventory/bootstrap.yml --ask-pass -e 'hostname=my-vps' -e 'tailscale_key=tskey-auth-XXXXX'
```

If the provider set up an SSH key instead:

```sh
ansible-playbook playbooks/site.yml -i inventory/bootstrap.yml --private-key ~/.ssh/id_whatever -e 'hostname=my-vps' -e 'tailscale_key=tskey-auth-XXXXX'
```

This is the only time provider credentials are needed.

### 3. Move the host to the main inventory

After bootstrap, find the Tailscale IP in the admin console (https://login.tailscale.com/admin/machines) and add the host to `inventory/hosts.yml`:

```yaml
all:
  hosts:
    my-vps:
      ansible_host: 100.x.x.x
```

Remove it from `inventory/bootstrap.yml`. All future runs use `inventory/hosts.yml` (the default), connecting as the `automation` user over Tailscale with `~/.ssh/id_automation` — no password or YubiKey needed.

### 4. Update your SSH config

Add the Tailscale IP to `~/.ssh/config` for direct SSH access:

```
Host my-vps
    HostName 100.x.x.x
    User hbauer
```

## What the bootstrap does

The `site.yml` playbook runs roles defined in order. It creates a key-only SSH user (`hbauer` with YubiKey) and an automation user (for future Ansible runs), hardens access (disables password auth, enables firewall + fail2ban), installs Tailscale, then installs tooling and dotfiles. After Tailscale is up, it locks down UFW to block all public access — SSH is only reachable over Tailscale. See `playbooks/site.yml` for the exact role list. All roles are idempotent — safe to re-run.

## Opt-in playbooks

Not every VPS needs these. Run them separately against specific hosts:

```sh
# Install Docker CE + lazydocker
ansible-playbook playbooks/add_docker.yml --limit my-vps

# Remove the automation user (and its home directory + sudo access)
ansible-playbook playbooks/remove_automation.yml --limit my-vps
```

## Configurable variables

All variables have sensible defaults. Override per-host in `host_vars/<hostname>.yml` or at runtime with `-e`.

| Variable | Default | Used by |
|---|---|---|
| `hostname` | *(required at runtime)* | `set_hostname`, `setup_tailscale` |
| `tailscale_key` | *(required at runtime)* | `setup_tailscale` |
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
