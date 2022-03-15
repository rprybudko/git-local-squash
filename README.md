# Git local squash
Squashing local commits using commitizen (optional). Useful if you need to compress commits before a pull request. Squashing occurs not through a rebase, but by merging into a temporary branch, followed by the creation of a commit message using the utility commitizen.

## Installation

### 1. Commit utility

For commits, the commitizen utility is used. You can find out more about commitizen [here](https://github.com/commitizen/cz-cli).
If committizen is not set locally in the project then make your repo [commitizen friendly](https://github.com/commitizen/cz-cli#making-your-repo-commitizen-friendly) or set it [globally](https://github.com/commitizen/cz-cli#conventional-commit-messages-as-a-global-utility). If another commit utility is used, please specify it instead of the code listed [here](https://github.com/rprybudko/git-local-squash/blob/main/cz-squash.sh#L32).

### 2. Squash git command

Put the file`cz-squash.sh`in your `home` directory. Create alias for new squash command. For example: git squash.

```sh
git config --global alias.squash '!sh cz-squash.sh'
```
Now, before you submit the code for review, you can squash all the commits into one using the command `git squash` and have already submitted one commit.

## Demo

![demo](https://github.com/rprybudko/git-local-squash/blob/main/storage/demo.gif)
