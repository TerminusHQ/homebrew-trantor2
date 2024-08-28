#! /bin/bash
set -u

# download trantor-cli.zip
TRANTOR_CLI_TEMP="/tmp/trantor2-cli.tar.gz"

# trantor cli installation package
TRANTOR_CLI_URL="https://terminus-trantor.oss-cn-hangzhou.aliyuncs.com/tools/cli2/trantor2-cli.latest.tar.gz"

# install path
TRANTOR_INSTALL_PATH="/usr/local/trantor2"

# exit shell with err_code
# $1 : err_code
# $2 : err_msg
exit_on_err() {
  [[ -n "${2}" ]] && echo "${2}" 1>&2
  exit "${1}"
}

# download
echo "downloading..."

rm -rf ${TRANTOR_CLI_TEMP}

curl \
  -sLk \
  --connect-timeout 60 \
  $TRANTOR_CLI_URL \
  -o ${TRANTOR_CLI_TEMP} ||
  exit_on_err 1 "download failed!"

# install
if [ ! -d "${TRANTOR_INSTALL_PATH}" ]; then
  sudo mkdir -p ${TRANTOR_INSTALL_PATH}
fi
sudo tar -zxf ${TRANTOR_CLI_TEMP} -C ${TRANTOR_INSTALL_PATH}

# call setup
$TRANTOR_INSTALL_PATH/setup.sh


#done
echo "Successfully installed."
