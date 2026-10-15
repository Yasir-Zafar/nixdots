status() {
  local flake rev days col
  step "Flakes"
  for flake in "$os" "$hm"; do
    rev=$(jq -r '.nodes[.nodes.root.inputs.nixpkgs].locked.rev[0:8]' "$flake/flake.lock")
    days=$((($(date +%s) - $(stat -c %Y "$flake/flake.lock")) / 86400))
    col=$green
    if [ "$days" -ge 30 ]; then col=$red; elif [ "$days" -ge 7 ]; then col=$yellow; fi
    printf '  %s%-4s%s lock %s%s days old%s (%s)  nixpkgs %s%s%s\n' "$bold" "$(basename "$flake")" "$reset" "$col" "$days" "$reset" "$(date -r "$flake/flake.lock" '+%F %R')" "$bold" "$rev" "$reset"
  done
  heading "Git"
  git -C "$dots" status --short --branch | head -15 | sed 's/^/  /'
  heading "Disk"
  df -h / | awk -v y="$yellow" -v r="$red" -v z="$reset" 'NR==1{print "  " $0; next} {p=$5+0; c=(p>=90?r:(p>=75?y:"")); print "  " c $0 z}'
}
