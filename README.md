# safer
> WIP: This project is currently under its initial development phase.

`safer` is a command to create scripts to run dev tools using container
runtimes. Running them like this isolates the rest of the developer
system. The script mounts the project files (and other, if needed) in
the same paths as the host to allow coherent feedback when this tools
report file paths.

The commands are created in the `.safer` directory. You can add this
directory to your PATH or you can run `safer` without any option to run
a sub-shell with a modified PATH.
