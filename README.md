# safer
> Protect your dev box from supply-chain attacks with **safer**.

⚠️ WIP: This project is currently under its initial development phase.
## What is safer?
**safer** creates scripts to run dev tools using container runtimes.

The scripts will mount the project files (and other, if needed) in the
same paths as the host to allow coherent feedback when this tools report
file paths. Running them like this isolates the rest of the developer
system.

The host dev tools (Neovim, diagnostics, AI agents...) will be able to
auto-detect this scripts as the actual tools and will understand the
output as if it was happening outside the container. This is
particularly useful for LSPs.

Using this technique, you get:

- **Host files isolation**: anything but the project files you
explicitly share will be isolated by the container runtime.
- **Reproducible tool chains**: using safer, each project can use an
exact version of the tools with independence of the developer system or
their platforms.
- **Cleaner developer systems**: separation of general host software and
project specific dev tools.

The commands are created in the `.safer` directory. You can add this
directory to your PATH or you can run `safer` without any option to run
a sub-shell with a modified PATH.
## Installing safer
### Linux
Download safer:

```
cd /tmp
curl -Lo safer https://github.com/fjfnaranjo/safer/releases/download/release-0.1-rc1/safer
curl -Lo safer.1 https://github.com/fjfnaranjo/safer/releases/download/release-0.1-rc1/safer.1
```

Install the files for your user (if you have `~/.local/bin` in your **PATH**):

```
install -Dm755 safer ~/.local/bin/safer
install -Dm644 safer.1 ~/.local/share/man/man1/safer.1
```

Or install them in the system:

```
sudo install -Dm755 safer /usr/local/bin/safer
sudo install -Dm644 safer.1 /usr/local/share/man/man1/safer.1
```
### MacOS
Use Homebrew:

```
brew tap fjfnaranjo/safer
brew install safer
```
