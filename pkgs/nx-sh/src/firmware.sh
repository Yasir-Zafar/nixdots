firmware() {
  local action="${1:-check}"
  case "$action" in
    check)
      step "Checking for firmware updates"
      fwupdmgr refresh --force || true
      # exit code 2 just means "nothing to update"
      fwupdmgr get-updates || true
      ;;
    update)
      step "Installing firmware updates"
      fwupdmgr update
      ;;
    devices)
      step "Firmware devices"
      fwupdmgr get-devices
      ;;
    history)
      step "Firmware history"
      fwupdmgr get-history
      ;;
    bios)
      step "BIOS"
      for f in sys_vendor product_name bios_vendor bios_version bios_date; do
        printf '  %s%-13s%s %s\n' "$bold" "$f" "$reset" "$(cat "/sys/class/dmi/id/$f" 2>/dev/null)"
      done
      ;;
    *) err "nx firmware: check|update|devices|history|bios"; exit 2 ;;
  esac
}
