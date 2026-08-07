# safer TODO

- Extend the behavior of the -s argument by implementing a new -t
  argument to allow better control.
  - Allow forcing the usage of both, none or one or another.
  - By default pass the stdin but detect if the shell is a tty (with
    test -t 1) to decide on pseudo-tty allocation.
- Allow the definition of environment variables.
- Allow to specify what environment variables should be passed from the
  shim environment to the tool in the container.
- Implement a criteria for the image library.
  - Rolling release strategy.
  - Templates for language specific distribution tools and other
    universal installers (like mise-en-place).
- Write a better explanation for the -t -i podman/docker flag controls.
  - None: Don't apply, generally, to dev tools.
  - Just -t: Doesn't make much sense also.
  - Just -it: Tools used interactively. This is the default.
  - Just -i: Tools used by stdin by another process. This is -s.
