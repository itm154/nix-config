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
│   │   │   ├── fish
│   │   │   ├── git
│   │   │   ├── lazygit
│   │   │   ├── neovim
│   │   │   ├── nixHelper
│   │   │   ├── starship
│   │   │   ├── yazi
│   │   │   └── zoxide
│   │   └── home
│   └── nixos
│       ├── desktop
│       │   ├── addons
│       │   │   └── sddm
│       │   └── plasma
│       ├── hardware
│       │   ├── audio
│       │   ├── batteryOptimization
│       │   ├── drawingTablet
│       │   └── nvidia
│       └── system
│           ├── flatpak
│           ├── fonts
│           ├── locales
│           └── noisetorch
├── packages
│   └── sddmRosePine
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
