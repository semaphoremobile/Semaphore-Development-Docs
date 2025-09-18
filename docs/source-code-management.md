# Source Code Management

We use [Git](https://git-scm.com/) with repositories hosted on [GitHub](https://github.com/).

Git tracks all changes over time and supports check-in, check-out, roll-back, and merging.

**Common commands:**
```bash
# clone repository
git clone git@github.com:git-username/git-project.git

# checkout staging branch
git checkout staging

# fetch latest changes
git pull

# create feature branch
git checkout -b feature/deployment-scripts

# see local status
git status

# stage a file
git add directory/ path/to/filename

# commit staged changes
git commit -m "Added Capistrano deployment scripts"

# push local commits to GitHub
git push -u origin main

# view commit history
git log --oneline --graph --decorate --all
```