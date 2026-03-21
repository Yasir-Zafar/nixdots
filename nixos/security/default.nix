# nixos/security/default.nix
# System security configuration
{
  imports = [
  ];

  # ============================================================================
  # Privilege Escalation
  # ============================================================================
  security.sudo = {
    # Allow wheel group members to use sudo without password
    # WARNING: This reduces security - consider disabling for production systems
    wheelNeedsPassword = false;

    # Alternative: Require password but cache it for 15 minutes
    # wheelNeedsPassword = true;
    # extraConfig = ''
    #   Defaults timestamp_timeout=15
    # '';
  };

  # ============================================================================
  # PolicyKit (Polkit)
  # ============================================================================
  # Privilege management for desktop applications
  security.polkit.enable = true;

  # ============================================================================
  # AppArmor (Optional Security Framework)
  # ============================================================================
  # Mandatory Access Control (MAC) system
  # Provides application sandboxing and additional security
  security.apparmor = {
    enable = false; # Set to true for enhanced security

    # If enabled, consider also enabling:
    # packages = with pkgs; [ apparmor-utils apparmor-profiles ];
  };

  # ============================================================================
  # Additional Security Options (Recommended)
  # ============================================================================
  # Uncomment to enhance system security:

  # Kernel hardening
  # security.lockKernelModules = false;                 # Prevent loading new kernel modules
  # boot.kernel.sysctl = {
  #   "kernel.dmesg_restrict" = 1;                      # Restrict dmesg to root
  #   "kernel.kptr_restrict" = 2;                       # Hide kernel pointers
  #   "kernel.unprivileged_bpf_disabled" = 1;          # Disable unprivileged BPF
  #   "net.core.bpf_jit_harden" = 2;                   # Harden BPF JIT compiler
  # };

  # Restrict ptrace to prevent debugging of other processes
  # security.allowUserNamespaces = true;                # Required for containers/flatpak
  # boot.kernel.sysctl."kernel.yama.ptrace_scope" = 1;

  # TPM2 support (for encrypted drives)
  # security.tpm2.enable = true;
  # security.tpm2.pkcs11.enable = true;                 # PKCS#11 support

  # USB Guard (prevent unauthorized USB devices)
  # services.usbguard = {
  #   enable = false;
  #   rules = ''
  #     # Allow USB keyboards and mice
  #     allow with-interface equals { 03:00:01 03:01:01 }
  #   '';
  # };
}
