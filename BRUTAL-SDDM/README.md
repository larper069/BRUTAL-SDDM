# AUXIS SDDM theme (Qt 6 / QML)

A first-pass native SDDM greeter theme using the AUXIS palette:
- Ink: `#11110f`
- Paper: `#efeee8`
- Signal red: `#ff4b2b`

## Preview / validate first
Do not replace your working greeter theme until you have tested this in a nested greeter or from a TTY.
SDDM themes execute in a greeter environment, not a regular desktop QML app.

## Install locally
```sh
mkdir -p ~/.local/share/sddm/themes
cp -r auxis-sddm ~/.local/share/sddm/themes/auxis
```

To test with SDDM's greeter test mode (availability varies by distro):
```sh
sddm-greeter --test-mode --theme ~/.local/share/sddm/themes/auxis
```

If `sddm-greeter` is missing, install the Qt 6 SDDM greeter package provided by your distribution.

## Enable
Edit `/etc/sddm.conf` or a drop-in under `/etc/sddm.conf.d/` and set:
```ini
[Theme]
Current=auxis
```
Back up your current config/theme first. Keep a TTY route available (`Ctrl+Alt+F3`) in case a greeter theme fails.

## Notes
- Theme uses the SDDM greeter APIs for login, session selection, suspend, shutdown and reboot.
- Available sessions depend on what is installed on the system.
- This is a starter implementation; validate QML property/API compatibility with your installed SDDM build before enabling it.
- Font files are intentionally not bundled in this starter. The theme uses Qt fallback fonts until you add licensed local fonts under `assets/`.
