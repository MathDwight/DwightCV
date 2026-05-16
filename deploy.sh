# Build the PDF and push it to an orphan branch with a single commit
set -e

# Set variables for later
branch=pdf
message="Deploy from $(git rev-parse --short HEAD)"
remote="$(git remote get-url origin)"
deploy=_deploy

# Make a clean build to make sure we don't deploy junk
make clean all

# Only clone the pages branch if we don't have it already
if [ ! -d "$deploy" ]; then
    git clone $remote --branch $branch --single-branch $deploy
fi

cd $deploy
# Need the rebase because of diverging commits after amend
git pull origin $branch --rebase
rm -rvf *
cp -Rvf ../*.pdf .
git add -A .
git commit --amend --reset-author -m "$message"
git push --force origin $branch
