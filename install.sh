#!/bin/bash
# config
DOTFILES_DIR="$HOME/dotfiles"
WALLPAPER_NAME="wallpaper.jpg"
REPO_SSH="git@github.com:s1ghty/dotfiles.git"

# cloning dotfiles (if they're not already xD)
echo "[1] Cloning dotfiles..."
if [ -d "$DOTFILES_DIR/.git" ]; then
    echo "Dotfiles already cloned. Skipping."
else
    git clone "$REPO_SSH" "$DOTFILES_DIR" || {
        echo "Failed to clone dotfiles. Exiting."
        exit 1
    }
fi

# symlinking
echo "[2] Symlinking configs..."

mkdir -p ~/.config
CONFIG_DIR="$DOTFILES_DIR/.config"

for dir in "$CONFIG_DIR"/*; do
    name=$(basename "$dir")
    ln -sf "$dir" "$HOME/.config/$name"
done

# wallpapers
echo "[3] Copying wallpaper..."
mkdir -p ~/Pictures
cp "$DOTFILES_DIR/$WALLPAPER_NAME" ~/Pictures/

# packages
echo "[4] Installing packages (optional)..."
read -p "Install packages using pacman and yay? [y/N] " answer
if [[ "$answer" =~ ^[Yy]$ ]]; then
    sudo pacman -S --needed \
  git alacritty hyprland mako neofetch hyprpaper \
  waybar wofi brightnessctl pipewire pipewire-pulse \
  ttf-jetbrains-mono-nerd wireplumber nwg-look \
  imagemagick chafa cmake meson cpio pkgconfig

    if ! command -v yay >/dev/null; then
        echo "Installing yay..."
        git clone https://aur.archlinux.org/yay.git
        cd yay
        makepkg -si
        cd ..
    fi

    yay -S rofi-lbonn-wayland-git papirus-folders-git
fi


echo "✅ Setup complete. You may want to restart Hyprland to apply changes."
