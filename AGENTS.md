# AGENTS.md - Guidelines for Agentic Coding in safer

## Project Overview

**safer** is a POSIX shell script project that creates proxy scripts to run development tools inside container runtimes (podman/docker). The scripts mount project files at the same paths on the container, enabling tools like LSPs to report file locations correctly.

- **Language**: POSIX-compliant shell script (`#!/bin/sh`)
- **Main file**: `safer` (124 lines)
- **Documentation**: `safer.1` (man page), `README.md`, `web/` (GitHub Pages)

---

## Build, Lint, and Test Commands

### Building

This project does not require compilation. The `safer` script is directly executable.

```sh
# Verify POSIX compliance with shellcheck (recommended)
shellcheck -e SC1091 -e SC2016 -s sh safer
```

### Linting

The project should follow POSIX shell standards. Use `shellcheck` with POSIX mode:

```sh
# Install shellcheck (if not available)
# Debian/Ubuntu: apt install shellcheck
# macOS: brew install shellcheck

# Run shellcheck with POSIX dialect
shellcheck -e SC1091 -e SC2016 -s sh safer

# Treat warnings as errors (CI mode)
shellcheck -e SC1091 -e SC2016 -s sh -W error safer
```

### Testing

**Currently there is no formal test suite.**

This project will not have tests.

---

## Code Style Guidelines

### General Principles

1. **POSIX Compliance**: Write for `/bin/sh`, not bash-specific syntax
2. **Portability**: Use only POSIX-compliant features; test on multiple shells (sh, dash, bash)
3. **Simplicity**: Prefer simple, readable solutions over clever ones

### Imports and External Dependencies

- Use only POSIX utilities (`printf`, `command`, `test`, etc.)
- Avoid bashisms: no `[[ ]]`, no `$(())`, no process substitution `<()`, no arrays
- Detect external commands gracefully (e.g., podman vs docker detection in lines 81-85)

### Formatting

- Use tabs for indentation in generated scripts (see line 101-118)
- Use tabs for indentation for the main script
- Maximum line length: 72 characters (soft limit)
- Use backslash for line continuation (see lines 101-118)

### Types

- Shell scripts are untyped; use descriptive variable names with prefixes:
  - `safer_*` for internal variables
  - `SAFER_*` for environment variables
  - `script_*` for generated script content

### Naming Conventions

- Variables: lowercase with underscores (`safer_cmd`, `safer_image`)
- Functions: lowercase with underscores (if used)
- Constants: uppercase (`SAFER_DIR`, `SAFER_RT_CMD`) only for env vars
- Scripts generated: lowercase matching the command name

### Error Handling

- Rely on `set -e`
- Use `command -v` to check for command existence (line 81)
- Provide usage information if the arguments don't match the getopt spec

### Variable Quoting

- quote variable expansions unless they are constant: `"$var"`, not `$var`
- Quote command substitutions: `"$(pwd)"`, not `$(pwd)`
- Use double quotes for variable expansion, single quotes for literals

### Code Organization

The main script follows this structure:
1. **Section 1**: Initialization and argument parsing (lines 8-78)
2. **Section 2**: Script generation/writing (lines 92-123)

When extending, maintain this section-based organization.

### Commenting

- Use comments to mark sections (e.g., `# Section 1: Init safer and read args/env`)
- Avoid unnecessary comments; code should be self-documenting
- Use TODO comments for future work (see lines 3-6)

### Config Files

The script sources config files in this order (lines 33-35):
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

---

## Development Workflow

### Adding New Features

1. Follow the existing section-based code organization
2. Add environment variable support alongside CLI options
3. Update `safer.1` man page for new options
4. Update `README.md` if user-facing behavior changes

### Running Locally

```sh
# Test creating a script
./safer testy testy:latest

# Test the generated script content

```
#!/bin/sh
podman run --rm -i \
        -v <pwd>:<pwd> \
        -w <pwd> \
        testy:latest "$@"
```


# Test entering subshell with modified PATH
./safer
```

Don't leave testing artifacts around.

### CI/CD

- The project uses GitHub Actions (see `.github/workflows/`)
- Release workflow: automatically attaches `safer` and `safer.1` to releases
- Web workflow: deploys `web/` directory to GitHub Pages on master

---

## Common Patterns

### Option Parsing (see lines 57-66)

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

### Command Detection (see lines 80-86)

```sh
if [ -z "$safer_runtime_cmd" ]; then
    if command -v podman >/dev/null 2>&1; then
        safer_runtime_cmd=podman
    elif command -v docker >/dev/null 2>&1; then
        safer_runtime_cmd=docker
    fi
fi
```

### Generated Script Template (see lines 98-120)

When modifying the generated script format, maintain:
- `#!/bin/sh` shebang
- POSIX-compliant container runtime commands
- Proper quoting of all variables

---

## File Structure

```
.
├── safer          # Main script (executable)
├── safer.1        # Man page
├── README.md      # User documentation
├── web/           # GitHub Pages site
├── .github/
│   └── workflows/
│       ├── release.yml    # Release automation
│       └── web.yml        # Pages deployment
└── AGENTS.md      # This file
```

---

## Future Improvements (TODO)

- Opening ports from container to host
- Persistence of created scripts
- Auto-image detection from command name
- Safer-images if image not specified
- Formal test suite

When working on these, maintain POSIX compliance and the existing code style.
