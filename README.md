ʕ•ᴥ•ʔ

cd
mkdir code
git clone https://github.com/ratbeard/dotfiles.git

had to take out zsh from shells - hadn't installed yet!
cd into bin dir to run it so it can source dots-brew
changed a few cask installs
generate a public key and upload it
pbcopy < ~/.ssh/id_rsa.pub
ssh -T git@github.com

had to run dots-link
dots-osx-defaults

brew cask alfred link

rvm:

    curl -L https://get.rvm.io | bash -s stable --rails --autolibs=enable


vim:

    git clone https://github.com/gmarik/Vundle.vim.git ~/.vim/bundle/vundle
    vim +PluginInstall +qall


