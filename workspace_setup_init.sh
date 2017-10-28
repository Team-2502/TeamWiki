rm -rf /tmp/TeamWikiInstallation
mkdir -p /tmp/TeamWikiInstallation
curl -s https://raw.githubusercontent.com/Team-2502/TeamWiki/master/workspace_setup_main.sh -o /tmp/TeamWikiInstallation/workspace_setup.sh
chmod +x /tmp/TeamWikiInstallation/workspace_setup.sh
/tmp/TeamWikiInstallation/workspace_setup.sh
rm -rf /tmp/TeamWikiInstallation
