class Trantor2 < Formula
  desc "Terminus Trantor2 CLI"
  homepage "https://www.terminus.io/"
  url "https://terminus-trantor.oss-cn-hangzhou.aliyuncs.com/tools/cli2/trantor2-cli.latest.tar.gz"
  version "0.0.1"
  sha256 "63f53c29ca39bc4620bd8374769c5a69df3875e1fcc5611f1e6ad09c44858b3c"

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
    runtime_lib_path = "#{libexec}/java-runtime/lib"
      Dir["#{runtime_lib_path}/*.dylib"].each do |dylib|
        system "install_name_tool", "-add_rpath", runtime_lib_path, dylib
      end
    (bin/"trantor2").write buildExe()
  end

  test do
    system "#{bin}/trantor2", "version"
  end

end