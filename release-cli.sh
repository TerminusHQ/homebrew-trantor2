#!/bin/bash
#Author hedy.he
#Date 2021/09/09

set -e -u

# info日志回显
function i() {
  echo -e "[\033[1;34mINFO\033[0m ] $1"
}
# warn日志回显
function w() {
  echo -e "[\033[1;33mWARN\033[0m ] $1"
}
# error日志回显
function e() {
  echo -e "[\033[1;31mERROR\033[0m] $1"
}
# 常量
BUILD_TEMP_FOLDER="./build_temp_folder"
CURRENT_VERSION=""
# 参数检查
if [[ $# != 3 ]]; then
  e "Please pass OSS_ACCESS_KEY_ID and OSS_ACCESS_KEY_SECRET and GITHUB_TOKEN(see: ./build.sh keyId keySecret token)"
  exit 1
fi
OSS_ACCESS_KEY_ID=$1
OSS_ACCESS_KEY_SECRET=$2
GITHUB_TOKEN=$3
# 编译
mvn clean package -Dmaven.test.skip
CURRENT_VERSION=$(mvn -q -Dexec.executable="echo" -Dexec.args="\${project.version}" --non-recursive exec:exec)

# 生成completion文件，需要 cli-completion，可跳过
# 如何 安装cli-completion：
# curl https://sh.rustup.rs -sSf | sh
# rustup install 1.59.0
# rustup run 1.59.0 cargo install cli-completion
if [[ -n $(type cli-completion) ]]; then
  i "Generate completion file."
  # 生成 zsh completion
  cli-completion --zsh trantor-completion.yaml >trantor2-cli/completions/zsh/_trantor
  # 生成 bash completion
  cli-completion --bash trantor-completion.yaml >trantor2-cli/completions/bash/trantor-completion.bash
  # 生成 fish completion
  cli-completion --fish trantor-completion.yaml >trantor2-cli/completions/fish/trantor-completion.fish
  # 生成 powershell completion
  cli-completion --powershell trantor-completion.yaml >trantor2-cli/completions/powershell/trantor-completion.ps
else
  w "No rebuilding of the Completion file, Check whether cli-completion has been installed."
  read -r -n 1 -p "Do you want to continue?(y/n): " confirm
  echo ""
  if [[ $confirm != [yY] ]]; then
    i "Canceled."
    exit 1
  fi
fi

# 删除 macos 系统文件
if [ -f "./trantor2-cli/.DS_Store" ]; then
  rm -rf ./trantor2-cli/.DS_Store
fi

# 压缩打包
if [ ! -d "$BUILD_TEMP_FOLDER" ]; then
  mkdir "$BUILD_TEMP_FOLDER"
fi

historicVersion="trantor2-cli.$(date "+%Y%m%d%H%M").tar.gz"
tar -zcf "$BUILD_TEMP_FOLDER/trantor2-cli.latest.tar.gz" --exclude=install.sh -C ./trantor2-cli .
cp "$BUILD_TEMP_FOLDER/trantor2-cli.latest.tar.gz" "$BUILD_TEMP_FOLDER/$historicVersion"

i "build done."

# 下载 oss-upload-tools
if [ ! -d "$BUILD_TEMP_FOLDER/oss-upload-tools" ]; then
  i "download oss-upload tools..."
  mkdir -p "$BUILD_TEMP_FOLDER/oss-upload-tools"
  curl -o $BUILD_TEMP_FOLDER/oss-upload-tools/ossutil https://gosspublic.alicdn.com/ossutil/1.7.16/ossutilmac64
  chmod +x $BUILD_TEMP_FOLDER/oss-upload-tools/ossutil
fi

# 上传到OSS
i "upload trantor2-cli to OSS..."
$BUILD_TEMP_FOLDER/oss-upload-tools/ossutil config -e oss-cn-hangzhou.aliyuncs.com -i "$OSS_ACCESS_KEY_ID" -k "$OSS_ACCESS_KEY_SECRET"
$BUILD_TEMP_FOLDER/oss-upload-tools/ossutil cp ./trantor2-cli/install.sh oss://terminus-trantor/tools/cli/
$BUILD_TEMP_FOLDER/oss-upload-tools/ossutil cp "$BUILD_TEMP_FOLDER/trantor2-cli.latest.tar.gz" oss://terminus-trantor/tools/cli/
$BUILD_TEMP_FOLDER/oss-upload-tools/ossutil cp "$BUILD_TEMP_FOLDER/$historicVersion" oss://terminus-trantor/tools/cli/history/

trantor_sha256=$(shasum -a 256 "$BUILD_TEMP_FOLDER/trantor2-cli.latest.tar.gz")
trantor_cli_file_sha256=${trantor_sha256:0:64}
trantor_git_commit=$(git rev-parse HEAD)
i "trantor cli file shasum: $trantor_cli_file_sha256"

rm -rf "$BUILD_TEMP_FOLDER/trantor2-cli.latest.tar.gz"
rm -rf "$BUILD_TEMP_FOLDER/$historicVersion"
i "upload completed."

# 上传到home brew
i "deploy homebrew..."
if [ -z "$trantor_cli_file_sha256" ]; then
  echo "can't get trantor cli sha256."
  exit 1
fi
# 修改、提交trantor.rb
cd $BUILD_TEMP_FOLDER
git clone "https://$GITHUB_TOKEN"@github.com/TerminusHQ/homebrew-trantor2.git
sed "s/{{version}}/$CURRENT_VERSION/g" ../trantor2-homebrew.rb | sed "s/{{trantor_cli_file_sha256}}/$trantor_cli_file_sha256/g" >"trantor2.rb"
mv trantor2.rb homebrew-trantor2/trantor2.rb
echo "hhhhhh"
cat homebrew-trantor2/trantor2.rb
cd homebrew-trantor2
git add trantor2.rb
git commit -am "update trantor cli version to [$CURRENT_VERSION], trantor commit[$trantor_git_commit]"
git push
cd .. && rm -rf homebrew-trantor2
i "publish homebrew success"
i "build trantor cli done."
