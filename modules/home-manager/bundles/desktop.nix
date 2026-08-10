# Convenience bundle: the full set of opt-in GUI/desktop apps. Import this
# (alongside common) on machines that want "everything", or skip it and import
# individual programs/* modules to pick and choose.
#
# macOS-only modules (aerospace, jankyborders, sketchybar) self-guard on
# stdenv.isDarwin, so importing this bundle on Linux is a no-op for those.
{...}: {
  imports = [
    ../programs/brave
    ../programs/vivaldi
    ../programs/qutebrowser
    ../programs/vscode
    ../programs/wezterm
    ../programs/ghostty
    ../programs/aerospace
    ../programs/jankyborders
    ../programs/sketchybar
  ];
}
