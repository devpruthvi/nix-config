{
  inputs,
  pkgs,
  ...
}: let
  agents = inputs.llm-agents.packages.${pkgs.stdenv.hostPlatform.system};
in {
  environment.systemPackages = [
    agents.dsh # DeepSeek harness; `dsh web` serves the UI on 127.0.0.1:3080
  ];
}
