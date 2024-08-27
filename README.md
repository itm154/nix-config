# My NixOS config made using [snowfall-lib](https://snowfall.org/guides/lib/quickstart/)


### Directory structure
<details>
<summary><code>tree | grep -v 'default.nix'</code></summary>
<pre>
<code>
├── flake.lock
├── flake.nix
├── homes
│   └── x86_64-linux
│       └── itm154@wsl
├── lib
│   └── module
├── modules
│   ├── home
│   │   ├── apps
│   │   │   └── kitty
│   │   ├── cli
│   │   │   ├── bat
│   │   │   ├── btop
│   │   │   ├── cava
│   │   │   ├── fish
│   │   │   ├── git
│   │   │   ├── lazygit
│   │   │   ├── neovim
│   │   │   ├── starship
│   │   │   ├── yazi
│   │   │   └── zoxide
│   │   ├── home
│   │   └── user
│   └── nixos
│       ├── cli
│       │   └── nixHelper
│       ├── desktop
│       │   ├── addons
│       │   │   ├── gdm
│       │   │   ├── sddm
│       │   │   └── xdgPortal
│       │   └── plasma
│       ├── hardware
│       │   ├── audio
│       │   ├── batteryOptimization
│       │   ├── bluetooth
│       │   ├── drawingTablet
│       │   ├── networking
│       │   └── nvidia
│       ├── home
│       ├── services
│       │   ├── ime
│       │   ├── podman
│       │   └── powerButton
│       ├── system
│       │   ├── boot
│       │   ├── flatpak
│       │   ├── fonts
│       │   ├── libinput
│       │   ├── locales
│       │   ├── noisetorch
│       │   ├── security
│       │   │   ├── doas
│       │   │   └── sudo
│       │   └── xkb
│       ├── user
│       └── virtualization
│           └── kvm
├── packages
│   └── sddm-rose-pine
├── README.md
├── systems
│   └── x86_64-linux
│       └── wsl
└── templates
    ├── lib
    ├── module
    ├── overlay
    └── system
</code>
</pre>
</details>
