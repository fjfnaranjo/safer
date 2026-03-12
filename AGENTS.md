# AGENTS.md - Guidelines for Agentic Coding in safer

## Project Overview

**safer** is a POSIX shell script project that creates proxy scripts to run development tools inside container runtimes (podman/docker). The scripts mounts project files at the same paths on the container, enabling tools like LSPs to report file locations correctly.

It can also generate the PATH variable definition to inject the directory for the scripts.

Also, it can install Containerfiles from an internal library under the `build` directory in the scripts dir and suggest the podman/docker command to build it.

Finally, it can run predefined invocations of itself, present in the internal library, with the common options used for specific tools.

- **Language**: POSIX-compliant shell script.
- **Main file**: `safer`
- **Man page**: `share/man/safer.1`
- **Documentation**: `README.md`
- **Landing site**: single `web/index.html` file.
- **TODO items**: `TODO.md`

## Usage

- The script generator: Its base functionality. Described above.

```safer [OPTIONS] <CMD> <IMAGE> [DIR...]```

- Library invocation: Uses a program invocation stored in the library.

```safer [-d SAFER_DIR]```

- Library install: Installs a copy of a Containerfile from the library.

```safer -l TOOL [DIR...]```

- PATH generation: Prints a definition of PATH to add the safer dir.

```safer -i TOOL```

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

```sh
# Run the test suite
make test-verbose
```

The project implements tests using a set of "expected" files in `tests/refs`. Then, in a `Makefile`, a `test-verbose` target runs a simple suite of `safer` invocations pointing it to `tests/outputs` and, for most cases, running the `diff` command directly between each item ref and its output. In other cases, the status code or the program output is checked.

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

### Error Handling

- Rely on `set -e`
- Use `command -v` to check for command existence
- Provide usage information if the arguments don't match the getopt spec

### Variable Quoting

- Quote variable expansions unless they are constant: `"$var"`, not `$var`
- Quote command substitutions: `"$(pwd)"`, not `$(pwd)`
- Use double quotes for variable expansion, single quotes for literals

### Code Organization

When extending, maintain the section-based organization comments.

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
3. Update `share/man/safer.1` man page for new options
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
- Release workflow: automatically attaches a `tar.gz` created with the Makefile
- Web workflow: deploys `web/` directory to GitHub Pages on master
- CI workflow: Runs `check` and `test-verbose` targets.

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
├── README.md        # User documentation
├── TODO.md          # TODO list
├── RELEASE          # Notes on the manual steps of a new release
├── share/
│   ├── man/safer.1  # Man page
│   ├── completion/* # Bash and ZSH completion scripts
│   ├── tools/*      # List of files with safer invocations (tools lib)
│   └── images/*     # Containerfiles library (image lib)
├── web/index.html   # GitHub Pages single-page landing site
├── .github/
│   └── workflows/
│       ├── release.yml    # Release automation
│       ├── web.yml        # Pages deployment
│       └── ci.yml         # CI testing
└── AGENTS.md      # This file
```
