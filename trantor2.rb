class Trantor2 < Formula
  desc "Terminus Trantor2 CLI"
  homepage "https://www.terminus.io/"
  url "https://terminus-trantor.oss-cn-hangzhou.aliyuncs.com/tools/cli2/trantor2-cli.latest.tar.gz"
  version "0.0.1"
  sha256 "28b2897ba94c8d9865e6f90cef9eaaf21efe4a37c8abd0e14e1c5816bcff73b4"

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
    mkdir_p libexec/"java-runtime"
    cp_r "java-runtime/.", libexec/"java-runtime"
    # Remove windows files
    libexec.install Dir["libexec/*"]
    (bin/"trantor2").write buildExe()
  end

  test do
    system "#{bin}/trantor2", "version"
  end

end