#!/bin/bash
today=$(date +%Y-%m-%d) #we'll add the date in the git commit
cat << "EOF"
       _          _               _
 _ __ (_)_  _____| | ___ __ _  __| | ___
| '_ \| \ \/ / _ \ |/ __/ _` |/ _` |/ _ \
| |_) | |>  <  __/ | (_| (_| | (_| |  __/
| .__/|_/_/\_\___|_|\___\__,_|\__,_|\___|
|_|
EOF
echo "${magenta}       Pixelcade Updater    ${white}"
echo ""
echo "${magenta}Checking for Updates...${white}"
git stash #stash away your local changes
git pull  #pull the latest
if git stash pop | grep -q 'conflict'; then           #put back your local changes and if there is a conflict , let's keep your changes
  cd $HOME/pixelcade
  echo "${yellow}Auto resolving conflict(s) and keeping your version(s) of the conflicting file(s)...${white}"
  git checkout --theirs *                             #change theirs to ours if we want to keep the pixelcade version instead
  git add *
  git commit -m "Pixelcade Update $today"
  git ls-files --unmerged | perl -n -e'/\t(.*)/ && print "$1\n"' | uniq | xargs -r git checkout --theirs 
else
  echo "${yellow}Update complete with no conflicts${white}"
fi

#for reference, here is the output of git stash pop if there is a conflict
#warning: Cannot merge binary files: wow_action_max/PopsGhostly.png (Updated upstream vs. Stashed changes)
#Auto-merging wow_action_max/PopsGhostly.png
#CONFLICT (content): Merge conflict in wow_action_max/PopsGhostly.png
