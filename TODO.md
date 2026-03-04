# safer TODO

## General

### -d for plain safer invocation

Calling just `safer` to enter the sub-shell should support the `-d`
argument.

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

## Nice to have

### Shell completion

Shell completion for `-l`, `-i` and IMAGE should be trivial to implement.
