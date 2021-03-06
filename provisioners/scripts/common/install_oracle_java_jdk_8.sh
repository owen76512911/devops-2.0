#!/bin/sh -eux
# install java se 8 development kit by oracle.

# install java se 8 development kit. -------------------------------------------
jdkhome="jdk180"
#jdkbuild="8u161-b12"
#jdkhash="2f38c3b165be4555a1fa6e98c45e0808"
#jdkbinary="jdk-8u161-linux-x64.tar.gz"
#jdkfolder="jdk1.8.0_161"
jdkbuild="8u162-b12"
jdkhash="0da788060d494f5095bf8624735fa2f1"
jdkbinary="jdk-8u162-linux-x64.tar.gz"
jdkfolder="jdk1.8.0_162"

# create java home parent folder.
mkdir -p /usr/local/java
cd /usr/local/java

# download jdk 8 binary from oracle otn.
wget --no-verbose --no-check-certificate --no-cookies --header "Cookie: oraclelicense=accept-securebackup-cookie" http://download.oracle.com/otn-pub/java/jdk/${jdkbuild}/${jdkhash}/${jdkbinary}
#wget --no-verbose --no-check-certificate --no-cookies --header "Cookie: oraclelicense=accept-securebackup-cookie" http://download.oracle.com/otn-pub/java/jce/8/jce_policy-8.zip

# extract jdk 8 binary and create softlink to 'jdk180'.
rm -f ${jdkhome}
tar -zxvf ${jdkbinary} --no-same-owner --no-overwrite-dir
chown -R root:root ./${jdkfolder}
ln -s ${jdkfolder} ${jdkhome}
rm -f ${jdkbinary}

# set jdk 8 home environment variables.
JAVA_HOME=/usr/local/java/${jdkhome}
export JAVA_HOME
PATH=${JAVA_HOME}/bin:$PATH
export PATH

# verify installation.
java -version
