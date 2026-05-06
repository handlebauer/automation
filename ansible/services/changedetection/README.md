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

Access at `http://<host-ip>:5000`.

## Discord notifications

A rich embed template is included at `roles/deploy_changedetection/files/discord-notification.json`. To use it:

1. In the changedetection.io UI, go to Settings > Notifications
2. Set the notification URL to: `posts://discord.com/api/webhooks/YOUR_ID/YOUR_TOKEN`
3. Paste the contents of `discord-notification.json` as the notification body

The template shows the watch title, diff, added/removed lines, URL, and timestamp in a Discord embed.

## Configurable variables

| Variable | Default | Description |
|---|---|---|
| `service_user` | `hbauer` | User to own the service files |
| `changedetection_port` | `5000` | Port to expose the web UI |
| `changedetection_tz` | `UTC` | Timezone for scheduling |
| `changedetection_fetch_workers` | `10` | Parallel fetch workers |
| `changedetection_max_chrome` | `10` | Max concurrent Chrome processes |
| `changedetection_base_url` | *(optional)* | Public URL for notification links |
