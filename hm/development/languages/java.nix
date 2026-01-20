# ============================================================================
# Java Development Environment
# Location: hm/development/languages/java.nix
# ============================================================================
{pkgs, ...}: {
  home = {
    # ========================================================================
    # JAVA PACKAGES
    # ========================================================================
    packages = with pkgs; [
      # ------------------------------------------------------------------------
      # Java Development Kit
      # ------------------------------------------------------------------------
      jdk21 # Java 21 LTS (or jdk17 for Java 17 LTS)
      # jdk17 # Alternative: Java 17 LTS
      # jdk11 # Alternative: Java 11 LTS

      # ------------------------------------------------------------------------
      # Build Tools
      # ------------------------------------------------------------------------
      maven # Apache Maven build tool
      gradle # Gradle build automation

      # ------------------------------------------------------------------------
      # Development Tools
      # ------------------------------------------------------------------------
      visualvm # Java performance monitoring

      # ------------------------------------------------------------------------
      # Framework CLIs
      # ------------------------------------------------------------------------
      spring-boot-cli # Spring Boot command-line interface
      # micronaut # Alternative: Micronaut CLI
      # quarkus # Alternative: Quarkus CLI
    ];

    # ========================================================================
    # JAVA ENVIRONMENT VARIABLES
    # ========================================================================
    sessionVariables = {
      # Java home directory
      JAVA_HOME = "${pkgs.jdk21}";

      # Maven JVM options
      MAVEN_OPTS = "-Xmx2g -XX:+UseG1GC";

      # Gradle JVM options (optional)
      # GRADLE_OPTS = "-Xmx2g -XX:MaxMetaspaceSize=512m";
    };

    # ========================================================================
    # MAVEN CONFIGURATION
    # ========================================================================
    file.".m2/settings.xml".text = ''
      <?xml version="1.0" encoding="UTF-8"?>
      <settings xmlns="http://maven.apache.org/SETTINGS/1.0.0"
                xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
                xsi:schemaLocation="http://maven.apache.org/SETTINGS/1.0.0
                                    http://maven.apache.org/xsd/settings-1.0.0.xsd">

        <!-- Local repository location -->
        <localRepository>''${user.home}/.m2/repository</localRepository>

        <!-- Plugin groups for abbreviated plugin execution -->
        <pluginGroups>
          <pluginGroup>org.springframework.boot</pluginGroup>
        </pluginGroups>

        <!-- Optional: Mirror configuration for faster downloads -->
        <!--
        <mirrors>
          <mirror>
            <id>maven-central</id>
            <name>Maven Central Mirror</name>
            <url>https://repo1.maven.org/maven2</url>
            <mirrorOf>central</mirrorOf>
          </mirror>
        </mirrors>
        -->

        <!-- Optional: Profiles for different environments -->
        <!--
        <profiles>
          <profile>
            <id>dev</id>
            <properties>
              <environment>development</environment>
            </properties>
          </profile>
        </profiles>
        -->
      </settings>
    '';

    # ========================================================================
    # GRADLE CONFIGURATION (Optional)
    # ========================================================================
    # Uncomment to configure Gradle properties
    # file.".gradle/gradle.properties".text = ''
    #   org.gradle.daemon=true
    #   org.gradle.parallel=true
    #   org.gradle.caching=true
    #   org.gradle.jvmargs=-Xmx2g -XX:MaxMetaspaceSize=512m
    # '';
  };
}
# ============================================================================
# JAVA VERSION MANAGEMENT
# ============================================================================
# To use multiple Java versions:
#
# 1. Install multiple JDKs:
#    home.packages = with pkgs; [ jdk21 jdk17 jdk11 ];
#
# 2. Use environment variables per project:
#    export JAVA_HOME=${pkgs.jdk17}
#
# 3. Or use direnv with .envrc:
#    use nix -p jdk17
# ============================================================================
# ============================================================================
# ADDITIONAL JAVA TOOLS TO CONSIDER
# ============================================================================
# - jbang: Java scripting tool
# - scala: Scala programming language
# - kotlin: Kotlin programming language
# - groovy: Groovy programming language
# - lombok: Java annotation library (IDE plugin)
# - checkstyle: Java code style checker
# - pmd: Java static code analyzer
# ============================================================================

