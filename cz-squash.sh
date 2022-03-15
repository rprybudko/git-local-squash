#!/bin/bash

# Get current branch name
current_branch=$(git rev-parse --abbrev-ref HEAD)

# If current branch is remote then exit
existed_in_remote=$(git ls-remote --heads origin "$current_branch")
if [[ -n ${existed_in_remote} ]]; then
  echo "$(tput setaf 1)Error: unable to do squash for remote branch!"
  exit 1
fi

# Get parent branch name
parent_branch=$(git show-branch -a | grep '\*' | grep -v $(git rev-parse --abbrev-ref HEAD) | head -n1 | sed 's/.*\[\(.*\)\].*/\1/' | sed 's/[\^~].*//')

# Create a temporary branch to which the squashed changes will be made
git checkout "$parent_branch" >/dev/null 2>&1
git checkout -b "$current_branch"-squash-temp >/dev/null 2>&1

# Merge with squash and check result
result=$(git merge --squash "$current_branch")
if echo "$result" | grep -q "nothing to squash"; then
  git checkout "$current_branch" >/dev/null 2>&1
  git branch -D "$current_branch"-squash-temp >/dev/null 2>&1
  echo "$(tput setaf 3)Warning:""$result"
  exit 0
else
  echo "$result"
fi

# Commit changes with commitizen
git cz

# Check if squash is canceled
if [[ -n $(git status -s) ]]; then
  git checkout "$current_branch" >/dev/null 2>&1
  git branch -D "$current_branch"-squash-temp >/dev/null 2>&1
  echo "$(tput setaf 2)Squash canceled!"
  exit 0
fi

# Remove if exist unsquashed branch to avoid the error that the branch already exists
existed_in_local=$(git branch --list "$current_branch"-unsquashed)
if [[ -n ${existed_in_local} ]]; then
  git branch -D "$current_branch"-unsquashed >/dev/null 2>&1
fi

# Rename the current branch to a unsquashed in order to later assign a current name to the temporary branch
git branch -m "$current_branch" "$current_branch"-unsquashed >/dev/null 2>&1

# Rename temporary branch to current
git branch -m "$current_branch" >/dev/null 2>&1

# Optional, not recommended if you want to keep the unsquashed history around for a bit longer
git branch -D "$current_branch"-unsquashed >/dev/null 2>&1

echo "$(tput setaf 2)Successfully squashed!"
