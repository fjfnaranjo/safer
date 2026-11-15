# Contributing

The `safer` script is directly executable; no build chain in required.

## Invocation examples

```sh
safer [OPTIONS] <CMD> <IMAGE> [DIR...]   # Generates a proxy script
safer [-d SAFER_DIR]                     # Prints a PATH definition
safer -i TOOL                            # Installs a Containerfile
```

## Useful Make targets

```sh
make check                 # shellcheck in POSIX mode
make test-verbose          # Full test suite (uses a container runtime)
make test-non-rt-verbose   # Partial suite (no container runtime)
```

## GitHub actions

- `ci.yml` runs `check` and `test` Make targets.
- `release.yml` packs **safer** and attaches it to a release.
- `web.yml` deploys `web/` to GitHub Pages on changes.

## Code style

- Write POSIX `sh`, not bash. No `[[ ]]`, `$(())`, process substitution,
  or arrays. Test with sh, dash, bash, and zsh.
- Use only POSIX utilities (e.g. `sed`); avoid unnecessary dependencies.
- Prefer simple, readable code over clever code.
- Indent with tabs (including in generated scripts).
- Keep lines under ~72 characters; use backslash for continuations.
- Rely on `set -e`. Check commands with `command -v`. Print usage when
  arguments do not match the getopt spec.
- Quote expansions unless constant: `"$var"`, `"$(pwd)"`. Use double
  quotes for expansion and single quotes for literals.

## Other criteria

### Environment variables vs CLI options

Only add an environment variable when the option makes sense
system-wide.

- Runtime options (`-R`, `-X`, `SAFER_RT_CMD`, `SAFER_RT_ARGS`) should
  have env vars: the runtime is usually the same across projects.
- Project+tool-specific options (`-e`, `-p`) should not have env vars:
  entrypoints and ports rarely apply globally.
- Project-specific (but not tool-specific) options may have env vars;
  that is what `.saferrc` is for.

## Adding features to the main script

1. Follow the guidelines.
2. Add tests.
3. Consider environment variable support (see above).
4. Update `share/man/safer.1`.
5. Update `README.md` and `web/index.html` if user-facing behavior changes.
6. Update the shell completion scripts if needed.
7. Remove the related item from `TODO.md` if present.

## Adding Containerfiles to the library

Try to strike a good balance between small image size and tool
functionality coverage. Most of the time either "Alpine + tool" or
"Alpine + language tool-chain + tool" should suffice. Check for existing
Containerfiles.
