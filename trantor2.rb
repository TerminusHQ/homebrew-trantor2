class Trantor2 < Formula
  desc "Terminus Trantor2 CLI"
  homepage "https://www.terminus.io/"
  url "https://terminus-trantor.oss-cn-hangzhou.aliyuncs.com/tools/cli2/trantor2-cli.latest.tar.gz"
  version "0.0.1"
  sha256 "bb1e5a9971efc828c2aab06ad961f980e550792ec89f57ec54abe80c55704a4b"

#   depends_on "docker"

  def buildExe()
    <<~EOS
      #!/bin/bash
      JAVACMD="#{libexec}/java-runtime/bin/java"
      export TRANTOR2_HOME="#{prefix}"
      export TRANTOR2_CLI_VERSION="0.0.1"
      exec "$JAVACMD" -jar "#{libexec}/trantor2-cli.jar" "$@"
    EOS
  end

  def install
    # Remove windows files
    libexec.install Dir["libexec/*"]
    cp_r "java-runtime", libexec/"java-runtime"
    (bin/"trantor2").write buildExe()
  end

  test do
    system "#{bin}/trantor2", "version"
  end

end