{ inputs, ... }:
let
  # herdr has no declarative plugin list in config.toml. It keeps a registry
  # at ~/.config/herdr/plugins.json, normally written by `herdr plugin
  # link/install`. That file is only a pointer list: herdr re-reads each
  # plugin's manifest from plugin_root when it runs an action, so nix can own
  # the registry and point it at store paths.
  #
  # Entries must carry the full field set. A minimal entry is silently
  # dropped and herdr reports no plugins at all.
  mkEntry = src:
    let
      manifest = builtins.fromTOML (builtins.readFile "${src}/herdr-plugin.toml");
    in
    {
      plugin_id = manifest.id;
      name = manifest.name;
      version = manifest.version;
      min_herdr_version = manifest.min_herdr_version;
      description = manifest.description;
      platforms = manifest.platforms;
      actions = manifest.actions;
      manifest_path = "${src}/herdr-plugin.toml";
      plugin_root = "${src}";
      enabled = true;
      source = { kind = "local"; };
    };

  plugins = [
    inputs.herdr-jump
    inputs.herdr-pane-tools
  ];
in
{
  # Read-only by construction: `herdr plugin link/install/enable/disable`
  # cannot persist against this file, which is the point. Add a plugin by
  # adding its flake input above, then switching.
  xdg.configFile."herdr/plugins.json" = {
    force = true; # replace whatever `herdr plugin link/install` left behind
    text = builtins.toJSON (map mkEntry plugins);
  };
}
