{userConfig, ...}: {
  virtualisation.docker.enable = true;
  users.users.${userConfig.name}.extraGroups = ["docker"];
}
