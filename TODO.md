# safer TODO

## safer library

### Library items overrides

Study further overrides that can carry from the original script
invocation to the library script. Like `-p`. Consider new environment
variables for this.

### Default image builders

Modify the scripts so that if they detect an image doesn't exists yet
but a file to build it exists in `.safer/images`, an output will be
generated suggesting the user how to build the image.

## Nice to have

### Shell completion

Shell completion for `-l`, `-i` and IMAGE should be trivial to implement.
