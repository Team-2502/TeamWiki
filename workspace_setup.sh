#!/bin/bash
read -p "By executing this script, you agree you have read the licenses for all software that will be downloaded [y/N]: " input
case $input in [Yy] )
	# Make applications folder if does not exist
	echo Making Applications folder
	mkdir -p ~/Applications

	# Install Toolbox
	echo "Installing JetBrains Toolbox 🔧"

	echo '> Downloading'
	curl -L https://download.jetbrains.com/toolbox/jetbrains-toolbox-1.4.2492.dmg -o toolbox.dmg

	echo '> Attatching'
	hdiutil attach toolbox.dmg

	echo '> Copying'
	cp -R '/Volumes/JetBrains Toolbox/JetBrains Toolbox.app' ~/Applications/

	echo '> Detatching'
	hdiutil detach `diskutil info '/Volumes/JetBrains Toolbox/' | awk '/Device Node/ {print $3}'`

	echo '> Removing installation dmg'
	rm toolbox.dmg

	echo '> Opening'
	open "~/Applications/JetBrains\ Toolbox.app"

	# Install Java 8 JDK
	echo "Installing Java 8 ☕️"

	echo '> Creating jars folder'
	mkdir -p jars

	echo '> Downloading Java 8 JDK'
	curl -L --header "Cookie: oraclelicense=accept-securebackup-cookie" http://download.oracle.com/otn-pub/java/jdk/8u144-b01/090f390dda5b47b9b721c7dfaa008135/jdk-8u144-macosx-x64.dmg -o jars/java_jdk.dmg

	echo '> Attatching'
	hdiutil attach jars/java_jdk.dmg

	echo '> Creating extraction folder'
	mkdir -p extraction

	echo '> Decompiling Package (xar)'
	xar -xvf '/Volumes/JDK 8 Update 144/JDK 8 Update 144.pkg' -C extraction

	echo '> Making extraction/jdk180144 folder'
	mkdir -p extraction/jdk180144

	echo '> Decompiling Nested Package (tar)'
	mkdir -p extraction/nested
	tar -xvf 'extraction/jdk180144.pkg/Payload' -C extraction/jdk180144

	echo '> Making Folder ~/Library/Java'
	mkdir -p ~/Library/Java

	echo '> Copying Java Folders'
	cp -R extraction/jdk180144 ~/Library/Java/

	echo '> Removing extraction folder'
	rm -rf extraction

	echo '> Detatching'
	hdiutil detach `diskutil info '/Volumes/JDK 8 Update 144/' | awk '/Device Node/ {print $3}'`

	echo '> Removing jars folder'
	rm -rf jars

	echo '> Modifying ~/.bash_profile'
	echo 'export JAVA_HOME="~/Library/Java/jdk180144/Contents/Home/"' >> ~/.bash_profile
	echo 'export PATH="$JAVA_HOME:$PATH"' >> ~/.bash_profile

	echo '> To test, execute . ~/.bash_profile && java -version'


	# Install Git Kraken
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

	echo '> Opening'
	open ~/Applications/GitKraken.app


esac
