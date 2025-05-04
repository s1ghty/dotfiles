#!/bin/bash

# === CONFIG ===
DOTFILES_DIR="$HOME/dotfiles"
WALLPAPER_NAME="wallpaper.jpg"
REPO_SSH="git@github.com:s1ghty/dotfiles.git"

# === 1. Clone dotfiles ===
echo "[1] Cloning dotfiles..."
git clone "$REPO_SSH" "$DOTFILES_DIR" || {
    echo "Failed to clone dotfiles. Exiting."
    exit 1
}

# === 2. Symlink configs ===
echo "[2] Symlinking configs..."

mkdir -p ~/.config

ln -sf "$DOTFILES_DIR/Thunar" ~/.config/Thunar
ln -sf "$DOTFILES_DIR/alacritty" ~/.config/alacritty
ln -sf "$DOTFILES_DIR/gtk-3.0" ~/.config/gtk-3.0
ln -sf "$DOTFILES_DIR/gtk-4.0" ~/.config/gtk-4.0
ln -sf "$DOTFILES_DIR/hypr" ~/.config/hypr
ln -sf "$DOTFILES_DIR/mako" ~/.config/mako
ln -sf "$DOTFILES_DIR/neofetch" ~/.config/neofetch
ln -sf "$DOTFILES_DIR/nwg-look" ~/.config/nwg-look
ln -sf "$DOTFILES_DIR/rofi" ~/.config/rofi
ln -sf "$DOTFILES_DIR/waybar" ~/.config/waybar
ln -sf "$DOTFILES_DIR/wofi" ~/.config/wofi
# Add more as needed...

# === 3. Copy wallpaper ===
echo "[3] Copying wallpaper..."
mkdir -p ~/Pictures/wallpapers
cp "$DOTFILES_DIR/$WALLPAPER_NAME" ~/Pictures/wallpapers/

# === 4. (Optional) Install packages ===
echo "[4] Installing packages (optional)..."
read -p "Install packages using pacman and yay? [y/N] " answer
if [[ "$answer" =~ ^[Yy]$ ]]; then
    sudo pacman -S --needed \
  git alacritty hyprland mako neofetch \
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

# === 5. Done ===
echo "✅ Setup complete. You may want to restart Hyprland to apply changes."

