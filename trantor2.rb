class Trantor2 < Formula
  desc "Terminus Trantor2 CLI"
  homepage "https://www.terminus.io/"
  url "https://terminus-trantor.oss-cn-hangzhou.aliyuncs.com/tools/cli2/trantor2-cli.latest.tar.gz"
  version "0.0.1"
  sha256 "0b1ae91e80f41552684afd8fc0813f77f649df182ae438d8e98536d5a5a423be"

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
      export TRANTOR2_CLI_VERSION="0.0.1"
      exec "$JAVACMD" -jar "#{libexec}/trantor2-cli.jar" "$@"
    EOS
  end

  def install
    # Remove windows files
    libexec.install Dir["libexec/*"]
    (bin/"trantor2").write buildExe()
  end

  test do
    system "#{bin}/trantor2", "version"
  end

end