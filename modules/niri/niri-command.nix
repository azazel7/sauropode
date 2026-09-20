{ config, pkgs, ... }:

let
  niri-column-move-wrap = pkgs.writeShellApplication {
    name = "niri-column-move-wrap";
    runtimeInputs = [ pkgs.niri pkgs.jaq ];
    text = ''
      DIRECTION="$1" # "left" or "right"

      # 1. Fetch current window array on the active workspace
      # Filter by matching the focused window's workspace ID to get all windows on that screen
      WINDOWS_JSON=$(niri msg --json windows)
      FOCUSED_WINDOW=$(echo "$WINDOWS_JSON" | jaq -r '.[] | select(.is_focused == true)')

      if [ -z "$FOCUSED_WINDOW" ]; then
          # Fallback to standard move if no window has focus metadata
          niri msg action move-column-"$DIRECTION"
          exit 0
      fi

      CURRENT_WORKSPACE=$(echo "$FOCUSED_WINDOW" | jaq -r '.workspace_id')

      # Extract unique columns in order on this workspace by grouping unique window X coordinates
      # (Niri represents structural columns on an infinite horizontal layout via coordinates)
      COLUMNS_X=$(echo "$WINDOWS_JSON" | jaq "[.[] | select(.workspace_id == $CURRENT_WORKSPACE)] | sort_by(.position.x) | [.[].position.x] | unique")
      TOTAL_COLUMNS=$(echo "$COLUMNS_X" | jaq 'length')

      # Find current column index
      MY_X=$(echo "$FOCUSED_WINDOW" | jaq -r '.position.x')
      MY_INDEX=$(echo "$COLUMNS_X" | jaq "index($MY_X)")

      # 2. Check boundaries and wrap if necessary
      if [ "$DIRECTION" = "left" ]; then
          if [ "$MY_INDEX" -eq 0 ]; then
              # At the far left edge: wrap to the very end
              niri msg action move-column-to-last
          else
              niri msg action move-column-left
          fi
      elif [ "$DIRECTION" = "right" ]; then
          LAST_INDEX=$((TOTAL_COLUMNS - 1))
          if [ "$MY_INDEX" -eq "$LAST_INDEX" ]; then
              # At the far right edge: wrap to the very beginning
              niri msg action move-column-to-first
          else
              niri msg action move-column-right
          fi
      fi
    '';
  };
in
{
  home.packages = [
    niri-column-move-wrap
  ];
}
