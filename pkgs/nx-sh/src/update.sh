update() {
  local flake
  for flake in "$os" "$hm"; do
    step "Updating $(basename "$flake")/flake.lock"
    if [ "$#" -eq 0 ]; then
      nix flake update --flake "$flake"
    else
      nix flake update "$@" --flake "$flake" || caution "skipped: not all of those inputs exist in $(basename "$flake")"
    fi
  done
  step "Done. Nothing changes until you build and switch (nx build, nx all)"
}
