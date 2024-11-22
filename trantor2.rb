class Trantor2 < Formula
  desc "Terminus Trantor2 CLI"
  homepage "https://www.terminus.io/"
  url "https://terminus-trantor.oss-cn-hangzhou.aliyuncs.com/tools/cli2/trantor2-cli.latest.tar.gz"
  version "0.0.1"
  sha256 "31b32cca170a3085eef50c3ee6438aaa1d3630ab89b1baf5f2342fc90e330742"

#   depends_on "docker"

  def buildExe()
    <<~EOS
      #!/bin/bash
      export JAVA_HOME="/java-runtime"
      JAVACMD="$JAVA_HOME/bin/java""
      export TRANTOR2_HOME="#{prefix}"
      export TRANTOR2_CLI_VERSION="0.0.1"
      exec "$JAVACMD" -jar "#{libexec}/trantor2-cli.jar" "$@"
    EOS
  end

  def install
    # Remove windows files
    java-runtime.install Dir["java-runtime/*"]
    libexec.install Dir["libexec/*"]
    (bin/"trantor2").write buildExe()
  end

  test do
    system "#{bin}/trantor2", "version"
  end

end