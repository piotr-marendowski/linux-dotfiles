# dotfiles

## Screenshots
![desktop](/assets/screen1.png)
<img src="/assets/whiptail1.png"  width="60%">
<img src="/assets/whiptail2.png"  width="60%">

## History
After accidentally breaking my machine, I decided to move to Arch Linux full time.
Then it converted into a hassle with configuring it all over again, so now I created
an install script to do everything for me.

## Installation
Installation only requires git to clone this repository and rename it do `.dotfiles`.
```
git clone https://github.com/piotr-marendowski/dotfiles.git
mv dotfiles .dotfiles
.dotfiles/whiptail-script.sh
```
Note that the bash script (script.sh) is discontinued in favor of the whiptail version,
for now it will stay in repo as a reference.

## Used programs/packages
- [Nvidia drivers](https://www.nvidia.com/en-us/drivers/unix/)
- [Paru (AUR helper)](https://github.com/Morganamilo/paru)
- [Xorg Window System](https://wiki.archlinux.org/title/Xorg)
- [Xorg-Xinit](https://wiki.archlinux.org/title/Xinit)
- [Qtile (window Manager)](http://www.qtile.org/)
- [Ly (session manager)](https://github.com/fairyglade/ly)
- [Alacritty (terminal emulator)](https://alacritty.org/)
- [Rofi (program launcher)](https://github.com/davatorium/rofi)
- [Dunst (notifications)](https://dunst-project.org/)
- [Htop (system monitor)](https://htop.dev/)
- [Flameshot (screenshots)](https://flameshot.org/)
- [Pulseaudio (sound)](https://www.freedesktop.org/wiki/Software/PulseAudio/)
- [or Pipewire (sound)](https://pipewire.org)
- [Neovim (IDE)](https://neovim.io/)
