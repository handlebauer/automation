# changedetection.io

Self-hosted website change detection and monitoring.

## Prerequisites

- Target node must be bootstrapped via `ansible/node/`
- Docker must be installed (`ansible/node/playbooks/add_docker.yml`)

## Setup

```sh
cd ansible/services/changedetection
ansible-playbook playbooks/site.yml \
  -e 'changedetection_domain=change-detection.example.com' \
  -e 'changedetection_password=xxx' \
  -e 'changedetection_notification_url=posts://discord.com/api/webhooks/ID/TOKEN?-format=text'
```

Access at `https://<changedetection_domain>`.

## Discord notifications

Configured automatically when `changedetection_notification_url` is provided. Uses a custom JSON embed template with added/removed diffs.

The notification URL **must** use `posts://` with `?-format=text` to prevent Apprise from appending query params that Discord rejects. Diff fields use `|tojson` to safely escape newlines and quotes in the JSON payload.

## Configurable variables

| Variable | Default | Description |
|---|---|---|
| `changedetection_password` | *(required)* | UI login password |
| `changedetection_domain` | *(required)* | Domain for Caddy reverse proxy |
| `changedetection_notification_url` | *(optional)* | Apprise notification URL (use `posts://...?-format=text` for Discord) |
| `service_user` | `hbauer` | User to own the service files |
| `changedetection_port` | `5000` | Internal port (Caddy proxies to this) |
| `changedetection_tz` | `UTC` | Timezone for scheduling |
| `changedetection_fetch_workers` | `10` | Parallel fetch workers |
| `changedetection_max_chrome` | `10` | Max concurrent Chrome processes |
| `changedetection_base_url` | *(optional)* | Public URL for notification links |
