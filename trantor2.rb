class Trantor2 < Formula
  desc "Terminus Trantor2 CLI"
  homepage "https://www.terminus.io/"
  url "https://terminus-trantor.oss-cn-hangzhou.aliyuncs.com/tools/cli2/trantor2-cli.latest.tar.gz"
  version "0.0.1"
  sha256 "4778bf0636f3bd1296bdb47bde148ed9fd6355d62c647f6f3496d4d43d7d822f"

#   depends_on "docker"
  skip_clean "java-runtime"
  def buildExe()
    <<~EOS
      #!/bin/bash
      export JAVA_HOME="#{prefix}/java-runtime"
      JAVACMD="$JAVA_HOME/bin/java"
      export TRANTOR2_HOME="#{prefix}"
      export TRANTOR2_CLI_VERSION="0.0.1"
      exec "$JAVACMD" -jar "#{libexec}/trantor2-cli.jar" "$@"
    EOS
  end

  def install
    # Remove windows files
    prefix.install %w[java-runtime]
    libexec.install Dir["libexec/*"]
    (bin/"trantor2").write buildExe()
  end

  test do
    system "#{bin}/trantor2", "version"
  end

end