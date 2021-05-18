#!/bin/sh
ln -sf ~/my-workspace-conf/.vimrc ~/.vimrc
mkdir -p ~/.vim/rc
ln -sf ~/my-workspace-conf/dein.toml ~/.vim/rc/dein.toml
touch ~/my-workspace-conf/dein_lazy.toml
