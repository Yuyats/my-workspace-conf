#!/bin/sh
ln -sf ~/my-workspace-conf/.vimrc ~/.vimrc
mkdir -p ~/.vim/rc
ln -sf ~/my-workspace-conf/dein.toml ~/.vim/rc/dein.toml
ln -sf ~/my-workspace-conf/dein_lazy.toml ~/.vim/rc/dein_lazy.toml
