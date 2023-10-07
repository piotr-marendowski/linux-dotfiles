# dotfiles

![desktop](assets/screen1.png)

![desktop](assets/screen2.png)

![desktop](assets/screen3.png)

<img src="assets/whiptail1.png"  width="60%">

## Configuration for preinstalled machines

```
git clone -b dwm https://github.com/piotr-marendowski/dotfiles.git
./dotfiles/install.sh
```

## Troubleshooting

If installation of paru will be stuck on <code>Arming ConditionNeedsUpdate</code> then reboot the system and start installation again.

## About this workflow

Mainly following the KISS principle my workflow consists of this three main pillars:

- Web browser - With vim keybindings and panorama tabs gives me the clear view of project's research, is fast and also secure.
- IDE - Neovim is my only IDE on this machine, is feature packed and incredibly fast.
- Terminal - With the help of a few keybindings, is simple and versatile.

Everything is driven by keybindings, I try not to overdose on them and keep their number as low as possible. My use of tags:

- Tag 1: Web browser and IDE
- Tag 2: Discord and other multimedia
- Tag 3: Games/more programs
- Tag 4: Additional space

### Tree
<pre>
├── .config
│   ├── dmenu
│   ├── dwm
│   ├── MangoHud
│   ├── nvim
│   │   ├── README and init.lua
│   │   └── lua
│   │       ├── plugins
│   │       └── options
│   ├── scripts
│   └── st
├── .gitconfig
├── .xprofile - startup apps
└── .zshrc
</pre>

## Used programs/packages

- [xorg](https://wiki.archlinux.org/title/Xorg)
- [xorg-xinit](https://wiki.archlinux.org/title/Xinit)
- [dwm](https://dwm.suckless.org/)
- [zsh](https://zsh.sourceforge.io/)
- [st](https://st.suckless.org/)
- [ly](https://github.com/fairyglade/ly)
- [paru](https://github.com/Morganamilo/paru)
- [nvidia drivers](https://www.nvidia.com/en-us/drivers/unix/)
- [dmenu](https://tools.suckless.org/dmenu/)
- [pipewire](https://pipewire.org)
- [neovim](https://neovim.io/)
- [librewolf](https://librewolf.net/)
- [nnn](https://github.com/jarun/nnn/tree/master)
- [maim](https://github.com/naelstrof/maim)

### This branch is updated and focused on integration with the [IvoryOS](https://github.com/piotr-marendowski/ivoryos), while the [qtile branch](https://github.com/piotr-marendowski/dotfiles) is more customizable and good-looking version.
