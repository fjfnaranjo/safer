# safer TODO

- Avoid stdout/stderr corruption when running persistent containers:
  - `(container-name) sleep inf >/dev/null 2>&1`
- Environment variables (`-e` as Docker/Podman `--env`).
- Allow multiple values for `-p` and `-e`.
- Implement a criteria for the image library.
  - Rolling release strategy.
  - Templates for language specific distribution tools and other
    universal installers (like mise-en-place).
