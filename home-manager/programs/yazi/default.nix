{...}: {
  programs.yazi = {
    enable = true;
    enableFishIntegration = true;
    settings = {
      manager = {
        sort_by = "natural";
        sort_dir_first = true;
      };
    };
  };

  home.file.".config/yazi/theme.toml" = {
    source = ./theme.toml;
  };
}
