class Trantor < Formula
  desc "Terminus Trantor2 CLI"
  homepage "https://www.terminus.io/"
  url "https://terminus-trantor.oss-cn-hangzhou.aliyuncs.com/tools/cli/trantor2-cli.latest.tar.gz"
  version "{{version}}"
  sha256 "{{trantor_cli_file_sha256}}"

#   depends_on "docker"

  def buildExe()
    <<~EOS
      #!/bin/bash
      if [ -z "$JAVA_HOME" ] ; then
        JAVACMD=`which java`
      else
        JAVACMD="$JAVA_HOME/bin/java"
      fi
      export TRANTOR2_HOME="#{prefix}"
      export TRANTOR2_CLI_VERSION="{{version}}"
      exec "$JAVACMD" -jar "#{libexec}/trantor2-cli.jar" "$@"
    EOS
  end

  def install
    # Remove windows files
    lib.install Dir["lib/*"]
    libexec.install Dir["libexec/*"]
    (bin/"trantor2").write buildExe()
  end

  test do
    system "#{bin}/trantor2", "version"
  end

end