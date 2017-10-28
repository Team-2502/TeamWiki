#!/bin/bash

JETBRAINS_TOOLBOX_VERSION="1.5.2871"
JAVA_JDK_URL="http://download.oracle.com/otn-pub/java/jdk/8u152-b16/aa0333dd3019491ca4f6ddbe78cdb6d0/jdk-8u152-macosx-x64.dmg"

read -p "By executing this script, you agree you have read the licenses for all software that will be downloaded [y/N]: " input
case $input in [Yy] )
	# Make applications folder if does not exist
	echo Making Applications folder
	mkdir -p $HOME/Applications

	# Install Toolbox
	echo 'Installing JetBrains Toolbox 🔧'

	echo '> Downloading'
	curl -L "https://download.jetbrains.com/toolbox/jetbrains-toolbox-$JETBRAINS_TOOLBOX_VERSION.dmg" -o toolbox.dmg

	echo '> Attatching'
	hdiutil attach toolbox.dmg

	echo '> Copying'
	cp -R '/Volumes/JetBrains Toolbox/JetBrains Toolbox.app' $HOME/Applications/

	echo '> Detatching'
	hdiutil detach `diskutil info '/Volumes/JetBrains Toolbox/' | awk '/Device Node/ {print $3}'`

	echo '> Removing installation dmg'
	rm toolbox.dmg

	echo '> Opening'
	open "$HOME/Applications/JetBrains Toolbox.app"

	# Install Java 8 JDK
	echo "Installing Java 8 ☕️"

	echo '> Creating jars folder'
	mkdir -p jars

	echo '> Downloading Java 8 JDK'
	curl -Lk --header "Cookie: oraclelicense=accept-securebackup-cookie" "$JAVA_JDK_URL" -o jars/java_jdk.dmg

	echo '> Attatching'
	hdiutil attach jars/java_jdk.dmg

	echo '> Creating extraction folder'
	mkdir -p extraction

	JAVA_PATH="$(ls /Volumes/ | awk '/JDK/' | head -1)"
	JAVA_PKG="$(ls "/Volumes/$JAVA_PATH" | awk '/JDK/')"
	echo '> Decompiling Package (xar)'
	xar -xvf "/Volumes/$JAVA_PATH/$JAVA_PKG" -C extraction

	JDK_PKG_JDK="$(ls extraction | awk '/jdk/')"
	JAVA_JDK="$(echo "jdk180151.pkg" | awk -F. '{print $1}')"
	echo '> Making extraction/jdk folder'
	mkdir -p "extraction/$JAVA_JDK"

	echo '> Decompiling Nested Package (tar)'
	mkdir -p extraction/nested
	tar -xvf "extraction/$JDK_PKG_JDK/Payload" -C "extraction/$JAVA_JDK"

	echo '> Making Folder ~/Library/Java/JavaVirtualMachines'
	mkdir -p "$HOME/Library/Java/JavaVirtualMachines"

	JAVA_CP_INTO_FOLDER="$(echo $JAVA_JDK | sed -E 's:([a-z0-9]{4})([0-9])([0-9])([0-9]{3}).*:\1.\2.\3_\4.jdk:')"
	JAVA_CP_FULL_FOLDER="$HOME/Library/Java/JavaVirtualMachines/$JAVA_CP_INTO_FOLDER"
	echo '> Copying Java Folders'
	cp -R "extraction/$JAVA_JDK" "$JAVA_CP_FULL_FOLDER"

	echo '> Removing extraction folder'
	rm -rf extraction

	echo '> Detatching'
	JAVA_VOLUME="$(diskutil info "/Volumes/$JAVA_PATH" | awk '/Device Node/ {print $3}')"
	hdiutil detach "$JAVA_VOLUME"

	echo '> Removing jars folder'
	rm -rf jars

	echo '> Modifying ~/.bash_profile'
	echo "export JAVA_HOME=$JAVA_CP_FULL_FOLDER/Contents/Home/" >> $HOME/.bash_profile
	echo 'export PATH="$JAVA_HOME:$PATH"' >> $HOME/.bash_profile

	echo '> To test, execute . ~/.bash_profile && java -version'


	# # Install Git Kraken
	echo "Installing Git Kraken 🐙"
	curl -L https://release.gitkraken.com/darwin/installGitKraken.dmg -o kraken.dmg

	echo '> Attatching'
	hdiutil attach kraken.dmg

	echo '> Copying'
	cp -R '/Volumes/Install GitKraken/GitKraken.app' ~/Applications/

	echo '> Detatching'
	hdiutil detach `diskutil info '/Volumes/Install GitKraken' | awk '/Device Node/ {print $3}'`

	echo '> Removing installation dmg'
	rm kraken.dmg

esac
