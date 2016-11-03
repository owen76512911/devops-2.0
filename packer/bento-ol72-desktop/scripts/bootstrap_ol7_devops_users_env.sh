#!/bin/bash
# create default environment profiles for devops users.

# create default environment profile for user 'root'. --------------------------
echo ""
echo "-----------------------------------------------------------"
echo "Creating default environment profile for user 'root'..."
echo "-----------------------------------------------------------"
echo "Saving original files..."
cd /root
cp -p .bash_profile .bash_profile.orig
cp -p .bashrc .bashrc.orig

echo "Copying the new environment files..."
cp -f /vagrant/scripts/user-root-bash_profile.sh ./.bash_profile
cp -f /vagrant/scripts/user-root-bashrc.sh ./.bashrc

echo "Copying VIM resource configuration files..."
cp -f /vagrant/scripts/vim-files.tar.gz .
tar -zxvf /vagrant/scripts/vim-files.tar.gz
rm -f vim-files.tar.gz

echo "Changing file ownership and permissions..."
chown -R root:root .
chmod 644 .bash_profile .bashrc
echo "-----------------------------------------------------------"
echo ""

# create default environment profile for user 'vagrant'. -----------------------
echo ""
echo "-----------------------------------------------------------"
echo "Creating default environment profile for user 'vagrant'..."
echo "-----------------------------------------------------------"
echo "Saving original files..."
cd /home/vagrant
cp -p .bash_profile .bash_profile.orig
cp -p .bashrc .bashrc.orig

echo "Copying the new environment files..."
cp -f /vagrant/scripts/user-vagrant-bash_profile.sh ./.bash_profile
cp -f /vagrant/scripts/user-vagrant-bashrc.sh ./.bashrc

echo "Copying VIM resource configuration files..."
cp -f /vagrant/scripts/vim-files.tar.gz .
tar -zxvf /vagrant/scripts/vim-files.tar.gz
rm -f vim-files.tar.gz

echo "Changing file ownership and permissions..."
chown -R vagrant:vagrant .
chmod 644 .bash_profile .bashrc
echo "-----------------------------------------------------------"
echo ""

# modify default terminal column and row size. (future) ------------------------
#echo ""
#echo "-----------------------------------------------------------"
#echo "Modifying default terminal column and row size..."
#echo "-----------------------------------------------------------"
#cols=162
#rows=34

#defprofileid=$(gsettings get org.gnome.Terminal.ProfilesList default)
#gsettings set org.gnome.Terminal.Legacy.Profile:/org/gnome/terminal/legacy/profiles:/:${defprofileid:1:-1}/ default-size-columns $cols
#gsettings set org.gnome.Terminal.Legacy.Profile:/org/gnome/terminal/legacy/profiles:/:${defprofileid:1:-1}/ default-size-rows $rows
#echo "-----------------------------------------------------------"
#echo ""