{ config, pkgs, ... }: {
  wayland.windowManager.hyprland = {
    enable = true;
    settings = {
      "$mainMod" = "SUPER";
      "$shiftMod" = "SUPERSHIFT";
      "$ctrlMod" = "SUPERCTRL";

      bind = [
        # Applications
        "$mainMod, Return, exec, wezterm"
        "$mainMod, B, exec, firefox"

        # 
      ];

      bindm = [
        "$mainMod, mouse:272, movewindow"
        "$mainMod, mouse:273, resizewindow"
      ]

        ++ (
          # workspaces
          # binds $mainMod + [shift +] {1..6} to [move to] workspace {1..10}
          builtins.concatLists (builtins.genList (x:
            let
              ws = let c = (x + 1) / 6;
              in builtins.toString (x + 1 - (c * 6));
            in [
              "$mainMod, ${ws}, workspace, ${toString (x + 1)}"
              "$mainMod SHIFT, ${ws}, movetoworkspace, ${toString (x + 1)}"
            ]) 6));
    };
  };
}
