# My NixOS config made using [snowfall-lib](https://snowfall.org/guides/lib/quickstart/)


### Directory structure
<details>
<summary><code>tree | grep -v 'default.nix'</code></summary>
<pre>
<code>
.
├── flake.lock
├── flake.nix
├── homes
│   └── x86_64-linux
│       ├── itm154
│       ├── itm154@vm
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
│   │   ├── theme
│   │   └── user
│   └── nixos
│       ├── cli
│       │   └── nixHelper
│       ├── desktop
│       │   ├── addons
│       │   │   ├── cursor
│       │   │   ├── gdm
│       │   │   ├── gtk
│       │   │   ├── qt
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
│       │   ├── secureBoot
│       │   ├── security
│       │   │   ├── doas
│       │   │   └── sudo
│       │   └── xkb
│       ├── user
│       └── virtualization
│           └── kvm
├── packages
│   ├── acer-module
│   ├── acer-wmi-battery
│   └── sddm-rose-pine
├── README.md
├── systems
│   └── x86_64-linux
│       ├── helios
│       ├── vm
│       └── wsl
└── templates
    ├── lib
    ├── module
    ├── overlay
    └── system
</code>
</pre>
</details>
