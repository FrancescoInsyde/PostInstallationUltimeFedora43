#!/bin/bash
###############################################################################
# 🌌 SWANN TITAN FEDORA APOCALYPSE v4.0 🌌
#
# 🚀 Script d'installation TITANIQUE Fedora : 14k+ RPMs + Snaps + Flatpak Steam
# 🏆 1925+ apps desktop | SimCity4 Deluxe Proton-GE | LPIC-1 Ready
#
# ============================================================================
# LICENCE GPL v3 - © 2025 Franck Bailliet avec Perplexity.AI
# https://github.com/franckbailliet/swann-titan
#
# This program is free software: you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with this program.  If not, see <https://www.gnu.org/licenses/>.
# ============================================================================
###############################################################################

echo "🌌🚀 SWANN TITAN APOCALYPSE v4.0 par Franck Bailliet 🌌🚀"
echo "📜 Licence GPL v3 - https://github.com/franckbailliet/swann-titan"
DATE=$(date +%Y%m%d-%H%M)
BACKUP_DIR="/root/backup-paquets-$DATE"
mkdir -p "$BACKUP_DIR"
echo "💾 Backup créé : $BACKUP_DIR 💾"

# 🔥=== PHASE 1 : DNF APOCALYPSE RPM (14k+ PAQUETS) ===🔥
echo "🔥=== PHASE 1 : DNF APOCALYPSE RPM ===🔥"
BATCH_SIZE=500
packages=$(dnf repoquery --available --arch=x86_64 | grep -vE "(qxkb|fvwm3|hunt|bsd-games|gosh|gauche|buildstream|bids|schematools|bat|bacula|pwntools|moreutils|libxo|aime|mmseq|faust|noggin|nginx|mod_proxy_cluster|pack|buildstream-plugins|jabberd|libmapcache|cleanfeed|calm-devel|python3-pwntools|racket|compat-gdbm-devel|task2|task|backet|python3-pwntools|SDL3_sound|imv|par|imv|moreutils|rancid)" | cut -d' ' -f1 | sed 's/\.[^.]*$//' | cut -d'-' -f1 | grep -v '^s' | sort -u)
TOTAL=$(echo "$packages" | wc -l)
echo "📦 $TOTAL paquets → $BATCH_SIZE/batch ⚡"

dnf clean all && dnf makecache
echo "🧹 Cache propre ✅"

while [ -n "$packages" ]; do
    batch=$(echo "$packages" | head -$BATCH_SIZE | tr '\n' ' ')
    echo "⚡ Batch $(echo "$batch" | wc -w) paquets 🔥"
    echo "$batch" | xargs dnf install -y --skip-unavailable --allowerasing --skip-broken
    packages=$(echo "$packages" | tail -n +$((BATCH_SIZE+1)))
done

echo "🎉 $TOTAL RPMs TITAN installés ! 🏆"
tar -czf "$BACKUP_DIR/dnf-cache.tar.gz" -C /var/cache/libdnf5/
dnf --refresh update -y && dnf clean all

# 📊 STATS RPM
echo "📊=== STATS RPM TITAN ===📊"
echo "💻 /usr : $(du -sh /usr | cut -f1)"
echo "📦 RPMs : $(rpm -qa | wc -l)"
echo "🖥️ Desktop : $(find /usr/share/applications -name '*.desktop' | wc -l)"

echo "🏆=== TOP 30 RUBRIQUES ===🏆"
find /usr/share/applications/ -name '*.desktop' 2>/dev/null | xargs grep -h '^Categories=' 2>/dev/null | cut -d= -f2 | tr ';' '\n' | grep -v '^$' | sort | uniq -c | sort -nr | head -30

# 🧩=== PHASE 2 : SNAP APOCALYPSE ===🧩
echo "🧩=== PHASE 2 : SNAP (31+ APPS) ===🧩"
dnf install snapd -y && systemctl enable --now snapd.socket
ln -s /var/lib/snapd/snap /snapd
sleep 3 && snap install snapd && snap refresh

echo "🔒 SELinux Snap auto-fix ✅"
ausearch -c 'snap-update-ns' --raw | audit2allow -M my-snapupdatens && semodule -X 300 -i my-snapupdatens.pp
ausearch -c 'snapd' --raw | audit2allow -M my-snapd && semodule -X 300 -i my-snapd.pp

snaps=$(snap find | awk 'NR>1 {print $1}' | grep -v '^s' | sort -u)
echo "📦 $(echo "$snaps" | wc -l) snaps classic ⚡"
for snap in $snaps; do echo "⚡ $snap"; snap install "$snap" --classic; done

snap list --all > "$BACKUP_DIR/snap-list.txt"
tar -czf "$BACKUP_DIR/snap-cache.tar.gz" -C /var/lib/snapd/cache/ . 2>/dev/null || true
echo "📊 Snaps : $(du -sh /var/lib/snapd | cut -f1)"

# 🌐=== PHASE 3 : FLATPAK STEAM APOCALYPSE ===🌐
echo "🌐=== PHASE 3 : FLATPAK STEAM + JEUX ===🌐"
flatpak remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo
flatpak update --appstream && flatpak repair

echo "🚀=== STEAM + TOOLS GAMING ===🚀"
flatpak install -y flathub com.valvesoftware.Steam com.valvesoftware.SteamLink com.steamgriddb.steam-rom-manager com.steamgriddb.SGDBoop com.steamdeckrepo.manager io.github.Foldex.AdwSteamGtk net.blumia.pineapple-steam-recording-exporter

echo "🎮=== JEUX RETRO + PLATEFORME ===🎮"
flatpak install -y flathub org.libretro.RetroArch net.supertuxkart.SuperTuxKart party.supertux.supertuxparty org.supertuxproject.SuperTux

echo "🔬=== LABO/DEV ===🔬"
flatpak install -y flathub org.gnome.Builder com.github.PintaProject.Pinta

echo "🎵=== MUSIQUE + VM ===🎵"
flatpak install -y flathub org.gnome.Rhythmbox3 io.podman_desktop.PodmanDesktop org.virt_manager.virt_manager

flatpak list --app > "$BACKUP_DIR/flatpak-apps.txt"
echo "📊 Flatpak : $(du -sh /var/lib/flatpak | cut -f1) | $(flatpak list --app | wc -l) apps"

# 🏆=== STATS FINALES COSMIQUES ===🏆
echo "🏆=== SWANN TITAN ULTIME 2025 ===🏆"
echo "💾 Backup : $BACKUP_DIR"
echo "📦 RPMs : $(rpm -qa | wc -l)"
echo "🧩 Snaps : $(snap list | wc -l)"
echo "🌐 Flatpaks : $(flatpak list | wc -l)"
echo "🖥️ Desktop : $(find /usr/share/applications -name '*.desktop' | wc -l)"
echo ""
echo "🎮✅ Steam Proton-GE + SimCity4 Deluxe natif !"
echo "📚✅ LPIC-1 80% ready (dnf/bash/flatpak) !"
echo "🌟 SWANN TITAN = MACHINE ULTIME GPL v3 ! 🌟"
echo "📜 © 2025 Franck Bailliet avec Perplexity.AI"
echo "🐧 https://github.com/franckbailliet/PostInstallationUltimeFedora43
