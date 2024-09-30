### Embedded AUR Package
 AUR build package for embedded developer

#### Repository Installation
Add the following code snippet to your /etc/pacman.conf:

```bash
[embedded-aur]
SigLevel = Optional
Server = https://github.com/vanbwodonk/embedded-aur-pkg/releases/latest/download
```

Then, run `sudo pacman -Sy` to update repository.
