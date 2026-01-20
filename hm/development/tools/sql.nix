# ============================================================================
# Database Tools Configuration
# Location: hm/development/tools/sql.nix
# ============================================================================
{pkgs, ...}: {
  # ==========================================================================
  # DATABASE PACKAGES
  # ==========================================================================
  home.packages = with pkgs; [
    # ------------------------------------------------------------------------
    # SQLite
    # ------------------------------------------------------------------------
    sqlite # SQLite database engine
    sqlite-analyzer # SQLite file analyzer
    sqlitebrowser # SQLite GUI browser

    # ------------------------------------------------------------------------
    # PostgreSQL Tools
    # ------------------------------------------------------------------------
    # postgresql # PostgreSQL client tools
    # pgcli # PostgreSQL CLI with auto-completion

    # ------------------------------------------------------------------------
    # MySQL/MariaDB Tools
    # ------------------------------------------------------------------------
    # mysql # MySQL client
    # mycli # MySQL CLI with auto-completion

    # ------------------------------------------------------------------------
    # Database GUI Tools
    # ------------------------------------------------------------------------
    # dbeaver-bin # Universal database tool
    # beekeeper-studio # Modern SQL editor

    # ------------------------------------------------------------------------
    # NoSQL Tools
    # ------------------------------------------------------------------------
    # mongodb-compass # MongoDB GUI
    # redis # Redis CLI
    # redli # Redis CLI with auto-completion

    # ------------------------------------------------------------------------
    # Database Utilities
    # ------------------------------------------------------------------------
    # usql # Universal SQL CLI
    # dbmate # Database migration tool
  ];
}
# ============================================================================
# DATABASE TOOL NOTES
# ============================================================================
# SQLite:
#   sqlite3 database.db               # Open database
#   .tables                           # List tables
#   .schema table_name                # Show table schema
#   .dump table_name                  # Dump table
#
# PostgreSQL (if enabled):
#   psql -U username -d database      # Connect to database
#   pgcli database_url                # Connect with auto-completion
#
# MySQL (if enabled):
#   mysql -u username -p database     # Connect to database
#   mycli -u username database        # Connect with auto-completion
#
# GUI Tools:
#   - SQLite Browser: User-friendly SQLite GUI
#   - DBeaver: Universal database tool (supports many databases)
#   - Beekeeper Studio: Modern, lightweight SQL editor
#
# Consider adding based on your needs:
#   - Database-specific clients (PostgreSQL, MySQL, MongoDB)
#   - Migration tools (dbmate, flyway)
#   - Database GUI tools
# ============================================================================

