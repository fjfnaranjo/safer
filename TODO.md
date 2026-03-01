# safer TODO

## Missing functionality

### Avoid replacing existing scripts

Self explanatory.

### CWD detection

- Detect when a safer script is being called from outside the project
  directory and refuse the invocation.
- When the script is called from under the project directory, modify
  the runtime working directory to use this directory instead of the
  base one.

## CI workflow

### Add testing

- Create a set of expected templates in `test/refs`.
- Create a target in a `Makefile` with a chain of commands to implement
  the tests:
    - Run _safer_ command with some parameters outputting to
      `test/outputs`.
    - Diff each command against is expected counterpart. Diff will
      output a non-zero status and fail the test.
- Explain testing strategy in `AGENTS.md`.

### Add shellcheck

- Create a target in a `Makefile` to run `shellcheck -s sh` over
  `safer`.

### Configure a GitHub Action

- Create a workflow `ci.yml` to launch the check and the tests on new
  pull requests.

## CD workflow

- Improve the `release.yml` workflow to pack a `.tar.gz` with the script
  and the man page with paths relative to `~/.local` and `/usr/local`.
- Remember to inject the version in `safer` using `sed`.
- Update install instructions and Homebrew formula after this changes.

## safer library

### Default commands by tool

To implement default set of arguments for existing tools, create shell
scripts in a `lib/commands` directory and call them with a new type of
command invocation:

```sh
safer -l [OPTIONS] <CMD> [DIR...]
```

This will exec the `lib/command/CMD.sh` script that contains another
safer command inside, like:

```sh
#!/bin/sh
safer opencode anomalyco/opencode "$@"
```

Document also the ability to exploit this logic to implement "variants"
for the library commands. So that `safer -l opencode-serve` invokes:

```sh
#!/bin/sh
safer -k -K "opencode serve" opencode anomalyco/opencode
```

Modify `safer` so that a plain `-k` argument will auto calculate the name
of the persistent containers and `-n` specifies the custom name.

Study further overrides that can carry from the original script
invocation to the library script. Like `-p`. Consider new environment
variables for this.

### Default image builders

In the library, under `lib/images`, include a list of `Containerfile`
files that can be copied to `.safer/build` with the next command:

```sh
safer -i <CMD>
```

Modify the scripts so that if they detect an image doesn't exists yet
but a file to build it exists in `.safer/build`, an output will be
generated suggesting the user how to build the image.

## Nice haves

### Shell completion

Shell completion for `-l`, `-i` and IMAGE should be trivial to implement.
