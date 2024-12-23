class Trantor2 < Formula
  desc "Terminus Trantor2 CLI"
  homepage "https://www.terminus.io/"
  url "https://terminus-new-trantor.oss-cn-hangzhou.aliyuncs.com/tools/cli2/trantor2-cli.latest.tar.gz"
  version "0.0.1"
  sha256 "3c3197e1e5448f9cbc36bc46ae629f5e821257b8d95da825fc4ae8bae6a56b50"

  # depends_on "docker"
  depends_on "openjdk@17"
  depends_on "mysql@8.4"

  def buildExe()
    <<~EOS
      #!/bin/bash
      export JAVA_HOME="#{Formula["openjdk@17"].opt_prefix}"
      JAVACMD="$JAVA_HOME/bin/java"
      export TRANTOR2_HOME="#{prefix}"
      export TRANTOR2_CLI_VERSION="0.0.1"
      exec "$JAVACMD" -jar "#{libexec}/trantor2-cli.jar" "$@"
    EOS
  end

  def install
    # 安装主文件和库
    libexec.install Dir["libexec/*"]
    (bin/"trantor2").write buildExe()
  end

  test do
    system "#{bin}/trantor2", "version"
  end
end