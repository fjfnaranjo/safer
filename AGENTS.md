# AGENTS.md - Guidelines for Agentic Coding in safer

## Project Overview

**safer** is a POSIX shell script project that creates proxy scripts to run development tools inside container runtimes (podman/docker). The scripts mounts project files at the same paths on the container, enabling tools like LSPs to report file locations correctly.

- **Language**: POSIX-compliant shell script.
- **Main file**: `safer`
- **Man page**: `safer.1`
- **Documentation**: `README.md`
- **Landing site**: single `web/index.html` file.
- **TODO items**: `TODO.md`

## Build, Lint, and Test Commands

### Building

This project does not require compilation. The `safer` script is directly executable.

### Linting

The project should follow POSIX shell standards. Use `shellcheck` with POSIX mode:

```sh
# Install shellcheck (if not available)
# Debian/Ubuntu: apt install shellcheck
# macOS: brew install shellcheck
# Alpine: apk add shellcheck

# Run shellcheck with POSIX dialect
make check
```

### Testing

Currently there is no formal test suite.

The project will implement tests in the future using a set of "expected" files in `test/refs`. Then, in a `Makefile`, a `test` target will ran a simple suite of `safer` invocations pointing it to `test/outputs` and running the `diff` command directly between each item ref and its output.

## Code Style Guidelines

### General Principles

1. **POSIX Compliance**: Write for `/bin/sh`, not bash-specific syntax
2. **Portability**: Use only POSIX-compliant features; test on multiple shells (sh, dash, bash, zsh). Avoid bashisms: no `[[ ]]`, no `$(())`, no process substitution `<()`, no arrays
3. **Simplicity**: Prefer simple, readable solutions over clever ones
4. **Non-dependant**: Use only POSIX utilities (`printf`, `command`, `test`, `sed`, etc.)

### Formatting

- Use tabs for indentation for the main script
- Use tabs for indentation in generated scripts
- Maximum line length: 72 characters (soft limit)
- Use backslash for line continuation

### Types

- Shell scripts are untyped; use descriptive variable names with prefixes:
  - `safer_*` for internal variables
  - `SAFER_*` for environment variables
  - `script_*` for generated script content

### Naming Conventions

- Variables: lowercase with underscores (`safer_cmd`, `safer_image`)
- Environment vars: uppercase (`SAFER_DIR`, `SAFER_RT_CMD`)
- Scripts generated: lowercase matching the command name _ and - if
present.

### Error Handling

- Rely on `set -e`
- Use `command -v` to check for command existence (line 81)
- Provide usage information if the arguments don't match the getopt spec

### Variable Quoting

- Quote variable expansions unless they are constant: `"$var"`, not `$var`
- Quote command substitutions: `"$(pwd)"`, not `$(pwd)`
- Use double quotes for variable expansion, single quotes for literals

### Code Organization

The main script follows this structure:
1. **Section 1**: Initialization and argument parsing
2. **Section 2**: Preprocessing of variables
2. **Section 3**: Script generation/writing

When extending, maintain this section-based organization.

### Commenting

- Use comments to mark sections (e.g., `# Section 1: Init safer and read args/env`)
- Avoid unnecessary comments; code should be self-documenting
- Use `TODO.md` content for documenting future work

### Config Files

The script sources config files in this order:
1. `/etc/safer` (system-wide)
2. `$HOME/.saferrc` (user-specific)
3. `.saferrc` (project-specific)

When modifying configuration handling, preserve this precedence order.

### Environment Variables vs CLI Options

Not all CLI options need environment variable support. Consider:

- **Runtime options** (`-R`, `-X`, `SAFER_RT_CMD`, `SAFER_RT_ARGS`): Suitable for env vars because the container runtime (podman/docker) is typically the same across all projects on a system.

- **Project+tool-specific options** (`-e`, `-p`): Typically should NOT have env vars because they are project+tool-specific (entrypoints, ports) and rarely used globally.

- **Project-specify, but not tool specific**: It makes sense they have
and env var because the `.saferrc` exists for this reason.

When adding a new option, consider whether it makes sense as an environment variable. If it's project+tool-specific, omit the env var.

## Development Workflow

### Adding New Features

1. Follow the existing section-based code organization
2. Add environment variable support alongside CLI options
3. Update `safer.1` man page for new options
4. Update `README.md` if the user-facing behavior described there changes
5. Update `web/index.html` if the user-facing behavior described there changes
6. Remove the `TODO.md` info associated with the feature if it exists.

### Running Locally

```sh
# Test creating a script
./safer testy testy:latest

# Test the generated script content

#!/bin/sh
podman run --rm -i \
        -v <pwd>:<pwd> \
        -w <pwd> \
        testy:latest "$@"
```

Don't leave testing artifacts around, but respect existing contents in
`.safer/` because they may be in use by the safer developers themselves.

### CI/CD

- The project uses GitHub Actions (see `.github/workflows/`)
- Release workflow: automatically attaches `safer` and `safer.1` to releases
- Web workflow: deploys `web/` directory to GitHub Pages on master

## Common Patterns

### Option Parsing

```sh
while getopts vhe:d:R:X: opt
do
    case $opt in
        e) safer_entrypoint=$OPTARG ;;
        d) safer_dir=$OPTARG ;;
        R) safer_runtime_cmd=$OPTARG ;;
        X) safer_runtime_args=$OPTARG ;;
        *) ;;
    esac
done
```

### Runtime Detection

```sh
if [ -z "$safer_runtime_cmd" ]; then
    if command -v podman >/dev/null 2>&1; then
        safer_runtime_cmd=podman
    elif command -v docker >/dev/null 2>&1; then
        safer_runtime_cmd=docker
    fi
fi
```

### Generated Script structure

When modifying the generated script format, maintain:
- `#!/bin/sh` shebang
- POSIX-compliant container runtime commands
- Proper quoting of all variables

Take into account how the generation of plain vs persistent scripts is mixed all together. Persistent scripts interlace, with tabs in front of the plain command if they are present, so that that generation is used as part of the `run` command for both the plain and the persistent version, and a new `exec` command is added below only for the persistent version. Is dirty, but simple and covered by the tests.

## File Structure

```
.
├── safer            # Main script (executable)
├── safer.1          # Man page
├── README.md        # User documentation
├── TODO.md          # TODO list
├── RELEASE          # Notes on the manual steps of a new release
├── web/index.html   # GitHub Pages single-page landing site
├── .github/
│   └── workflows/
│       ├── release.yml    # Release automation
│       └── web.yml        # Pages deployment
└── AGENTS.md      # This file
```
