# Privacy

## Send only these three fields

```json
{"v":1,"used":41.2,"resets_at":1738857600,"ts":1738600000}
```

The scripts in this repository do that and nothing else.

## Do not send the status line input as it is

The status line receives a large JSON document. Besides `rate_limits`, it can contain:

- folders: `cwd`, `workspace.current_dir`, `workspace.project_dir`, `workspace.added_dirs` (often include your operating system user name)
- repository and pull request details: `workspace.repo.host/owner/name`, `pr.number`, `pr.url`, `worktree.*`
- ids and paths: `session_id`, `prompt_id`, `transcript_path`
- cost, model, version and agent names

Repository, folder and pull request names can reveal an employer or a customer. Use an allow list (pick fields), never a block list.

## Delivery path secrets

- Treat the ntfy topic, the Tailscale address and the gist id like passwords. Do not put them in screenshots, issues, pull requests or public repositories.
- ntfy's public server keeps topic names and IP addresses in logs and caches messages for about 12 hours. Two numbers are low risk, but use a random topic of 32 or more characters. See https://docs.ntfy.sh/publish/ and https://docs.ntfy.sh/faq/
- Secret gists are not private: anyone with the link can read them. See https://docs.github.com/en/get-started/writing-on-github/editing-and-sharing-content-with-gists/creating-gists

## Work computers

Do not run this on a computer or in a repository that belongs to your employer. Managed settings can block it, and outgoing requests may be logged.

## Claude Code settings that stop it

The status line does not run if the workspace is not trusted, if hooks are disabled (`disableAllHooks`), or if only managed hooks are allowed.
