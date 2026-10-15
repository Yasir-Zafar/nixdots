# shared: repo paths, result links, and the look (nh-style output)
dots="${NX_DOTS:-$HOME/dots}"
os="$dots/nix"
hm="$dots/hm"
desktop="$dots/modules/nixos/desktop" # where the greeter import lives (nx try)
# every directory with nix files (for fmt; assets/ has none)
nixdirs=("$dots/nix" "$dots/hm" "$dots/hosts" "$dots/modules" "$dots/home" "$dots/pkgs" "$dots/lib")
# `nh … build` would otherwise drop a ./result link wherever nx runs;
# these links also keep the last build from being garbage-collected
links="${XDG_CACHE_HOME:-$HOME/.cache}/nx"
mkdir -p "$links"

# --- look: same as nh (green ">" for steps, bold headings), colours only on a terminal ---
if [ -t 1 ] && [ -z "${NO_COLOR:-}" ]; then
  bold=$'\e[1m' dim=$'\e[2m' reset=$'\e[0m'
  red=$'\e[31m' green=$'\e[32m' yellow=$'\e[33m' blue=$'\e[34m' cyan=$'\e[36m'
else
  bold='' dim='' reset='' red='' green='' yellow='' blue='' cyan=''
fi
step() { printf '%s>%s %s\n' "$bold$green" "$reset" "$*"; }
heading() { printf '\n%s%s%s\n' "$bold" "$*" "$reset"; }
note() { printf '  %s%s%s\n' "$dim" "$*" "$reset"; }
good() { printf '  %s✔%s %s\n' "$green" "$reset" "$*"; }
caution() { printf '  %s!%s %s\n' "$yellow" "$reset" "$*"; }
err() { printf '%serror:%s %s\n' "$bold$red" "$reset" "$*" >&2; }
# colour for a byte count: red from 1 GiB, yellow from 100 MiB
size_colour() {
  if [ "$1" -ge 1073741824 ]; then printf '%s' "$red"; elif [ "$1" -ge 104857600 ]; then printf '%s' "$yellow"; fi
}
