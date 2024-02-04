{ config, pkgs, ... }: {
  programs.git = {
    enable = true;
    package = pkgs.gitFull;
    extraConfig = {
      credential = {
        credentialstore = "secretservice";
        helper = "${pkgs.git-credential-manager}/bin/git-credential-manager";
      };
    };

    userName = "itm154";
    userEmail = "ashrulfahmi@gmail.com";
  };

  programs.lazygit.enable = true;
  programs.lazygit.settings = {
    gui.theme = {
      lightTheme = false;
      activeBorderColor = [ "#a6e3a1" "bold" ];
      inactiveBorderColor = [ "#cdd6f4" ];
      optionsTextColor = [ "#89b4fa" ];
      selectedLineBgColor = [ "#313244" ];
      selectedRangeBgColor = [ "#313244" ];
      cherryPickedCommitBgColor = [ "#94e2d5" ];
      cherryPickedCommitFgColor = [ "#89b4fa" ];
      unstagedChangesColor = [ "red" ];
    };
    gui.showIcons = true;
    gui.showBottomLine = true;
  };
}
