# tr-github-reconcile
Shell script for reconciling a destination directory with my github repositories. Written so that it could be easily modified for other github users.

# Usage
```
./tr-github-reconcile.sh [-d [path]]
```

* The script checks for folders for each listed github repository under a specified root directory. A default is set in the script with `varRootDir`, which can be customized for your implementation or usage.
* **-d [path]** can also be used to specify a different root directory at script execution.

# Operation
* The script will first check for the specified or default root directory, and offer to create it if it does not exist.
* The script will then start checking for each repository:
  - If a folder for that repository does not exist in the root directory, it will offer to clone it.
  - If a folder exists for that repository, it will check for `.git`.
  - If `.git` does not exist, it will offer to `git init` the directory, then add the repository as an origin and pull it.
  - If `.git` does exist, it will pull it.

# Customization
* This script was written so that another github user could easily modify it to perform these operations for their own repositories.
* Two variables need to be customized, near the beginning of the script:
  - `varMyGitUrlRoot` would need to be changed to your `https://github.com/username/`.
  - `varRepoList` lists each repository name, separated by a space. The script goes through a `for` loop of this variable, checking each space-delimited value.
