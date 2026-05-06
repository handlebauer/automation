# changedetection.io

Self-hosted website change detection and monitoring.

## Prerequisites

- Target node must be bootstrapped via `ansible/node/`
- Docker must be installed (`ansible/node/playbooks/add_docker.yml`)

## Setup

Add the target to `inventory/hosts.yml`, then:

```sh
cd ansible/services/changedetection
ansible-playbook playbooks/site.yml
```

Access at `http://<tailscale-ip>:5000`.

## Configurable variables

| Variable | Default | Description |
|---|---|---|
| `service_user` | `hbauer` | User to own the service files |
| `changedetection_port` | `5000` | Port to expose the web UI |
| `changedetection_tz` | `UTC` | Timezone for scheduling |
