echo '> Starting init script'
rm -rf /tmp/TeamWikiInstallation
mkdir -p /tmp/TeamWikiInstallation
echo '> Curling main script'
curl -s https://raw.githubusercontent.com/Team-2502/TeamWiki/master/workspace_setup_main.sh -o /tmp/TeamWikiInstallation/workspace_setup.sh
chmod +x /tmp/TeamWikiInstallation/workspace_setup.sh
echo '> Executing main script'
/tmp/TeamWikiInstallation/workspace_setup.sh
echo '> Removing all script garbage'
rm -rf /tmp/TeamWikiInstallation
