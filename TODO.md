# safer TODO

- Remove tools (not images) completely.
- Allow the definition of environment variables.
- Allow to specify what environment variables should be passed from the
  shim environment to the tool in the container.
- Implement a criteria for the image library.
  - Rolling release strategy.
  - Templates for language specific distribution tools and other
    universal installers (like mise-en-place).
- Add an option to build the images from the library.
- Write a better explanation for the -t -i podman/docker flag controls.
  - None: Don't apply, generally, to dev tools.
  - Just -t: Doesn't make much sense also.
  - Just -it: Tools used interactively. This is the default.
  - Just -i: Tools used by stdin by another process. This is -s.
