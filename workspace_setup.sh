#!/bin/bash
STARTED=0
while [ $STARTED -ne 1 ]; do
	read -p "By executing this script, you agree you have read the licenses for all software that will be installed [y/N]: " input < /dev/tty
	case $input in
		[Yy] )

		STARTED=1

		JETBRAINS_TOOLBOX_VERSION="1.5.2871"
		JAVA_JDK_URL="http://download.oracle.com/otn-pub/java/jdk/8u152-b16/aa0333dd3019491ca4f6ddbe78cdb6d0/jdk-8u152-macosx-x64.dmg"

		mkdir -p /tmp/TeamWikiInstallation
		# Make applications folder if does not exist
		echo Making Applications folder
		mkdir -p $HOME/Applications

		echo 'Starting Script 🎬'
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
		mkdir -p /tmp/TeamWikiInstallation/jars

		echo '> Downloading Java 8 JDK'
		curl -Lk --header "Cookie: oraclelicense=accept-securebackup-cookie" "$JAVA_JDK_URL" -o /tmp/TeamWikiInstallation/jars/java_jdk.dmg

		echo '> Attatching'
		hdiutil attach /tmp/TeamWikiInstallation/jars/java_jdk.dmg

		echo '> Creating extraction folder'
		mkdir -p /tmp/TeamWikiInstallation/extraction

		JAVA_PATH="$(ls /Volumes/ | awk '/JDK/' | head -1)"
		JAVA_PKG="$(ls "/Volumes/$JAVA_PATH" | awk '/JDK/')"
		echo '> Decompiling Package (xar)'
		xar -xf "/Volumes/$JAVA_PATH/$JAVA_PKG" -C /tmp/TeamWikiInstallation/extraction

		JDK_PKG_JDK="$(ls /tmp/TeamWikiInstallation/extraction | awk '/jdk/')"
		JAVA_JDK="$(echo "jdk180151.pkg" | awk -F. '{print $1}')"
		echo '> Making extraction/jdk folder'
		mkdir -p "/tmp/TeamWikiInstallation/extraction/$JAVA_JDK"

		echo '> Decompiling Nested Package (tar)'
		mkdir -p /tmp/TeamWikiInstallation/extraction/nested
		tar -xf "/tmp/TeamWikiInstallation/extraction/$JDK_PKG_JDK/Payload" -C "/tmp/TeamWikiInstallation/extraction/$JAVA_JDK"

		echo '> Making Folder ~/Library/Java/JavaVirtualMachines'
		mkdir -p "$HOME/Library/Java/JavaVirtualMachines"

		JAVA_CP_INTO_FOLDER="$(echo $JAVA_JDK | sed -E 's:([a-z0-9]{4})([0-9])([0-9])([0-9]{3}).*:\1.\2.\3_\4.jdk:')"
		JAVA_CP_FULL_FOLDER="$HOME/Library/Java/JavaVirtualMachines/$JAVA_CP_INTO_FOLDER"
		echo '> Copying Java Folders'
		cp -R "/tmp/TeamWikiInstallation/extraction/$JAVA_JDK" "$JAVA_CP_FULL_FOLDER"

		echo '> Removing extraction folder'
		rm -rf /tmp/TeamWikiInstallation/extraction

		echo '> Detatching'
		JAVA_VOLUME="$(diskutil info "/Volumes/$JAVA_PATH" | awk '/Device Node/ {print $3}')"
		hdiutil detach "$JAVA_VOLUME"

		echo '> Removing jars folder'
		rm -rf /tmp/TeamWikiInstallation/jars

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

		echo 'Removing extra garbage 🗑️'
		rm -rf /tmp/TeamWikiInstallation

		echo 'Script completed! 🙌'
		;;

		*)
		printf "\n⚠️  Installation stopped. To accept terms, type 'y' and then press 'ENTER'  ⚠️\n\n"
		;;
	esac
done
