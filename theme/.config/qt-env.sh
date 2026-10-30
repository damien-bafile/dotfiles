# Qt5 + Qt6 dark theme - sourced from ~/.zprofile (session) and ~/.zshrc (terminals)

# Qt6: use the qt6ct platform theme. It applies ~/.config/qt6ct/qt6ct.conf
# (style=kvantum, palette=darker.conf) to every Qt6 app.
export QT_QPA_PLATFORMTHEME=qt6ct

# Qt5: no qt5ct plugin is installed, so Qt5 apps would fall back to Fusion
# with the GTK palette. This forces the Kvantum style (KvArcDark) for them
# too. Side effect: the qt6ct tool shows a cosmetic "not configured
# correctly" banner, because it sees an external style override.
export QT_STYLE_OVERRIDE=kvantum

# NOTE: /etc/profile.d/qt6ct.sh (shipped by Void's qt6ct package) exports
# QT_QPA_PLATFORM=wayland on Wayland sessions. That is fine for Qt6 (the
# qt6-wayland plugin is installed) but BREAKS Qt5 apps - this Qt5 build has
# no Wayland QPA plugin. Install qt5-wayland to fix it:
#     sudo xbps-install -S qt5-wayland
# Until then, run Qt5 apps with: QT_QPA_PLATFORM=xcb <app>
