#!/bin/bash
set -ouex pipefail

# Choose: stable or git
VARIANT=stable   # change to "git" if you want hyprland-git + plugins-git + waybar-git, eww-git, etc.

# Enable COPR
dnf5 -y copr enable solopasha/hyprland

if [[ "$VARIANT" == "git" ]]; then
  HYPR_PKGS=(
    hyprland-git
    hyprland-plugins-git
    waybar-git
    eww-git
  )
else
  HYPR_PKGS=(
    hyprland
    hyprland-plugins
    waybar            # use Fedora’s stable waybar; change to waybar-git if you prefer
    eww               # or eww-git if you want bleeding edge
  )
fi

# Common packages you listed (from that COPR when available; otherwise Fedora/RPM Fusion)
COMMON_PKGS=(
  xdg-desktop-portal-hyprland
  hyprland-contrib
  hyprpaper
  hyprpicker
  hypridle
  hyprlock
  hyprsunset
  hyprpolkitagent
  hyprsysteminfo
  hyprland-autoname-workspaces
  hyprshot
  satty
  aylurs-gtk-shell
  aylurs-gtk-shell2
  hyprpanel
  cliphist
  nwg-clipman
  swww
  waypaper
  hyprnome
  hyprdim
  swaylock-effects
  pyprland
  mpvpaper
  uwsm
  qt6ct-kde
)

# Install everything
dnf5 install -y "${HYPR_PKGS[@]}" "${COMMON_PKGS[@]}"

# Keep SDDM, but default to Hyprland
install -d /etc/sddm.conf.d
cat > /etc/sddm.conf.d/10-hyprland.conf <<'EOF'
[General]
Session=hyprland.desktop

[Wayland]
EnableWayland=true
CompositorCommand=
EOF

systemctl enable podman.socket || true
# If you really want to avoid shipping the COPR enabled in the final image, uncomment:
# dnf5 -y copr disable solopasha/hyprland || true
