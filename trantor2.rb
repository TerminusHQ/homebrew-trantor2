class Trantor2 < Formula
  desc "Terminus Trantor2 CLI"
  homepage "https://www.terminus.io/"
  url "https://terminus-trantor.oss-cn-hangzhou.aliyuncs.com/tools/cli2/trantor2-cli.latest.tar.gz"
  version "0.0.1"
  sha256 "5ae61a29a482bf1795e2c8a5380980336d81bad6a302654bdc1fc8b36e06d135"

  keg_only "To prevent Homebrew from modifying runtime files"

  def build_exe
    <<~EOS
      #!/bin/bash
      JAVACMD="#{libexec}/java-runtime/bin/java"
      export TRANTOR2_HOME="#{prefix}"
      export TRANTOR2_CLI_VERSION="#{version}"
      exec "$JAVACMD" -jar "#{libexec}/trantor2-cli.jar" "$@"
    EOS
  end

  def install
    libexec.install Dir["libexec/*"]
    (bin/"trantor2").write build_exe
    chmod 0755, bin/"trantor2"
  end

  def post_install
    Dir["#{libexec}/java-runtime/lib/*.dylib"].each do |dylib|
      system "install_name_tool", "-id", dylib, dylib
      system "codesign", "--force", "--deep", "--sign", "-", dylib
    end
    opoo "Skipping codesign and @rpath modifications for custom JRE"
  end

  test do
    assert_match "0.0.1", shell_output("#{bin}/trantor2 version")
  end
end