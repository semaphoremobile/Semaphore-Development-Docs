# Source Code Management

We use [Git](https://git-scm.com/) with repositories hosted on [GitHub](https://github.com/).

Git tracks all changes over time and supports check-in, check-out, roll-back, and merging.

**Common commands:**
```bash
# clone (recursive if submodules)
git clone --recursive git@github.com:git-username/git-project.git

# fetch latest changes
git pull

# see local status
git status

# stage a file
git add path/to/filename

# commit staged changes
git commit -m "Updated config file"

# push local commits to GitHub
git push origin main   # or 'master' if your repo still uses it

# view commit history
git log --oneline --graph --decorate --all
```