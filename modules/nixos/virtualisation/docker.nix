{userConfig, ...}: {
  virtualisation.docker.enable = true;
  virtualisation.docker.enableOnBoot = false; # start manually via systemctl
  users.users.${userConfig.name}.extraGroups = ["docker"];
}
