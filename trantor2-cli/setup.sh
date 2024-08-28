#! /bin/bash
set -u

# setup

# resolve links - $0 may be a link to Trantor home
PRG="$0"
# need this for relative symlinks
while [ -h "$PRG" ]; do
  ls=$(ls -ld "$PRG")
  link=$(expr "$ls" : '.*-> \(.*\)$')
  if expr "$link" : '/.*' >/dev/null; then
    PRG="$link"
  else
    PRG="$(dirname "$PRG")/$link"
  fi
done
# make it fully qualified
TRANTOR_HOME=$(cd "$(dirname "$PRG")" && pwd)

# soft link /usr/local/bin
sudo ln -sf "${TRANTOR_HOME}"/bin/trantor2 /usr/local/bin/trantor2

# configure completion just support zsh
#if [[ "$SHELL" == "/bin/zsh" ]]; then
#  sudo ln -sf "${TRANTOR_HOME}"/completions/zsh/_trantor2 /usr/local/share/zsh/site-functions/_trantor2
#  rm -rf "$HOME/.zcompdump"
#  /bin/zsh -i -c "autoload -U compinit && compinit"
#fi

#done
echo "setup succeeded."
